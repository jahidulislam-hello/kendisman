import 'package:freezed_annotation/freezed_annotation.dart';

part 'program.freezed.dart';
part 'program.g.dart';

@freezed
abstract class Program with _$Program {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Program({
    required String id,
    required String userId,
    required String name,
    required bool isAiGenerated,
    required bool isActive,
    String? createdAt,
  }) = _Program;

  factory Program.fromJson(Map<String, dynamic> json) => _$ProgramFromJson(json);
}

@freezed
abstract class Routine with _$Routine {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Routine({
    required String id,
    required String userId,
    required String name,
    required bool isAiGenerated,
    required String programId,
    required int dayIndex,
  }) = _Routine;

  factory Routine.fromJson(Map<String, dynamic> json) => _$RoutineFromJson(json);
}

@freezed
abstract class RoutineLibraryEntry with _$RoutineLibraryEntry {
  const factory RoutineLibraryEntry({
    required Routine routine,
    required int exerciseCount,
    required List<String> exercisePreview,
    String? lastPerformedAt,
  }) = _RoutineLibraryEntry;

  factory RoutineLibraryEntry.fromJson(Map<String, dynamic> json) => _$RoutineLibraryEntryFromJson(json);
}

@freezed
abstract class RoutineLibrary with _$RoutineLibrary {
  const factory RoutineLibrary({
    required Program program,
    required List<RoutineLibraryEntry> entries,
  }) = _RoutineLibrary;

  factory RoutineLibrary.fromJson(Map<String, dynamic> json) => _$RoutineLibraryFromJson(json);
}