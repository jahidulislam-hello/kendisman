import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise.freezed.dart';
part 'exercise.g.dart';

@freezed
abstract class Exercise with _$Exercise {
  const factory Exercise({
    required String id,
    required String name,
    required String muscleGroup,
    required String equipmentType,
    String? videoUrl,
    String? gifUrl,
    String? imageUrl,
    required List<String> primaryMuscles,
    required List<String> secondaryMuscles,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);
}

@freezed
abstract class RoutineExercise with _$RoutineExercise {
  const factory RoutineExercise({
    required String id,
    required String routineId,
    required String exerciseId,
    required int orderIndex,
    required int targetSets,
    required int targetReps,
    int? targetRepsMin,
    int? targetRepsMax,
    required double targetWeight,
  }) = _RoutineExercise;

  factory RoutineExercise.fromJson(Map<String, dynamic> json) => _$RoutineExerciseFromJson(json);
}

@freezed
abstract class RoutineSetTarget with _$RoutineSetTarget {
  const factory RoutineSetTarget({
    required int setIndex,
    int? targetReps,
    double? targetWeight,
  }) = _RoutineSetTarget;

  factory RoutineSetTarget.fromJson(Map<String, dynamic> json) => _$RoutineSetTargetFromJson(json);
}

@freezed
abstract class RoutineExerciseWithDetails with _$RoutineExerciseWithDetails {
  const factory RoutineExerciseWithDetails({
    required String id,
    required String routineId,
    required String exerciseId,
    required int orderIndex,
    required int targetSets,
    required int targetReps,
    int? targetRepsMin,
    int? targetRepsMax,
    required double targetWeight,
    required Exercise exercise,
    required List<RoutineSetTarget> sets,
  }) = _RoutineExerciseWithDetails;

  factory RoutineExerciseWithDetails.fromJson(Map<String, dynamic> json) =>
      _$RoutineExerciseWithDetailsFromJson(json);
}

enum ChangeType {
  weightUp,
  weightDown,
  volumeUp,
  volumeDown,
  repsUp,
  hold,
  newExercise,
}

extension ChangeTypeExtension on ChangeType {
  String get value => switch (this) {
    ChangeType.weightUp => 'weight_up',
    ChangeType.weightDown => 'weight_down',
    ChangeType.volumeUp => 'volume_up',
    ChangeType.volumeDown => 'volume_down',
    ChangeType.repsUp => 'reps_up',
    ChangeType.hold => 'hold',
    ChangeType.newExercise => 'new_exercise',
  };

  static ChangeType fromString(String value) => switch (value) {
    'weight_up' => ChangeType.weightUp,
    'weight_down' => ChangeType.weightDown,
    'volume_up' => ChangeType.volumeUp,
    'volume_down' => ChangeType.volumeDown,
    'reps_up' => ChangeType.repsUp,
    'hold' => ChangeType.hold,
    'new_exercise' => ChangeType.newExercise,
    _ => throw ArgumentError('Unknown ChangeType: $value'),
  };
}