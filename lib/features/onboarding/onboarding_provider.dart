import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingState {
  final bool useMetric; // kg/cm when true; lbs/ft when false
  final String? gender;
  final DateTime birthday;
  final double weightKg;
  final double heightCm;
  final String? goal;
  final String? equipment;
  final String? experience;
  final int? frequency;
  final bool appleHealthEnabled;
  final String plan; // annual | monthly

  const OnboardingState({
    this.useMetric = true,
    this.gender,
    required this.birthday,
    this.weightKg = 70,
    this.heightCm = 170,
    this.goal,
    this.equipment,
    this.experience,
    this.frequency,
    this.appleHealthEnabled = false,
    this.plan = 'annual',
  });

  OnboardingState copyWith({
    bool? useMetric,
    String? gender,
    DateTime? birthday,
    double? weightKg,
    double? heightCm,
    String? goal,
    String? equipment,
    String? experience,
    int? frequency,
    bool? appleHealthEnabled,
    String? plan,
  }) {
    return OnboardingState(
      useMetric: useMetric ?? this.useMetric,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      goal: goal ?? this.goal,
      equipment: equipment ?? this.equipment,
      experience: experience ?? this.experience,
      frequency: frequency ?? this.frequency,
      appleHealthEnabled: appleHealthEnabled ?? this.appleHealthEnabled,
      plan: plan ?? this.plan,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier()
      : super(OnboardingState(birthday: DateTime(2006, 1, 1)));

  void setUseMetric(bool v) => state = state.copyWith(useMetric: v);
  void setGender(String v) => state = state.copyWith(gender: v);
  void setBirthday(DateTime v) => state = state.copyWith(birthday: v);
  void setWeightKg(double v) => state = state.copyWith(weightKg: v);
  void setHeightCm(double v) => state = state.copyWith(heightCm: v);
  void setGoal(String v) => state = state.copyWith(goal: v);
  void setEquipment(String v) => state = state.copyWith(equipment: v);
  void setExperience(String v) => state = state.copyWith(experience: v);
  void setFrequency(int v) => state = state.copyWith(frequency: v);
  void setAppleHealth(bool v) => state = state.copyWith(appleHealthEnabled: v);
  void setPlan(String v) => state = state.copyWith(plan: v);
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) => OnboardingNotifier());
