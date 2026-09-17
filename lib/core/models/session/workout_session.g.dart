// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodaysWorkoutItemImpl _$$TodaysWorkoutItemImplFromJson(
        Map<String, dynamic> json) =>
    _$TodaysWorkoutItemImpl(
      id: json['id'] as String,
      exerciseId: json['exerciseId'] as String,
      name: json['name'] as String,
      muscleGroup: json['muscleGroup'] as String,
      targetSets: (json['targetSets'] as num).toInt(),
      targetRepsMin: (json['targetRepsMin'] as num).toInt(),
      targetRepsMax: (json['targetRepsMax'] as num).toInt(),
      targetWeight: (json['targetWeight'] as num).toDouble(),
      suggestionWeight: (json['suggestionWeight'] as num?)?.toDouble(),
      suggestionRepsMin: (json['suggestionRepsMin'] as num?)?.toInt(),
      suggestionRepsMax: (json['suggestionRepsMax'] as num?)?.toInt(),
      suggestionChangeType:
          _changeTypeFromJson(json['suggestionChangeType'] as String?),
      suggestionReasoning: json['suggestionReasoning'] as String?,
    );

Map<String, dynamic> _$$TodaysWorkoutItemImplToJson(
        _$TodaysWorkoutItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'exerciseId': instance.exerciseId,
      'name': instance.name,
      'muscleGroup': instance.muscleGroup,
      'targetSets': instance.targetSets,
      'targetRepsMin': instance.targetRepsMin,
      'targetRepsMax': instance.targetRepsMax,
      'targetWeight': instance.targetWeight,
      'suggestionWeight': instance.suggestionWeight,
      'suggestionRepsMin': instance.suggestionRepsMin,
      'suggestionRepsMax': instance.suggestionRepsMax,
      'suggestionChangeType': _changeTypeToJson(instance.suggestionChangeType),
      'suggestionReasoning': instance.suggestionReasoning,
    };

_$TodaysWorkoutImpl _$$TodaysWorkoutImplFromJson(Map<String, dynamic> json) =>
    _$TodaysWorkoutImpl(
      routine: _routineFromJson(json['routine'] as Map<String, dynamic>?),
      items: (json['items'] as List<dynamic>)
          .map((e) => TodaysWorkoutItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TodaysWorkoutImplToJson(_$TodaysWorkoutImpl instance) =>
    <String, dynamic>{
      'routine': _routineToJson(instance.routine),
      'items': instance.items,
    };

_$WorkoutSessionImpl _$$WorkoutSessionImplFromJson(Map<String, dynamic> json) =>
    _$WorkoutSessionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      routineId: json['routineId'] as String?,
      startedAt: json['startedAt'] as String,
      completedAt: json['completedAt'] as String?,
      mode: json['mode'] as String,
      quickWorkoutName: json['quickWorkoutName'] as String?,
    );

Map<String, dynamic> _$$WorkoutSessionImplToJson(
        _$WorkoutSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'routineId': instance.routineId,
      'startedAt': instance.startedAt,
      'completedAt': instance.completedAt,
      'mode': instance.mode,
      'quickWorkoutName': instance.quickWorkoutName,
    };

_$SetEntryImpl _$$SetEntryImplFromJson(Map<String, dynamic> json) =>
    _$SetEntryImpl(
      setIndex: (json['setIndex'] as num).toInt(),
      reps: (json['reps'] as num).toInt(),
      weight: (json['weight'] as num).toDouble(),
      rpe: (json['rpe'] as num?)?.toDouble(),
      isWarmup: json['isWarmup'] as bool?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$SetEntryImplToJson(_$SetEntryImpl instance) =>
    <String, dynamic>{
      'setIndex': instance.setIndex,
      'reps': instance.reps,
      'weight': instance.weight,
      'rpe': instance.rpe,
      'isWarmup': instance.isWarmup,
      'note': instance.note,
    };

_$SetDraftImpl _$$SetDraftImplFromJson(Map<String, dynamic> json) =>
    _$SetDraftImpl(
      setIndex: (json['setIndex'] as num).toInt(),
      reps: (json['reps'] as num).toInt(),
      weight: (json['weight'] as num).toDouble(),
      rpe: (json['rpe'] as num?)?.toDouble(),
      isWarmup: json['isWarmup'] as bool? ?? false,
    );

Map<String, dynamic> _$$SetDraftImplToJson(_$SetDraftImpl instance) =>
    <String, dynamic>{
      'setIndex': instance.setIndex,
      'reps': instance.reps,
      'weight': instance.weight,
      'rpe': instance.rpe,
      'isWarmup': instance.isWarmup,
    };

_$IncompleteSessionImpl _$$IncompleteSessionImplFromJson(
        Map<String, dynamic> json) =>
    _$IncompleteSessionImpl(
      sessionId: json['sessionId'] as String,
      routineId: json['routineId'] as String,
      startedAt: json['startedAt'] as String,
      loggedExerciseIds: (json['loggedExerciseIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$IncompleteSessionImplToJson(
        _$IncompleteSessionImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'routineId': instance.routineId,
      'startedAt': instance.startedAt,
      'loggedExerciseIds': instance.loggedExerciseIds,
    };

_$QuickSessionImpl _$$QuickSessionImplFromJson(Map<String, dynamic> json) =>
    _$QuickSessionImpl(
      sessionId: json['sessionId'] as String,
      startedAt: json['startedAt'] as String,
      loggedExerciseIds: (json['loggedExerciseIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$QuickSessionImplToJson(_$QuickSessionImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'startedAt': instance.startedAt,
      'loggedExerciseIds': instance.loggedExerciseIds,
    };

_$SessionSetCountsImpl _$$SessionSetCountsImplFromJson(
        Map<String, dynamic> json) =>
    _$SessionSetCountsImpl(
      setCount: (json['setCount'] as num).toInt(),
    );

Map<String, dynamic> _$$SessionSetCountsImplToJson(
        _$SessionSetCountsImpl instance) =>
    <String, dynamic>{
      'setCount': instance.setCount,
    };

_$HomeStatsImpl _$$HomeStatsImplFromJson(Map<String, dynamic> json) =>
    _$HomeStatsImpl(
      volumeThisWeek: (json['volumeThisWeek'] as num).toDouble(),
      volumeLastWeek: (json['volumeLastWeek'] as num).toDouble(),
      minutesThisWeek: (json['minutesThisWeek'] as num).toInt(),
      minutesLastWeek: (json['minutesLastWeek'] as num).toInt(),
      setsThisWeek: (json['setsThisWeek'] as num).toInt(),
      workoutsThisWeek: (json['workoutsThisWeek'] as num).toInt(),
      weeklyTarget: (json['weeklyTarget'] as num).toInt(),
      streak: (json['streak'] as num).toInt(),
      programName: json['programName'] as String?,
      programWeek: (json['programWeek'] as num?)?.toInt(),
      weekDays: (json['weekDays'] as List<dynamic>)
          .map((e) => WeekDay.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastSession: json['lastSession'] == null
          ? null
          : LastSession.fromJson(json['lastSession'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$HomeStatsImplToJson(_$HomeStatsImpl instance) =>
    <String, dynamic>{
      'volumeThisWeek': instance.volumeThisWeek,
      'volumeLastWeek': instance.volumeLastWeek,
      'minutesThisWeek': instance.minutesThisWeek,
      'minutesLastWeek': instance.minutesLastWeek,
      'setsThisWeek': instance.setsThisWeek,
      'workoutsThisWeek': instance.workoutsThisWeek,
      'weeklyTarget': instance.weeklyTarget,
      'streak': instance.streak,
      'programName': instance.programName,
      'programWeek': instance.programWeek,
      'weekDays': instance.weekDays,
      'lastSession': instance.lastSession,
    };

_$WeekDayImpl _$$WeekDayImplFromJson(Map<String, dynamic> json) =>
    _$WeekDayImpl(
      label: json['label'] as String,
      dateKey: json['dateKey'] as String,
      workedOut: json['workedOut'] as bool,
      isToday: json['isToday'] as bool,
    );

Map<String, dynamic> _$$WeekDayImplToJson(_$WeekDayImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'dateKey': instance.dateKey,
      'workedOut': instance.workedOut,
      'isToday': instance.isToday,
    };

_$LastSessionImpl _$$LastSessionImplFromJson(Map<String, dynamic> json) =>
    _$LastSessionImpl(
      prCount: (json['prCount'] as num).toInt(),
    );

Map<String, dynamic> _$$LastSessionImplToJson(_$LastSessionImpl instance) =>
    <String, dynamic>{
      'prCount': instance.prCount,
    };

_$SupersetGroupImpl _$$SupersetGroupImplFromJson(Map<String, dynamic> json) =>
    _$SupersetGroupImpl(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      exerciseIds: (json['exerciseIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      color: json['color'] as String,
    );

Map<String, dynamic> _$$SupersetGroupImplToJson(_$SupersetGroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'exerciseIds': instance.exerciseIds,
      'color': instance.color,
    };
