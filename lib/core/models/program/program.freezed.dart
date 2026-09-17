// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'program.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Program _$ProgramFromJson(Map<String, dynamic> json) {
  return _Program.fromJson(json);
}

/// @nodoc
mixin _$Program {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get isAiGenerated => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProgramCopyWith<Program> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgramCopyWith<$Res> {
  factory $ProgramCopyWith(Program value, $Res Function(Program) then) =
      _$ProgramCopyWithImpl<$Res, Program>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      bool isAiGenerated,
      bool isActive,
      String? createdAt});
}

/// @nodoc
class _$ProgramCopyWithImpl<$Res, $Val extends Program>
    implements $ProgramCopyWith<$Res> {
  _$ProgramCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? isAiGenerated = null,
    Object? isActive = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isAiGenerated: null == isAiGenerated
          ? _value.isAiGenerated
          : isAiGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProgramImplCopyWith<$Res> implements $ProgramCopyWith<$Res> {
  factory _$$ProgramImplCopyWith(
          _$ProgramImpl value, $Res Function(_$ProgramImpl) then) =
      __$$ProgramImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      bool isAiGenerated,
      bool isActive,
      String? createdAt});
}

/// @nodoc
class __$$ProgramImplCopyWithImpl<$Res>
    extends _$ProgramCopyWithImpl<$Res, _$ProgramImpl>
    implements _$$ProgramImplCopyWith<$Res> {
  __$$ProgramImplCopyWithImpl(
      _$ProgramImpl _value, $Res Function(_$ProgramImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? isAiGenerated = null,
    Object? isActive = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$ProgramImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isAiGenerated: null == isAiGenerated
          ? _value.isAiGenerated
          : isAiGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$ProgramImpl implements _Program {
  const _$ProgramImpl(
      {required this.id,
      required this.userId,
      required this.name,
      required this.isAiGenerated,
      required this.isActive,
      this.createdAt});

  factory _$ProgramImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProgramImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String name;
  @override
  final bool isAiGenerated;
  @override
  final bool isActive;
  @override
  final String? createdAt;

  @override
  String toString() {
    return 'Program(id: $id, userId: $userId, name: $name, isAiGenerated: $isAiGenerated, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgramImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isAiGenerated, isAiGenerated) ||
                other.isAiGenerated == isAiGenerated) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, userId, name, isAiGenerated, isActive, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgramImplCopyWith<_$ProgramImpl> get copyWith =>
      __$$ProgramImplCopyWithImpl<_$ProgramImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProgramImplToJson(
      this,
    );
  }
}

abstract class _Program implements Program {
  const factory _Program(
      {required final String id,
      required final String userId,
      required final String name,
      required final bool isAiGenerated,
      required final bool isActive,
      final String? createdAt}) = _$ProgramImpl;

  factory _Program.fromJson(Map<String, dynamic> json) = _$ProgramImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get name;
  @override
  bool get isAiGenerated;
  @override
  bool get isActive;
  @override
  String? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ProgramImplCopyWith<_$ProgramImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Routine _$RoutineFromJson(Map<String, dynamic> json) {
  return _Routine.fromJson(json);
}

/// @nodoc
mixin _$Routine {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get isAiGenerated => throw _privateConstructorUsedError;
  String get programId => throw _privateConstructorUsedError;
  int get dayIndex => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoutineCopyWith<Routine> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutineCopyWith<$Res> {
  factory $RoutineCopyWith(Routine value, $Res Function(Routine) then) =
      _$RoutineCopyWithImpl<$Res, Routine>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      bool isAiGenerated,
      String programId,
      int dayIndex});
}

/// @nodoc
class _$RoutineCopyWithImpl<$Res, $Val extends Routine>
    implements $RoutineCopyWith<$Res> {
  _$RoutineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? isAiGenerated = null,
    Object? programId = null,
    Object? dayIndex = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isAiGenerated: null == isAiGenerated
          ? _value.isAiGenerated
          : isAiGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
      programId: null == programId
          ? _value.programId
          : programId // ignore: cast_nullable_to_non_nullable
              as String,
      dayIndex: null == dayIndex
          ? _value.dayIndex
          : dayIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoutineImplCopyWith<$Res> implements $RoutineCopyWith<$Res> {
  factory _$$RoutineImplCopyWith(
          _$RoutineImpl value, $Res Function(_$RoutineImpl) then) =
      __$$RoutineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      bool isAiGenerated,
      String programId,
      int dayIndex});
}

/// @nodoc
class __$$RoutineImplCopyWithImpl<$Res>
    extends _$RoutineCopyWithImpl<$Res, _$RoutineImpl>
    implements _$$RoutineImplCopyWith<$Res> {
  __$$RoutineImplCopyWithImpl(
      _$RoutineImpl _value, $Res Function(_$RoutineImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? isAiGenerated = null,
    Object? programId = null,
    Object? dayIndex = null,
  }) {
    return _then(_$RoutineImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isAiGenerated: null == isAiGenerated
          ? _value.isAiGenerated
          : isAiGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
      programId: null == programId
          ? _value.programId
          : programId // ignore: cast_nullable_to_non_nullable
              as String,
      dayIndex: null == dayIndex
          ? _value.dayIndex
          : dayIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$RoutineImpl implements _Routine {
  const _$RoutineImpl(
      {required this.id,
      required this.userId,
      required this.name,
      required this.isAiGenerated,
      required this.programId,
      required this.dayIndex});

  factory _$RoutineImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutineImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String name;
  @override
  final bool isAiGenerated;
  @override
  final String programId;
  @override
  final int dayIndex;

  @override
  String toString() {
    return 'Routine(id: $id, userId: $userId, name: $name, isAiGenerated: $isAiGenerated, programId: $programId, dayIndex: $dayIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutineImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isAiGenerated, isAiGenerated) ||
                other.isAiGenerated == isAiGenerated) &&
            (identical(other.programId, programId) ||
                other.programId == programId) &&
            (identical(other.dayIndex, dayIndex) ||
                other.dayIndex == dayIndex));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, userId, name, isAiGenerated, programId, dayIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutineImplCopyWith<_$RoutineImpl> get copyWith =>
      __$$RoutineImplCopyWithImpl<_$RoutineImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutineImplToJson(
      this,
    );
  }
}

abstract class _Routine implements Routine {
  const factory _Routine(
      {required final String id,
      required final String userId,
      required final String name,
      required final bool isAiGenerated,
      required final String programId,
      required final int dayIndex}) = _$RoutineImpl;

  factory _Routine.fromJson(Map<String, dynamic> json) = _$RoutineImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get name;
  @override
  bool get isAiGenerated;
  @override
  String get programId;
  @override
  int get dayIndex;
  @override
  @JsonKey(ignore: true)
  _$$RoutineImplCopyWith<_$RoutineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoutineLibraryEntry _$RoutineLibraryEntryFromJson(Map<String, dynamic> json) {
  return _RoutineLibraryEntry.fromJson(json);
}

/// @nodoc
mixin _$RoutineLibraryEntry {
  Routine get routine => throw _privateConstructorUsedError;
  int get exerciseCount => throw _privateConstructorUsedError;
  List<String> get exercisePreview => throw _privateConstructorUsedError;
  String? get lastPerformedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoutineLibraryEntryCopyWith<RoutineLibraryEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutineLibraryEntryCopyWith<$Res> {
  factory $RoutineLibraryEntryCopyWith(
          RoutineLibraryEntry value, $Res Function(RoutineLibraryEntry) then) =
      _$RoutineLibraryEntryCopyWithImpl<$Res, RoutineLibraryEntry>;
  @useResult
  $Res call(
      {Routine routine,
      int exerciseCount,
      List<String> exercisePreview,
      String? lastPerformedAt});

  $RoutineCopyWith<$Res> get routine;
}

/// @nodoc
class _$RoutineLibraryEntryCopyWithImpl<$Res, $Val extends RoutineLibraryEntry>
    implements $RoutineLibraryEntryCopyWith<$Res> {
  _$RoutineLibraryEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? routine = null,
    Object? exerciseCount = null,
    Object? exercisePreview = null,
    Object? lastPerformedAt = freezed,
  }) {
    return _then(_value.copyWith(
      routine: null == routine
          ? _value.routine
          : routine // ignore: cast_nullable_to_non_nullable
              as Routine,
      exerciseCount: null == exerciseCount
          ? _value.exerciseCount
          : exerciseCount // ignore: cast_nullable_to_non_nullable
              as int,
      exercisePreview: null == exercisePreview
          ? _value.exercisePreview
          : exercisePreview // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastPerformedAt: freezed == lastPerformedAt
          ? _value.lastPerformedAt
          : lastPerformedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RoutineCopyWith<$Res> get routine {
    return $RoutineCopyWith<$Res>(_value.routine, (value) {
      return _then(_value.copyWith(routine: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RoutineLibraryEntryImplCopyWith<$Res>
    implements $RoutineLibraryEntryCopyWith<$Res> {
  factory _$$RoutineLibraryEntryImplCopyWith(_$RoutineLibraryEntryImpl value,
          $Res Function(_$RoutineLibraryEntryImpl) then) =
      __$$RoutineLibraryEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Routine routine,
      int exerciseCount,
      List<String> exercisePreview,
      String? lastPerformedAt});

  @override
  $RoutineCopyWith<$Res> get routine;
}

/// @nodoc
class __$$RoutineLibraryEntryImplCopyWithImpl<$Res>
    extends _$RoutineLibraryEntryCopyWithImpl<$Res, _$RoutineLibraryEntryImpl>
    implements _$$RoutineLibraryEntryImplCopyWith<$Res> {
  __$$RoutineLibraryEntryImplCopyWithImpl(_$RoutineLibraryEntryImpl _value,
      $Res Function(_$RoutineLibraryEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? routine = null,
    Object? exerciseCount = null,
    Object? exercisePreview = null,
    Object? lastPerformedAt = freezed,
  }) {
    return _then(_$RoutineLibraryEntryImpl(
      routine: null == routine
          ? _value.routine
          : routine // ignore: cast_nullable_to_non_nullable
              as Routine,
      exerciseCount: null == exerciseCount
          ? _value.exerciseCount
          : exerciseCount // ignore: cast_nullable_to_non_nullable
              as int,
      exercisePreview: null == exercisePreview
          ? _value._exercisePreview
          : exercisePreview // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastPerformedAt: freezed == lastPerformedAt
          ? _value.lastPerformedAt
          : lastPerformedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoutineLibraryEntryImpl implements _RoutineLibraryEntry {
  const _$RoutineLibraryEntryImpl(
      {required this.routine,
      required this.exerciseCount,
      required final List<String> exercisePreview,
      this.lastPerformedAt})
      : _exercisePreview = exercisePreview;

  factory _$RoutineLibraryEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutineLibraryEntryImplFromJson(json);

  @override
  final Routine routine;
  @override
  final int exerciseCount;
  final List<String> _exercisePreview;
  @override
  List<String> get exercisePreview {
    if (_exercisePreview is EqualUnmodifiableListView) return _exercisePreview;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercisePreview);
  }

  @override
  final String? lastPerformedAt;

  @override
  String toString() {
    return 'RoutineLibraryEntry(routine: $routine, exerciseCount: $exerciseCount, exercisePreview: $exercisePreview, lastPerformedAt: $lastPerformedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutineLibraryEntryImpl &&
            (identical(other.routine, routine) || other.routine == routine) &&
            (identical(other.exerciseCount, exerciseCount) ||
                other.exerciseCount == exerciseCount) &&
            const DeepCollectionEquality()
                .equals(other._exercisePreview, _exercisePreview) &&
            (identical(other.lastPerformedAt, lastPerformedAt) ||
                other.lastPerformedAt == lastPerformedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, routine, exerciseCount,
      const DeepCollectionEquality().hash(_exercisePreview), lastPerformedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutineLibraryEntryImplCopyWith<_$RoutineLibraryEntryImpl> get copyWith =>
      __$$RoutineLibraryEntryImplCopyWithImpl<_$RoutineLibraryEntryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutineLibraryEntryImplToJson(
      this,
    );
  }
}

abstract class _RoutineLibraryEntry implements RoutineLibraryEntry {
  const factory _RoutineLibraryEntry(
      {required final Routine routine,
      required final int exerciseCount,
      required final List<String> exercisePreview,
      final String? lastPerformedAt}) = _$RoutineLibraryEntryImpl;

  factory _RoutineLibraryEntry.fromJson(Map<String, dynamic> json) =
      _$RoutineLibraryEntryImpl.fromJson;

  @override
  Routine get routine;
  @override
  int get exerciseCount;
  @override
  List<String> get exercisePreview;
  @override
  String? get lastPerformedAt;
  @override
  @JsonKey(ignore: true)
  _$$RoutineLibraryEntryImplCopyWith<_$RoutineLibraryEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoutineLibrary _$RoutineLibraryFromJson(Map<String, dynamic> json) {
  return _RoutineLibrary.fromJson(json);
}

/// @nodoc
mixin _$RoutineLibrary {
  Program get program => throw _privateConstructorUsedError;
  List<RoutineLibraryEntry> get entries => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoutineLibraryCopyWith<RoutineLibrary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutineLibraryCopyWith<$Res> {
  factory $RoutineLibraryCopyWith(
          RoutineLibrary value, $Res Function(RoutineLibrary) then) =
      _$RoutineLibraryCopyWithImpl<$Res, RoutineLibrary>;
  @useResult
  $Res call({Program program, List<RoutineLibraryEntry> entries});

  $ProgramCopyWith<$Res> get program;
}

/// @nodoc
class _$RoutineLibraryCopyWithImpl<$Res, $Val extends RoutineLibrary>
    implements $RoutineLibraryCopyWith<$Res> {
  _$RoutineLibraryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? program = null,
    Object? entries = null,
  }) {
    return _then(_value.copyWith(
      program: null == program
          ? _value.program
          : program // ignore: cast_nullable_to_non_nullable
              as Program,
      entries: null == entries
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<RoutineLibraryEntry>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProgramCopyWith<$Res> get program {
    return $ProgramCopyWith<$Res>(_value.program, (value) {
      return _then(_value.copyWith(program: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RoutineLibraryImplCopyWith<$Res>
    implements $RoutineLibraryCopyWith<$Res> {
  factory _$$RoutineLibraryImplCopyWith(_$RoutineLibraryImpl value,
          $Res Function(_$RoutineLibraryImpl) then) =
      __$$RoutineLibraryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Program program, List<RoutineLibraryEntry> entries});

  @override
  $ProgramCopyWith<$Res> get program;
}

/// @nodoc
class __$$RoutineLibraryImplCopyWithImpl<$Res>
    extends _$RoutineLibraryCopyWithImpl<$Res, _$RoutineLibraryImpl>
    implements _$$RoutineLibraryImplCopyWith<$Res> {
  __$$RoutineLibraryImplCopyWithImpl(
      _$RoutineLibraryImpl _value, $Res Function(_$RoutineLibraryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? program = null,
    Object? entries = null,
  }) {
    return _then(_$RoutineLibraryImpl(
      program: null == program
          ? _value.program
          : program // ignore: cast_nullable_to_non_nullable
              as Program,
      entries: null == entries
          ? _value._entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<RoutineLibraryEntry>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoutineLibraryImpl implements _RoutineLibrary {
  const _$RoutineLibraryImpl(
      {required this.program, required final List<RoutineLibraryEntry> entries})
      : _entries = entries;

  factory _$RoutineLibraryImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutineLibraryImplFromJson(json);

  @override
  final Program program;
  final List<RoutineLibraryEntry> _entries;
  @override
  List<RoutineLibraryEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  String toString() {
    return 'RoutineLibrary(program: $program, entries: $entries)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutineLibraryImpl &&
            (identical(other.program, program) || other.program == program) &&
            const DeepCollectionEquality().equals(other._entries, _entries));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, program, const DeepCollectionEquality().hash(_entries));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutineLibraryImplCopyWith<_$RoutineLibraryImpl> get copyWith =>
      __$$RoutineLibraryImplCopyWithImpl<_$RoutineLibraryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutineLibraryImplToJson(
      this,
    );
  }
}

abstract class _RoutineLibrary implements RoutineLibrary {
  const factory _RoutineLibrary(
      {required final Program program,
      required final List<RoutineLibraryEntry> entries}) = _$RoutineLibraryImpl;

  factory _RoutineLibrary.fromJson(Map<String, dynamic> json) =
      _$RoutineLibraryImpl.fromJson;

  @override
  Program get program;
  @override
  List<RoutineLibraryEntry> get entries;
  @override
  @JsonKey(ignore: true)
  _$$RoutineLibraryImplCopyWith<_$RoutineLibraryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
