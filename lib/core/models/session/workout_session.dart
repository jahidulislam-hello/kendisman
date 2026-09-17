import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fitzella/core/models/workout/exercise.dart';
import 'package:fitzella/core/models/program/program.dart';

part 'workout_session.freezed.dart';
part 'workout_session.g.dart';

@freezed
abstract class TodaysWorkoutItem with _$TodaysWorkoutItem {
  const factory TodaysWorkoutItem({
    required String id,
    required String exerciseId,
    required String name,
    required String muscleGroup,
    required int targetSets,
    required int targetRepsMin,
    required int targetRepsMax,
    required double targetWeight,
    required double? suggestionWeight,
    int? suggestionRepsMin,
    int? suggestionRepsMax,
    @JsonKey(
      fromJson: _changeTypeFromJson,
      toJson: _changeTypeToJson,
    )
    ChangeType? suggestionChangeType,
    String? suggestionReasoning,
  }) = _TodaysWorkoutItem;

  factory TodaysWorkoutItem.fromJson(Map<String, dynamic> json) => _$TodaysWorkoutItemFromJson(json);
}

ChangeType? _changeTypeFromJson(String? value) {
  if (value == null) return null;
  return ChangeTypeExtension.fromString(value);
}

String? _changeTypeToJson(ChangeType? value) {
  return value?.value;
}

Routine _routineFromJson(Map<String, dynamic>? json) {
  if (json == null) throw ArgumentError('routine cannot be null');
  return Routine.fromJson(json);
}

Map<String, dynamic> _routineToJson(Routine value) {
  return value.toJson();
}

@freezed
abstract class TodaysWorkout with _$TodaysWorkout {
  const factory TodaysWorkout({
    @JsonKey(
      fromJson: _routineFromJson,
      toJson: _routineToJson,
    )
    required Routine routine,
    required List<TodaysWorkoutItem> items,
  }) = _TodaysWorkout;

  factory TodaysWorkout.fromJson(Map<String, dynamic> json) => _$TodaysWorkoutFromJson(json);
}

@freezed
abstract class WorkoutSession with _$WorkoutSession {
  const factory WorkoutSession({
    required String id,
    required String userId,
    String? routineId,
    required String startedAt,
    String? completedAt,
    required String mode,
    String? quickWorkoutName,
  }) = _WorkoutSession;

  factory WorkoutSession.fromJson(Map<String, dynamic> json) => _$WorkoutSessionFromJson(json);
}

@freezed
abstract class SetEntry with _$SetEntry {
  const factory SetEntry({
    required int setIndex,
    required int reps,
    required double weight,
    double? rpe,
    bool? isWarmup,
    String? note,
  }) = _SetEntry;

  factory SetEntry.fromJson(Map<String, dynamic> json) => _$SetEntryFromJson(json);
}

@freezed
abstract class SetDraft with _$SetDraft {
  const factory SetDraft({
    required int setIndex,
    required int reps,
    required double weight,
    double? rpe,
    @Default(false) bool isWarmup,
  }) = _SetDraft;

  factory SetDraft.fromJson(Map<String, dynamic> json) => _$SetDraftFromJson(json);
}

@freezed
abstract class IncompleteSession with _$IncompleteSession {
  const factory IncompleteSession({
    required String sessionId,
    required String routineId,
    required String startedAt,
    required List<String> loggedExerciseIds,
  }) = _IncompleteSession;

  factory IncompleteSession.fromJson(Map<String, dynamic> json) => _$IncompleteSessionFromJson(json);
}

@freezed
abstract class QuickSession with _$QuickSession {
  const factory QuickSession({
    required String sessionId,
    required String startedAt,
    required List<String> loggedExerciseIds,
  }) = _QuickSession;

  factory QuickSession.fromJson(Map<String, dynamic> json) => _$QuickSessionFromJson(json);
}

@freezed
abstract class SessionSetCounts with _$SessionSetCounts {
  const factory SessionSetCounts({
    required int setCount,
  }) = _SessionSetCounts;

  factory SessionSetCounts.fromJson(Map<String, dynamic> json) => _$SessionSetCountsFromJson(json);
}

@freezed
abstract class HomeStats with _$HomeStats {
  const factory HomeStats({
    required double volumeThisWeek,
    required double volumeLastWeek,
    required int minutesThisWeek,
    required int minutesLastWeek,
    required int setsThisWeek,
    required int workoutsThisWeek,
    required int weeklyTarget,
    required int streak,
    String? programName,
    int? programWeek,
    required List<WeekDay> weekDays,
    LastSession? lastSession,
  }) = _HomeStats;

  factory HomeStats.fromJson(Map<String, dynamic> json) => _$HomeStatsFromJson(json);
}

@freezed
abstract class WeekDay with _$WeekDay {
  const factory WeekDay({
    required String label,
    required String dateKey,
    required bool workedOut,
    required bool isToday,
  }) = _WeekDay;

  factory WeekDay.fromJson(Map<String, dynamic> json) => _$WeekDayFromJson(json);
}

@freezed
abstract class LastSession with _$LastSession {
  const factory LastSession({
    required int prCount,
  }) = _LastSession;

  factory LastSession.fromJson(Map<String, dynamic> json) => _$LastSessionFromJson(json);
}

@freezed
abstract class SupersetGroup with _$SupersetGroup {
  const factory SupersetGroup({
    required String id,
    required String sessionId,
    required List<String> exerciseIds,
    required String color,
  }) = _SupersetGroup;

  factory SupersetGroup.fromJson(Map<String, dynamic> json) => _$SupersetGroupFromJson(json);
}