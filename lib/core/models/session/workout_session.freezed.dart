// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TodaysWorkoutItem _$TodaysWorkoutItemFromJson(Map<String, dynamic> json) {
  return _TodaysWorkoutItem.fromJson(json);
}

/// @nodoc
mixin _$TodaysWorkoutItem {
  String get id => throw _privateConstructorUsedError;
  String get exerciseId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get muscleGroup => throw _privateConstructorUsedError;
  int get targetSets => throw _privateConstructorUsedError;
  int get targetRepsMin => throw _privateConstructorUsedError;
  int get targetRepsMax => throw _privateConstructorUsedError;
  double get targetWeight => throw _privateConstructorUsedError;
  double? get suggestionWeight => throw _privateConstructorUsedError;
  int? get suggestionRepsMin => throw _privateConstructorUsedError;
  int? get suggestionRepsMax => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _changeTypeFromJson, toJson: _changeTypeToJson)
  ChangeType? get suggestionChangeType => throw _privateConstructorUsedError;
  String? get suggestionReasoning => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TodaysWorkoutItemCopyWith<TodaysWorkoutItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodaysWorkoutItemCopyWith<$Res> {
  factory $TodaysWorkoutItemCopyWith(
          TodaysWorkoutItem value, $Res Function(TodaysWorkoutItem) then) =
      _$TodaysWorkoutItemCopyWithImpl<$Res, TodaysWorkoutItem>;
  @useResult
  $Res call(
      {String id,
      String exerciseId,
      String name,
      String muscleGroup,
      int targetSets,
      int targetRepsMin,
      int targetRepsMax,
      double targetWeight,
      double? suggestionWeight,
      int? suggestionRepsMin,
      int? suggestionRepsMax,
      @JsonKey(fromJson: _changeTypeFromJson, toJson: _changeTypeToJson)
      ChangeType? suggestionChangeType,
      String? suggestionReasoning});
}

/// @nodoc
class _$TodaysWorkoutItemCopyWithImpl<$Res, $Val extends TodaysWorkoutItem>
    implements $TodaysWorkoutItemCopyWith<$Res> {
  _$TodaysWorkoutItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? exerciseId = null,
    Object? name = null,
    Object? muscleGroup = null,
    Object? targetSets = null,
    Object? targetRepsMin = null,
    Object? targetRepsMax = null,
    Object? targetWeight = null,
    Object? suggestionWeight = freezed,
    Object? suggestionRepsMin = freezed,
    Object? suggestionRepsMax = freezed,
    Object? suggestionChangeType = freezed,
    Object? suggestionReasoning = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      muscleGroup: null == muscleGroup
          ? _value.muscleGroup
          : muscleGroup // ignore: cast_nullable_to_non_nullable
              as String,
      targetSets: null == targetSets
          ? _value.targetSets
          : targetSets // ignore: cast_nullable_to_non_nullable
              as int,
      targetRepsMin: null == targetRepsMin
          ? _value.targetRepsMin
          : targetRepsMin // ignore: cast_nullable_to_non_nullable
              as int,
      targetRepsMax: null == targetRepsMax
          ? _value.targetRepsMax
          : targetRepsMax // ignore: cast_nullable_to_non_nullable
              as int,
      targetWeight: null == targetWeight
          ? _value.targetWeight
          : targetWeight // ignore: cast_nullable_to_non_nullable
              as double,
      suggestionWeight: freezed == suggestionWeight
          ? _value.suggestionWeight
          : suggestionWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      suggestionRepsMin: freezed == suggestionRepsMin
          ? _value.suggestionRepsMin
          : suggestionRepsMin // ignore: cast_nullable_to_non_nullable
              as int?,
      suggestionRepsMax: freezed == suggestionRepsMax
          ? _value.suggestionRepsMax
          : suggestionRepsMax // ignore: cast_nullable_to_non_nullable
              as int?,
      suggestionChangeType: freezed == suggestionChangeType
          ? _value.suggestionChangeType
          : suggestionChangeType // ignore: cast_nullable_to_non_nullable
              as ChangeType?,
      suggestionReasoning: freezed == suggestionReasoning
          ? _value.suggestionReasoning
          : suggestionReasoning // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TodaysWorkoutItemImplCopyWith<$Res>
    implements $TodaysWorkoutItemCopyWith<$Res> {
  factory _$$TodaysWorkoutItemImplCopyWith(_$TodaysWorkoutItemImpl value,
          $Res Function(_$TodaysWorkoutItemImpl) then) =
      __$$TodaysWorkoutItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String exerciseId,
      String name,
      String muscleGroup,
      int targetSets,
      int targetRepsMin,
      int targetRepsMax,
      double targetWeight,
      double? suggestionWeight,
      int? suggestionRepsMin,
      int? suggestionRepsMax,
      @JsonKey(fromJson: _changeTypeFromJson, toJson: _changeTypeToJson)
      ChangeType? suggestionChangeType,
      String? suggestionReasoning});
}

/// @nodoc
class __$$TodaysWorkoutItemImplCopyWithImpl<$Res>
    extends _$TodaysWorkoutItemCopyWithImpl<$Res, _$TodaysWorkoutItemImpl>
    implements _$$TodaysWorkoutItemImplCopyWith<$Res> {
  __$$TodaysWorkoutItemImplCopyWithImpl(_$TodaysWorkoutItemImpl _value,
      $Res Function(_$TodaysWorkoutItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? exerciseId = null,
    Object? name = null,
    Object? muscleGroup = null,
    Object? targetSets = null,
    Object? targetRepsMin = null,
    Object? targetRepsMax = null,
    Object? targetWeight = null,
    Object? suggestionWeight = freezed,
    Object? suggestionRepsMin = freezed,
    Object? suggestionRepsMax = freezed,
    Object? suggestionChangeType = freezed,
    Object? suggestionReasoning = freezed,
  }) {
    return _then(_$TodaysWorkoutItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      muscleGroup: null == muscleGroup
          ? _value.muscleGroup
          : muscleGroup // ignore: cast_nullable_to_non_nullable
              as String,
      targetSets: null == targetSets
          ? _value.targetSets
          : targetSets // ignore: cast_nullable_to_non_nullable
              as int,
      targetRepsMin: null == targetRepsMin
          ? _value.targetRepsMin
          : targetRepsMin // ignore: cast_nullable_to_non_nullable
              as int,
      targetRepsMax: null == targetRepsMax
          ? _value.targetRepsMax
          : targetRepsMax // ignore: cast_nullable_to_non_nullable
              as int,
      targetWeight: null == targetWeight
          ? _value.targetWeight
          : targetWeight // ignore: cast_nullable_to_non_nullable
              as double,
      suggestionWeight: freezed == suggestionWeight
          ? _value.suggestionWeight
          : suggestionWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      suggestionRepsMin: freezed == suggestionRepsMin
          ? _value.suggestionRepsMin
          : suggestionRepsMin // ignore: cast_nullable_to_non_nullable
              as int?,
      suggestionRepsMax: freezed == suggestionRepsMax
          ? _value.suggestionRepsMax
          : suggestionRepsMax // ignore: cast_nullable_to_non_nullable
              as int?,
      suggestionChangeType: freezed == suggestionChangeType
          ? _value.suggestionChangeType
          : suggestionChangeType // ignore: cast_nullable_to_non_nullable
              as ChangeType?,
      suggestionReasoning: freezed == suggestionReasoning
          ? _value.suggestionReasoning
          : suggestionReasoning // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TodaysWorkoutItemImpl implements _TodaysWorkoutItem {
  const _$TodaysWorkoutItemImpl(
      {required this.id,
      required this.exerciseId,
      required this.name,
      required this.muscleGroup,
      required this.targetSets,
      required this.targetRepsMin,
      required this.targetRepsMax,
      required this.targetWeight,
      required this.suggestionWeight,
      this.suggestionRepsMin,
      this.suggestionRepsMax,
      @JsonKey(fromJson: _changeTypeFromJson, toJson: _changeTypeToJson)
      this.suggestionChangeType,
      this.suggestionReasoning});

  factory _$TodaysWorkoutItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$TodaysWorkoutItemImplFromJson(json);

  @override
  final String id;
  @override
  final String exerciseId;
  @override
  final String name;
  @override
  final String muscleGroup;
  @override
  final int targetSets;
  @override
  final int targetRepsMin;
  @override
  final int targetRepsMax;
  @override
  final double targetWeight;
  @override
  final double? suggestionWeight;
  @override
  final int? suggestionRepsMin;
  @override
  final int? suggestionRepsMax;
  @override
  @JsonKey(fromJson: _changeTypeFromJson, toJson: _changeTypeToJson)
  final ChangeType? suggestionChangeType;
  @override
  final String? suggestionReasoning;

  @override
  String toString() {
    return 'TodaysWorkoutItem(id: $id, exerciseId: $exerciseId, name: $name, muscleGroup: $muscleGroup, targetSets: $targetSets, targetRepsMin: $targetRepsMin, targetRepsMax: $targetRepsMax, targetWeight: $targetWeight, suggestionWeight: $suggestionWeight, suggestionRepsMin: $suggestionRepsMin, suggestionRepsMax: $suggestionRepsMax, suggestionChangeType: $suggestionChangeType, suggestionReasoning: $suggestionReasoning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodaysWorkoutItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.muscleGroup, muscleGroup) ||
                other.muscleGroup == muscleGroup) &&
            (identical(other.targetSets, targetSets) ||
                other.targetSets == targetSets) &&
            (identical(other.targetRepsMin, targetRepsMin) ||
                other.targetRepsMin == targetRepsMin) &&
            (identical(other.targetRepsMax, targetRepsMax) ||
                other.targetRepsMax == targetRepsMax) &&
            (identical(other.targetWeight, targetWeight) ||
                other.targetWeight == targetWeight) &&
            (identical(other.suggestionWeight, suggestionWeight) ||
                other.suggestionWeight == suggestionWeight) &&
            (identical(other.suggestionRepsMin, suggestionRepsMin) ||
                other.suggestionRepsMin == suggestionRepsMin) &&
            (identical(other.suggestionRepsMax, suggestionRepsMax) ||
                other.suggestionRepsMax == suggestionRepsMax) &&
            (identical(other.suggestionChangeType, suggestionChangeType) ||
                other.suggestionChangeType == suggestionChangeType) &&
            (identical(other.suggestionReasoning, suggestionReasoning) ||
                other.suggestionReasoning == suggestionReasoning));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      exerciseId,
      name,
      muscleGroup,
      targetSets,
      targetRepsMin,
      targetRepsMax,
      targetWeight,
      suggestionWeight,
      suggestionRepsMin,
      suggestionRepsMax,
      suggestionChangeType,
      suggestionReasoning);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TodaysWorkoutItemImplCopyWith<_$TodaysWorkoutItemImpl> get copyWith =>
      __$$TodaysWorkoutItemImplCopyWithImpl<_$TodaysWorkoutItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TodaysWorkoutItemImplToJson(
      this,
    );
  }
}

abstract class _TodaysWorkoutItem implements TodaysWorkoutItem {
  const factory _TodaysWorkoutItem(
      {required final String id,
      required final String exerciseId,
      required final String name,
      required final String muscleGroup,
      required final int targetSets,
      required final int targetRepsMin,
      required final int targetRepsMax,
      required final double targetWeight,
      required final double? suggestionWeight,
      final int? suggestionRepsMin,
      final int? suggestionRepsMax,
      @JsonKey(fromJson: _changeTypeFromJson, toJson: _changeTypeToJson)
      final ChangeType? suggestionChangeType,
      final String? suggestionReasoning}) = _$TodaysWorkoutItemImpl;

  factory _TodaysWorkoutItem.fromJson(Map<String, dynamic> json) =
      _$TodaysWorkoutItemImpl.fromJson;

  @override
  String get id;
  @override
  String get exerciseId;
  @override
  String get name;
  @override
  String get muscleGroup;
  @override
  int get targetSets;
  @override
  int get targetRepsMin;
  @override
  int get targetRepsMax;
  @override
  double get targetWeight;
  @override
  double? get suggestionWeight;
  @override
  int? get suggestionRepsMin;
  @override
  int? get suggestionRepsMax;
  @override
  @JsonKey(fromJson: _changeTypeFromJson, toJson: _changeTypeToJson)
  ChangeType? get suggestionChangeType;
  @override
  String? get suggestionReasoning;
  @override
  @JsonKey(ignore: true)
  _$$TodaysWorkoutItemImplCopyWith<_$TodaysWorkoutItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TodaysWorkout _$TodaysWorkoutFromJson(Map<String, dynamic> json) {
  return _TodaysWorkout.fromJson(json);
}

/// @nodoc
mixin _$TodaysWorkout {
  @JsonKey(fromJson: _routineFromJson, toJson: _routineToJson)
  Routine get routine => throw _privateConstructorUsedError;
  List<TodaysWorkoutItem> get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TodaysWorkoutCopyWith<TodaysWorkout> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodaysWorkoutCopyWith<$Res> {
  factory $TodaysWorkoutCopyWith(
          TodaysWorkout value, $Res Function(TodaysWorkout) then) =
      _$TodaysWorkoutCopyWithImpl<$Res, TodaysWorkout>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _routineFromJson, toJson: _routineToJson)
      Routine routine,
      List<TodaysWorkoutItem> items});

  $RoutineCopyWith<$Res> get routine;
}

/// @nodoc
class _$TodaysWorkoutCopyWithImpl<$Res, $Val extends TodaysWorkout>
    implements $TodaysWorkoutCopyWith<$Res> {
  _$TodaysWorkoutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? routine = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      routine: null == routine
          ? _value.routine
          : routine // ignore: cast_nullable_to_non_nullable
              as Routine,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TodaysWorkoutItem>,
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
abstract class _$$TodaysWorkoutImplCopyWith<$Res>
    implements $TodaysWorkoutCopyWith<$Res> {
  factory _$$TodaysWorkoutImplCopyWith(
          _$TodaysWorkoutImpl value, $Res Function(_$TodaysWorkoutImpl) then) =
      __$$TodaysWorkoutImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _routineFromJson, toJson: _routineToJson)
      Routine routine,
      List<TodaysWorkoutItem> items});

  @override
  $RoutineCopyWith<$Res> get routine;
}

/// @nodoc
class __$$TodaysWorkoutImplCopyWithImpl<$Res>
    extends _$TodaysWorkoutCopyWithImpl<$Res, _$TodaysWorkoutImpl>
    implements _$$TodaysWorkoutImplCopyWith<$Res> {
  __$$TodaysWorkoutImplCopyWithImpl(
      _$TodaysWorkoutImpl _value, $Res Function(_$TodaysWorkoutImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? routine = null,
    Object? items = null,
  }) {
    return _then(_$TodaysWorkoutImpl(
      routine: null == routine
          ? _value.routine
          : routine // ignore: cast_nullable_to_non_nullable
              as Routine,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TodaysWorkoutItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TodaysWorkoutImpl implements _TodaysWorkout {
  const _$TodaysWorkoutImpl(
      {@JsonKey(fromJson: _routineFromJson, toJson: _routineToJson)
      required this.routine,
      required final List<TodaysWorkoutItem> items})
      : _items = items;

  factory _$TodaysWorkoutImpl.fromJson(Map<String, dynamic> json) =>
      _$$TodaysWorkoutImplFromJson(json);

  @override
  @JsonKey(fromJson: _routineFromJson, toJson: _routineToJson)
  final Routine routine;
  final List<TodaysWorkoutItem> _items;
  @override
  List<TodaysWorkoutItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'TodaysWorkout(routine: $routine, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodaysWorkoutImpl &&
            (identical(other.routine, routine) || other.routine == routine) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, routine, const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TodaysWorkoutImplCopyWith<_$TodaysWorkoutImpl> get copyWith =>
      __$$TodaysWorkoutImplCopyWithImpl<_$TodaysWorkoutImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TodaysWorkoutImplToJson(
      this,
    );
  }
}

abstract class _TodaysWorkout implements TodaysWorkout {
  const factory _TodaysWorkout(
      {@JsonKey(fromJson: _routineFromJson, toJson: _routineToJson)
      required final Routine routine,
      required final List<TodaysWorkoutItem> items}) = _$TodaysWorkoutImpl;

  factory _TodaysWorkout.fromJson(Map<String, dynamic> json) =
      _$TodaysWorkoutImpl.fromJson;

  @override
  @JsonKey(fromJson: _routineFromJson, toJson: _routineToJson)
  Routine get routine;
  @override
  List<TodaysWorkoutItem> get items;
  @override
  @JsonKey(ignore: true)
  _$$TodaysWorkoutImplCopyWith<_$TodaysWorkoutImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkoutSession _$WorkoutSessionFromJson(Map<String, dynamic> json) {
  return _WorkoutSession.fromJson(json);
}

/// @nodoc
mixin _$WorkoutSession {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get routineId => throw _privateConstructorUsedError;
  String get startedAt => throw _privateConstructorUsedError;
  String? get completedAt => throw _privateConstructorUsedError;
  String get mode => throw _privateConstructorUsedError;
  String? get quickWorkoutName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkoutSessionCopyWith<WorkoutSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutSessionCopyWith<$Res> {
  factory $WorkoutSessionCopyWith(
          WorkoutSession value, $Res Function(WorkoutSession) then) =
      _$WorkoutSessionCopyWithImpl<$Res, WorkoutSession>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String? routineId,
      String startedAt,
      String? completedAt,
      String mode,
      String? quickWorkoutName});
}

/// @nodoc
class _$WorkoutSessionCopyWithImpl<$Res, $Val extends WorkoutSession>
    implements $WorkoutSessionCopyWith<$Res> {
  _$WorkoutSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? routineId = freezed,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? mode = null,
    Object? quickWorkoutName = freezed,
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
      routineId: freezed == routineId
          ? _value.routineId
          : routineId // ignore: cast_nullable_to_non_nullable
              as String?,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String,
      quickWorkoutName: freezed == quickWorkoutName
          ? _value.quickWorkoutName
          : quickWorkoutName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutSessionImplCopyWith<$Res>
    implements $WorkoutSessionCopyWith<$Res> {
  factory _$$WorkoutSessionImplCopyWith(_$WorkoutSessionImpl value,
          $Res Function(_$WorkoutSessionImpl) then) =
      __$$WorkoutSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String? routineId,
      String startedAt,
      String? completedAt,
      String mode,
      String? quickWorkoutName});
}

/// @nodoc
class __$$WorkoutSessionImplCopyWithImpl<$Res>
    extends _$WorkoutSessionCopyWithImpl<$Res, _$WorkoutSessionImpl>
    implements _$$WorkoutSessionImplCopyWith<$Res> {
  __$$WorkoutSessionImplCopyWithImpl(
      _$WorkoutSessionImpl _value, $Res Function(_$WorkoutSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? routineId = freezed,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? mode = null,
    Object? quickWorkoutName = freezed,
  }) {
    return _then(_$WorkoutSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      routineId: freezed == routineId
          ? _value.routineId
          : routineId // ignore: cast_nullable_to_non_nullable
              as String?,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String,
      quickWorkoutName: freezed == quickWorkoutName
          ? _value.quickWorkoutName
          : quickWorkoutName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutSessionImpl implements _WorkoutSession {
  const _$WorkoutSessionImpl(
      {required this.id,
      required this.userId,
      this.routineId,
      required this.startedAt,
      this.completedAt,
      required this.mode,
      this.quickWorkoutName});

  factory _$WorkoutSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? routineId;
  @override
  final String startedAt;
  @override
  final String? completedAt;
  @override
  final String mode;
  @override
  final String? quickWorkoutName;

  @override
  String toString() {
    return 'WorkoutSession(id: $id, userId: $userId, routineId: $routineId, startedAt: $startedAt, completedAt: $completedAt, mode: $mode, quickWorkoutName: $quickWorkoutName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.routineId, routineId) ||
                other.routineId == routineId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.quickWorkoutName, quickWorkoutName) ||
                other.quickWorkoutName == quickWorkoutName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, routineId, startedAt,
      completedAt, mode, quickWorkoutName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutSessionImplCopyWith<_$WorkoutSessionImpl> get copyWith =>
      __$$WorkoutSessionImplCopyWithImpl<_$WorkoutSessionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutSessionImplToJson(
      this,
    );
  }
}

abstract class _WorkoutSession implements WorkoutSession {
  const factory _WorkoutSession(
      {required final String id,
      required final String userId,
      final String? routineId,
      required final String startedAt,
      final String? completedAt,
      required final String mode,
      final String? quickWorkoutName}) = _$WorkoutSessionImpl;

  factory _WorkoutSession.fromJson(Map<String, dynamic> json) =
      _$WorkoutSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get routineId;
  @override
  String get startedAt;
  @override
  String? get completedAt;
  @override
  String get mode;
  @override
  String? get quickWorkoutName;
  @override
  @JsonKey(ignore: true)
  _$$WorkoutSessionImplCopyWith<_$WorkoutSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SetEntry _$SetEntryFromJson(Map<String, dynamic> json) {
  return _SetEntry.fromJson(json);
}

/// @nodoc
mixin _$SetEntry {
  int get setIndex => throw _privateConstructorUsedError;
  int get reps => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;
  double? get rpe => throw _privateConstructorUsedError;
  bool? get isWarmup => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SetEntryCopyWith<SetEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetEntryCopyWith<$Res> {
  factory $SetEntryCopyWith(SetEntry value, $Res Function(SetEntry) then) =
      _$SetEntryCopyWithImpl<$Res, SetEntry>;
  @useResult
  $Res call(
      {int setIndex,
      int reps,
      double weight,
      double? rpe,
      bool? isWarmup,
      String? note});
}

/// @nodoc
class _$SetEntryCopyWithImpl<$Res, $Val extends SetEntry>
    implements $SetEntryCopyWith<$Res> {
  _$SetEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? setIndex = null,
    Object? reps = null,
    Object? weight = null,
    Object? rpe = freezed,
    Object? isWarmup = freezed,
    Object? note = freezed,
  }) {
    return _then(_value.copyWith(
      setIndex: null == setIndex
          ? _value.setIndex
          : setIndex // ignore: cast_nullable_to_non_nullable
              as int,
      reps: null == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as int,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      rpe: freezed == rpe
          ? _value.rpe
          : rpe // ignore: cast_nullable_to_non_nullable
              as double?,
      isWarmup: freezed == isWarmup
          ? _value.isWarmup
          : isWarmup // ignore: cast_nullable_to_non_nullable
              as bool?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SetEntryImplCopyWith<$Res>
    implements $SetEntryCopyWith<$Res> {
  factory _$$SetEntryImplCopyWith(
          _$SetEntryImpl value, $Res Function(_$SetEntryImpl) then) =
      __$$SetEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int setIndex,
      int reps,
      double weight,
      double? rpe,
      bool? isWarmup,
      String? note});
}

/// @nodoc
class __$$SetEntryImplCopyWithImpl<$Res>
    extends _$SetEntryCopyWithImpl<$Res, _$SetEntryImpl>
    implements _$$SetEntryImplCopyWith<$Res> {
  __$$SetEntryImplCopyWithImpl(
      _$SetEntryImpl _value, $Res Function(_$SetEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? setIndex = null,
    Object? reps = null,
    Object? weight = null,
    Object? rpe = freezed,
    Object? isWarmup = freezed,
    Object? note = freezed,
  }) {
    return _then(_$SetEntryImpl(
      setIndex: null == setIndex
          ? _value.setIndex
          : setIndex // ignore: cast_nullable_to_non_nullable
              as int,
      reps: null == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as int,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      rpe: freezed == rpe
          ? _value.rpe
          : rpe // ignore: cast_nullable_to_non_nullable
              as double?,
      isWarmup: freezed == isWarmup
          ? _value.isWarmup
          : isWarmup // ignore: cast_nullable_to_non_nullable
              as bool?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SetEntryImpl implements _SetEntry {
  const _$SetEntryImpl(
      {required this.setIndex,
      required this.reps,
      required this.weight,
      this.rpe,
      this.isWarmup,
      this.note});

  factory _$SetEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SetEntryImplFromJson(json);

  @override
  final int setIndex;
  @override
  final int reps;
  @override
  final double weight;
  @override
  final double? rpe;
  @override
  final bool? isWarmup;
  @override
  final String? note;

  @override
  String toString() {
    return 'SetEntry(setIndex: $setIndex, reps: $reps, weight: $weight, rpe: $rpe, isWarmup: $isWarmup, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetEntryImpl &&
            (identical(other.setIndex, setIndex) ||
                other.setIndex == setIndex) &&
            (identical(other.reps, reps) || other.reps == reps) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.rpe, rpe) || other.rpe == rpe) &&
            (identical(other.isWarmup, isWarmup) ||
                other.isWarmup == isWarmup) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, setIndex, reps, weight, rpe, isWarmup, note);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SetEntryImplCopyWith<_$SetEntryImpl> get copyWith =>
      __$$SetEntryImplCopyWithImpl<_$SetEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SetEntryImplToJson(
      this,
    );
  }
}

abstract class _SetEntry implements SetEntry {
  const factory _SetEntry(
      {required final int setIndex,
      required final int reps,
      required final double weight,
      final double? rpe,
      final bool? isWarmup,
      final String? note}) = _$SetEntryImpl;

  factory _SetEntry.fromJson(Map<String, dynamic> json) =
      _$SetEntryImpl.fromJson;

  @override
  int get setIndex;
  @override
  int get reps;
  @override
  double get weight;
  @override
  double? get rpe;
  @override
  bool? get isWarmup;
  @override
  String? get note;
  @override
  @JsonKey(ignore: true)
  _$$SetEntryImplCopyWith<_$SetEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SetDraft _$SetDraftFromJson(Map<String, dynamic> json) {
  return _SetDraft.fromJson(json);
}

/// @nodoc
mixin _$SetDraft {
  int get setIndex => throw _privateConstructorUsedError;
  int get reps => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;
  double? get rpe => throw _privateConstructorUsedError;
  bool get isWarmup => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SetDraftCopyWith<SetDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetDraftCopyWith<$Res> {
  factory $SetDraftCopyWith(SetDraft value, $Res Function(SetDraft) then) =
      _$SetDraftCopyWithImpl<$Res, SetDraft>;
  @useResult
  $Res call(
      {int setIndex, int reps, double weight, double? rpe, bool isWarmup});
}

/// @nodoc
class _$SetDraftCopyWithImpl<$Res, $Val extends SetDraft>
    implements $SetDraftCopyWith<$Res> {
  _$SetDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? setIndex = null,
    Object? reps = null,
    Object? weight = null,
    Object? rpe = freezed,
    Object? isWarmup = null,
  }) {
    return _then(_value.copyWith(
      setIndex: null == setIndex
          ? _value.setIndex
          : setIndex // ignore: cast_nullable_to_non_nullable
              as int,
      reps: null == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as int,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      rpe: freezed == rpe
          ? _value.rpe
          : rpe // ignore: cast_nullable_to_non_nullable
              as double?,
      isWarmup: null == isWarmup
          ? _value.isWarmup
          : isWarmup // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SetDraftImplCopyWith<$Res>
    implements $SetDraftCopyWith<$Res> {
  factory _$$SetDraftImplCopyWith(
          _$SetDraftImpl value, $Res Function(_$SetDraftImpl) then) =
      __$$SetDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int setIndex, int reps, double weight, double? rpe, bool isWarmup});
}

/// @nodoc
class __$$SetDraftImplCopyWithImpl<$Res>
    extends _$SetDraftCopyWithImpl<$Res, _$SetDraftImpl>
    implements _$$SetDraftImplCopyWith<$Res> {
  __$$SetDraftImplCopyWithImpl(
      _$SetDraftImpl _value, $Res Function(_$SetDraftImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? setIndex = null,
    Object? reps = null,
    Object? weight = null,
    Object? rpe = freezed,
    Object? isWarmup = null,
  }) {
    return _then(_$SetDraftImpl(
      setIndex: null == setIndex
          ? _value.setIndex
          : setIndex // ignore: cast_nullable_to_non_nullable
              as int,
      reps: null == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as int,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      rpe: freezed == rpe
          ? _value.rpe
          : rpe // ignore: cast_nullable_to_non_nullable
              as double?,
      isWarmup: null == isWarmup
          ? _value.isWarmup
          : isWarmup // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SetDraftImpl implements _SetDraft {
  const _$SetDraftImpl(
      {required this.setIndex,
      required this.reps,
      required this.weight,
      this.rpe,
      this.isWarmup = false});

  factory _$SetDraftImpl.fromJson(Map<String, dynamic> json) =>
      _$$SetDraftImplFromJson(json);

  @override
  final int setIndex;
  @override
  final int reps;
  @override
  final double weight;
  @override
  final double? rpe;
  @override
  @JsonKey()
  final bool isWarmup;

  @override
  String toString() {
    return 'SetDraft(setIndex: $setIndex, reps: $reps, weight: $weight, rpe: $rpe, isWarmup: $isWarmup)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetDraftImpl &&
            (identical(other.setIndex, setIndex) ||
                other.setIndex == setIndex) &&
            (identical(other.reps, reps) || other.reps == reps) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.rpe, rpe) || other.rpe == rpe) &&
            (identical(other.isWarmup, isWarmup) ||
                other.isWarmup == isWarmup));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, setIndex, reps, weight, rpe, isWarmup);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SetDraftImplCopyWith<_$SetDraftImpl> get copyWith =>
      __$$SetDraftImplCopyWithImpl<_$SetDraftImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SetDraftImplToJson(
      this,
    );
  }
}

abstract class _SetDraft implements SetDraft {
  const factory _SetDraft(
      {required final int setIndex,
      required final int reps,
      required final double weight,
      final double? rpe,
      final bool isWarmup}) = _$SetDraftImpl;

  factory _SetDraft.fromJson(Map<String, dynamic> json) =
      _$SetDraftImpl.fromJson;

  @override
  int get setIndex;
  @override
  int get reps;
  @override
  double get weight;
  @override
  double? get rpe;
  @override
  bool get isWarmup;
  @override
  @JsonKey(ignore: true)
  _$$SetDraftImplCopyWith<_$SetDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IncompleteSession _$IncompleteSessionFromJson(Map<String, dynamic> json) {
  return _IncompleteSession.fromJson(json);
}

/// @nodoc
mixin _$IncompleteSession {
  String get sessionId => throw _privateConstructorUsedError;
  String get routineId => throw _privateConstructorUsedError;
  String get startedAt => throw _privateConstructorUsedError;
  List<String> get loggedExerciseIds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $IncompleteSessionCopyWith<IncompleteSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncompleteSessionCopyWith<$Res> {
  factory $IncompleteSessionCopyWith(
          IncompleteSession value, $Res Function(IncompleteSession) then) =
      _$IncompleteSessionCopyWithImpl<$Res, IncompleteSession>;
  @useResult
  $Res call(
      {String sessionId,
      String routineId,
      String startedAt,
      List<String> loggedExerciseIds});
}

/// @nodoc
class _$IncompleteSessionCopyWithImpl<$Res, $Val extends IncompleteSession>
    implements $IncompleteSessionCopyWith<$Res> {
  _$IncompleteSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? routineId = null,
    Object? startedAt = null,
    Object? loggedExerciseIds = null,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      routineId: null == routineId
          ? _value.routineId
          : routineId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String,
      loggedExerciseIds: null == loggedExerciseIds
          ? _value.loggedExerciseIds
          : loggedExerciseIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncompleteSessionImplCopyWith<$Res>
    implements $IncompleteSessionCopyWith<$Res> {
  factory _$$IncompleteSessionImplCopyWith(_$IncompleteSessionImpl value,
          $Res Function(_$IncompleteSessionImpl) then) =
      __$$IncompleteSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      String routineId,
      String startedAt,
      List<String> loggedExerciseIds});
}

/// @nodoc
class __$$IncompleteSessionImplCopyWithImpl<$Res>
    extends _$IncompleteSessionCopyWithImpl<$Res, _$IncompleteSessionImpl>
    implements _$$IncompleteSessionImplCopyWith<$Res> {
  __$$IncompleteSessionImplCopyWithImpl(_$IncompleteSessionImpl _value,
      $Res Function(_$IncompleteSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? routineId = null,
    Object? startedAt = null,
    Object? loggedExerciseIds = null,
  }) {
    return _then(_$IncompleteSessionImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      routineId: null == routineId
          ? _value.routineId
          : routineId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String,
      loggedExerciseIds: null == loggedExerciseIds
          ? _value._loggedExerciseIds
          : loggedExerciseIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IncompleteSessionImpl implements _IncompleteSession {
  const _$IncompleteSessionImpl(
      {required this.sessionId,
      required this.routineId,
      required this.startedAt,
      required final List<String> loggedExerciseIds})
      : _loggedExerciseIds = loggedExerciseIds;

  factory _$IncompleteSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncompleteSessionImplFromJson(json);

  @override
  final String sessionId;
  @override
  final String routineId;
  @override
  final String startedAt;
  final List<String> _loggedExerciseIds;
  @override
  List<String> get loggedExerciseIds {
    if (_loggedExerciseIds is EqualUnmodifiableListView)
      return _loggedExerciseIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_loggedExerciseIds);
  }

  @override
  String toString() {
    return 'IncompleteSession(sessionId: $sessionId, routineId: $routineId, startedAt: $startedAt, loggedExerciseIds: $loggedExerciseIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncompleteSessionImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.routineId, routineId) ||
                other.routineId == routineId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            const DeepCollectionEquality()
                .equals(other._loggedExerciseIds, _loggedExerciseIds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, sessionId, routineId, startedAt,
      const DeepCollectionEquality().hash(_loggedExerciseIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IncompleteSessionImplCopyWith<_$IncompleteSessionImpl> get copyWith =>
      __$$IncompleteSessionImplCopyWithImpl<_$IncompleteSessionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IncompleteSessionImplToJson(
      this,
    );
  }
}

abstract class _IncompleteSession implements IncompleteSession {
  const factory _IncompleteSession(
      {required final String sessionId,
      required final String routineId,
      required final String startedAt,
      required final List<String> loggedExerciseIds}) = _$IncompleteSessionImpl;

  factory _IncompleteSession.fromJson(Map<String, dynamic> json) =
      _$IncompleteSessionImpl.fromJson;

  @override
  String get sessionId;
  @override
  String get routineId;
  @override
  String get startedAt;
  @override
  List<String> get loggedExerciseIds;
  @override
  @JsonKey(ignore: true)
  _$$IncompleteSessionImplCopyWith<_$IncompleteSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuickSession _$QuickSessionFromJson(Map<String, dynamic> json) {
  return _QuickSession.fromJson(json);
}

/// @nodoc
mixin _$QuickSession {
  String get sessionId => throw _privateConstructorUsedError;
  String get startedAt => throw _privateConstructorUsedError;
  List<String> get loggedExerciseIds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuickSessionCopyWith<QuickSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuickSessionCopyWith<$Res> {
  factory $QuickSessionCopyWith(
          QuickSession value, $Res Function(QuickSession) then) =
      _$QuickSessionCopyWithImpl<$Res, QuickSession>;
  @useResult
  $Res call(
      {String sessionId, String startedAt, List<String> loggedExerciseIds});
}

/// @nodoc
class _$QuickSessionCopyWithImpl<$Res, $Val extends QuickSession>
    implements $QuickSessionCopyWith<$Res> {
  _$QuickSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? startedAt = null,
    Object? loggedExerciseIds = null,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String,
      loggedExerciseIds: null == loggedExerciseIds
          ? _value.loggedExerciseIds
          : loggedExerciseIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuickSessionImplCopyWith<$Res>
    implements $QuickSessionCopyWith<$Res> {
  factory _$$QuickSessionImplCopyWith(
          _$QuickSessionImpl value, $Res Function(_$QuickSessionImpl) then) =
      __$$QuickSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId, String startedAt, List<String> loggedExerciseIds});
}

/// @nodoc
class __$$QuickSessionImplCopyWithImpl<$Res>
    extends _$QuickSessionCopyWithImpl<$Res, _$QuickSessionImpl>
    implements _$$QuickSessionImplCopyWith<$Res> {
  __$$QuickSessionImplCopyWithImpl(
      _$QuickSessionImpl _value, $Res Function(_$QuickSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? startedAt = null,
    Object? loggedExerciseIds = null,
  }) {
    return _then(_$QuickSessionImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String,
      loggedExerciseIds: null == loggedExerciseIds
          ? _value._loggedExerciseIds
          : loggedExerciseIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuickSessionImpl implements _QuickSession {
  const _$QuickSessionImpl(
      {required this.sessionId,
      required this.startedAt,
      required final List<String> loggedExerciseIds})
      : _loggedExerciseIds = loggedExerciseIds;

  factory _$QuickSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuickSessionImplFromJson(json);

  @override
  final String sessionId;
  @override
  final String startedAt;
  final List<String> _loggedExerciseIds;
  @override
  List<String> get loggedExerciseIds {
    if (_loggedExerciseIds is EqualUnmodifiableListView)
      return _loggedExerciseIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_loggedExerciseIds);
  }

  @override
  String toString() {
    return 'QuickSession(sessionId: $sessionId, startedAt: $startedAt, loggedExerciseIds: $loggedExerciseIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuickSessionImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            const DeepCollectionEquality()
                .equals(other._loggedExerciseIds, _loggedExerciseIds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, sessionId, startedAt,
      const DeepCollectionEquality().hash(_loggedExerciseIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuickSessionImplCopyWith<_$QuickSessionImpl> get copyWith =>
      __$$QuickSessionImplCopyWithImpl<_$QuickSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuickSessionImplToJson(
      this,
    );
  }
}

abstract class _QuickSession implements QuickSession {
  const factory _QuickSession(
      {required final String sessionId,
      required final String startedAt,
      required final List<String> loggedExerciseIds}) = _$QuickSessionImpl;

  factory _QuickSession.fromJson(Map<String, dynamic> json) =
      _$QuickSessionImpl.fromJson;

  @override
  String get sessionId;
  @override
  String get startedAt;
  @override
  List<String> get loggedExerciseIds;
  @override
  @JsonKey(ignore: true)
  _$$QuickSessionImplCopyWith<_$QuickSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionSetCounts _$SessionSetCountsFromJson(Map<String, dynamic> json) {
  return _SessionSetCounts.fromJson(json);
}

/// @nodoc
mixin _$SessionSetCounts {
  int get setCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SessionSetCountsCopyWith<SessionSetCounts> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionSetCountsCopyWith<$Res> {
  factory $SessionSetCountsCopyWith(
          SessionSetCounts value, $Res Function(SessionSetCounts) then) =
      _$SessionSetCountsCopyWithImpl<$Res, SessionSetCounts>;
  @useResult
  $Res call({int setCount});
}

/// @nodoc
class _$SessionSetCountsCopyWithImpl<$Res, $Val extends SessionSetCounts>
    implements $SessionSetCountsCopyWith<$Res> {
  _$SessionSetCountsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? setCount = null,
  }) {
    return _then(_value.copyWith(
      setCount: null == setCount
          ? _value.setCount
          : setCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionSetCountsImplCopyWith<$Res>
    implements $SessionSetCountsCopyWith<$Res> {
  factory _$$SessionSetCountsImplCopyWith(_$SessionSetCountsImpl value,
          $Res Function(_$SessionSetCountsImpl) then) =
      __$$SessionSetCountsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int setCount});
}

/// @nodoc
class __$$SessionSetCountsImplCopyWithImpl<$Res>
    extends _$SessionSetCountsCopyWithImpl<$Res, _$SessionSetCountsImpl>
    implements _$$SessionSetCountsImplCopyWith<$Res> {
  __$$SessionSetCountsImplCopyWithImpl(_$SessionSetCountsImpl _value,
      $Res Function(_$SessionSetCountsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? setCount = null,
  }) {
    return _then(_$SessionSetCountsImpl(
      setCount: null == setCount
          ? _value.setCount
          : setCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionSetCountsImpl implements _SessionSetCounts {
  const _$SessionSetCountsImpl({required this.setCount});

  factory _$SessionSetCountsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionSetCountsImplFromJson(json);

  @override
  final int setCount;

  @override
  String toString() {
    return 'SessionSetCounts(setCount: $setCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionSetCountsImpl &&
            (identical(other.setCount, setCount) ||
                other.setCount == setCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, setCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionSetCountsImplCopyWith<_$SessionSetCountsImpl> get copyWith =>
      __$$SessionSetCountsImplCopyWithImpl<_$SessionSetCountsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionSetCountsImplToJson(
      this,
    );
  }
}

abstract class _SessionSetCounts implements SessionSetCounts {
  const factory _SessionSetCounts({required final int setCount}) =
      _$SessionSetCountsImpl;

  factory _SessionSetCounts.fromJson(Map<String, dynamic> json) =
      _$SessionSetCountsImpl.fromJson;

  @override
  int get setCount;
  @override
  @JsonKey(ignore: true)
  _$$SessionSetCountsImplCopyWith<_$SessionSetCountsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HomeStats _$HomeStatsFromJson(Map<String, dynamic> json) {
  return _HomeStats.fromJson(json);
}

/// @nodoc
mixin _$HomeStats {
  double get volumeThisWeek => throw _privateConstructorUsedError;
  double get volumeLastWeek => throw _privateConstructorUsedError;
  int get minutesThisWeek => throw _privateConstructorUsedError;
  int get minutesLastWeek => throw _privateConstructorUsedError;
  int get setsThisWeek => throw _privateConstructorUsedError;
  int get workoutsThisWeek => throw _privateConstructorUsedError;
  int get weeklyTarget => throw _privateConstructorUsedError;
  int get streak => throw _privateConstructorUsedError;
  String? get programName => throw _privateConstructorUsedError;
  int? get programWeek => throw _privateConstructorUsedError;
  List<WeekDay> get weekDays => throw _privateConstructorUsedError;
  LastSession? get lastSession => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HomeStatsCopyWith<HomeStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStatsCopyWith<$Res> {
  factory $HomeStatsCopyWith(HomeStats value, $Res Function(HomeStats) then) =
      _$HomeStatsCopyWithImpl<$Res, HomeStats>;
  @useResult
  $Res call(
      {double volumeThisWeek,
      double volumeLastWeek,
      int minutesThisWeek,
      int minutesLastWeek,
      int setsThisWeek,
      int workoutsThisWeek,
      int weeklyTarget,
      int streak,
      String? programName,
      int? programWeek,
      List<WeekDay> weekDays,
      LastSession? lastSession});

  $LastSessionCopyWith<$Res>? get lastSession;
}

/// @nodoc
class _$HomeStatsCopyWithImpl<$Res, $Val extends HomeStats>
    implements $HomeStatsCopyWith<$Res> {
  _$HomeStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? volumeThisWeek = null,
    Object? volumeLastWeek = null,
    Object? minutesThisWeek = null,
    Object? minutesLastWeek = null,
    Object? setsThisWeek = null,
    Object? workoutsThisWeek = null,
    Object? weeklyTarget = null,
    Object? streak = null,
    Object? programName = freezed,
    Object? programWeek = freezed,
    Object? weekDays = null,
    Object? lastSession = freezed,
  }) {
    return _then(_value.copyWith(
      volumeThisWeek: null == volumeThisWeek
          ? _value.volumeThisWeek
          : volumeThisWeek // ignore: cast_nullable_to_non_nullable
              as double,
      volumeLastWeek: null == volumeLastWeek
          ? _value.volumeLastWeek
          : volumeLastWeek // ignore: cast_nullable_to_non_nullable
              as double,
      minutesThisWeek: null == minutesThisWeek
          ? _value.minutesThisWeek
          : minutesThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      minutesLastWeek: null == minutesLastWeek
          ? _value.minutesLastWeek
          : minutesLastWeek // ignore: cast_nullable_to_non_nullable
              as int,
      setsThisWeek: null == setsThisWeek
          ? _value.setsThisWeek
          : setsThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      workoutsThisWeek: null == workoutsThisWeek
          ? _value.workoutsThisWeek
          : workoutsThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyTarget: null == weeklyTarget
          ? _value.weeklyTarget
          : weeklyTarget // ignore: cast_nullable_to_non_nullable
              as int,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      programName: freezed == programName
          ? _value.programName
          : programName // ignore: cast_nullable_to_non_nullable
              as String?,
      programWeek: freezed == programWeek
          ? _value.programWeek
          : programWeek // ignore: cast_nullable_to_non_nullable
              as int?,
      weekDays: null == weekDays
          ? _value.weekDays
          : weekDays // ignore: cast_nullable_to_non_nullable
              as List<WeekDay>,
      lastSession: freezed == lastSession
          ? _value.lastSession
          : lastSession // ignore: cast_nullable_to_non_nullable
              as LastSession?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LastSessionCopyWith<$Res>? get lastSession {
    if (_value.lastSession == null) {
      return null;
    }

    return $LastSessionCopyWith<$Res>(_value.lastSession!, (value) {
      return _then(_value.copyWith(lastSession: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomeStatsImplCopyWith<$Res>
    implements $HomeStatsCopyWith<$Res> {
  factory _$$HomeStatsImplCopyWith(
          _$HomeStatsImpl value, $Res Function(_$HomeStatsImpl) then) =
      __$$HomeStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double volumeThisWeek,
      double volumeLastWeek,
      int minutesThisWeek,
      int minutesLastWeek,
      int setsThisWeek,
      int workoutsThisWeek,
      int weeklyTarget,
      int streak,
      String? programName,
      int? programWeek,
      List<WeekDay> weekDays,
      LastSession? lastSession});

  @override
  $LastSessionCopyWith<$Res>? get lastSession;
}

/// @nodoc
class __$$HomeStatsImplCopyWithImpl<$Res>
    extends _$HomeStatsCopyWithImpl<$Res, _$HomeStatsImpl>
    implements _$$HomeStatsImplCopyWith<$Res> {
  __$$HomeStatsImplCopyWithImpl(
      _$HomeStatsImpl _value, $Res Function(_$HomeStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? volumeThisWeek = null,
    Object? volumeLastWeek = null,
    Object? minutesThisWeek = null,
    Object? minutesLastWeek = null,
    Object? setsThisWeek = null,
    Object? workoutsThisWeek = null,
    Object? weeklyTarget = null,
    Object? streak = null,
    Object? programName = freezed,
    Object? programWeek = freezed,
    Object? weekDays = null,
    Object? lastSession = freezed,
  }) {
    return _then(_$HomeStatsImpl(
      volumeThisWeek: null == volumeThisWeek
          ? _value.volumeThisWeek
          : volumeThisWeek // ignore: cast_nullable_to_non_nullable
              as double,
      volumeLastWeek: null == volumeLastWeek
          ? _value.volumeLastWeek
          : volumeLastWeek // ignore: cast_nullable_to_non_nullable
              as double,
      minutesThisWeek: null == minutesThisWeek
          ? _value.minutesThisWeek
          : minutesThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      minutesLastWeek: null == minutesLastWeek
          ? _value.minutesLastWeek
          : minutesLastWeek // ignore: cast_nullable_to_non_nullable
              as int,
      setsThisWeek: null == setsThisWeek
          ? _value.setsThisWeek
          : setsThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      workoutsThisWeek: null == workoutsThisWeek
          ? _value.workoutsThisWeek
          : workoutsThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyTarget: null == weeklyTarget
          ? _value.weeklyTarget
          : weeklyTarget // ignore: cast_nullable_to_non_nullable
              as int,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      programName: freezed == programName
          ? _value.programName
          : programName // ignore: cast_nullable_to_non_nullable
              as String?,
      programWeek: freezed == programWeek
          ? _value.programWeek
          : programWeek // ignore: cast_nullable_to_non_nullable
              as int?,
      weekDays: null == weekDays
          ? _value._weekDays
          : weekDays // ignore: cast_nullable_to_non_nullable
              as List<WeekDay>,
      lastSession: freezed == lastSession
          ? _value.lastSession
          : lastSession // ignore: cast_nullable_to_non_nullable
              as LastSession?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeStatsImpl implements _HomeStats {
  const _$HomeStatsImpl(
      {required this.volumeThisWeek,
      required this.volumeLastWeek,
      required this.minutesThisWeek,
      required this.minutesLastWeek,
      required this.setsThisWeek,
      required this.workoutsThisWeek,
      required this.weeklyTarget,
      required this.streak,
      this.programName,
      this.programWeek,
      required final List<WeekDay> weekDays,
      this.lastSession})
      : _weekDays = weekDays;

  factory _$HomeStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeStatsImplFromJson(json);

  @override
  final double volumeThisWeek;
  @override
  final double volumeLastWeek;
  @override
  final int minutesThisWeek;
  @override
  final int minutesLastWeek;
  @override
  final int setsThisWeek;
  @override
  final int workoutsThisWeek;
  @override
  final int weeklyTarget;
  @override
  final int streak;
  @override
  final String? programName;
  @override
  final int? programWeek;
  final List<WeekDay> _weekDays;
  @override
  List<WeekDay> get weekDays {
    if (_weekDays is EqualUnmodifiableListView) return _weekDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weekDays);
  }

  @override
  final LastSession? lastSession;

  @override
  String toString() {
    return 'HomeStats(volumeThisWeek: $volumeThisWeek, volumeLastWeek: $volumeLastWeek, minutesThisWeek: $minutesThisWeek, minutesLastWeek: $minutesLastWeek, setsThisWeek: $setsThisWeek, workoutsThisWeek: $workoutsThisWeek, weeklyTarget: $weeklyTarget, streak: $streak, programName: $programName, programWeek: $programWeek, weekDays: $weekDays, lastSession: $lastSession)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStatsImpl &&
            (identical(other.volumeThisWeek, volumeThisWeek) ||
                other.volumeThisWeek == volumeThisWeek) &&
            (identical(other.volumeLastWeek, volumeLastWeek) ||
                other.volumeLastWeek == volumeLastWeek) &&
            (identical(other.minutesThisWeek, minutesThisWeek) ||
                other.minutesThisWeek == minutesThisWeek) &&
            (identical(other.minutesLastWeek, minutesLastWeek) ||
                other.minutesLastWeek == minutesLastWeek) &&
            (identical(other.setsThisWeek, setsThisWeek) ||
                other.setsThisWeek == setsThisWeek) &&
            (identical(other.workoutsThisWeek, workoutsThisWeek) ||
                other.workoutsThisWeek == workoutsThisWeek) &&
            (identical(other.weeklyTarget, weeklyTarget) ||
                other.weeklyTarget == weeklyTarget) &&
            (identical(other.streak, streak) || other.streak == streak) &&
            (identical(other.programName, programName) ||
                other.programName == programName) &&
            (identical(other.programWeek, programWeek) ||
                other.programWeek == programWeek) &&
            const DeepCollectionEquality().equals(other._weekDays, _weekDays) &&
            (identical(other.lastSession, lastSession) ||
                other.lastSession == lastSession));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      volumeThisWeek,
      volumeLastWeek,
      minutesThisWeek,
      minutesLastWeek,
      setsThisWeek,
      workoutsThisWeek,
      weeklyTarget,
      streak,
      programName,
      programWeek,
      const DeepCollectionEquality().hash(_weekDays),
      lastSession);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStatsImplCopyWith<_$HomeStatsImpl> get copyWith =>
      __$$HomeStatsImplCopyWithImpl<_$HomeStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeStatsImplToJson(
      this,
    );
  }
}

abstract class _HomeStats implements HomeStats {
  const factory _HomeStats(
      {required final double volumeThisWeek,
      required final double volumeLastWeek,
      required final int minutesThisWeek,
      required final int minutesLastWeek,
      required final int setsThisWeek,
      required final int workoutsThisWeek,
      required final int weeklyTarget,
      required final int streak,
      final String? programName,
      final int? programWeek,
      required final List<WeekDay> weekDays,
      final LastSession? lastSession}) = _$HomeStatsImpl;

  factory _HomeStats.fromJson(Map<String, dynamic> json) =
      _$HomeStatsImpl.fromJson;

  @override
  double get volumeThisWeek;
  @override
  double get volumeLastWeek;
  @override
  int get minutesThisWeek;
  @override
  int get minutesLastWeek;
  @override
  int get setsThisWeek;
  @override
  int get workoutsThisWeek;
  @override
  int get weeklyTarget;
  @override
  int get streak;
  @override
  String? get programName;
  @override
  int? get programWeek;
  @override
  List<WeekDay> get weekDays;
  @override
  LastSession? get lastSession;
  @override
  @JsonKey(ignore: true)
  _$$HomeStatsImplCopyWith<_$HomeStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeekDay _$WeekDayFromJson(Map<String, dynamic> json) {
  return _WeekDay.fromJson(json);
}

/// @nodoc
mixin _$WeekDay {
  String get label => throw _privateConstructorUsedError;
  String get dateKey => throw _privateConstructorUsedError;
  bool get workedOut => throw _privateConstructorUsedError;
  bool get isToday => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeekDayCopyWith<WeekDay> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeekDayCopyWith<$Res> {
  factory $WeekDayCopyWith(WeekDay value, $Res Function(WeekDay) then) =
      _$WeekDayCopyWithImpl<$Res, WeekDay>;
  @useResult
  $Res call({String label, String dateKey, bool workedOut, bool isToday});
}

/// @nodoc
class _$WeekDayCopyWithImpl<$Res, $Val extends WeekDay>
    implements $WeekDayCopyWith<$Res> {
  _$WeekDayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? dateKey = null,
    Object? workedOut = null,
    Object? isToday = null,
  }) {
    return _then(_value.copyWith(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      dateKey: null == dateKey
          ? _value.dateKey
          : dateKey // ignore: cast_nullable_to_non_nullable
              as String,
      workedOut: null == workedOut
          ? _value.workedOut
          : workedOut // ignore: cast_nullable_to_non_nullable
              as bool,
      isToday: null == isToday
          ? _value.isToday
          : isToday // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeekDayImplCopyWith<$Res> implements $WeekDayCopyWith<$Res> {
  factory _$$WeekDayImplCopyWith(
          _$WeekDayImpl value, $Res Function(_$WeekDayImpl) then) =
      __$$WeekDayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, String dateKey, bool workedOut, bool isToday});
}

/// @nodoc
class __$$WeekDayImplCopyWithImpl<$Res>
    extends _$WeekDayCopyWithImpl<$Res, _$WeekDayImpl>
    implements _$$WeekDayImplCopyWith<$Res> {
  __$$WeekDayImplCopyWithImpl(
      _$WeekDayImpl _value, $Res Function(_$WeekDayImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? dateKey = null,
    Object? workedOut = null,
    Object? isToday = null,
  }) {
    return _then(_$WeekDayImpl(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      dateKey: null == dateKey
          ? _value.dateKey
          : dateKey // ignore: cast_nullable_to_non_nullable
              as String,
      workedOut: null == workedOut
          ? _value.workedOut
          : workedOut // ignore: cast_nullable_to_non_nullable
              as bool,
      isToday: null == isToday
          ? _value.isToday
          : isToday // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeekDayImpl implements _WeekDay {
  const _$WeekDayImpl(
      {required this.label,
      required this.dateKey,
      required this.workedOut,
      required this.isToday});

  factory _$WeekDayImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeekDayImplFromJson(json);

  @override
  final String label;
  @override
  final String dateKey;
  @override
  final bool workedOut;
  @override
  final bool isToday;

  @override
  String toString() {
    return 'WeekDay(label: $label, dateKey: $dateKey, workedOut: $workedOut, isToday: $isToday)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeekDayImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.dateKey, dateKey) || other.dateKey == dateKey) &&
            (identical(other.workedOut, workedOut) ||
                other.workedOut == workedOut) &&
            (identical(other.isToday, isToday) || other.isToday == isToday));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, label, dateKey, workedOut, isToday);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeekDayImplCopyWith<_$WeekDayImpl> get copyWith =>
      __$$WeekDayImplCopyWithImpl<_$WeekDayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeekDayImplToJson(
      this,
    );
  }
}

abstract class _WeekDay implements WeekDay {
  const factory _WeekDay(
      {required final String label,
      required final String dateKey,
      required final bool workedOut,
      required final bool isToday}) = _$WeekDayImpl;

  factory _WeekDay.fromJson(Map<String, dynamic> json) = _$WeekDayImpl.fromJson;

  @override
  String get label;
  @override
  String get dateKey;
  @override
  bool get workedOut;
  @override
  bool get isToday;
  @override
  @JsonKey(ignore: true)
  _$$WeekDayImplCopyWith<_$WeekDayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LastSession _$LastSessionFromJson(Map<String, dynamic> json) {
  return _LastSession.fromJson(json);
}

/// @nodoc
mixin _$LastSession {
  int get prCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LastSessionCopyWith<LastSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LastSessionCopyWith<$Res> {
  factory $LastSessionCopyWith(
          LastSession value, $Res Function(LastSession) then) =
      _$LastSessionCopyWithImpl<$Res, LastSession>;
  @useResult
  $Res call({int prCount});
}

/// @nodoc
class _$LastSessionCopyWithImpl<$Res, $Val extends LastSession>
    implements $LastSessionCopyWith<$Res> {
  _$LastSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prCount = null,
  }) {
    return _then(_value.copyWith(
      prCount: null == prCount
          ? _value.prCount
          : prCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LastSessionImplCopyWith<$Res>
    implements $LastSessionCopyWith<$Res> {
  factory _$$LastSessionImplCopyWith(
          _$LastSessionImpl value, $Res Function(_$LastSessionImpl) then) =
      __$$LastSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int prCount});
}

/// @nodoc
class __$$LastSessionImplCopyWithImpl<$Res>
    extends _$LastSessionCopyWithImpl<$Res, _$LastSessionImpl>
    implements _$$LastSessionImplCopyWith<$Res> {
  __$$LastSessionImplCopyWithImpl(
      _$LastSessionImpl _value, $Res Function(_$LastSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prCount = null,
  }) {
    return _then(_$LastSessionImpl(
      prCount: null == prCount
          ? _value.prCount
          : prCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LastSessionImpl implements _LastSession {
  const _$LastSessionImpl({required this.prCount});

  factory _$LastSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$LastSessionImplFromJson(json);

  @override
  final int prCount;

  @override
  String toString() {
    return 'LastSession(prCount: $prCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LastSessionImpl &&
            (identical(other.prCount, prCount) || other.prCount == prCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, prCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LastSessionImplCopyWith<_$LastSessionImpl> get copyWith =>
      __$$LastSessionImplCopyWithImpl<_$LastSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LastSessionImplToJson(
      this,
    );
  }
}

abstract class _LastSession implements LastSession {
  const factory _LastSession({required final int prCount}) = _$LastSessionImpl;

  factory _LastSession.fromJson(Map<String, dynamic> json) =
      _$LastSessionImpl.fromJson;

  @override
  int get prCount;
  @override
  @JsonKey(ignore: true)
  _$$LastSessionImplCopyWith<_$LastSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SupersetGroup _$SupersetGroupFromJson(Map<String, dynamic> json) {
  return _SupersetGroup.fromJson(json);
}

/// @nodoc
mixin _$SupersetGroup {
  String get id => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  List<String> get exerciseIds => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SupersetGroupCopyWith<SupersetGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupersetGroupCopyWith<$Res> {
  factory $SupersetGroupCopyWith(
          SupersetGroup value, $Res Function(SupersetGroup) then) =
      _$SupersetGroupCopyWithImpl<$Res, SupersetGroup>;
  @useResult
  $Res call(
      {String id, String sessionId, List<String> exerciseIds, String color});
}

/// @nodoc
class _$SupersetGroupCopyWithImpl<$Res, $Val extends SupersetGroup>
    implements $SupersetGroupCopyWith<$Res> {
  _$SupersetGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? exerciseIds = null,
    Object? color = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      exerciseIds: null == exerciseIds
          ? _value.exerciseIds
          : exerciseIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SupersetGroupImplCopyWith<$Res>
    implements $SupersetGroupCopyWith<$Res> {
  factory _$$SupersetGroupImplCopyWith(
          _$SupersetGroupImpl value, $Res Function(_$SupersetGroupImpl) then) =
      __$$SupersetGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String sessionId, List<String> exerciseIds, String color});
}

/// @nodoc
class __$$SupersetGroupImplCopyWithImpl<$Res>
    extends _$SupersetGroupCopyWithImpl<$Res, _$SupersetGroupImpl>
    implements _$$SupersetGroupImplCopyWith<$Res> {
  __$$SupersetGroupImplCopyWithImpl(
      _$SupersetGroupImpl _value, $Res Function(_$SupersetGroupImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? exerciseIds = null,
    Object? color = null,
  }) {
    return _then(_$SupersetGroupImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      exerciseIds: null == exerciseIds
          ? _value._exerciseIds
          : exerciseIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SupersetGroupImpl implements _SupersetGroup {
  const _$SupersetGroupImpl(
      {required this.id,
      required this.sessionId,
      required final List<String> exerciseIds,
      required this.color})
      : _exerciseIds = exerciseIds;

  factory _$SupersetGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$SupersetGroupImplFromJson(json);

  @override
  final String id;
  @override
  final String sessionId;
  final List<String> _exerciseIds;
  @override
  List<String> get exerciseIds {
    if (_exerciseIds is EqualUnmodifiableListView) return _exerciseIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exerciseIds);
  }

  @override
  final String color;

  @override
  String toString() {
    return 'SupersetGroup(id: $id, sessionId: $sessionId, exerciseIds: $exerciseIds, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupersetGroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            const DeepCollectionEquality()
                .equals(other._exerciseIds, _exerciseIds) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, sessionId,
      const DeepCollectionEquality().hash(_exerciseIds), color);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SupersetGroupImplCopyWith<_$SupersetGroupImpl> get copyWith =>
      __$$SupersetGroupImplCopyWithImpl<_$SupersetGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SupersetGroupImplToJson(
      this,
    );
  }
}

abstract class _SupersetGroup implements SupersetGroup {
  const factory _SupersetGroup(
      {required final String id,
      required final String sessionId,
      required final List<String> exerciseIds,
      required final String color}) = _$SupersetGroupImpl;

  factory _SupersetGroup.fromJson(Map<String, dynamic> json) =
      _$SupersetGroupImpl.fromJson;

  @override
  String get id;
  @override
  String get sessionId;
  @override
  List<String> get exerciseIds;
  @override
  String get color;
  @override
  @JsonKey(ignore: true)
  _$$SupersetGroupImplCopyWith<_$SupersetGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
