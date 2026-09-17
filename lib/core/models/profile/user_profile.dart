import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserProfile({
    required String id,
    required String email,
    required UserMode mode,
    required SubscriptionTier subscriptionTier,
    required UnitPreference unitPreference,
    required ThemePreference themePreference,
    UserSex? sex,
    String? username,
    String? dateOfBirth,
    int? heightCm,
    String? photoUrl,
    required String createdAt,
    String? pushToken,
    required bool notificationsEnabled,
    int? restTimerDefaultOverrideSeconds,
    @Default(<String, int>{}) Map<String, int> restTimerExerciseOverrides,
    required bool restTimerEnabled,
    required bool rpeTrackingEnabled,
    required bool trialNudgeSent,
    required bool isReviewer,
    required String referralCode,
    required bool isLifetime,
    TrainingGoal? goal,
    ExperienceLevel? experienceLevel,
    int? trainingDaysPerWeek,
    required bool emailOptIn,
    String? referralSource,
    required bool onboarded,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // Harden against partial / legacy rows from Postgres (null referral_code, etc.).
    final data = Map<String, dynamic>.from(json);
    data['referral_code'] ??= '';
    data['email'] ??= '';
    data['created_at'] = data['created_at']?.toString() ?? DateTime.now().toUtc().toIso8601String();
    data['notifications_enabled'] ??= true;
    data['rest_timer_enabled'] ??= true;
    data['rpe_tracking_enabled'] ??= false;
    data['trial_nudge_sent'] ??= false;
    data['is_reviewer'] ??= false;
    data['is_lifetime'] ??= false;
    data['email_opt_in'] ??= false;
    data['onboarded'] ??= false;
    data['rest_timer_exercise_overrides'] ??= <String, dynamic>{};
    data['mode'] ??= 'manual';
    data['subscription_tier'] ??= 'free';
    data['unit_preference'] ??= 'kg';
    data['theme_preference'] ??= 'system';
    return _$UserProfileFromJson(data);
  }
}

enum UserMode {
  @JsonValue('manual')
  manual,
  @JsonValue('ai_coach')
  aiCoach,
}

enum SubscriptionTier {
  @JsonValue('free')
  free,
  @JsonValue('plus')
  plus,
  @JsonValue('premium')
  premium,
}

enum UnitPreference {
  @JsonValue('lb')
  lb,
  @JsonValue('kg')
  kg,
}

enum UserSex {
  @JsonValue('male')
  male,
  @JsonValue('female')
  female,
}

enum ThemePreference {
  @JsonValue('system')
  system,
  @JsonValue('light')
  light,
  @JsonValue('dark')
  dark,
}

enum TrainingGoal {
  @JsonValue('muscle')
  muscle,
  @JsonValue('strength')
  strength,
  @JsonValue('fat_loss')
  fatLoss,
  @JsonValue('build_muscle')
  buildMuscle,
  @JsonValue('improve_endurance')
  improveEndurance,
  @JsonValue('general_fitness')
  generalFitness,
}

enum ExperienceLevel {
  @JsonValue('beginner')
  beginner,
  @JsonValue('intermediate')
  intermediate,
  @JsonValue('advanced')
  advanced,
}

extension UserModeExtension on UserMode {
  String get value => switch (this) {
        UserMode.manual => 'manual',
        UserMode.aiCoach => 'ai_coach',
      };

  static UserMode fromString(String value) => switch (value) {
        'ai_coach' || 'aiCoach' => UserMode.aiCoach,
        _ => UserMode.manual,
      };
}

extension SubscriptionTierExtension on SubscriptionTier {
  String get value => name;
  static SubscriptionTier fromString(String value) =>
      SubscriptionTier.values.byName(value);
}

extension UnitPreferenceExtension on UnitPreference {
  String get value => name;
  static UnitPreference fromString(String value) =>
      UnitPreference.values.byName(value);
}

extension UserSexExtension on UserSex {
  String get value => name;
  static UserSex fromString(String value) => UserSex.values.byName(value);
}

extension ThemePreferenceExtension on ThemePreference {
  String get value => name;
  static ThemePreference fromString(String value) =>
      ThemePreference.values.byName(value);
}

extension TrainingGoalExtension on TrainingGoal {
  String get value => switch (this) {
        TrainingGoal.muscle => 'muscle',
        TrainingGoal.strength => 'strength',
        TrainingGoal.fatLoss => 'fat_loss',
        TrainingGoal.buildMuscle => 'build_muscle',
        TrainingGoal.improveEndurance => 'improve_endurance',
        TrainingGoal.generalFitness => 'general_fitness',
      };

  static TrainingGoal fromString(String value) => switch (value) {
        'strength' => TrainingGoal.strength,
        'fat_loss' || 'fatLoss' => TrainingGoal.fatLoss,
        'build_muscle' || 'buildMuscle' => TrainingGoal.buildMuscle,
        'improve_endurance' || 'improveEndurance' => TrainingGoal.improveEndurance,
        'general_fitness' || 'generalFitness' => TrainingGoal.generalFitness,
        _ => TrainingGoal.muscle,
      };
}

extension ExperienceLevelExtension on ExperienceLevel {
  String get value => name;
  static ExperienceLevel fromString(String value) =>
      ExperienceLevel.values.byName(value);
}