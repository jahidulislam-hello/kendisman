import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:fitzella/core/models/profile/user_profile.dart';
import 'package:fitzella/core/providers/auth_provider.dart';
import 'package:fitzella/core/services/profile_prefs_service.dart';
import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/features/profile/widgets/profile_widgets.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  String _dob = '';
  String _gender = 'Male';
  bool _saving = false;
  bool _uploadingPhoto = false;
  Uint8List? _localPhotoBytes;

  @override
  void initState() {
    super.initState();
    final cached = ref.read(cachedProfileProvider);
    final remote = ref.read(currentProfileProvider);
    _name = TextEditingController(
      text: cached?.username ?? remote?.username ?? cached?.displayName ?? '',
    );
    _email = TextEditingController(text: cached?.email ?? remote?.email ?? '');
    _gender = _capitalize(cached?.sex ?? remote?.sex?.name ?? 'male');
    _dob = _formatDob(cached?.dateOfBirth ?? remote?.dateOfBirth);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _changePhoto() async {
    if (_uploadingPhoto) return;
    final colors = ref.read(appColorsProvider);
    final hasPhoto = _localPhotoBytes != null ||
        (ref.read(currentProfileProvider)?.photoUrl ??
                ref.read(cachedProfileProvider)?.photoUrl) !=
            null;

    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library_outlined, color: colors.textPrimary),
              title: Text('Choose from gallery', style: TextStyle(color: colors.textPrimary)),
              onTap: () => Navigator.pop(ctx, 'gallery'),
            ),
            ListTile(
              leading: Icon(Icons.photo_camera_outlined, color: colors.textPrimary),
              title: Text('Take a photo', style: TextStyle(color: colors.textPrimary)),
              onTap: () => Navigator.pop(ctx, 'camera'),
            ),
            if (hasPhoto)
              ListTile(
                leading: Icon(Icons.delete_outline, color: colors.danger),
                title: Text('Remove photo', style: TextStyle(color: colors.danger)),
                onTap: () => Navigator.pop(ctx, 'remove'),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (action == null || !mounted) return;

    if (action == 'remove') {
      setState(() {
        _uploadingPhoto = true;
        _localPhotoBytes = null;
      });
      final result = await ref.read(authNotifierProvider.notifier).removeProfilePhoto();
      if (!mounted) return;
      setState(() => _uploadingPhoto = false);
      result.when(
        success: (_) {},
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        },
      );
      return;
    }

    final picker = ImagePicker();
    final source = action == 'camera' ? ImageSource.camera : ImageSource.gallery;
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    final bytes = await picked.readAsBytes();
    setState(() {
      _localPhotoBytes = bytes;
      _uploadingPhoto = true;
    });

    final result = await ref.read(authNotifierProvider.notifier).uploadProfilePhoto(
          bytes,
          fileName: picked.name,
        );
    if (!mounted) return;
    setState(() => _uploadingPhoto = false);
    result.when(
      success: (_) {},
      error: (message) {
        setState(() => _localPhotoBytes = null);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      },
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final notifier = ref.read(authNotifierProvider.notifier);
    final usernameResult = await notifier.updateUsername(_name.text.trim());
    final usernameError = usernameResult.when(
      success: (_) => null,
      error: (message) => message,
    );
    if (usernameError != null) {
      _showSaveError(usernameError);
      return;
    }

    final sex = switch (_gender.toLowerCase()) {
      'male' => UserSex.male,
      'female' => UserSex.female,
      _ => null,
    };
    final sexResult = await notifier.updateSex(sex);
    final sexError = sexResult.when(
      success: (_) => null,
      error: (message) => message,
    );
    if (sexError != null) {
      _showSaveError(sexError);
      return;
    }

    DateTime? parsed;
    try {
      parsed = DateFormat('MMM d, yyyy').parse(_dob);
    } catch (_) {}
    if (_dob.trim().isNotEmpty && parsed == null) {
      _showSaveError('Enter your date of birth in a valid format.');
      return;
    }
    if (parsed != null) {
      final iso =
          '${parsed.year.toString().padLeft(4, '0')}-'
          '${parsed.month.toString().padLeft(2, '0')}-'
          '${parsed.day.toString().padLeft(2, '0')}';
      final dateResult = await notifier.updateDateOfBirth(iso);
      final dateError = dateResult.when(
        success: (_) => null,
        error: (message) => message,
      );
      if (dateError != null) {
        _showSaveError(dateError);
        return;
      }
    }

    final prefs = ref.read(profilePrefsServiceProvider);
    final existing = prefs.load() ?? const CachedProfile();
    final updated = existing.copyWith(
      username: _name.text.trim().isEmpty ? existing.username : _name.text.trim(),
      email: existing.email ?? ref.read(currentProfileProvider)?.email,
      sex: sex?.name ?? existing.sex,
      dateOfBirth: parsed == null
          ? existing.dateOfBirth
          : '${parsed.year.toString().padLeft(4, '0')}-'
              '${parsed.month.toString().padLeft(2, '0')}-'
              '${parsed.day.toString().padLeft(2, '0')}',
    );
    await prefs.save(updated);
    ref.read(cachedProfileProvider.notifier).state = updated;

    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.pop(context);
  }

  void _showSaveError(String message) {
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not save profile: $message')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final remote = ref.watch(currentProfileProvider);
    final cached = ref.watch(cachedProfileProvider);
    final photoUrl = remote?.photoUrl ?? cached?.photoUrl;
    final hasImage = _localPhotoBytes != null || (photoUrl != null && photoUrl.isNotEmpty);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            ProfileBackHeader(
              title: 'Edit Profile',
              centeredTitle: true,
              trailing: TextButton(
                onPressed: _saving ? null : _save,
                child: Text(
                  _saving ? '…' : 'SAVE',
                  style: TextStyle(color: colors.accent, fontWeight: FontWeight.w800, letterSpacing: 0.4),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _changePhoto,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 48,
                                backgroundColor: colors.surface,
                                backgroundImage: _avatarProvider(_localPhotoBytes, photoUrl),
                                child: !hasImage
                                    ? Icon(Icons.person, size: 50, color: colors.textMuted)
                                    : null,
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(color: colors.accent, shape: BoxShape.circle),
                                  child: _uploadingPhoto
                                      ? Padding(
                                          padding: const EdgeInsets.all(7),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: colors.onAccent,
                                          ),
                                        )
                                      : Icon(Icons.camera_alt, color: colors.onAccent, size: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: _changePhoto,
                          child: Text(
                            _uploadingPhoto ? 'Uploading…' : 'Change Photo',
                            style: TextStyle(color: colors.accent, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const ProfileSectionLabel('Personal info'),
                  Text('Full Name', style: TextStyle(color: colors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 8),
                  _field(colors, _name),
                  const SizedBox(height: 14),
                  Text('Email Address', style: TextStyle(color: colors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 8),
                  _field(colors, _email, enabled: false),
                  const SizedBox(height: 6),
                  Text('Managed in Account settings', style: TextStyle(color: colors.textMuted, fontSize: 12)),
                  const SizedBox(height: 22),
                  const ProfileSectionLabel('Body & details'),
                  ProfileGroupCard(
                    children: [
                      ProfileSettingsTile(
                        icon: Icons.calendar_today_outlined,
                        title: 'Date of Birth',
                        value: _dob.isEmpty ? 'Not set' : _dob,
                        onTap: () async {
                          final initial = DateTime.tryParse(
                                (ref.read(cachedProfileProvider)?.dateOfBirth) ?? '',
                              ) ??
                              DateTime(2000, 1, 1);
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: initial,
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2015),
                          );
                          if (picked != null) {
                            setState(() => _dob = DateFormat('MMM d, yyyy').format(picked));
                          }
                        },
                      ),
                      ProfileSettingsTile(
                        icon: Icons.person_outline,
                        title: 'Gender',
                        value: _gender,
                        onTap: () async {
                          final v = await showModalBottomSheet<String>(
                            context: context,
                            backgroundColor: colors.surface,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (ctx) => SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: ['Male', 'Female', 'Other']
                                    .map(
                                      (e) => ListTile(
                                        title: Text(e, style: TextStyle(color: colors.textPrimary)),
                                        onTap: () => Navigator.pop(ctx, e),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          );
                          if (v != null) setState(() => _gender = v);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(dynamic colors, TextEditingController c, {bool enabled = true}) {
    return TextField(
      controller: c,
      enabled: enabled,
      style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.accent, width: 1.5)),
      ),
    );
  }

  ImageProvider? _avatarProvider(Uint8List? bytes, String? photoUrl) {
    if (bytes != null) return MemoryImage(bytes);
    if (photoUrl != null && photoUrl.isNotEmpty) return NetworkImage(photoUrl);
    return null;
  }

  String _capitalize(String v) =>
      v.isEmpty ? v : '${v[0].toUpperCase()}${v.substring(1).toLowerCase()}';

  String _formatDob(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    final d = DateTime.tryParse(iso);
    if (d == null) return iso;
    return DateFormat('MMM d, yyyy').format(d);
  }
}

class BodyProfileScreen extends ConsumerWidget {
  const BodyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final profile = ref.watch(cachedProfileProvider);
    final remote = ref.watch(currentProfileProvider);
    final useMetric = profile?.useMetric ?? true;

    final sex = _capitalize(profile?.sex ?? remote?.sex?.name ?? '—');
    final birthday = _formatDob(profile?.dateOfBirth ?? remote?.dateOfBirth) ?? '—';
    final heightCm = profile?.heightCm ?? remote?.heightCm?.toDouble();
    final weightKg = profile?.weightKg;

    final heightLabel = heightCm == null
        ? '—'
        : useMetric
            ? '${heightCm.round()} cm'
            : _cmToFtIn(heightCm);
    final weightLabel = weightKg == null
        ? '—'
        : useMetric
            ? '${weightKg.toStringAsFixed(1)} kg'
            : '${(weightKg * 2.2046226218).toStringAsFixed(1)} lb';

    return ProfileScaffold(
      title: 'Body Profile',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          _row(colors, 'SEX', 'Sex', sex),
          _row(colors, 'BIRTHDAY', 'Birthday', birthday),
          _row(colors, 'HEIGHT', 'Height', heightLabel),
          _row(colors, 'BODYWEIGHT', 'Bodyweight', weightLabel),
          if (profile?.goal != null) _row(colors, 'GOAL', 'Goal', profile!.goal!),
          if (profile?.experience != null) _row(colors, 'EXPERIENCE', 'Experience', profile!.experience!),
          if (profile?.frequency != null)
            _row(colors, 'FREQUENCY', 'Training days', '${profile!.frequency} / week'),
          if (profile?.equipment != null) _row(colors, 'EQUIPMENT', 'Equipment', profile!.equipment!),
          const SizedBox(height: 8),
          Text(
            'These values come from your profile setup and stay synced in Supabase + on this device.',
            style: TextStyle(color: colors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _row(dynamic colors, String section, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileSectionLabel(section),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.border, width: 0.5),
            ),
            child: Row(
              children: [
                Text(label, style: TextStyle(color: colors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                const Spacer(),
                Text(value, style: TextStyle(color: colors.accent, fontSize: 15, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String v) =>
      v.isEmpty || v == '—' ? v : '${v[0].toUpperCase()}${v.substring(1).toLowerCase()}';

  String? _formatDob(String? iso) {
    if (iso == null || iso.isEmpty) return null;
    final d = DateTime.tryParse(iso);
    if (d == null) return iso;
    return DateFormat('MMM d, yyyy').format(d);
  }

  String _cmToFtIn(double cm) {
    final totalInches = cm / 2.54;
    final feet = totalInches ~/ 12;
    final inches = (totalInches - feet * 12).round();
    return "$feet'$inches\"";
  }
}

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final profile = ref.watch(cachedProfileProvider);
    final remote = ref.watch(currentProfileProvider);
    final email = profile?.email ?? remote?.email ?? '—';
    final username = profile?.username ?? remote?.username ?? profile?.displayName ?? '—';

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            const ProfileBackHeader(title: 'Account', centeredTitle: true),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  ProfileGroupCard(
                    children: [
                      ProfileSettingsTile(
                        icon: Icons.mail_outline,
                        title: 'Email',
                        subtitle: email,
                        onTap: null,
                      ),
                      ProfileSettingsTile(
                        icon: Icons.person_outline,
                        title: 'Username',
                        subtitle: username,
                        onTap: () => context.push('/profile/edit'),
                      ),
                      ProfileSettingsTile(
                        icon: Icons.lock_outline,
                        title: 'Change Password',
                        onTap: () => context.push('/auth/forgot-password'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ProfileGroupCard(
                    children: [
                      ProfileSettingsTile(
                        icon: Icons.delete_outline,
                        title: 'Delete account',
                        iconColor: colors.danger,
                        iconBg: colors.danger.withValues(alpha: 0.12),
                        titleColor: colors.danger,
                        trailing: const SizedBox.shrink(),
                        onTap: () => _confirmDelete(context, ref),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Deleting your account will permanently remove all your data. This action cannot be undone.',
                    style: TextStyle(color: colors.textMuted, fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text(
          'This permanently deletes your profile, routines, workout history, goals, and measurements.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete account'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final result = await ref.read(authNotifierProvider.notifier).deleteAccount();
    if (!context.mounted) return;
    result.when(
      success: (_) => context.go('/welcome'),
      error: (message) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not delete account: $message')),
      ),
    );
  }
}
