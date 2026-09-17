// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:go_router/go_router.dart';
//
// import 'package:fitzella/core/theme/app_theme.dart';
// import 'package:fitzella/core/theme/theme_provider.dart';
// import 'package:fitzella/core/providers/auth_provider.dart';
// import 'package:fitzella/core/providers/workout_session_provider.dart';
// import 'package:fitzella/core/models/session/workout_session.dart';
// import 'package:fitzella/core/models/profile/user_profile.dart';
// import 'package:fitzella/shared/widgets/buttons.dart';
// import 'package:fitzella/shared/widgets/cards.dart';
// import 'package:fitzella/shared/widgets/dialogs_sheets.dart';
// import 'package:fitzella/shared/widgets/inputs.dart';
//
// /// Home screen matching the React Native HomeScreen
// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   final _scrollController = ScrollController();
//   bool _chooserOpen = false;
//   String? _startingRoutineId;
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = ref.watch(appColorsProvider);
//     final authState = ref.watch(authNotifierProvider);
//     final workoutState = ref.watch(workoutSessionNotifierProvider);
//     final profile = authState.profile;
//     final session = authState.session;
//     final workout = workoutState.workout;
//     final isRestDay = workoutState.isRestDay;
//     final workoutLoading = workoutState.loading;
//
//     // Handle loading state
//     if (workoutLoading) {
//       return Scaffold(
//         backgroundColor: colors.background,
//         body: Center(
//           child: CircularProgressIndicator(color: colors.textPrimary),
//         ),
//       );
//     }
//
//     // Handle rest day
//     if (workout == null && isRestDay) {
//       return _buildRestDayView(colors);
//     }
//
//     // Handle no program
//     if (workout == null) {
//       return _buildNoProgramView(colors);
//     }
//
//     return _buildHomeContent(colors, profile, workout);
//   }
//
//   Widget _buildRestDayView(AppColors colors) {
//     return Scaffold(
//       backgroundColor: colors.background,
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(AppSpacing.xxl),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text('😴', style: TextStyle(fontSize: 54)),
//                 const VGap(AppSpacing.sm),
//                 Text('Rest Day', style: AppTypography.restTitle.copyWith(color: colors.textPrimary)),
//                 const VGap(AppSpacing.sm),
//                 Text(
//                   'Your program has today as a rest day. You can still choose a routine to train.',
//                   style: AppTypography.restSubtitle.copyWith(color: colors.textSecondary),
//                   textAlign: TextAlign.center,
//                 ),
//                 const VGap(AppSpacing.lg),
//                 PrimaryButton(
//                   title: 'Choose Routine',
//                   leading: const Icon(Icons.swap_horiz, size: 15),
//                   onPressed: _openChooser,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNoProgramView(AppColors colors) {
//     return Scaffold(
//       backgroundColor: colors.background,
//       body: SafeArea(
//         child: EmptyState(
//           icon: Icons.fitness_center,
//           title: 'No Active Program',
//           subtitle: 'Create a program or choose a template to get started.',
//           action: PrimaryButton(
//             title: 'Browse Programs',
//             onPressed: () => context.go('/profile/program-templates'),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHomeContent(AppColors colors, UserProfile? profile, TodaysWorkout workout) {
//     final exerciseCount = workout.items.length;
//     final setCount = workout.items.fold(0, (sum, item) => sum + item.targetSets);
//
//     final name = _getDisplayName(profile);
//     final dateLine = _formatDateLine();
//
//     // Stats (placeholder - would come from HomeStats)
//     final stats = _getPlaceholderStats();
//
//     return Scaffold(
//       backgroundColor: colors.background,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header with avatar
//             _buildHeader(colors, name, dateLine),
//
//             // Scrollable content
//             Expanded(
//               child: SingleChildScrollView(
//                 controller: _scrollController,
//                 padding: const EdgeInsets.fromLTRB(
//                   AppSpacing.xl,
//                   0,
//                   AppSpacing.xl,
//                   AppSpacing.xxl,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Up Next hero card
//                     _buildHeroCard(colors, workout, exerciseCount, setCount),
//
//                     const VGap(AppSpacing.xl),
//
//                     // This Week section
//                     SectionHeader(title: 'This Week'),
//                     _buildWeekChips(colors),
//
//                     const VGap(AppSpacing.xl),
//
//                     // Weekly Snapshot
//                     Text('Weekly Snapshot', style: AppTypography.sectionHeader.copyWith(color: colors.textPrimary)),
//                     const VGap(AppSpacing.md),
//                     _buildStatsRow1(colors, stats),
//                     const VGap(AppSpacing.md),
//                     _buildStatsRow2(colors, stats),
//
//                     const VGap(AppSpacing.xl),
//
//                     // Achievements
//                     _buildAchievements(colors),
//                   ],
//                 ),
//               ),
//             ),
//
//             // Routine chooser bottom sheet
//             if (_chooserOpen) _buildRoutineChooser(colors),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader(AppColors colors, String? name, String dateLine) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.md),
//       child: Row(
//         children: [
//           // Avatar
//           GestureDetector(
//             onTap: _handleChangePhoto,
//             child: Container(
//               width: 44,
//               height: 44,
//               decoration: BoxDecoration(
//                 color: colors.surface,
//                 borderRadius: BorderRadius.circular(22),
//                 border: Border.all(color: colors.border, width: 0.5),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(22),
//                 child: _buildAvatarContent(colors, name),
//               ),
//             ),
//           ),
//           const HGap(AppSpacing.md),
//           // Greeting
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(dateLine, style: AppTypography.dateLine.copyWith(color: colors.textSecondary)),
//                 const VGap(2),
//                 Text(
//                   name != null ? 'Ready, $name?' : 'Ready?',
//                   style: AppTypography.greeting.copyWith(color: colors.textPrimary),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAvatarContent(AppColors colors, String? name) {
//     // Would show image if photo_url exists
//     return Center(
//       child: Text(
//         (name ?? '?').characters.first,
//         style: AppTypography.avatarText.copyWith(color: colors.accent),
//       ),
//     );
//   }
//
//   Widget _buildHeroCard(AppColors colors, TodaysWorkout workout, int exerciseCount, int setCount) {
//     final heroSubtext = 'Week 1 • ${workout.routine.name}'; // Placeholder
//     final estimatedMinutes = _estimateWorkoutMinutes(workout);
//
//     return AppCard(
//       onTap: _handleStartToday,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Top row with "Up Next" pill and duration
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: colors.accent.withValues(alpha: 0.1),
//                   borderRadius: BorderRadius.circular(AppRadius.pill),
//                 ),
//                 child: Text('Up Next', style: AppTypography.upNextPill.copyWith(color: colors.accent)),
//               ),
//               if (estimatedMinutes > 0)
//                 Row(
//                   children: [
//                     Icon(Icons.access_time, size: 14, color: colors.textSecondary),
//                     const HGap(AppSpacing.xs),
//                     Text('${estimatedMinutes}m', style: AppTypography.heroDuration.copyWith(color: colors.textSecondary)),
//                   ],
//                 ),
//             ],
//           ),
//           const VGap(AppSpacing.md),
//
//           // Routine name
//           Text(workout.routine.name, style: AppTypography.heroTitle.copyWith(color: colors.textPrimary)),
//           const VGap(AppSpacing.xs),
//           Text(heroSubtext, style: AppTypography.heroMeta.copyWith(color: colors.textSecondary)),
//
//           const VGap(AppSpacing.lg),
//
//           // Start button
//           SizedBox(
//             width: double.infinity,
//             child: PrimaryButton(
//               title: 'Start Workout',
//               leading: const _PlayIcon(),
//               onPressed: _handleStartToday,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWeekChips(AppColors colors) {
//     final weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
//     final todayIndex = DateTime.now().weekday - 1;
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: weekDays.asMap().entries.map((entry) {
//         final index = entry.key;
//         final label = entry.value;
//         final isToday = index == todayIndex;
//         final workedOut = index < todayIndex; // Placeholder
//
//         Color bgColor;
//         Color textColor;
//         if (workedOut) {
//           bgColor = colors.accent.withValues(alpha: 0.1);
//           textColor = colors.accent;
//         } else if (isToday) {
//           bgColor = colors.accent;
//           textColor = colors.onAccent;
//         } else {
//           bgColor = colors.background;
//           textColor = colors.textMuted;
//         }
//
//         return Expanded(
//           child: Container(
//             margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs / 2),
//             padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
//             decoration: BoxDecoration(
//               color: bgColor,
//               borderRadius: BorderRadius.circular(AppRadius.badge),
//               border: workedOut || isToday ? null : Border.all(color: colors.border, width: 0.5),
//             ),
//             child: Column(
//               children: [
//                 Text(label, style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w600,
//                   color: textColor,
//                 )),
//                 const VGap(2),
//                 Text(
//                   '${index + 1}',
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: textColor,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
//
//   Widget _buildStatsRow1(AppColors colors, _PlaceholderStats stats) {
//     return Row(
//       children: [
//         Expanded(
//           child: _StatCard(
//             icon: Icons.fitness_center,
//             label: 'Volume',
//             value: '${stats.volumeThisWeek.toStringAsFixed(0)} ${stats.unit}',
//             caption: '${stats.volPct >= 0 ? '+' : ''}${stats.volPct.toStringAsFixed(1)}% vs last week',
//             good: stats.volPct >= 0,
//           ),
//         ),
//         const HGap(AppSpacing.md),
//         Expanded(
//           child: _StatCard(
//             icon: Icons.layers,
//             label: 'Sets',
//             value: '${stats.setsThisWeek}',
//             caption: stats.perWorkout > 0 ? '${stats.perWorkout} per workout' : null,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatsRow2(AppColors colors, _PlaceholderStats stats) {
//     return Row(
//       children: [
//         Expanded(
//           child: _StatCard(
//             icon: Icons.calendar_today,
//             label: 'Workouts',
//             value: '${stats.workoutsThisWeek}/${stats.weeklyTarget}',
//             caption: stats.remaining > 0 ? '${stats.remaining} remaining' : null,
//           ),
//         ),
//         const HGap(AppSpacing.md),
//         Expanded(
//           child: _StatCard(
//             icon: Icons.access_time,
//             label: 'Time',
//             value: _formatDuration(stats.minutesThisWeek),
//             caption: stats.minDiff != 0
//                 ? '${stats.minDiff >= 0 ? '+' : ''}${_formatDuration(stats.minDiff.abs())} vs last week'
//                 : null,
//             good: stats.minDiff >= 0,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildAchievements(AppColors colors) {
//     final pills = <_AchievementPill>[
//       if (true) _AchievementPill(
//         icon: Icons.local_fire_department,
//         text: '3 workouts this week',
//       ),
//       if (true) _AchievementPill(
//         icon: Icons.star,
//         text: '2 PRs',
//       ),
//     ];
//
//     if (pills.isEmpty) return const SizedBox.shrink();
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('Achievements', style: AppTypography.sectionHeader.copyWith(color: colors.textPrimary)),
//             Icon(Icons.chevron_right, color: colors.textMuted),
//           ],
//         ),
//         const VGap(AppSpacing.md),
//         Wrap(
//           spacing: AppSpacing.sm,
//           runSpacing: AppSpacing.sm,
//           children: pills.map((pill) => Container(
//             padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
//             decoration: BoxDecoration(
//               color: colors.surface,
//               borderRadius: BorderRadius.circular(AppRadius.pill),
//               border: Border.all(color: colors.border, width: 0.5),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(pill.icon, size: 14, color: colors.accent),
//                 const HGap(AppSpacing.xs),
//                 Text(pill.text, style: AppTypography.secondary.copyWith(color: colors.textPrimary)),
//               ],
//             ),
//           )).toList(),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildRoutineChooser(AppColors colors) {
//     return Positioned.fill(
//       child: Material(
//         color: Colors.black.withValues(alpha: 0.45),
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             height: MediaQuery.of(context).size.height * 0.8,
//             decoration: BoxDecoration(
//               color: colors.surface,
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
//               border: Border.all(color: colors.border, width: 0.5),
//             ),
//             child: Column(
//               children: [
//                 // Grabber
//                 Container(
//                   margin: const EdgeInsets.only(top: AppSpacing.md),
//                   width: 44,
//                   height: 5,
//                   decoration: BoxDecoration(
//                     color: colors.border,
//                     borderRadius: BorderRadius.circular(3),
//                   ),
//                 ),
//                 // Title
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.md),
//                   child: Text('Choose Routine', style: AppTypography.sheetTitle.copyWith(color: colors.textPrimary)),
//                 ),
//                 // List
//                 Expanded(
//                   child: ListView(
//                     padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
//                     children: [
//                       // Placeholder routine entries
//                       _RoutineChooserItem(
//                         name: 'Push Day',
//                         exerciseCount: 6,
//                         isActive: false,
//                         onTap: () {},
//                       ),
//                       _RoutineChooserItem(
//                         name: 'Pull Day',
//                         exerciseCount: 5,
//                         isActive: true,
//                         onTap: () {},
//                       ),
//                       _RoutineChooserItem(
//                         name: 'Leg Day',
//                         exerciseCount: 7,
//                         isActive: false,
//                         onTap: () {},
//                       ),
//                       // New routine button
//                       const VGap(AppSpacing.xs),
//                       OutlinedButton(
//                         onPressed: _createNewRoutine,
//                         style: OutlinedButton.styleFrom(
//                           side: BorderSide(color: colors.border, width: 1.5),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
//                           padding: const EdgeInsets.all(AppSpacing.md),
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 40,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                 color: colors.background,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Center(
//                                 child: Text('+', style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.normal,
//                                   color: colors.textSecondary,
//                                 )),
//                               ),
//                             ),
//                             const HGap(AppSpacing.md),
//                             Text('New Routine', style: AppTypography.newRowText.copyWith(color: colors.textPrimary)),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
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
//
//   String _formatDateLine() {
//     final now = DateTime.now();
//     return '${_weekdayName(now.weekday)}, ${_monthName(now.month)} ${now.day}';
//   }
//
//   String _weekdayName(int weekday) {
//     const names = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
//     return names[weekday - 1];
//   }
//
//   String _monthName(int month) {
//     const names = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
//     return names[month - 1];
//   }
//
//   _PlaceholderStats _getPlaceholderStats() {
//     return _PlaceholderStats(
//       volumeThisWeek: 12500,
//       volumeLastWeek: 11000,
//       minutesThisWeek: 180,
//       minutesLastWeek: 160,
//       setsThisWeek: 45,
//       workoutsThisWeek: 3,
//       weeklyTarget: 4,
//       streak: 5,
//     );
//   }
//
//   int _estimateWorkoutMinutes(TodaysWorkout workout) {
//     int total = 0;
//     for (final item in workout.items) {
//       final rest = 90; // Default compound rest
//       total += item.targetSets * (45 + rest) + 45;
//     }
//     return (total / 60).round();
//   }
//
//   String _formatDuration(int minutes) {
//     if (minutes < 60) return '${minutes}m';
//     final hours = minutes ~/ 60;
//     final rem = minutes % 60;
//     return rem > 0 ? '${hours}h ${rem}m' : '${hours}h';
//   }
//
//   void _handleChangePhoto() {
//     // TODO: Implement image picker
//   }
//
//   void _handleStartToday() {
//     // TODO: Start workout
//     context.go('/workout/active');
//   }
//
//   void _openChooser() {
//     setState(() => _chooserOpen = true);
//   }
//
//   void _createNewRoutine() {
//     setState(() => _chooserOpen = false);
//     context.go('/profile/routine-editor');
//   }
// }
//
// class _PlaceholderStats {
//   final double volumeThisWeek;
//   final double volumeLastWeek;
//   final int minutesThisWeek;
//   final int minutesLastWeek;
//   final int setsThisWeek;
//   final int workoutsThisWeek;
//   final int weeklyTarget;
//   final int streak;
//
//   const _PlaceholderStats({
//     required this.volumeThisWeek,
//     required this.volumeLastWeek,
//     required this.minutesThisWeek,
//     required this.minutesLastWeek,
//     required this.setsThisWeek,
//     required this.workoutsThisWeek,
//     required this.weeklyTarget,
//     required this.streak,
//   });
//
//   double get volPct => volumeLastWeek > 0
//       ? ((volumeThisWeek - volumeLastWeek) / volumeLastWeek) * 100
//       : 0;
//
//   int get minDiff => minutesThisWeek - minutesLastWeek;
//
//   int get perWorkout => workoutsThisWeek > 0 ? setsThisWeek ~/ workoutsThisWeek : 0;
//
//   int get remaining => weeklyTarget > workoutsThisWeek ? weeklyTarget - workoutsThisWeek : 0;
//
//   String get unit => 'lb';
// }
//
// class _AchievementPill {
//   final IconData icon;
//   final String text;
//   const _AchievementPill({required this.icon, required this.text});
// }
//
// class _PlayIcon extends StatelessWidget {
//   const _PlayIcon();
//   @override
//   Widget build(BuildContext context) => const Icon(Icons.play_arrow, size: 16);
// }
//
// class _StatCard extends ConsumerWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//   final String? caption;
//   final bool? good;
//
//   const _StatCard({
//     required this.icon,
//     required this.label,
//     required this.value,
//     this.caption,
//     this.good,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final colors = ref.watch(appColorsProvider);
//     final captionColor = good == null ? colors.textMuted : (good! ? colors.success : colors.danger);
//
//     return AppCard(
//       padding: const EdgeInsets.all(AppSpacing.lg),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, size: 24, color: colors.accent),
//               const Spacer(),
//             ],
//           ),
//           const VGap(AppSpacing.md),
//           Text(label, style: AppTypography.sectionHeader.copyWith(color: colors.textSecondary)),
//           const VGap(AppSpacing.xs),
//           Text(value, style: AppTypography.statNumber.copyWith(color: colors.textPrimary)),
//           if (caption != null) ...[
//             const VGap(AppSpacing.xs),
//             Text(caption!, style: AppTypography.small.copyWith(color: captionColor)),
//           ],
//         ],
//       ),
//     );
//   }
// }
//
// class _RoutineChooserItem extends ConsumerWidget {
//   final String name;
//   final int exerciseCount;
//   final bool isActive;
//   final VoidCallback onTap;
//
//   const _RoutineChooserItem({
//     required this.name,
//     required this.exerciseCount,
//     required this.isActive,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final colors = ref.watch(appColorsProvider);
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(AppRadius.card),
//       child: Container(
//         padding: const EdgeInsets.all(AppSpacing.md),
//         margin: const EdgeInsets.only(bottom: AppSpacing.sm),
//         decoration: BoxDecoration(
//           color: colors.background,
//           borderRadius: BorderRadius.circular(AppRadius.card),
//           border: Border.all(
//             color: isActive ? colors.accent : Colors.transparent,
//             width: 1.5,
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: colors.accent.withValues(alpha: 0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(Icons.fitness_center, color: colors.accent, size: 20),
//             ),
//             const HGap(AppSpacing.md),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(name, style: AppTypography.routineName.copyWith(color: colors.textPrimary)),
//                   const VGap(2),
//                   Text('$exerciseCount exercises', style: AppTypography.routineSub.copyWith(color: colors.textSecondary)),
//                 ],
//               ),
//             ),
//             Icon(Icons.chevron_right, color: colors.textMuted),
//           ],
//         ),
//       ),
//     );
//   }
// }