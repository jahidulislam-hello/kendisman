// import 'package:fitzella/core/theme/app_theme.dart';
// import 'package:flutter/material.dart';
//
//
// /// Second screen: social-proof / hero screen.
// /// Tapping the circular arrow button advances to the next route.
// class OnboardingScreen extends StatelessWidget {
//   const OnboardingScreen({super.key});
//
//   static const _gold = Color(0xFFF5A623);
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = AppColors.dark;
//
//     return Scaffold(
//       backgroundColor: colors.background,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Top bar
//             Padding(
//               padding: const EdgeInsets.fromLTRB(
//                 AppSpacing.xl,
//                 AppSpacing.sm,
//                 AppSpacing.xl,
//                 0,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text(
//                     'Sign in',
//                     style: AppTypography.secondary.copyWith(
//                       color: colors.textSecondary,
//                       fontWeight: AppWeight.medium,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Hero image
//             Expanded(
//               flex: 5,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: AppSpacing.xl,
//                   vertical: AppSpacing.md,
//                 ),
//                 child: _HeroImage(),
//               ),
//             ),
//
//             // Content sheet
//             Expanded(
//               flex: 6,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: AppSpacing.xxl,
//                 ),
//                 child: Column(
//                   children: [
//                     _StarRow(color: _gold),
//                     const SizedBox(height: AppSpacing.md),
//                     _LaurelHeading(colors: colors),
//                     const SizedBox(height: AppSpacing.xs),
//                     Text(
//                       'of users choice',
//                       style: AppTypography.secondary.copyWith(
//                         color: colors.textSecondary,
//                       ),
//                     ),
//                     const SizedBox(height: AppSpacing.lg),
//                     _StatsRow(colors: colors),
//                     const SizedBox(height: AppSpacing.xl),
//                     _ChecklistRow(colors: colors, label: 'Strength erection'),
//                     const SizedBox(height: AppSpacing.sm),
//                     _ChecklistRow(colors: colors, label: 'Increase stamina'),
//                     const SizedBox(height: AppSpacing.sm),
//                     _ChecklistRow(colors: colors, label: 'Enhance orgasms'),
//                     const Spacer(),
//                     _NextButton(colors: colors),
//                     const SizedBox(height: AppSpacing.xl),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _HeroImage extends StatelessWidget {
//   const _HeroImage();
//
//   @override
//   Widget build(BuildContext context) {
//     // Replace this decorated placeholder with your actual illustration
//     // (e.g. Image.asset('assets/images/hero_globe.png')).
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(AppRadius.card),
//       child: Container(
//         decoration: const BoxDecoration(
//           gradient: RadialGradient(
//             center: Alignment(0, -0.2),
//             radius: 1.1,
//             colors: [
//               Color(0xFF3A2A16),
//               Color(0xFF0B0B0F),
//             ],
//           ),
//         ),
//         alignment: Alignment.center,
//         child: const Icon(
//           Icons.public,
//           size: 96,
//           color: Color(0xFFF5A623),
//         ),
//       ),
//     );
//   }
// }
//
// class _StarRow extends StatelessWidget {
//   const _StarRow({required this.color});
//
//   final Color color;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(
//         5,
//         (i) => Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 2),
//           child: Icon(Icons.star_rounded, color: color, size: 22),
//         ),
//       ),
//     );
//   }
// }
//
// class _LaurelHeading extends StatelessWidget {
//   const _LaurelHeading({required this.colors});
//
//   final AppColors colors;
//
//   @override
//   Widget build(BuildContext context) {
//     final leaf = Icon(
//       Icons.eco_outlined,
//       size: 26,
//       color: colors.textMuted,
//     );
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Transform.flip(flipX: true, child: leaf),
//         const SizedBox(width: AppSpacing.sm),
//         Text(
//           'Millions',
//           style: AppTypography.heroTitle.copyWith(
//             color: colors.textPrimary,
//           ),
//         ),
//         const SizedBox(width: AppSpacing.sm),
//         leaf,
//       ],
//     );
//   }
// }
//
// class _StatsRow extends StatelessWidget {
//   const _StatsRow({required this.colors});
//
//   final AppColors colors;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _Stat(colors: colors, value: '4.76', label: 'out of 5'),
//         Container(
//           width: 1,
//           height: 28,
//           margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
//           color: colors.border,
//         ),
//         _Stat(colors: colors, value: '50k', label: 'reviews'),
//       ],
//     );
//   }
// }
//
// class _Stat extends StatelessWidget {
//   const _Stat({
//     required this.colors,
//     required this.value,
//     required this.label,
//   });
//
//   final AppColors colors;
//   final String value;
//   final String label;
//
//   @override
//   Widget build(BuildContext context) {
//     return RichText(
//       text: TextSpan(
//         children: [
//           TextSpan(
//             text: value,
//             style: AppTypography.cardTitle.copyWith(
//               color: colors.textPrimary,
//               fontWeight: AppWeight.bold,
//             ),
//           ),
//           TextSpan(
//             text: '  $label',
//             style: AppTypography.secondary.copyWith(
//               color: colors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ChecklistRow extends StatelessWidget {
//   const _ChecklistRow({required this.colors, required this.label});
//
//   final AppColors colors;
//   final String label;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 22,
//           height: 22,
//           decoration: const BoxDecoration(
//             color: Color(0xFFF5A623),
//             shape: BoxShape.circle,
//           ),
//           alignment: Alignment.center,
//           child: const Icon(Icons.check, size: 14, color: Colors.white),
//         ),
//         const SizedBox(width: AppSpacing.md),
//         Text(
//           label,
//           style: AppTypography.body.copyWith(color: colors.textPrimary),
//         ),
//       ],
//     );
//   }
// }
//
// class _NextButton extends StatelessWidget {
//   const _NextButton({required this.colors});
//
//   final AppColors colors;
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Material(
//         color: colors.accent,
//         shape: const CircleBorder(),
//         child: InkWell(
//           customBorder: const CircleBorder(),
//           onTap: () {
//             // Now that auth screens exist, send new users into Sign Up.
//             // Change to '/sign-in' if you'd rather land existing users there.
//             Navigator.of(context).pushNamed('/sign-up');
//           },
//           child: SizedBox(
//             width: 56,
//             height: 56,
//             child: Icon(Icons.arrow_forward, color: colors.onAccent),
//           ),
//         ),
//       ),
//     );
//   }
// }
