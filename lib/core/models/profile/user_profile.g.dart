// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      mode: $enumDecode(_$UserModeEnumMap, json['mode']),
      subscriptionTier:
          $enumDecode(_$SubscriptionTierEnumMap, json['subscription_tier']),
      unitPreference:
          $enumDecode(_$UnitPreferenceEnumMap, json['unit_preference']),
      themePreference:
          $enumDecode(_$ThemePreferenceEnumMap, json['theme_preference']),
      sex: $enumDecodeNullable(_$UserSexEnumMap, json['sex']),
      username: json['username'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      heightCm: (json['height_cm'] as num?)?.toInt(),
      photoUrl: json['photo_url'] as String?,
      createdAt: json['created_at'] as String,
      pushToken: json['push_token'] as String?,
      notificationsEnabled: json['notifications_enabled'] as bool,
      restTimerDefaultOverrideSeconds:
          (json['rest_timer_default_override_seconds'] as num?)?.toInt(),
      restTimerExerciseOverrides:
          (json['rest_timer_exercise_overrides'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const <String, int>{},
      restTimerEnabled: json['rest_timer_enabled'] as bool,
      rpeTrackingEnabled: json['rpe_tracking_enabled'] as bool,
      trialNudgeSent: json['trial_nudge_sent'] as bool,
      isReviewer: json['is_reviewer'] as bool,
      referralCode: json['referral_code'] as String,
      isLifetime: json['is_lifetime'] as bool,
      goal: $enumDecodeNullable(_$TrainingGoalEnumMap, json['goal']),
      experienceLevel: $enumDecodeNullable(
          _$ExperienceLevelEnumMap, json['experience_level']),
      trainingDaysPerWeek: (json['training_days_per_week'] as num?)?.toInt(),
      equipmentPreference: json['equipment_preference'] as String?,
      emailOptIn: json['email_opt_in'] as bool,
      referralSource: json['referral_source'] as String?,
      onboarded: json['onboarded'] as bool,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'mode': _$UserModeEnumMap[instance.mode]!,
      'subscription_tier':
          _$SubscriptionTierEnumMap[instance.subscriptionTier]!,
      'unit_preference': _$UnitPreferenceEnumMap[instance.unitPreference]!,
      'theme_preference': _$ThemePreferenceEnumMap[instance.themePreference]!,
      'sex': _$UserSexEnumMap[instance.sex],
      'username': instance.username,
      'date_of_birth': instance.dateOfBirth,
      'height_cm': instance.heightCm,
      'photo_url': instance.photoUrl,
      'created_at': instance.createdAt,
      'push_token': instance.pushToken,
      'notifications_enabled': instance.notificationsEnabled,
      'rest_timer_default_override_seconds':
          instance.restTimerDefaultOverrideSeconds,
      'rest_timer_exercise_overrides': instance.restTimerExerciseOverrides,
      'rest_timer_enabled': instance.restTimerEnabled,
      'rpe_tracking_enabled': instance.rpeTrackingEnabled,
      'trial_nudge_sent': instance.trialNudgeSent,
      'is_reviewer': instance.isReviewer,
      'referral_code': instance.referralCode,
      'is_lifetime': instance.isLifetime,
      'goal': _$TrainingGoalEnumMap[instance.goal],
      'experience_level': _$ExperienceLevelEnumMap[instance.experienceLevel],
      'training_days_per_week': instance.trainingDaysPerWeek,
      'equipment_preference': instance.equipmentPreference,
      'email_opt_in': instance.emailOptIn,
      'referral_source': instance.referralSource,
      'onboarded': instance.onboarded,
    };

const _$UserModeEnumMap = {
  UserMode.manual: 'manual',
  UserMode.aiCoach: 'ai_coach',
};

const _$SubscriptionTierEnumMap = {
  SubscriptionTier.free: 'free',
  SubscriptionTier.plus: 'plus',
  SubscriptionTier.premium: 'premium',
};

const _$UnitPreferenceEnumMap = {
  UnitPreference.lb: 'lb',
  UnitPreference.kg: 'kg',
};

const _$ThemePreferenceEnumMap = {
  ThemePreference.system: 'system',
  ThemePreference.light: 'light',
  ThemePreference.dark: 'dark',
};

const _$UserSexEnumMap = {
  UserSex.male: 'male',
  UserSex.female: 'female',
};

const _$TrainingGoalEnumMap = {
  TrainingGoal.muscle: 'muscle',
  TrainingGoal.strength: 'strength',
  TrainingGoal.fatLoss: 'fat_loss',
  TrainingGoal.buildMuscle: 'build_muscle',
  TrainingGoal.improveEndurance: 'improve_endurance',
  TrainingGoal.generalFitness: 'general_fitness',
};

const _$ExperienceLevelEnumMap = {
  ExperienceLevel.beginner: 'beginner',
  ExperienceLevel.intermediate: 'intermediate',
  ExperienceLevel.advanced: 'advanced',
};
