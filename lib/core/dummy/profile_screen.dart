// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
//
// import 'package:fitzella/core/theme/app_theme.dart';
// import 'package:fitzella/core/theme/theme_provider.dart';
// import 'package:fitzella/core/providers/auth_provider.dart';
// import 'package:fitzella/core/models/profile/user_profile.dart';
// import 'package:fitzella/shared/widgets/buttons.dart';
// import 'package:fitzella/shared/widgets/cards.dart';
//
// /// Profile screen
// class ProfileScreen extends ConsumerWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final colors = ref.watch(appColorsProvider);
//     final authState = ref.watch(authNotifierProvider);
//     final profile = authState.profile;
//
//     return Scaffold(
//       backgroundColor: colors.background,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, 0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Profile header
//               Row(
//                 children: [
//                   // Avatar
//                   Container(
//                     width: 60,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       color: colors.surface,
//                       borderRadius: BorderRadius.circular(30),
//                       border: Border.all(color: colors.border, width: 0.5),
//                     ),
//                     child: Center(
//                       child: Text(
//                         _getDisplayName(profile)?.characters.first ?? '?',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: colors.accent,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const HGap(AppSpacing.md),
//                   // Name and email
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           _getDisplayName(profile) ?? 'User',
//                           style: AppTypography.greeting.copyWith(color: colors.textPrimary),
//                         ),
//                         if (profile?.email != null)
//                           Text(
//                             profile!.email,
//                             style: AppTypography.secondary.copyWith(color: colors.textSecondary),
//                           ),
//                       ],
//                     ),
//                   ),
//                   // Settings button
//                   CircularIconButton(
//                     icon: Icons.settings,
//                     onPressed: () => context.go('/profile/edit'),
//                     backgroundColor: colors.surface,
//                     iconColor: colors.textPrimary,
//                   ),
//                 ],
//               ),
//
//               const VGap(AppSpacing.xl),
//
//               // Sections
//               Text('Account', style: AppTypography.sectionHeader.copyWith(color: colors.textPrimary)),
//               const VGap(AppSpacing.md),
//               _buildSettingsSection(colors, [
//                 _SettingsItem('Account', Icons.person_outline, () => context.go('/profile/account')),
//                 _SettingsItem('Privacy', Icons.privacy_tip_outlined, () => context.go('/profile/account-privacy')),
//                 _SettingsItem('Subscription', Icons.card_membership_outlined, () => context.go('/profile/subscription')),
//               ]),
//
//               const VGap(AppSpacing.xl),
//
//               Text('Appearance', style: AppTypography.sectionHeader.copyWith(color: colors.textPrimary)),
//               const VGap(AppSpacing.md),
//               _buildSettingsSection(colors, [
//                 _SettingsItem('Theme', Icons.palette_outlined, () => context.go('/profile/appearance')),
//                 _SettingsItem('Units', Icons.straighten_outlined, () => context.go('/profile/units')),
//                 _SettingsItem('Language', Icons.language_outlined, () => context.go('/profile/language')),
//               ]),
//
//               const VGap(AppSpacing.xl),
//
//               Text('Notifications', style: AppTypography.sectionHeader.copyWith(color: colors.textPrimary)),
//               const VGap(AppSpacing.md),
//               _buildSettingsSection(colors, [
//                 _SettingsItem('Workout Reminders', Icons.notifications_outlined, () => context.go('/profile/notifications')),
//                 _SettingsItem('Timer Sound', Icons.volume_up_outlined, () => context.go('/profile/timer-sound')),
//                 _SettingsItem('Rest Timer', Icons.timer_outlined, () => context.go('/profile/rest-timer-settings')),
//               ]),
//
//               const VGap(AppSpacing.xl),
//
//               Text('Data', style: AppTypography.sectionHeader.copyWith(color: colors.textPrimary)),
//               const VGap(AppSpacing.md),
//               _buildSettingsSection(colors, [
//                 _SettingsItem('Import Data', Icons.upload_outlined, () => context.go('/profile/import-data')),
//                 _SettingsItem('Export Data', Icons.download_outlined, () => context.go('/profile/export-import')),
//               ]),
//
//               const VGap(AppSpacing.xl),
//
//               Text('Support', style: AppTypography.sectionHeader.copyWith(color: colors.textPrimary)),
//               const VGap(AppSpacing.md),
//               _buildSettingsSection(colors, [
//                 _SettingsItem('Get Help', Icons.help_outline, () => context.go('/profile/help')),
//                 _SettingsItem('Send Feedback', Icons.feedback_outlined, () => context.go('/profile/feedback')),
//                 _SettingsItem('About', Icons.info_outline, () => context.go('/profile/about')),
//               ]),
//
//               const VGap(AppSpacing.xl),
//
//               Text('More', style: AppTypography.sectionHeader.copyWith(color: colors.textPrimary)),
//               const VGap(AppSpacing.md),
//               _buildSettingsSection(colors, [
//                 _SettingsItem('Goals', Icons.flag_outlined, () => context.go('/profile/goals')),
//                 _SettingsItem('Program Manager', Icons.fitness_center_outlined, () => context.go('/profile/program-manager')),
//                 _SettingsItem('Referral', Icons.share_outlined, () => context.go('/profile/referral')),
//               ]),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSettingsSection(AppColors colors, List<_SettingsItem> items) {
//     return Column(
//       children: items.map((item) => AppCard(
//         onTap: item.onTap,
//         padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
//         child: Row(
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: colors.accent.withValues(alpha: 0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(item.icon, color: colors.accent, size: 20),
//             ),
//             const HGap(AppSpacing.md),
//             Expanded(
//               child: Text(item.title, style: AppTypography.body.copyWith(color: colors.textPrimary)),
//             ),
//             Icon(Icons.chevron_right, color: colors.textMuted),
//           ],
//         ),
//       )).toList(),
//     );
//   }
//
//   String? _getDisplayName(UserProfile? profile) {
//     if (profile == null) return null;
//     final rawUsername = profile.username?.trim();
//     if (rawUsername != null && rawUsername.isNotEmpty && !rawUsername.contains('@') && !rawUsername.contains('+')) {
//       return rawUsername;
//     }
//     if (profile.email != null) {
//       final local = profile.email.split('@')[0].split('+')[0].split('.')[0].trim();
//       if (local.isNotEmpty) {
//         return local[0].toUpperCase() + local.substring(1);
//       }
//     }
//     return null;
//   }
// }
//
// class _SettingsItem {
//   final String title;
//   final IconData icon;
//   final VoidCallback onTap;
//   _SettingsItem(this.title, this.icon, this.onTap);
// }