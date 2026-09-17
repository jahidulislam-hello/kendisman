// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:fitzella/core/theme/app_theme.dart';
// import 'package:fitzella/core/theme/theme_provider.dart';
// import 'package:fitzella/core/models/profile/user_profile.dart';
// import 'package:fitzella/shared/widgets/buttons.dart';
// import 'package:fitzella/shared/widgets/cards.dart';
// import 'package:fitzella/shared/widgets/inputs.dart';
//
// /// Onboarding base screen
// class OnboardingScreen extends ConsumerWidget {
//   final Widget child;
//   final String? title;
//   final String? subtitle;
//   final bool showBack;
//
//   const OnboardingScreen({
//     super.key,
//     required this.child,
//     this.title,
//     this.subtitle,
//     this.showBack = true,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final colors = ref.watch(appColorsProvider);
//
//     return Scaffold(
//       backgroundColor: colors.background,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, AppSpacing.xl),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               if (showBack)
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: IconButton(
//                     icon: Icon(Icons.arrow_back_ios_new, color: colors.textPrimary),
//                     onPressed: () => context.pop(),
//                     padding: EdgeInsets.zero,
//                     constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
//                   ),
//                 ),
//               if (title != null) ...[
//                 const VGap(AppSpacing.md),
//                 Text(title!, style: AppTypography.screenTitle.copyWith(color: colors.textPrimary)),
//                 if (subtitle != null) ...[
//                   const VGap(AppSpacing.xs),
//                   Text(subtitle!, style: AppTypography.secondary.copyWith(color: colors.textSecondary)),
//                 ],
//                 const VGap(AppSpacing.xl),
//               ],
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: child,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// Welcome screen
// class WelcomeScreen extends ConsumerWidget {
//   const WelcomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final colors = ref.watch(appColorsProvider);
//
//     return OnboardingScreen(
//       title: 'Welcome to Fitzella',
//       subtitle: 'Your personal strength training companion',
//       showBack: false,
//       child: Column(
//         children: [
//           const VGap(AppSpacing.xl),
//           // Illustration placeholder
//           Container(
//             height: 240,
//             decoration: BoxDecoration(
//               color: colors.accent.withValues(alpha: 0.1),
//               borderRadius: BorderRadius.circular(28),
//             ),
//             child: Center(
//               child: Icon(Icons.fitness_center, size: 80, color: colors.accent),
//             ),
//           ),
//           const VGap(AppSpacing.xxl),
//           Text(
//             'Build strength. Track progress. Achieve goals.',
//             style: AppTypography.greeting.copyWith(color: colors.textPrimary),
//             textAlign: TextAlign.center,
//           ),
//           const VGap(AppSpacing.lg),
//           Text(
//             'Create personalized workout programs, log every set with precision, and watch your progress unfold with beautiful analytics.',
//             style: AppTypography.body.copyWith(color: colors.textSecondary),
//             textAlign: TextAlign.center,
//           ),
//           const VGap(AppSpacing.xxl),
//           PrimaryButton(
//             title: 'Get Started',
//             onPressed: () => context.go('/onboarding/goal'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Goal selection screen
// class GoalStepScreen extends ConsumerStatefulWidget {
//   const GoalStepScreen({super.key});
//
//   @override
//   ConsumerState<GoalStepScreen> createState() => _GoalStepScreenState();
// }
//
// class _GoalStepScreenState extends ConsumerState<GoalStepScreen> {
//   TrainingGoal? _selectedGoal;
//
//   final _goals = [
//     (TrainingGoal.buildMuscle, 'Build Muscle', 'Hypertrophy focused training', Icons.fitness_center),
//     (TrainingGoal.strength, 'Get Stronger', 'Strength and power focus', Icons.bolt),
//     (TrainingGoal.fatLoss, 'Lose Fat', 'Metabolic conditioning', Icons.local_fire_department),
//     (TrainingGoal.improveEndurance, 'Improve Endurance', 'Stamina and conditioning', Icons.directions_run),
//     (TrainingGoal.generalFitness, 'General Fitness', 'Balanced overall health', Icons.favorite),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return OnboardingScreen(
//       title: 'What\'s your main goal?',
//       subtitle: 'This helps us personalize your experience',
//       child: Column(
//         children: [
//           const VGap(AppSpacing.xl),
//           ..._goals.map((goal) => Padding(
//             padding: const EdgeInsets.only(bottom: AppSpacing.md),
//             child: _GoalOption(
//               goal: goal.$1,
//               title: goal.$2,
//               subtitle: goal.$3,
//               icon: goal.$4,
//               selected: _selectedGoal == goal.$1,
//               onTap: () => setState(() => _selectedGoal = goal.$1),
//             ),
//           )),
//           const VGap(AppSpacing.xl),
//           PrimaryButton(
//             title: 'Continue',
//             onPressed: _selectedGoal != null
//                 ? () => context.go('/onboarding/experience')
//                 : null,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _GoalOption extends ConsumerWidget {
//   final TrainingGoal goal;
//   final String title;
//   final String subtitle;
//   final IconData icon;
//   final bool selected;
//   final VoidCallback onTap;
//
//   const _GoalOption({
//     required this.goal,
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//     required this.selected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final colors = ref.watch(appColorsProvider);
//
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(AppRadius.card),
//       child: Container(
//         padding: const EdgeInsets.all(AppSpacing.lg),
//         decoration: BoxDecoration(
//           color: colors.surface,
//           borderRadius: BorderRadius.circular(AppRadius.card),
//           border: Border.all(
//             color: selected ? colors.accent : colors.border,
//             width: selected ? 2 : 0.5,
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 48,
//               height: 48,
//               decoration: BoxDecoration(
//                 color: selected ? colors.accent : colors.accent.withValues(alpha: 0.1),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Icon(icon, color: selected ? colors.onAccent : colors.accent, size: 24),
//             ),
//             const HGap(AppSpacing.md),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title, style: AppTypography.cardTitle.copyWith(color: colors.textPrimary)),
//                   Text(subtitle, style: AppTypography.secondary.copyWith(color: colors.textSecondary)),
//                 ],
//               ),
//             ),
//             if (selected)
//               Icon(Icons.check_circle, color: colors.accent, size: 24)
//             else
//               Icon(Icons.radio_button_unchecked, color: colors.textMuted, size: 24),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// Experience level screen
// class ExperienceStepScreen extends ConsumerStatefulWidget {
//   const ExperienceStepScreen({super.key});
//
//   @override
//   ConsumerState<ExperienceStepScreen> createState() => _ExperienceStepScreenState();
// }
//
// class _ExperienceStepScreenState extends ConsumerState<ExperienceStepScreen> {
//   ExperienceLevel? _selectedExperience;
//
//   final _levels = const [
//     (ExperienceLevel.beginner, 'Beginner', 'New to strength training', '0-1 year'),
//     (ExperienceLevel.intermediate, 'Intermediate', 'Some experience', '1-3 years'),
//     (ExperienceLevel.advanced, 'Advanced', 'Experienced lifter', '3+ years'),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return OnboardingScreen(
//       title: 'What\'s your experience level?',
//       subtitle: 'We\'ll adjust program difficulty accordingly',
//       child: Column(
//         children: [
//           const VGap(AppSpacing.xl),
//           ..._levels.map((level) => Padding(
//             padding: const EdgeInsets.only(bottom: AppSpacing.md),
//             child: _ExperienceOption(
//               level: level.$1,
//               title: level.$2,
//               subtitle: level.$3,
//               detail: level.$4,
//               selected: _selectedExperience == level.$1,
//               onTap: () => setState(() => _selectedExperience = level.$1),
//             ),
//           )),
//           const VGap(AppSpacing.xl),
//           PrimaryButton(
//             title: 'Continue',
//             onPressed: _selectedExperience != null
//                 ? () => context.go('/onboarding/frequency')
//                 : null,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ExperienceOption extends ConsumerWidget {
//   final ExperienceLevel level;
//   final String title;
//   final String subtitle;
//   final String detail;
//   final bool selected;
//   final VoidCallback onTap;
//
//   const _ExperienceOption({
//     required this.level,
//     required this.title,
//     required this.subtitle,
//     required this.detail,
//     required this.selected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final colors = ref.watch(appColorsProvider);
//
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(AppRadius.card),
//       child: Container(
//         padding: const EdgeInsets.all(AppSpacing.lg),
//         decoration: BoxDecoration(
//           color: colors.surface,
//           borderRadius: BorderRadius.circular(AppRadius.card),
//           border: Border.all(
//             color: selected ? colors.accent : colors.border,
//             width: selected ? 2 : 0.5,
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 48,
//               height: 48,
//               decoration: BoxDecoration(
//                 color: selected ? colors.accent : colors.accent.withValues(alpha: 0.1),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Center(
//                 child: Text(
//                   detail,
//                   style: TextStyle(
//                     fontSize: 11,
//                     fontWeight: FontWeight.bold,
//                     color: selected ? colors.onAccent : colors.accent,
//                   ),
//                 ),
//               ),
//             ),
//             const HGap(AppSpacing.md),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title, style: AppTypography.cardTitle.copyWith(color: colors.textPrimary)),
//                   Text(subtitle, style: AppTypography.secondary.copyWith(color: colors.textSecondary)),
//                 ],
//               ),
//             ),
//             if (selected)
//               Icon(Icons.check_circle, color: colors.accent, size: 24)
//             else
//               Icon(Icons.radio_button_unchecked, color: colors.textMuted, size: 24),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// Frequency selection screen
// class FrequencyStepScreen extends ConsumerStatefulWidget {
//   const FrequencyStepScreen({super.key});
//
//   @override
//   ConsumerState<FrequencyStepScreen> createState() => _FrequencyStepScreenState();
// }
//
// class _FrequencyStepScreenState extends ConsumerState<FrequencyStepScreen> {
//   int? _selectedDays;
//
//   @override
//   Widget build(BuildContext context) {
//     return OnboardingScreen(
//       title: 'How many days per week?',
//       subtitle: 'Be realistic about your schedule',
//       child: Column(
//         children: [
//           const VGap(AppSpacing.xl),
//           ...[3, 4, 5, 6].map((days) => Padding(
//             padding: const EdgeInsets.only(bottom: AppSpacing.md),
//             child: _FrequencyOption(
//               days: days,
//               selected: _selectedDays == days,
//               onTap: () => setState(() => _selectedDays = days),
//             ),
//           )),
//           const VGap(AppSpacing.xl),
//           PrimaryButton(
//             title: 'Continue',
//             onPressed: _selectedDays != null
//                 ? () => context.go('/onboarding/gender')
//                 : null,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _FrequencyOption extends ConsumerWidget {
//   final int days;
//   final bool selected;
//   final VoidCallback onTap;
//
//   const _FrequencyOption({
//     required this.days,
//     required this.selected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final colors = ref.watch(appColorsProvider);
//
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(AppRadius.card),
//       child: Container(
//         padding: const EdgeInsets.all(AppSpacing.lg),
//         decoration: BoxDecoration(
//           color: colors.surface,
//           borderRadius: BorderRadius.circular(AppRadius.card),
//           border: Border.all(
//             color: selected ? colors.accent : colors.border,
//             width: selected ? 2 : 0.5,
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 48,
//               height: 48,
//               decoration: BoxDecoration(
//                 color: selected ? colors.accent : colors.accent.withValues(alpha: 0.1),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Center(
//                 child: Text(
//                   '$days',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: selected ? colors.onAccent : colors.accent,
//                   ),
//                 ),
//               ),
//             ),
//             const HGap(AppSpacing.md),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('$days days/week', style: AppTypography.cardTitle.copyWith(color: colors.textPrimary)),
//                   Text(
//                     days == 3 ? 'Full body split recommended' :
//                     days == 4 ? 'Upper/Lower split recommended' :
//                     days == 5 ? 'Push/Pull/Legs split recommended' :
//                     'PPL + accessory split recommended',
//                     style: AppTypography.secondary.copyWith(color: colors.textSecondary),
//                   ),
//                 ],
//               ),
//             ),
//             if (selected)
//               Icon(Icons.check_circle, color: colors.accent, size: 24)
//             else
//               Icon(Icons.radio_button_unchecked, color: colors.textMuted, size: 24),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// Gender selection screen
// class GenderStepScreen extends ConsumerStatefulWidget {
//   const GenderStepScreen({super.key});
//
//   @override
//   ConsumerState<GenderStepScreen> createState() => _GenderStepScreenState();
// }
//
// class _GenderStepScreenState extends ConsumerState<GenderStepScreen> {
//   UserSex? _selectedGender;
//   bool _hasChosenGender = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return OnboardingScreen(
//       title: 'What\'s your gender?',
//       subtitle: 'Helps calculate accurate calorie estimates',
//       child: Column(
//         children: [
//           const VGap(AppSpacing.xl),
//           ...[UserSex.male, UserSex.female].map((gender) => Padding(
//             padding: const EdgeInsets.only(bottom: AppSpacing.md),
//             child: _GenderOption(
//               sex: gender,
//               title: gender.name.substring(0, 1).toUpperCase() + gender.name.substring(1),
//               selected: _hasChosenGender && _selectedGender == gender,
//               onTap: () => setState(() {
//                 _selectedGender = gender;
//                 _hasChosenGender = true;
//               }),
//             ),
//           )),
//           const VGap(AppSpacing.md),
//           Padding(
//             padding: const EdgeInsets.only(bottom: AppSpacing.md),
//             child: _GenderOption(
//               sex: null,
//               title: 'Prefer not to say',
//               selected: _hasChosenGender && _selectedGender == null,
//               onTap: () => setState(() {
//                 _selectedGender = null;
//                 _hasChosenGender = true;
//               }),
//             ),
//           ),
//           const VGap(AppSpacing.xl),
//           PrimaryButton(
//             title: 'Continue',
//             onPressed: _hasChosenGender
//                 ? () => context.go('/onboarding/height')
//                 : null,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _GenderOption extends ConsumerWidget {
//   final UserSex? sex;
//   final String title;
//   final bool selected;
//   final VoidCallback onTap;
//
//   const _GenderOption({
//     required this.sex,
//     required this.title,
//     required this.selected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final colors = ref.watch(appColorsProvider);
//
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(AppRadius.card),
//       child: Container(
//         padding: const EdgeInsets.all(AppSpacing.lg),
//         decoration: BoxDecoration(
//           color: colors.surface,
//           borderRadius: BorderRadius.circular(AppRadius.card),
//           border: Border.all(
//             color: selected ? colors.accent : colors.border,
//             width: selected ? 2 : 0.5,
//           ),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(title, style: AppTypography.cardTitle.copyWith(color: colors.textPrimary)),
//             ),
//             if (selected)
//               Icon(Icons.check_circle, color: colors.accent, size: 24)
//             else
//               Icon(Icons.radio_button_unchecked, color: colors.textMuted, size: 24),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// Height input screen
// class HeightStepScreen extends ConsumerStatefulWidget {
//   const HeightStepScreen({super.key});
//
//   @override
//   ConsumerState<HeightStepScreen> createState() => _HeightStepScreenState();
// }
//
// class _HeightStepScreenState extends ConsumerState<HeightStepScreen> {
//   double _heightValue = 175;
//   String _unit = 'cm'; // or 'ft/in'
//
//   @override
//   Widget build(BuildContext context) {
//     return OnboardingScreen(
//       title: 'How tall are you?',
//       subtitle: 'Used for BMI and calorie calculations',
//       child: Column(
//         children: [
//           const VGap(AppSpacing.xl),
//           SegmentedControl<String>(
//             value: _unit,
//             onChanged: (v) => setState(() => _unit = v),
//             options: const [
//               SegmentOption(value: 'cm', label: 'Centimeters'),
//               SegmentOption(value: 'ft/in', label: 'Feet/Inches'),
//             ],
//           ),
//           const VGap(AppSpacing.xl),
//           NumberInput(
//             value: _heightValue,
//             onChanged: (v) => setState(() => _heightValue = v),
//             label: _unit == 'cm' ? 'Height (cm)' : 'Height (inches)',
//             min: _unit == 'cm' ? 100 : 40,
//             max: _unit == 'cm' ? 250 : 98,
//             step: 1,
//             suffix: _unit == 'cm' ? 'cm' : 'in',
//           ),
//           if (_unit == 'ft/in') ...[
//             const VGap(AppSpacing.md),
//             NumberInput(
//               value: 0,
//               onChanged: (_) {},
//               label: 'Additional inches',
//               min: 0,
//               max: 11,
//               step: 1,
//               suffix: 'in',
//             ),
//           ],
//           const VGap(AppSpacing.xl),
//           PrimaryButton(
//             title: 'Continue',
//             onPressed: () => context.go('/onboarding/weight'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Weight input screen
// class WeightStepScreen extends ConsumerStatefulWidget {
//   const WeightStepScreen({super.key});
//
//   @override
//   ConsumerState<WeightStepScreen> createState() => _WeightStepScreenState();
// }
//
// class _WeightStepScreenState extends ConsumerState<WeightStepScreen> {
//   double _weightValue = 75;
//   String _unit = 'kg'; // or 'lb'
//
//   @override
//   Widget build(BuildContext context) {
//     return OnboardingScreen(
//       title: 'What\'s your current weight?',
//       subtitle: 'Used for BMI and calorie calculations',
//       child: Column(
//         children: [
//           const VGap(AppSpacing.xl),
//           SegmentedControl<String>(
//             value: _unit,
//             onChanged: (v) => setState(() => _unit = v),
//             options: const [
//               SegmentOption(value: 'kg', label: 'Kilograms'),
//               SegmentOption(value: 'lb', label: 'Pounds'),
//             ],
//           ),
//           const VGap(AppSpacing.xl),
//           NumberInput(
//             value: _weightValue,
//             onChanged: (v) => setState(() => _weightValue = v),
//             label: _unit == 'kg' ? 'Weight (kg)' : 'Weight (lb)',
//             min: _unit == 'kg' ? 30 : 66,
//             max: _unit == 'kg' ? 300 : 660,
//             step: 0.5,
//             decimals: 1,
//             suffix: _unit,
//           ),
//           const VGap(AppSpacing.xl),
//           PrimaryButton(
//             title: 'Continue',
//             onPressed: () {
//               context.go('/onboarding/birthday');
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Birthday input screen
// class BirthdayStepScreen extends ConsumerStatefulWidget {
//   const BirthdayStepScreen({super.key});
//
//   @override
//   ConsumerState<BirthdayStepScreen> createState() => _BirthdayStepScreenState();
// }
//
// class _BirthdayStepScreenState extends ConsumerState<BirthdayStepScreen> {
//   DateTime? _selectedDate;
//
//   Future<void> _pickDate() async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
//       firstDate: DateTime(1920),
//       lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)),
//     );
//     if (date != null) setState(() => _selectedDate = date);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = ref.watch(appColorsProvider);
//
//     return OnboardingScreen(
//       title: 'When\'s your birthday?',
//       subtitle: 'Used for age-based recommendations',
//       child: Column(
//         children: [
//           const VGap(AppSpacing.xl),
//           GestureDetector(
//             onTap: _pickDate,
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(AppSpacing.lg),
//               decoration: BoxDecoration(
//                 color: colors.surface,
//                 borderRadius: BorderRadius.circular(AppRadius.card),
//                 border: Border.all(color: colors.border, width: 0.5),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.cake_outlined, color: colors.accent, size: 24),
//                   const HGap(AppSpacing.md),
//                   Expanded(
//                     child: Text(
//                       _selectedDate == null
//                           ? 'Select your birth date'
//                           : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
//                       style: _selectedDate == null
//                           ? AppTypography.body.copyWith(color: colors.textMuted)
//                           : AppTypography.cardTitle.copyWith(color: colors.textPrimary),
//                     ),
//                   ),
//                   Icon(Icons.chevron_right, color: colors.textMuted),
//                 ],
//               ),
//             ),
//           ),
//           const VGap(AppSpacing.xl),
//           PrimaryButton(
//             title: 'Continue',
//             onPressed: _selectedDate != null
//                 ? () => context.go('/onboarding/units')
//                 : null,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Units preference screen
// class UnitsStepScreen extends ConsumerStatefulWidget {
//   const UnitsStepScreen({super.key});
//
//   @override
//   ConsumerState<UnitsStepScreen> createState() => _UnitsStepScreenState();
// }
//
// class _UnitsStepScreenState extends ConsumerState<UnitsStepScreen> {
//   String _weightUnit = 'kg';
//   String _distanceUnit = 'km';
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = ref.watch(appColorsProvider);
//
//     return OnboardingScreen(
//       title: 'Preferred units',
//       subtitle: 'Choose your measurement system',
//       child: Column(
//         children: [
//           const VGap(AppSpacing.xl),
//           Text('Weight', style: AppTypography.sectionHeader.copyWith(color: colors.textPrimary)),
//           const VGap(AppSpacing.md),
//           SegmentedControl<String>(
//             value: _weightUnit,
//             onChanged: (v) => setState(() => _weightUnit = v),
//             options: const [
//               SegmentOption(value: 'kg', label: 'Kilograms'),
//               SegmentOption(value: 'lb', label: 'Pounds'),
//             ],
//           ),
//           const VGap(AppSpacing.xl),
//           Text('Distance', style: AppTypography.sectionHeader.copyWith(color: colors.textPrimary)),
//           const VGap(AppSpacing.md),
//           SegmentedControl<String>(
//             value: _distanceUnit,
//             onChanged: (v) => setState(() => _distanceUnit = v),
//             options: const [
//               SegmentOption(value: 'km', label: 'Kilometers'),
//               SegmentOption(value: 'mi', label: 'Miles'),
//             ],
//           ),
//           const VGap(AppSpacing.xl),
//           PrimaryButton(
//             title: 'Continue',
//             onPressed: () => context.go('/onboarding/ready'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Ready screen
// class ReadyScreen extends ConsumerWidget {
//   const ReadyScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final colors = ref.watch(appColorsProvider);
//
//     return OnboardingScreen(
//       title: 'You\'re all set!',
//       subtitle: 'Let\'s create your first program',
//       showBack: false,
//       child: Column(
//         children: [
//           const VGap(AppSpacing.xl),
//           Container(
//             height: 200,
//             decoration: BoxDecoration(
//               color: colors.accent.withValues(alpha: 0.1),
//               borderRadius: BorderRadius.circular(28),
//             ),
//             child: Center(
//               child: Icon(Icons.rocket_launch, size: 80, color: colors.accent),
//             ),
//           ),
//           const VGap(AppSpacing.xxl),
//           Text(
//             'We\'ll set up a personalized program based on your goals.',
//             style: AppTypography.body.copyWith(color: colors.textSecondary),
//             textAlign: TextAlign.center,
//           ),
//           const VGap(AppSpacing.xxl),
//           PrimaryButton(
//             title: 'Create My Program',
//             onPressed: () => context.go('/profile/ai-questionnaire'),
//           ),
//           const VGap(AppSpacing.md),
//           TextButton(
//             onPressed: () => context.go('/home'),
//             child: Text('Skip for now', style: AppTypography.body.copyWith(color: colors.textSecondary)),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Onboarding paywall screen
// class OnboardingPaywallScreen extends ConsumerWidget {
//   const OnboardingPaywallScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final colors = ref.watch(appColorsProvider);
//
//     return OnboardingScreen(
//       title: 'Unlock Unlimited Access',
//       subtitle: 'Get full access to all features',
//       showBack: false,
//       child: Column(
//         children: [
//           const VGap(AppSpacing.xl),
//           // Feature list
//           ...[
//             ('Unlimited Programs', 'Create and follow any program'),
//             ('Advanced Analytics', 'Detailed progress tracking'),
//             ('AI Coach', 'Personalized recommendations'),
//             ('Export Data', 'Take your data anywhere'),
//           ].map((f) => Padding(
//             padding: const EdgeInsets.only(bottom: AppSpacing.md),
//             child: Row(
//               children: [
//                 Container(
//                   width: 24,
//                   height: 24,
//                   decoration: BoxDecoration(
//                     color: colors.success.withValues(alpha: 0.1),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Icon(Icons.check, color: colors.success, size: 16),
//                 ),
//                 const HGap(AppSpacing.md),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(f.$1, style: AppTypography.cardTitle.copyWith(color: colors.textPrimary)),
//                       Text(f.$2, style: AppTypography.secondary.copyWith(color: colors.textSecondary)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           )),
//           const VGap(AppSpacing.xl),
//           PrimaryButton(
//             title: 'Start Free Trial',
//             onPressed: () => context.go('/onboarding/ready'),
//           ),
//           const VGap(AppSpacing.md),
//           TextButton(
//             onPressed: () => context.go('/onboarding/ready'),
//             child: Text('Continue with Free', style: AppTypography.body.copyWith(color: colors.textSecondary)),
//           ),
//         ],
//       ),
//     );
//   }
// }