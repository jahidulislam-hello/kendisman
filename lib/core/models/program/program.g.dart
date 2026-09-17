// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProgramImpl _$$ProgramImplFromJson(Map<String, dynamic> json) =>
    _$ProgramImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      isAiGenerated: json['is_ai_generated'] as bool,
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$ProgramImplToJson(_$ProgramImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'is_ai_generated': instance.isAiGenerated,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
    };

_$RoutineImpl _$$RoutineImplFromJson(Map<String, dynamic> json) =>
    _$RoutineImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      isAiGenerated: json['is_ai_generated'] as bool,
      programId: json['program_id'] as String,
      dayIndex: (json['day_index'] as num).toInt(),
    );

Map<String, dynamic> _$$RoutineImplToJson(_$RoutineImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'is_ai_generated': instance.isAiGenerated,
      'program_id': instance.programId,
      'day_index': instance.dayIndex,
    };

_$RoutineLibraryEntryImpl _$$RoutineLibraryEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$RoutineLibraryEntryImpl(
      routine: Routine.fromJson(json['routine'] as Map<String, dynamic>),
      exerciseCount: (json['exerciseCount'] as num).toInt(),
      exercisePreview: (json['exercisePreview'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastPerformedAt: json['lastPerformedAt'] as String?,
    );

Map<String, dynamic> _$$RoutineLibraryEntryImplToJson(
        _$RoutineLibraryEntryImpl instance) =>
    <String, dynamic>{
      'routine': instance.routine,
      'exerciseCount': instance.exerciseCount,
      'exercisePreview': instance.exercisePreview,
      'lastPerformedAt': instance.lastPerformedAt,
    };

_$RoutineLibraryImpl _$$RoutineLibraryImplFromJson(Map<String, dynamic> json) =>
    _$RoutineLibraryImpl(
      program: Program.fromJson(json['program'] as Map<String, dynamic>),
      entries: (json['entries'] as List<dynamic>)
          .map((e) => RoutineLibraryEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RoutineLibraryImplToJson(
        _$RoutineLibraryImpl instance) =>
    <String, dynamic>{
      'program': instance.program,
      'entries': instance.entries,
    };
