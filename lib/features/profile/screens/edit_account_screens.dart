import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/features/profile/widgets/profile_widgets.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _name = TextEditingController(text: 'demo_athlete');
  final _email = TextEditingController(text: 'demo@fitzella.app');
  String _dob = 'Apr 18, 1996';
  String _gender = 'Male';

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            ProfileBackHeader(
              title: 'Edit Profile',
              centeredTitle: true,
              trailing: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('SAVE', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w800, letterSpacing: 0.4)),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundColor: colors.surface,
                              child: Icon(Icons.person, size: 50, color: colors.textMuted),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(color: colors.accent, shape: BoxShape.circle),
                                child: Icon(Icons.camera_alt, color: colors.onAccent, size: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text('Change Photo', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w600)),
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
                  _field(colors, _email),
                  const SizedBox(height: 6),
                  Text('Managed in Account settings', style: TextStyle(color: colors.textMuted, fontSize: 12)),
                  const SizedBox(height: 22),
                  const ProfileSectionLabel('Body & details'),
                  ProfileGroupCard(
                    children: [
                      ProfileSettingsTile(
                        icon: Icons.calendar_today_outlined,
                        title: 'Date of Birth',
                        value: _dob,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(1996, 4, 18),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2015),
                          );
                          if (picked != null) {
                            setState(() => _dob = '${_month(picked.month)} ${picked.day}, ${picked.year}');
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
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                            builder: (ctx) => SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: ['Male', 'Female', 'Other']
                                    .map((e) => ListTile(
                                          title: Text(e, style: TextStyle(color: colors.textPrimary)),
                                          onTap: () => Navigator.pop(ctx, e),
                                        ))
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

  Widget _field(dynamic colors, TextEditingController c) {
    return TextField(
      controller: c,
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

  String _month(int m) =>
      const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][m - 1];
}

class BodyProfileScreen extends ConsumerWidget {
  const BodyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return ProfileScaffold(
      title: 'Body Profile',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          _row(colors, 'SEX', 'Sex', 'Male'),
          _row(colors, 'BIRTHDAY', 'Birthday', 'Apr 18, 1996'),
          _row(colors, 'HEIGHT', 'Height', '5\'10"'),
          _row(colors, 'BODYWEIGHT', 'Bodyweight', '181 lb'),
          const SizedBox(height: 8),
          Text(
            'Updating logs a new entry in Body Measurements.',
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
}

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
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
                        subtitle: 'demo@fitzella.app',
                        onTap: () {},
                      ),
                      ProfileSettingsTile(
                        icon: Icons.person_outline,
                        title: 'Username',
                        subtitle: 'demo_athlete',
                        onTap: () {},
                      ),
                      ProfileSettingsTile(
                        icon: Icons.lock_outline,
                        title: 'Change Password',
                        onTap: () {},
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
                        onTap: () {},
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
}
