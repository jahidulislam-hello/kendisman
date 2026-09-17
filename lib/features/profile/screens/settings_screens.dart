import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitzella/core/theme/app_theme.dart';
import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/features/profile/widgets/profile_widgets.dart';

final unitsProvider = StateNotifierProvider<UnitsNotifier, UnitsState>((ref) {
  return UnitsNotifier(ref.watch(sharedPreferencesProvider));
});

class UnitsState {
  final String weight; // lb | kg
  final String distance; // mi | km
  final String body; // in | cm

  const UnitsState({
    this.weight = 'lb',
    this.distance = 'mi',
    this.body = 'in',
  });

  UnitsState copyWith({String? weight, String? distance, String? body}) => UnitsState(
        weight: weight ?? this.weight,
        distance: distance ?? this.distance,
        body: body ?? this.body,
      );

  String get weightLabel => weight == 'lb' ? 'Pounds (lb)' : 'Kilograms (kg)';
}

class UnitsNotifier extends StateNotifier<UnitsState> {
  final SharedPreferences prefs;
  UnitsNotifier(this.prefs) : super(UnitsState(
          weight: prefs.getString('unit_weight') ?? 'lb',
          distance: prefs.getString('unit_distance') ?? 'mi',
          body: prefs.getString('unit_body') ?? 'in',
        ));

  Future<void> setWeight(String v) async {
    await prefs.setString('unit_weight', v);
    state = state.copyWith(weight: v);
  }

  Future<void> setDistance(String v) async {
    await prefs.setString('unit_distance', v);
    state = state.copyWith(distance: v);
  }

  Future<void> setBody(String v) async {
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
                onTap: () => ref.read(themeNotifierProvider.notifier).setPreference(ThemePreference.light),
              ),
              _ThemeRow(
                icon: Icons.dark_mode_outlined,
                label: 'Dark',
                selected: selected == ThemePreference.dark,
                onTap: () => ref.read(themeNotifierProvider.notifier).setPreference(ThemePreference.dark),
              ),
              _ThemeRow(
                icon: Icons.contrast,
                label: 'System',
                selected: selected == ThemePreference.system,
                onTap: () => ref.read(themeNotifierProvider.notifier).setPreference(ThemePreference.system),
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
          const ProfileSectionLabel('Weight'),
          _Segment(
            left: 'Kilograms (kg)',
            right: 'Pounds (lb)',
            leftSelected: units.weight == 'kg',
            onLeft: () => ref.read(unitsProvider.notifier).setWeight('kg'),
            onRight: () => ref.read(unitsProvider.notifier).setWeight('lb'),
          ),
          const SizedBox(height: 18),
          const ProfileSectionLabel('Distance'),
          _Segment(
            left: 'Kilometers',
            right: 'Miles',
            leftSelected: units.distance == 'km',
            onLeft: () => ref.read(unitsProvider.notifier).setDistance('km'),
            onRight: () => ref.read(unitsProvider.notifier).setDistance('mi'),
          ),
          const SizedBox(height: 18),
          const ProfileSectionLabel('Body measurements'),
          _Segment(
            left: 'Centimeters (cm)',
            right: 'Inches (in)',
            leftSelected: units.body == 'cm',
            onLeft: () => ref.read(unitsProvider.notifier).setBody('cm'),
            onRight: () => ref.read(unitsProvider.notifier).setBody('in'),
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
    const langs = ['English', 'Spanish', 'French', 'German', 'Portuguese'];
    return ProfileScaffold(
      title: 'Language',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          ProfileGroupCard(
            children: langs
                .map((l) => ProfileSettingsTile(
                      icon: Icons.language,
                      title: l,
                      trailing: l == 'English'
                          ? Icon(Icons.check_circle, color: colors.accent, size: 20)
                          : Icon(Icons.circle_outlined, color: colors.border, size: 20),
                      onTap: () => Navigator.pop(context),
                    ))
                .toList(),
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
  bool enabled = true;
  String duration = 'Auto';
  String sound = 'Default';

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
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
                      onChanged: (v) => setState(() => enabled = v),
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
                  if (v != null) setState(() => duration = v);
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
    const sounds = ['Default', 'Beep', 'Chime', 'Bell', 'Silent'];
    return ProfileScaffold(
      title: 'Timer Sound',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          ProfileGroupCard(
            children: sounds
                .map((s) => ProfileSettingsTile(
                      icon: Icons.music_note_outlined,
                      title: s,
                      trailing: s == 'Default' ? Icon(Icons.check_circle, color: colors.accent) : null,
                      onTap: () => Navigator.pop(context),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
