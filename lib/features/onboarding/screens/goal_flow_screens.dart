import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitzella/core/providers/auth_provider.dart';
import 'package:fitzella/core/theme/app_theme.dart';
import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/features/onboarding/onboarding_provider.dart';
import 'package:fitzella/features/onboarding/widgets/onboarding_widgets.dart';

/// 08 — Goal (step 6)
class OnboardingGoalScreen extends ConsumerWidget {
  const OnboardingGoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final selected = ref.watch(onboardingProvider).goal ?? 'Gain Strength';

    const options = [
      ('Build Muscle', 'Increase size and strength'),
      ('Gain Strength', 'Lift heavier, get stronger'),
      ('Lose Weight', 'Reduce body fat'),
      ('Tone Up', 'Lean and defined physique'),
      ('General Fitness', 'Improve overall health and well-being'),
    ];

    return OnboardingStepScaffold(
      colors: colors,
      step: 6,
      onContinue: () => context.go('/onboarding/equipment'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingStepHeader(
            colors: colors,
            icon: Icons.track_changes,
            step: 6,
            title: 'What is your top goal?',
            subtitle: "We'll tailor your program to match your primary objective.",
          ),
          const SizedBox(height: 22),
          Expanded(
            child: ListView(
              children: options
                  .map(
                    (o) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OnboardingOptionCard(
                        colors: colors,
                        title: o.$1,
                        subtitle: o.$2,
                        selected: selected == o.$1,
                        onTap: () => ref.read(onboardingProvider.notifier).setGoal(o.$1),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// 09 — Equipment (step 7)
class OnboardingEquipmentScreen extends ConsumerWidget {
  const OnboardingEquipmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final selected = ref.watch(onboardingProvider).equipment ?? 'Full Gym';

    const options = [
      ('Full Gym', 'Access to barbells, machines, cables'),
      ('Home Gym', 'Dumbbells, bands, basic equipment'),
      ('No Equipment', "Bodyweight only, I'll train anywhere"),
    ];

    return OnboardingStepScaffold(
      colors: colors,
      step: 7,
      onContinue: () => context.go('/onboarding/experience'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingStepHeader(
            colors: colors,
            icon: Icons.grid_view_rounded,
            step: 7,
            title: 'What equipment do you have?',
            subtitle: "We'll suggest exercises that match your available gear.",
          ),
          const SizedBox(height: 22),
          Expanded(
            child: ListView(
              children: options
                  .map(
                    (o) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OnboardingOptionCard(
                        colors: colors,
                        title: o.$1,
                        subtitle: o.$2,
                        selected: selected == o.$1,
                        onTap: () => ref.read(onboardingProvider.notifier).setEquipment(o.$1),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// 10 — Experience (step 8)
class OnboardingExperienceScreen extends ConsumerWidget {
  const OnboardingExperienceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final selected = ref.watch(onboardingProvider).experience ?? 'Beginner';

    const options = [
      ('Beginner', 'Less than 1 year of consistent training'),
      ('Intermediate', '1–3 years of consistent training'),
      ('Advanced', '3+ years of consistent training'),
    ];

    return OnboardingStepScaffold(
      colors: colors,
      step: 8,
      onContinue: () => context.go('/onboarding/frequency'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingStepHeader(
            colors: colors,
            icon: Icons.star_border_rounded,
            step: 8,
            title: 'How much training experience do you have?',
            subtitle: 'Be honest — this helps us set the right starting point.',
          ),
          const SizedBox(height: 22),
          Expanded(
            child: ListView(
              children: options
                  .map(
                    (o) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OnboardingOptionCard(
                        colors: colors,
                        title: o.$1,
                        subtitle: o.$2,
                        selected: selected == o.$1,
                        onTap: () => ref.read(onboardingProvider.notifier).setExperience(o.$1),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// 11 — Frequency (step 9)
class OnboardingFrequencyScreen extends ConsumerWidget {
  const OnboardingFrequencyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final selected = ref.watch(onboardingProvider).frequency ?? 3;

    const options = [
      (2, '2 days per week', 'Light — great for active recovery'
      ),
      (3, '3 days per week', 'Balanced — ideal for most goals'),
      (4, '4 days per week', 'Focused — solid weekly volume'),
      (5, '5 days per week', 'Dedicated — serious commitment'),
    ];

    return OnboardingStepScaffold(
      colors: colors,
      step: 9,
      onContinue: () => context.go('/onboarding/apple-health'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingStepHeader(
            colors: colors,
            icon: Icons.sync,
            step: 9,
            title: 'How often do you want to work out?',
            subtitle: 'Choose how many days per week you can commit to training.',
          ),
          const SizedBox(height: 22),
          Expanded(
            child: ListView(
              children: options
                  .map(
                    (o) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OnboardingOptionCard(
                        colors: colors,
                        title: o.$2,
                        subtitle: o.$3,
                        selected: selected == o.$1,
                        onTap: () => ref.read(onboardingProvider.notifier).setFrequency(o.$1),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// 12 — Apple Health (step 10)
class OnboardingAppleHealthScreen extends ConsumerWidget {
  const OnboardingAppleHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    return OnboardingStepScaffold(
      colors: colors,
      step: 10,
      continueLabel: 'Enable Apple Health',
      onContinue: () {
        ref.read(onboardingProvider.notifier).setAppleHealth(true);
        context.go('/onboarding/paywall');
      },
      body: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(color: const Color(0xFFFF3B30).withValues(alpha: 0.35), blurRadius: 24, spreadRadius: 2),
              ],
            ),
            child: const Icon(Icons.favorite_border, color: Color(0xFFFF3B30), size: 42),
          ),
          const SizedBox(height: 28),
          Text(
            'Apple Health',
            style: TextStyle(color: colors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Text(
            'Connect Apple Health to automatically sync your workouts, active calories, heart rate, and more — keeping all your health data in one place.',
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.textSecondary, fontSize: 15, height: 1.45),
          ),
          const SizedBox(height: 28),
          const Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                _HealthBullet('Sync workouts automatically'),
                SizedBox(height: 14),
                _HealthBullet('Track active calories & heart rate'),
                SizedBox(height: 14),
                _HealthBullet('Unified health dashboard'),
              ],
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              ref.read(onboardingProvider.notifier).setAppleHealth(false);
              context.go('/onboarding/paywall');
            },
            child: Text('Skip for now', style: TextStyle(color: colors.textMuted, fontSize: 15, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _HealthBullet extends StatelessWidget {
  final String text;
  const _HealthBullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(color: kOnboardingGreen, shape: BoxShape.circle),
          child: const Icon(Icons.check, size: 14, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: const TextStyle(color: Color(0xFF9B9BA5), fontSize: 15)),
        ),
      ],
    );
  }
}

/// 13 — Paywall / free trial
class OnboardingPaywallScreen extends ConsumerWidget {
  const OnboardingPaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final plan = ref.watch(onboardingProvider).plan;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            children: [
              const Text(
                'LIMITED OFFER',
                style: TextStyle(color: kOnboardingBlue, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1),
              ),
              const SizedBox(height: 12),
              Text(
                'Start your 14-day\nfree trial',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.textPrimary, fontSize: 30, fontWeight: FontWeight.w800, height: 1.15),
              ),
              const SizedBox(height: 10),
              Text(
                'Cancel anytime. No charge until your trial ends.',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 28),
              _PlanCard(
                colors: colors,
                title: 'Annual',
                subtitle: '\$3.33 / month, billed annually',
                price: '\$39.99',
                period: 'per year',
                selected: plan == 'annual',
                badge: 'SAVE 65%',
                onTap: () => ref.read(onboardingProvider.notifier).setPlan('annual'),
              ),
              const SizedBox(height: 12),
              _PlanCard(
                colors: colors,
                title: 'Monthly',
                subtitle: 'Flexible, cancel anytime',
                price: '\$9.99',
                period: 'per month',
                selected: plan == 'monthly',
                onTap: () => ref.read(onboardingProvider.notifier).setPlan('monthly'),
              ),
              const SizedBox(height: 24),
              const _PaywallBullet('14-day free trial, no charge today'),
              const SizedBox(height: 12),
              const _PaywallBullet('Full access to all features'),
              const SizedBox(height: 12),
              const _PaywallBullet('Cancel anytime before trial ends'),
              const Spacer(),
              OnboardingPrimaryButton(
                label: 'Start Free Trial',
                background: kOnboardingGreen,
                onPressed: () => context.go('/onboarding/ready'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final AppColors colors;
  final String title;
  final String subtitle;
  final String price;
  final String period;
  final bool selected;
  final String? badge;
  final VoidCallback onTap;

  const _PlanCard({
    required this.colors,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.period,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: selected ? kOnboardingBlue : colors.border, width: selected ? 1.5 : 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(color: colors.textPrimary, fontSize: 17, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(color: colors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(price, style: TextStyle(color: colors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                    Text(period, style: TextStyle(color: colors.textMuted, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          if (badge != null)
            Positioned(
              top: -10,
              right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: kOnboardingBlue, borderRadius: BorderRadius.circular(20)),
                child: Text(badge!, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
              ),
            ),
        ],
      ),
    );
  }
}

class _PaywallBullet extends StatelessWidget {
  final String text;
  const _PaywallBullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check, color: kOnboardingGreen, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(color: Color(0xFF9B9BA5), fontSize: 14))),
      ],
    );
  }
}

/// 14 — Ready / Start Training
class OnboardingReadyScreen extends ConsumerStatefulWidget {
  const OnboardingReadyScreen({super.key});

  @override
  ConsumerState<OnboardingReadyScreen> createState() => _OnboardingReadyScreenState();
}

class _OnboardingReadyScreenState extends ConsumerState<OnboardingReadyScreen> {
  bool _saving = false;

  Future<void> _finish() async {
    if (_saving) return;
    setState(() => _saving = true);
    final draft = ref.read(onboardingProvider);
    final result =
        await ref.read(authNotifierProvider.notifier).completeOnboarding(draft);
    if (!mounted) return;
    setState(() => _saving = false);
    result.when(
      success: (_) => context.go('/home'),
      error: (message) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        context.go('/home');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final apple = ref.watch(onboardingProvider).appleHealthEnabled;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: kOnboardingGreen.withValues(alpha: 0.35), blurRadius: 28, spreadRadius: 2),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(color: kOnboardingGreen, shape: BoxShape.circle),
                    child: const Icon(Icons.check, color: Colors.white, size: 32),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                "You're ready!",
                style: TextStyle(color: colors.textPrimary, fontSize: 30, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text(
                'Your personalised Fitzella program has been built. Time to start crushing your goals.',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.textSecondary, fontSize: 15, height: 1.45),
              ),
              const SizedBox(height: 28),
              _ReadyRow(colors: colors, text: 'Program tailored to your goals'),
              const SizedBox(height: 10),
              _ReadyRow(colors: colors, text: 'Progress tracking ready to go'),
              const SizedBox(height: 10),
              _ReadyRow(colors: colors, text: apple ? 'Apple Health synced' : 'Apple Health skipped'),
              const Spacer(flex: 2),
              OnboardingPrimaryButton(
                label: _saving ? 'Saving…' : 'Start Training',
                background: kOnboardingGreen,
                onPressed: _saving ? () {} : _finish,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReadyRow extends StatelessWidget {
  final AppColors colors;
  final String text;
  const _ReadyRow({required this.colors, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(color: kOnboardingGreen, shape: BoxShape.circle),
            child: const Icon(Icons.check, size: 14, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(color: colors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
