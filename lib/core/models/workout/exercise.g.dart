// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExerciseImpl _$$ExerciseImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      muscleGroup: json['muscleGroup'] as String,
      equipmentType: json['equipmentType'] as String,
      videoUrl: json['videoUrl'] as String?,
      gifUrl: json['gifUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
      primaryMuscles: (json['primaryMuscles'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      secondaryMuscles: (json['secondaryMuscles'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ExerciseImplToJson(_$ExerciseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'muscleGroup': instance.muscleGroup,
      'equipmentType': instance.equipmentType,
      'videoUrl': instance.videoUrl,
      'gifUrl': instance.gifUrl,
      'imageUrl': instance.imageUrl,
      'primaryMuscles': instance.primaryMuscles,
      'secondaryMuscles': instance.secondaryMuscles,
    };

_$RoutineExerciseImpl _$$RoutineExerciseImplFromJson(
        Map<String, dynamic> json) =>
    _$RoutineExerciseImpl(
      id: json['id'] as String,
      routineId: json['routineId'] as String,
      exerciseId: json['exerciseId'] as String,
      orderIndex: (json['orderIndex'] as num).toInt(),
      targetSets: (json['targetSets'] as num).toInt(),
      targetReps: (json['targetReps'] as num).toInt(),
      targetRepsMin: (json['targetRepsMin'] as num?)?.toInt(),
      targetRepsMax: (json['targetRepsMax'] as num?)?.toInt(),
      targetWeight: (json['targetWeight'] as num).toDouble(),
    );

Map<String, dynamic> _$$RoutineExerciseImplToJson(
        _$RoutineExerciseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'routineId': instance.routineId,
      'exerciseId': instance.exerciseId,
      'orderIndex': instance.orderIndex,
      'targetSets': instance.targetSets,
      'targetReps': instance.targetReps,
      'targetRepsMin': instance.targetRepsMin,
      'targetRepsMax': instance.targetRepsMax,
      'targetWeight': instance.targetWeight,
    };

_$RoutineSetTargetImpl _$$RoutineSetTargetImplFromJson(
        Map<String, dynamic> json) =>
    _$RoutineSetTargetImpl(
      setIndex: (json['setIndex'] as num).toInt(),
      targetReps: (json['targetReps'] as num?)?.toInt(),
      targetWeight: (json['targetWeight'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$RoutineSetTargetImplToJson(
        _$RoutineSetTargetImpl instance) =>
    <String, dynamic>{
      'setIndex': instance.setIndex,
      'targetReps': instance.targetReps,
      'targetWeight': instance.targetWeight,
    };

_$RoutineExerciseWithDetailsImpl _$$RoutineExerciseWithDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$RoutineExerciseWithDetailsImpl(
      id: json['id'] as String,
      routineId: json['routineId'] as String,
      exerciseId: json['exerciseId'] as String,
      orderIndex: (json['orderIndex'] as num).toInt(),
      targetSets: (json['targetSets'] as num).toInt(),
      targetReps: (json['targetReps'] as num).toInt(),
      targetRepsMin: (json['targetRepsMin'] as num?)?.toInt(),
      targetRepsMax: (json['targetRepsMax'] as num?)?.toInt(),
      targetWeight: (json['targetWeight'] as num).toDouble(),
      exercise: Exercise.fromJson(json['exercise'] as Map<String, dynamic>),
      sets: (json['sets'] as List<dynamic>)
          .map((e) => RoutineSetTarget.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RoutineExerciseWithDetailsImplToJson(
        _$RoutineExerciseWithDetailsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'routineId': instance.routineId,
      'exerciseId': instance.exerciseId,
      'orderIndex': instance.orderIndex,
      'targetSets': instance.targetSets,
      'targetReps': instance.targetReps,
      'targetRepsMin': instance.targetRepsMin,
      'targetRepsMax': instance.targetRepsMax,
      'targetWeight': instance.targetWeight,
      'exercise': instance.exercise,
      'sets': instance.sets,
    };
