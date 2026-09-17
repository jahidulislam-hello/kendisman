// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
//
// import 'package:fitzella/core/theme/app_theme.dart';
// import 'package:fitzella/core/theme/theme_provider.dart';
// import 'package:fitzella/core/providers/auth_provider.dart';
// import 'package:fitzella/core/providers/workout_session_provider.dart';
// import 'package:fitzella/shared/widgets/buttons.dart';
// import 'package:fitzella/shared/widgets/cards.dart';
// import 'package:fitzella/shared/widgets/dialogs_sheets.dart';
//
// /// Workout screen matching the React Native WorkoutScreen
// class WorkoutScreen extends ConsumerStatefulWidget {
//   const WorkoutScreen({super.key});
//
//   @override
//   ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
// }
//
// class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
//   String? _previewRoutineId;
//   bool _clockOpen = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = ref.watch(appColorsProvider);
//     final authState = ref.watch(authNotifierProvider);
//     final workoutState = ref.watch(workoutSessionNotifierProvider);
//     final profile = authState.profile;
//     final session = authState.session;
//     final library = _getPlaceholderLibrary();
//     final hasActiveSession = workoutState.hasActiveSession;
//     final loading = workoutState.loading;
//
//     return Scaffold(
//       backgroundColor: colors.background,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, 0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Title row with clock button
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Workout', style: AppTypography.screenTitle.copyWith(color: colors.textPrimary)),
//                   CircularIconButton(
//                     icon: Icons.access_time,
//                     onPressed: () => setState(() => _clockOpen = true),
//                     backgroundColor: colors.surface,
//                     iconColor: colors.textPrimary,
//                   ),
//                 ],
//               ),
//               const VGap(AppSpacing.lg),
//
//               // Resume banner
//               if (hasActiveSession)
//                 AppCard(
//                   backgroundColor: colors.accent,
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 8,
//                         height: 8,
//                         decoration: BoxDecoration(
//                           color: colors.onAccent,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                       ),
//                       const HGap(AppSpacing.sm),
//                       Expanded(
//                         child: Text(
//                           'Resume in-progress workout',
//                           style: AppTypography.resumeText.copyWith(color: colors.onAccent),
//                         ),
//                       ),
//                       Icon(Icons.chevron_right, color: colors.onAccent),
//                     ],
//                   ),
//                 ),
//
//               const VGap(AppSpacing.lg),
//
//               // Start empty workout button
//               PrimaryButton(
//                 title: 'Start Empty Workout',
//                 onPressed: _handleStartEmpty,
//                 width: double.infinity,
//               ),
//
//               const VGap(AppSpacing.md),
//
//               // Launcher pills
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => context.go('/profile/routine-editor'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: colors.accent,
//                         side: BorderSide(color: colors.accent, width: 1.5),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text('+', style: AppTypography.launcherPlus.copyWith(color: colors.accent)),
//                           const HGap(AppSpacing.sm),
//                           Text('New Routine', style: AppTypography.launcherText),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const HGap(AppSpacing.md),
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => context.go('/profile/new-plan'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: colors.accent,
//                         side: BorderSide(color: colors.accent, width: 1.5),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text('+', style: AppTypography.launcherPlus.copyWith(color: colors.accent)),
//                           const HGap(AppSpacing.sm),
//                           Text('New Plan', style: AppTypography.launcherText),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const VGap(AppSpacing.xl),
//
//               // Active program header
//               if (library != null)
//                 GestureDetector(
//                   onTap: () => context.go('/profile/program-manager'),
//                   child: AppCard(
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             library.program.name,
//                             style: AppTypography.planName.copyWith(color: colors.textPrimary),
//                           ),
//                         ),
//                         Icon(Icons.chevron_right, color: colors.textSecondary, size: 20),
//                       ],
//                     ),
//                   ),
//                 ),
//
//               const VGap(AppSpacing.md),
//
//               // Routine grid
//               if (library != null && library.entries.isNotEmpty)
//                 Expanded(
//                   child: GridView.builder(
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: AppSpacing.sm,
//                       mainAxisSpacing: AppSpacing.md,
//                       childAspectRatio: 0.85,
//                     ),
//                     itemCount: library.entries.length,
//                     itemBuilder: (context, index) {
//                       final entry = library.entries[index];
//                       return _RoutineCard(
//                         entry: entry,
//                         onTap: () => setState(() => _previewRoutineId = entry.routine.id),
//                       );
//                     },
//                   ),
//                 )
//               else if (library != null && library.entries.isEmpty)
//                 Center(
//                   child: Text(
//                     'This plan has no routines yet',
//                     style: AppTypography.emptyPlan.copyWith(color: colors.textSecondary),
//                   ),
//                 )
//               else
//                 _buildNoProgramView(colors),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNoProgramView(AppColors colors) {
//     return Expanded(
//       child: EmptyState(
//         icon: Icons.fitness_center,
//         title: 'No Active Program',
//         subtitle: 'Create a routine or browse programs to get started.',
//         action: Column(
//           children: [
//             PrimaryButton(
//               title: 'Browse Programs',
//               onPressed: () => context.go('/profile/program-templates'),
//               width: double.infinity,
//             ),
//             const VGap(AppSpacing.md),
//             OutlinedButton(
//               onPressed: _handleStartEmpty,
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: colors.accent,
//                 side: BorderSide(color: colors.accent, width: 1.5),
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('+', style: AppTypography.launcherPlus.copyWith(color: colors.accent)),
//                   const HGap(AppSpacing.sm),
//                   Text('Start Empty Workout', style: AppTypography.launcherText),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   _PlaceholderRoutineLibrary? _getPlaceholderLibrary() {
//     // Placeholder - would come from actual data
//     return _PlaceholderRoutineLibrary(
//       program: _PlaceholderProgram(name: 'Push/Pull/Legs'),
//       entries: [
//         _PlaceholderRoutineEntry(routine: _PlaceholderRoutine(name: 'Push Day', id: '1'), exerciseCount: 6),
//         _PlaceholderRoutineEntry(routine: _PlaceholderRoutine(name: 'Pull Day', id: '2'), exerciseCount: 5),
//         _PlaceholderRoutineEntry(routine: _PlaceholderRoutine(name: 'Leg Day', id: '3'), exerciseCount: 7),
//         _PlaceholderRoutineEntry(routine: _PlaceholderRoutine(name: 'Upper Body', id: '4'), exerciseCount: 8),
//       ],
//     );
//   }
//
//   void _handleStartEmpty() {
//     // TODO: Start empty workout
//     context.go('/workout/active');
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // Show preview sheet when routine selected
//   }
// }
//
// class _RoutineCard extends ConsumerWidget {
//   final _PlaceholderRoutineEntry entry;
//   final VoidCallback onTap;
//
//   const _RoutineCard({required this.entry, required this.onTap});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final colors = ref.watch(appColorsProvider);
//     return AppCard(
//       onTap: onTap,
//       padding: const EdgeInsets.all(AppSpacing.lg),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(entry.routine.name, style: AppTypography.cardName.copyWith(color: colors.textPrimary)),
//           const VGap(AppSpacing.sm),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('• Exercise 1', style: AppTypography.cardExercise.copyWith(color: colors.textSecondary)),
//                 Text('• Exercise 2', style: AppTypography.cardExercise.copyWith(color: colors.textSecondary)),
//                 Text('• Exercise 3', style: AppTypography.cardExercise.copyWith(color: colors.textSecondary)),
//                 if (entry.exerciseCount > 3)
//                   Text('+${entry.exerciseCount - 3} more', style: AppTypography.cardMore.copyWith(color: colors.textMuted)),
//               ],
//             ),
//           ),
//           Text('Last performed: Today', style: AppTypography.cardLast.copyWith(color: colors.textMuted)),
//         ],
//       ),
//     );
//   }
// }
//
// class _PlaceholderProgram {
//   final String name;
//   _PlaceholderProgram({required this.name});
// }
//
// class _PlaceholderRoutine {
//   final String name;
//   final String id;
//   _PlaceholderRoutine({required this.name, required this.id});
// }
//
// class _PlaceholderRoutineEntry {
//   final _PlaceholderRoutine routine;
//   final int exerciseCount;
//   _PlaceholderRoutineEntry({required this.routine, required this.exerciseCount});
// }
//
// class _PlaceholderRoutineLibrary {
//   final _PlaceholderProgram program;
//   final List<_PlaceholderRoutineEntry> entries;
//   _PlaceholderRoutineLibrary({required this.program, required this.entries});
// }