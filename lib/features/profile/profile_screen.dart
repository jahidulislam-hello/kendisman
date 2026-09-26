import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitzella/core/providers/auth_provider.dart';
import 'package:fitzella/core/services/profile_prefs_service.dart';
import 'package:fitzella/core/theme/app_theme.dart';
import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/features/profile/widgets/profile_widgets.dart';
import 'package:fitzella/features/profile/screens/settings_screens.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final theme = ref.watch(appThemeProvider);
    final units = ref.watch(unitsProvider);
    final profile = ref.watch(cachedProfileProvider);
    final remote = ref.watch(currentProfileProvider);
    final name = profile?.displayName ??
        remote?.username ??
        (remote?.email.contains('@') == true ? remote!.email.split('@').first : null) ??
        'Athlete';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'A';
    final photoUrl = remote?.photoUrl ?? profile?.photoUrl;
    final tier = remote?.subscriptionTier.name ?? 'free';
    final appearanceLabel = switch (theme.preference) {
      ThemePreference.light => 'Light',
      ThemePreference.dark => 'Dark',
      ThemePreference.system => 'System',
    };

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: colors.surface,
                    backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                        ? NetworkImage(photoUrl)
                        : null,
                    child: photoUrl == null || photoUrl.isEmpty
                        ? Text(
                            initial,
                            style: TextStyle(color: colors.accent, fontSize: 36, fontWeight: FontWeight.w800),
                          )
                        : null,
                  ),
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: GestureDetector(
                      onTap: () => context.push('/profile/edit'),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: colors.accent,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.background, width: 2),
                        ),
                        child: Icon(Icons.camera_alt, color: colors.onAccent, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              tier == 'free' ? 'Free plan' : 'Active · ${tier.toUpperCase()}',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textSecondary, fontSize: 14),
            ),
            if (profile?.goal != null) ...[
              const SizedBox(height: 6),
              Text(
                'Goal: ${profile!.goal}',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.textMuted, fontSize: 13),
              ),
            ],
            const SizedBox(height: 28),
            const ProfileSectionLabel('App settings'),
            ProfileGroupCard(
              children: [
                ProfileSettingsTile(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  onTap: () => context.push('/profile/edit'),
                ),
                ProfileSettingsTile(
                  icon: Icons.accessibility_new,
                  title: 'Body Profile',
                  onTap: () => context.push('/profile/body-profile'),
                ),
                ProfileSettingsTile(
                  icon: Icons.shield_outlined,
                  title: 'Account',
                  onTap: () => context.push('/profile/account'),
                ),
                ProfileSettingsTile(
                  icon: Icons.straighten,
                  title: 'Units',
                  value: units.weightLabel,
                  onTap: () => context.push('/profile/units'),
                ),
                ProfileSettingsTile(
                  icon: Icons.language,
                  title: 'Language',
                  value: 'English',
                  onTap: () => context.push('/profile/language'),
                ),
                ProfileSettingsTile(
                  icon: Icons.wb_sunny_outlined,
                  title: 'Appearance',
                  value: appearanceLabel,
                  onTap: () => context.push('/profile/appearance'),
                ),
                ProfileSettingsTile(
                  icon: Icons.workspace_premium_outlined,
                  title: 'Manage Subscription',
                  onTap: () => context.push('/profile/subscription'),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const ProfileSectionLabel('Workout'),
            ProfileGroupCard(
              children: [
                ProfileSettingsTile(
                  icon: Icons.timer_outlined,
                  title: 'Rest Timer',
                  onTap: () => context.push('/profile/rest-timer-settings'),
                ),
                ProfileSettingsTile(
                  icon: Icons.calendar_month_outlined,
                  title: 'Workout Reminders',
                  onTap: () => context.push('/profile/notifications'),
                ),
                ProfileSettingsTile(
                  icon: Icons.watch_outlined,
                  title: 'Apple Watch',
                  value: 'Coming soon',
                  trailing: const SizedBox.shrink(),
                ),
                ProfileSettingsTile(
                  icon: Icons.ios_share_outlined,
                  title: 'Export & Import Data',
                  onTap: () => context.push('/profile/export-import'),
                ),
                ProfileSettingsTile(
                  icon: Icons.fitness_center,
                  title: 'Build Routine',
                  onTap: () => context.push('/profile/program-builder'),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const ProfileSectionLabel('Legal & security'),
            ProfileGroupCard(
              children: [
                ProfileSettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Terms & Conditions',
                  subtitle: 'Review product terms',
                  external: true,
                  onTap: () {},
                ),
                ProfileSettingsTile(
                  icon: Icons.verified_user_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'See how your data is handled',
                  external: true,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 22),
            const ProfileSectionLabel('Support'),
            ProfileGroupCard(
              children: [
                ProfileSettingsTile(
                  icon: Icons.phone_iphone,
                  title: 'Getting Started',
                  onTap: () => context.push('/profile/help'),
                ),
                ProfileSettingsTile(
                  icon: Icons.chat_bubble_outline,
                  title: 'Contact Us',
                  onTap: () => context.push('/profile/feedback'),
                ),
                ProfileSettingsTile(
                  icon: Icons.info_outline,
                  title: 'About',
                  value: 'v1.0.0',
                  onTap: () => context.push('/profile/about'),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const ProfileSectionLabel('Follow us'),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border, width: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialBtn(icon: Icons.camera_alt_outlined, colors: colors),
                  const SizedBox(width: 18),
                  _SocialBtn(icon: Icons.alternate_email, colors: colors),
                  const SizedBox(width: 18),
                  _SocialBtn(icon: Icons.reddit, colors: colors),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Material(
              color: colors.surface,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: () async {
                  await ref.read(authNotifierProvider.notifier).signOut();
                  if (context.mounted) context.go('/welcome');
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: Text(
                    'Sign out',
                    style: TextStyle(color: colors.danger, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final IconData icon;
  final AppColors colors;
  const _SocialBtn({required this.icon, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: colors.accent.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: colors.accent, size: 22),
    );
  }
}
