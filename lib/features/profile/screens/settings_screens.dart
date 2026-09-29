import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitzella/core/theme/app_theme.dart';
import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/core/models/profile/user_profile.dart' as profile_model;
import 'package:fitzella/core/providers/auth_provider.dart';
import 'package:fitzella/core/services/fitness_data_service.dart';
import 'package:fitzella/features/profile/widgets/profile_widgets.dart';

final unitsProvider = StateNotifierProvider<UnitsNotifier, UnitsState>((ref) {
  final notifier = UnitsNotifier(ref.watch(sharedPreferencesProvider), ref);
  notifier.loadFromServer();
  return notifier;
});

class UnitsState {
  final String weight; // lb | kg
  final String distance; // mi | km
  final String body; // in | cm
  final String? error;

  const UnitsState({
    this.weight = 'lb',
    this.distance = 'mi',
    this.body = 'in',
    this.error,
  });

  UnitsState copyWith({String? weight, String? distance, String? body, String? error}) => UnitsState(
        weight: weight ?? this.weight,
        distance: distance ?? this.distance,
        body: body ?? this.body,
        error: error,
      );

  String get weightLabel => weight == 'lb' ? 'Pounds (lb)' : 'Kilograms (kg)';
}

class UnitsNotifier extends StateNotifier<UnitsState> {
  final SharedPreferences prefs;
  final Ref ref;
  UnitsNotifier(this.prefs, this.ref) : super(UnitsState(
          weight: prefs.getString('unit_weight') ?? 'lb',
          distance: prefs.getString('unit_distance') ?? 'mi',
          body: prefs.getString('unit_body') ?? 'in',
        ));

  Future<void> loadFromServer() async {
    try {
      final values = await ref.read(fitnessDataServiceProvider).fetchAccountPreferences();
      final weight = values['unit_preference'] as String? ?? state.weight;
      final distance = values['distance_preference'] as String? ?? state.distance;
      final body = values['body_measurement_preference'] as String? ?? state.body;
      await prefs.setString('unit_weight', weight);
      await prefs.setString('unit_distance', distance);
      await prefs.setString('unit_body', body);
      state = state.copyWith(weight: weight, distance: distance, body: body);
    } catch (error) {
      state = state.copyWith(error: 'Could not load account preferences: $error');
    }
  }

  Future<void> setWeight(String v) async {
    final result = await ref
        .read(authNotifierProvider.notifier)
        .updateUnitPreference(v == 'kg'
            ? profile_model.UnitPreference.kg
            : profile_model.UnitPreference.lb);
    result.when(
      success: (_) {},
      error: (message) => throw StateError(message),
    );
    await prefs.setString('unit_weight', v);
    state = state.copyWith(weight: v);
  }

  Future<void> setDistance(String v) async {
    await ref.read(fitnessDataServiceProvider).updateAccountPreference(
          'distance_preference',
          v,
        );
    await prefs.setString('unit_distance', v);
    state = state.copyWith(distance: v);
  }

  Future<void> setBody(String v) async {
    await ref.read(fitnessDataServiceProvider).updateAccountPreference(
          'body_measurement_preference',
          v,
        );
    await prefs.setString('unit_body', v);
    state = state.copyWith(body: v);
  }
}

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final theme = ref.watch(appThemeProvider);
    final selected = theme.preference;

    return ProfileScaffold(
      title: 'Appearance',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          ProfileGroupCard(
            children: [
              _ThemeRow(
                icon: Icons.wb_sunny_outlined,
                label: 'Light',
                selected: selected == ThemePreference.light,
                onTap: () => _saveTheme(context, ref, ThemePreference.light),
              ),
              _ThemeRow(
                icon: Icons.dark_mode_outlined,
                label: 'Dark',
                selected: selected == ThemePreference.dark,
                onTap: () => _saveTheme(context, ref, ThemePreference.dark),
              ),
              _ThemeRow(
                icon: Icons.contrast,
                label: 'System',
                selected: selected == ThemePreference.system,
                onTap: () => _saveTheme(context, ref, ThemePreference.system),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Choose how fitzella looks on your device.',
            style: TextStyle(color: colors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Future<void> _saveTheme(
      BuildContext context, WidgetRef ref, ThemePreference preference) async {
    final result = await ref
        .read(authNotifierProvider.notifier)
        .updateThemePreference(
          profile_model.ThemePreference.values.byName(preference.name),
        );
    result.when(
      success: (_) =>
          ref.read(themeNotifierProvider.notifier).setPreference(preference),
      error: (message) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save appearance: $message')),
      ),
    );
  }
}

class _ThemeRow extends ConsumerWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeRow({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected ? colors.accent.withValues(alpha: 0.14) : colors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: selected ? colors.accent : colors.textSecondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? colors.accent : colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? colors.accent : Colors.transparent,
                border: Border.all(color: selected ? colors.accent : colors.border, width: 1.5),
              ),
              child: selected ? Icon(Icons.check, color: colors.onAccent, size: 14) : null,
            ),
          ],
        ),
      ),
    );
  }
}

class UnitsScreen extends ConsumerWidget {
  const UnitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final units = ref.watch(unitsProvider);

    return ProfileScaffold(
      title: 'Units',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          if (units.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(units.error!,
                  style: TextStyle(color: colors.danger)),
            ),
          const ProfileSectionLabel('Weight'),
          _Segment(
            left: 'Kilograms (kg)',
            right: 'Pounds (lb)',
            leftSelected: units.weight == 'kg',
            onLeft: () => _setWeight(context, ref, 'kg'),
            onRight: () => _setWeight(context, ref, 'lb'),
          ),
          const SizedBox(height: 18),
          const ProfileSectionLabel('Distance'),
          _Segment(
            left: 'Kilometers',
            right: 'Miles',
            leftSelected: units.distance == 'km',
            onLeft: () => _setDistance(context, ref, 'km'),
            onRight: () => _setDistance(context, ref, 'mi'),
          ),
          const SizedBox(height: 18),
          const ProfileSectionLabel('Body measurements'),
          _Segment(
            left: 'Centimeters (cm)',
            right: 'Inches (in)',
            leftSelected: units.body == 'cm',
            onLeft: () => _setBody(context, ref, 'cm'),
            onRight: () => _setBody(context, ref, 'in'),
          ),
          const SizedBox(height: 18),
          Text(
            'Weight, distance, and measurements use one system. Changes apply throughout the app immediately.',
            style: TextStyle(color: colors.textMuted, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Future<void> _setWeight(
      BuildContext context, WidgetRef ref, String preference) async {
    try {
      await ref.read(unitsProvider.notifier).setWeight(preference);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save weight units: $error')),
        );
      }
    }
  }

  Future<void> _setDistance(
      BuildContext context, WidgetRef ref, String preference) async {
    try {
      await ref.read(unitsProvider.notifier).setDistance(preference);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save distance units: $error')),
        );
      }
    }
  }

  Future<void> _setBody(
      BuildContext context, WidgetRef ref, String preference) async {
    try {
      await ref.read(unitsProvider.notifier).setBody(preference);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save measurement units: $error')),
        );
      }
    }
  }
}

class _Segment extends ConsumerWidget {
  final String left;
  final String right;
  final bool leftSelected;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  const _Segment({
    required this.left,
    required this.right,
    required this.leftSelected,
    required this.onLeft,
    required this.onRight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(child: _pill(colors, left, leftSelected, onLeft)),
          Expanded(child: _pill(colors, right, !leftSelected, onRight)),
        ],
      ),
    );
  }

  Widget _pill(AppColors colors, String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? colors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? colors.onAccent : colors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final preferences = ref.watch(accountPreferencesProvider);
    const langs = ['English', 'Spanish', 'French', 'German', 'Portuguese'];
    return ProfileScaffold(
      title: 'Language',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          preferences.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Column(
              children: [
                Text('Could not load language preference: $error',
                    style: TextStyle(color: colors.textPrimary)),
                TextButton(
                  onPressed: () => ref.invalidate(accountPreferencesProvider),
                  child: const Text('Try again'),
                ),
              ],
            ),
            data: (values) => ProfileGroupCard(
              children: langs
                .map((l) => ProfileSettingsTile(
                      icon: Icons.language,
                      title: l,
                      trailing: l == values['language_preference']
                          ? Icon(Icons.check_circle, color: colors.accent, size: 20)
                          : Icon(Icons.circle_outlined, color: colors.border, size: 20),
                      onTap: () async {
                        try {
                          await ref.read(fitnessDataServiceProvider)
                              .updateAccountPreference('language_preference', l);
                          ref.invalidate(accountPreferencesProvider);
                        } catch (error) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Could not save language: $error')),
                            );
                          }
                        }
                      },
                    ))
                .toList(),
          ),
          ),
        ],
      ),
    );
  }
}

class RestTimerSettingsScreen extends ConsumerStatefulWidget {
  const RestTimerSettingsScreen({super.key});

  @override
  ConsumerState<RestTimerSettingsScreen> createState() => _RestTimerSettingsScreenState();
}

class _RestTimerSettingsScreenState extends ConsumerState<RestTimerSettingsScreen> {
  String sound = 'Default';

  Future<void> _setEnabled(bool value) async {
    final result = await ref
        .read(authNotifierProvider.notifier)
        .updateRestTimerEnabled(value);
    result.when(
      success: (_) {},
      error: (message) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save timer setting: $message')),
      ),
    );
  }

  Future<void> _setDuration(String value) async {
    final seconds = value == 'Auto' ? null : int.parse(value.replaceAll('s', ''));
    final result = await ref
        .read(authNotifierProvider.notifier)
        .updateRestTimerDefaultOverride(seconds);
    result.when(
      success: (_) {},
      error: (message) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save timer duration: $message')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final profile = ref.watch(currentProfileProvider);
    final enabled = profile?.restTimerEnabled ?? true;
    final override = profile?.restTimerDefaultOverrideSeconds;
    final duration = override == null ? 'Auto' : '${override}s';
    return ProfileScaffold(
      title: 'Rest Timer',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          ProfileGroupCard(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                child: Row(
                  children: [
                    Expanded(child: Text('Rest timer', style: TextStyle(color: colors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600))),
                    Switch.adaptive(
                      value: enabled,
                      activeColor: colors.accent,
                      onChanged: _setEnabled,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  final v = await showModalBottomSheet<String>(
                    context: context,
                    backgroundColor: colors.surface,
                    builder: (ctx) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: ['Auto', '60s', '90s', '120s', '180s']
                            .map((e) => ListTile(
                                  title: Text(e, style: TextStyle(color: colors.textPrimary)),
                                  onTap: () => Navigator.pop(ctx, e),
                                ))
                            .toList(),
                      ),
                    ),
                  );
                  if (v != null) await _setDuration(v);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: Row(
                    children: [
                      Expanded(child: Text('Default duration', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: colors.background, borderRadius: BorderRadius.circular(20)),
                        child: Text(duration, style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ),
              ProfileSettingsTile(
                icon: Icons.volume_up_outlined,
                title: 'Timer Sound',
                value: sound,
                onTap: () => context.push('/profile/timer-sound'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Automatically start a countdown after you log each set. Off disables it entirely.',
            style: TextStyle(color: colors.textSecondary, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class TimerSoundScreen extends ConsumerWidget {
  const TimerSoundScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final preferences = ref.watch(accountPreferencesProvider);
    const sounds = ['Default', 'Beep', 'Chime', 'Bell', 'Silent'];
    return ProfileScaffold(
      title: 'Timer Sound',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          preferences.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Column(
              children: [
                Text('Could not load timer sound preference: $error',
                    style: TextStyle(color: colors.textPrimary)),
                TextButton(
                  onPressed: () => ref.invalidate(accountPreferencesProvider),
                  child: const Text('Try again'),
                ),
              ],
            ),
            data: (values) => ProfileGroupCard(
              children: sounds
                .map((s) => ProfileSettingsTile(
                      icon: Icons.music_note_outlined,
                      title: s,
                      trailing: s == values['timer_sound_preference']
                          ? Icon(Icons.check_circle, color: colors.accent)
                          : null,
                      onTap: () async {
                        try {
                          await ref.read(fitnessDataServiceProvider)
                              .updateAccountPreference('timer_sound_preference', s);
                          ref.invalidate(accountPreferencesProvider);
                        } catch (error) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Could not save timer sound: $error')),
                            );
                          }
                        }
                      },
                    ))
                .toList(),
          ),
          ),
        ],
      ),
    );
  }
}
