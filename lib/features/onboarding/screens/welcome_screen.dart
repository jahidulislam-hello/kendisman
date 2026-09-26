import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/features/onboarding/widgets/onboarding_widgets.dart';

/// 01 — Health terms
class OnboardingWelcomeScreen extends ConsumerWidget {
  const OnboardingWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.border),
                    ),
                    child: Icon(Icons.fitness_center, color: colors.textPrimary, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Fitzella',
                    style: TextStyle(color: colors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                'Please accept our health\nterms and policy',
                style: TextStyle(color: colors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800, height: 1.2),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.border),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'HEALTH DISCLAIMER',
                          style: TextStyle(color: kOnboardingBlue, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.6),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Fitzella provides fitness training guidance for informational and educational purposes only. It is not a substitute for professional medical advice, diagnosis, or treatment.\n\n'
                          'Always consult your physician or a qualified health provider before beginning any exercise program, especially if you have a pre-existing medical condition, injury, or are pregnant.\n\n'
                          'By continuing, you acknowledge that you use Fitzella at your own risk and that the app creators are not liable for any injury or health issues that may result from following training recommendations.',
                          style: TextStyle(color: colors.textSecondary, fontSize: 14, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              OnboardingPrimaryButton(
                label: 'Accept and Continue',
                onPressed: () => context.go('/onboarding/units'),
              ),
              const SizedBox(height: 14),
              Text(
                'By continuing you agree to our Terms of Service and Privacy Policy',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.textMuted, fontSize: 12, height: 1.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
