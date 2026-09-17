// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
//
// import 'package:fitzella/core/theme/app_theme.dart';
// import 'package:fitzella/core/theme/theme_provider.dart';
//
// import 'package:fitzella/shared/widgets/cards.dart';
//
// /// Progress screen
// class ProgressScreen extends ConsumerWidget {
//   const ProgressScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final colors = ref.watch(appColorsProvider);
//
//     return Scaffold(
//       backgroundColor: colors.background,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, 0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Progress', style: AppTypography.screenTitle.copyWith(color: colors.textPrimary)),
//               const VGap(AppSpacing.xl),
//               Expanded(
//                 child: ListView(
//                   children: [
//                     _buildSectionCard(
//                       colors,
//                       'Body Measurements',
//                       'Track your body composition over time',
//                       Icons.straighten,
//                       () => context.go('/profile/body-measurements'),
//                     ),
//                     const VGap(AppSpacing.md),
//                     _buildSectionCard(
//                       colors,
//                       'Personal Records',
//                       'View your strongest lifts',
//                       Icons.emoji_events,
//                       () => context.go('/progress/personal-records'),
//                     ),
//                     const VGap(AppSpacing.md),
//                     _buildSectionCard(
//                       colors,
//                       'Workout Calendar',
//                       'See your training consistency',
//                       Icons.calendar_month,
//                       () => context.go('/progress/calendar'),
//                     ),
//                     const VGap(AppSpacing.md),
//                     _buildSectionCard(
//                       colors,
//                       'Achievements',
//                       'Unlock badges and milestones',
//                       Icons.military_tech,
//                       () => context.go('/progress/achievements'),
//                     ),
//                     const VGap(AppSpacing.md),
//                     _buildSectionCard(
//                       colors,
//                       'Session History',
//                       'Review past workouts in detail',
//                       Icons.history,
//                       () => context.go('/progress/session-detail'),
//                     ),
//                     const VGap(AppSpacing.md),
//                     _buildSectionCard(
//                       colors,
//                       'Monthly Report',
//                       'Your training summary',
//                       Icons.description,
//                       () => context.go('/progress/monthly-report'),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionCard(
//     AppColors colors,
//     String title,
//     String subtitle,
//     IconData icon,
//     VoidCallback onTap,
//   ) {
//     return AppCard(
//       onTap: onTap,
//       child: Row(
//         children: [
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               color: colors.accent.withValues(alpha: 0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, color: colors.accent, size: 24),
//           ),
//           const HGap(AppSpacing.md),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: AppTypography.cardTitle.copyWith(color: colors.textPrimary)),
//                 const VGap(2),
//                 Text(subtitle, style: AppTypography.secondary.copyWith(color: colors.textSecondary)),
//               ],
//             ),
//           ),
//           Icon(Icons.chevron_right, color: colors.textMuted),
//         ],
//       ),
//     );
//   }
// }