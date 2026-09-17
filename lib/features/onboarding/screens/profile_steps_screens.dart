import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/features/onboarding/onboarding_provider.dart';
import 'package:fitzella/features/onboarding/widgets/onboarding_widgets.dart';

/// 02 — Units (step 1)
class OnboardingUnitsScreen extends ConsumerWidget {
  const OnboardingUnitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final state = ref.watch(onboardingProvider);

    return OnboardingStepScaffold(
      colors: colors,
      step: 1,
      onContinue: () => context.go('/onboarding/gender'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OnboardingStepHeader(
                    colors: colors,
                    icon: Icons.balance,
                    step: 1,
                    title: 'Select your units',
                    subtitle:
                        'Choose the measurement system you prefer for tracking your progress.',
                  ),
                  Column(
                    children: [
                      OnboardingUnitToggle(
                        colors: colors,
                        left: 'kg',
                        right: 'lbs',
                        leftSelected: state.useMetric,
                        onChanged: (metric) =>
                            ref.read(onboardingProvider.notifier).setUseMetric(metric),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'You can change this anytime in Settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.textMuted, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 03 — Gender (step 2)
class OnboardingGenderScreen extends ConsumerWidget {
  const OnboardingGenderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final selected = ref.watch(onboardingProvider).gender ?? 'Male';

    const options = [
      'Female',
      'Male',
      'Prefer not to say',
    ];

    return OnboardingStepScaffold(
      colors: colors,
      step: 2,
      onContinue: () => context.go('/onboarding/birthday'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingStepHeader(
            colors: colors,
            icon: Icons.person_outline,
            step: 2,
            title: "What's your gender?",
            subtitle: 'This helps us personalise your experience and calorie estimates.',
          ),
          const SizedBox(height: 28),
          ...options.map((title) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OnboardingOptionCard(
                colors: colors,
                title: title,
                subtitle: '',
                selected: selected == title,
                onTap: () => ref.read(onboardingProvider.notifier).setGender(title),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// 04 — Birthday (step 3)
class OnboardingBirthdayScreen extends ConsumerStatefulWidget {
  const OnboardingBirthdayScreen({super.key});

  @override
  ConsumerState<OnboardingBirthdayScreen> createState() => _OnboardingBirthdayScreenState();
}

class _OnboardingBirthdayScreenState extends ConsumerState<OnboardingBirthdayScreen> {
  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  late int _month;
  late int _day;
  late int _year;

  @override
  void initState() {
    super.initState();
    final b = ref.read(onboardingProvider).birthday;
    _month = b.month;
    _day = b.day;
    _year = b.year;
  }

  void _commit() {
    final daysInMonth = DateTime(_year, _month + 1, 0).day;
    final day = _day.clamp(1, daysInMonth);
    ref.read(onboardingProvider.notifier).setBirthday(DateTime(_year, _month, day));
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final years = List.generate(80, (i) => (DateTime.now().year - i).toString());
    final days = List.generate(31, (i) => '${i + 1}');

    return OnboardingStepScaffold(
      colors: colors,
      step: 3,
      onContinue: () {
        _commit();
        context.go('/onboarding/weight');
      },
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OnboardingStepHeader(
                    colors: colors,
                    icon: Icons.calendar_today_outlined,
                    step: 3,
                    title: 'When is your birthday?',
                    subtitle:
                        'We use this to calculate your age-adjusted training recommendations.',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OnboardingWheelPicker(
                        colors: colors,
                        width: 130,
                        items: _months,
                        selectedIndex: _month - 1,
                        onSelected: (i) => setState(() {
                          _month = i + 1;
                          _commit();
                        }),
                      ),
                      OnboardingWheelPicker(
                        colors: colors,
                        width: 70,
                        items: days,
                        selectedIndex: _day - 1,
                        onSelected: (i) => setState(() {
                          _day = i + 1;
                          _commit();
                        }),
                      ),
                      OnboardingWheelPicker(
                        colors: colors,
                        width: 90,
                        items: years,
                        selectedIndex: years.indexOf('$_year').clamp(0, years.length - 1),
                        onSelected: (i) => setState(() {
                          _year = int.parse(years[i]);
                          _commit();
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 05 — Weight (step 4)
class OnboardingWeightScreen extends ConsumerStatefulWidget {
  const OnboardingWeightScreen({super.key});

  @override
  ConsumerState<OnboardingWeightScreen> createState() => _OnboardingWeightScreenState();
}

class _OnboardingWeightScreenState extends ConsumerState<OnboardingWeightScreen> {
  late bool _metric;
  late int _value;

  @override
  void initState() {
    super.initState();
    final s = ref.read(onboardingProvider);
    _metric = s.useMetric;
    _value = _metric ? s.weightKg.round().clamp(30, 200) : (s.weightKg * 2.20462).round().clamp(66, 440);
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final min = _metric ? 30 : 66;
    final max = _metric ? 200 : 440;
    final items = List.generate(max - min + 1, (i) => '${min + i}');

    return OnboardingStepScaffold(
      colors: colors,
      step: 4,
      onContinue: () {
        final kg = _metric ? _value.toDouble() : _value / 2.20462;
        ref.read(onboardingProvider.notifier).setWeightKg(kg);
        ref.read(onboardingProvider.notifier).setUseMetric(_metric);
        context.go('/onboarding/height');
      },
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OnboardingStepHeader(
                    colors: colors,
                    icon: Icons.monitor_weight_outlined,
                    step: 4,
                    title: 'What is your weight?',
                  ),
                  const SizedBox(height: 24),
                  OnboardingUnitToggle(
                    colors: colors,
                    left: 'kg',
                    right: 'lbs',
                    leftSelected: _metric,
                    onChanged: (metric) {
                      setState(() {
                        if (metric == _metric) return;
                        if (metric) {
                          _value = (_value / 2.20462).round().clamp(30, 200);
                        } else {
                          _value = (_value * 2.20462).round().clamp(66, 440);
                        }
                        _metric = metric;
                      });
                    },
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$_value',
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextSpan(
                            text: ' ${_metric ? 'kg' : 'lbs'}',
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: OnboardingWheelPicker(
                      colors: colors,
                      width: 120,
                      items: items,
                      selectedIndex: (_value - min).clamp(0, items.length - 1),
                      onSelected: (i) => setState(() => _value = min + i),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 06/07 — Height (step 5)
class OnboardingHeightScreen extends ConsumerStatefulWidget {
  const OnboardingHeightScreen({super.key});

  @override
  ConsumerState<OnboardingHeightScreen> createState() => _OnboardingHeightScreenState();
}

class _OnboardingHeightScreenState extends ConsumerState<OnboardingHeightScreen> {
  late bool _useFt;
  late int _cm;
  late int _ft;
  late int _inch;

  @override
  void initState() {
    super.initState();
    final s = ref.read(onboardingProvider);
    _cm = s.heightCm.round().clamp(120, 220);
    _useFt = !s.useMetric;
    final totalInches = (_cm / 2.54).round();
    _ft = totalInches ~/ 12;
    _inch = totalInches % 12;
    if (_ft < 4) _ft = 4;
    if (_ft > 7) _ft = 7;
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);

    return OnboardingStepScaffold(
      colors: colors,
      step: 5,
      onContinue: () {
        final cm = _useFt ? ((_ft * 12 + _inch) * 2.54) : _cm.toDouble();
        ref.read(onboardingProvider.notifier).setHeightCm(cm);
        context.go('/onboarding/goal');
      },
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OnboardingStepHeader(
                    colors: colors,
                    icon: Icons.straighten,
                    step: 5,
                    title: 'What is your height?',
                  ),
                  const SizedBox(height: 24),
                  OnboardingUnitToggle(
                    colors: colors,
                    left: 'ft',
                    right: 'cm',
                    leftSelected: _useFt,
                    onChanged: (ft) {
                      setState(() {
                        if (ft == _useFt) return;
                        if (ft) {
                          final totalInches = (_cm / 2.54).round();
                          _ft = (totalInches ~/ 12).clamp(4, 7);
                          _inch = totalInches % 12;
                        } else {
                          _cm = ((_ft * 12 + _inch) * 2.54).round().clamp(120, 220);
                        }
                        _useFt = ft;
                      });
                    },
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child: Text(
                      _useFt ? "$_ft'$_inch\"" : '$_cm cm',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_useFt)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OnboardingWheelPicker(
                          colors: colors,
                          width: 80,
                          items: List.generate(4, (i) => '${i + 4}'),
                          selectedIndex: (_ft - 4).clamp(0, 3),
                          onSelected: (i) => setState(() => _ft = i + 4),
                        ),
                        OnboardingWheelPicker(
                          colors: colors,
                          width: 80,
                          items: List.generate(12, (i) => '$i'),
                          selectedIndex: _inch.clamp(0, 11),
                          onSelected: (i) => setState(() => _inch = i),
                        ),
                      ],
                    )
                  else
                    Center(
                      child: OnboardingWheelPicker(
                        colors: colors,
                        width: 120,
                        items: List.generate(101, (i) => '${120 + i}'),
                        selectedIndex: (_cm - 120).clamp(0, 100),
                        onSelected: (i) => setState(() => _cm = 120 + i),
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
