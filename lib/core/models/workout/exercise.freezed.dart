// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Exercise _$ExerciseFromJson(Map<String, dynamic> json) {
  return _Exercise.fromJson(json);
}

/// @nodoc
mixin _$Exercise {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get muscleGroup => throw _privateConstructorUsedError;
  String get equipmentType => throw _privateConstructorUsedError;
  String? get videoUrl => throw _privateConstructorUsedError;
  String? get gifUrl => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<String> get primaryMuscles => throw _privateConstructorUsedError;
  List<String> get secondaryMuscles => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExerciseCopyWith<Exercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseCopyWith<$Res> {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) then) =
      _$ExerciseCopyWithImpl<$Res, Exercise>;
  @useResult
  $Res call(
      {String id,
      String name,
      String muscleGroup,
      String equipmentType,
      String? videoUrl,
      String? gifUrl,
      String? imageUrl,
      List<String> primaryMuscles,
      List<String> secondaryMuscles});
}

/// @nodoc
class _$ExerciseCopyWithImpl<$Res, $Val extends Exercise>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? muscleGroup = null,
    Object? equipmentType = null,
    Object? videoUrl = freezed,
    Object? gifUrl = freezed,
    Object? imageUrl = freezed,
    Object? primaryMuscles = null,
    Object? secondaryMuscles = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      muscleGroup: null == muscleGroup
          ? _value.muscleGroup
          : muscleGroup // ignore: cast_nullable_to_non_nullable
              as String,
      equipmentType: null == equipmentType
          ? _value.equipmentType
          : equipmentType // ignore: cast_nullable_to_non_nullable
              as String,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      gifUrl: freezed == gifUrl
          ? _value.gifUrl
          : gifUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryMuscles: null == primaryMuscles
          ? _value.primaryMuscles
          : primaryMuscles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      secondaryMuscles: null == secondaryMuscles
          ? _value.secondaryMuscles
          : secondaryMuscles // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExerciseImplCopyWith<$Res>
    implements $ExerciseCopyWith<$Res> {
  factory _$$ExerciseImplCopyWith(
          _$ExerciseImpl value, $Res Function(_$ExerciseImpl) then) =
      __$$ExerciseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String muscleGroup,
      String equipmentType,
      String? videoUrl,
      String? gifUrl,
      String? imageUrl,
      List<String> primaryMuscles,
      List<String> secondaryMuscles});
}

/// @nodoc
class __$$ExerciseImplCopyWithImpl<$Res>
    extends _$ExerciseCopyWithImpl<$Res, _$ExerciseImpl>
    implements _$$ExerciseImplCopyWith<$Res> {
  __$$ExerciseImplCopyWithImpl(
      _$ExerciseImpl _value, $Res Function(_$ExerciseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? muscleGroup = null,
    Object? equipmentType = null,
    Object? videoUrl = freezed,
    Object? gifUrl = freezed,
    Object? imageUrl = freezed,
    Object? primaryMuscles = null,
    Object? secondaryMuscles = null,
  }) {
    return _then(_$ExerciseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      muscleGroup: null == muscleGroup
          ? _value.muscleGroup
          : muscleGroup // ignore: cast_nullable_to_non_nullable
              as String,
      equipmentType: null == equipmentType
          ? _value.equipmentType
          : equipmentType // ignore: cast_nullable_to_non_nullable
              as String,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      gifUrl: freezed == gifUrl
          ? _value.gifUrl
          : gifUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryMuscles: null == primaryMuscles
          ? _value._primaryMuscles
          : primaryMuscles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      secondaryMuscles: null == secondaryMuscles
          ? _value._secondaryMuscles
          : secondaryMuscles // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExerciseImpl implements _Exercise {
  const _$ExerciseImpl(
      {required this.id,
      required this.name,
      required this.muscleGroup,
      required this.equipmentType,
      this.videoUrl,
      this.gifUrl,
      this.imageUrl,
      required final List<String> primaryMuscles,
      required final List<String> secondaryMuscles})
      : _primaryMuscles = primaryMuscles,
        _secondaryMuscles = secondaryMuscles;

  factory _$ExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String muscleGroup;
  @override
  final String equipmentType;
  @override
  final String? videoUrl;
  @override
  final String? gifUrl;
  @override
  final String? imageUrl;
  final List<String> _primaryMuscles;
  @override
  List<String> get primaryMuscles {
    if (_primaryMuscles is EqualUnmodifiableListView) return _primaryMuscles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_primaryMuscles);
  }

  final List<String> _secondaryMuscles;
  @override
  List<String> get secondaryMuscles {
    if (_secondaryMuscles is EqualUnmodifiableListView)
      return _secondaryMuscles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_secondaryMuscles);
  }

  @override
  String toString() {
    return 'Exercise(id: $id, name: $name, muscleGroup: $muscleGroup, equipmentType: $equipmentType, videoUrl: $videoUrl, gifUrl: $gifUrl, imageUrl: $imageUrl, primaryMuscles: $primaryMuscles, secondaryMuscles: $secondaryMuscles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.muscleGroup, muscleGroup) ||
                other.muscleGroup == muscleGroup) &&
            (identical(other.equipmentType, equipmentType) ||
                other.equipmentType == equipmentType) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.gifUrl, gifUrl) || other.gifUrl == gifUrl) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality()
                .equals(other._primaryMuscles, _primaryMuscles) &&
            const DeepCollectionEquality()
                .equals(other._secondaryMuscles, _secondaryMuscles));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      muscleGroup,
      equipmentType,
      videoUrl,
      gifUrl,
      imageUrl,
      const DeepCollectionEquality().hash(_primaryMuscles),
      const DeepCollectionEquality().hash(_secondaryMuscles));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseImplCopyWith<_$ExerciseImpl> get copyWith =>
      __$$ExerciseImplCopyWithImpl<_$ExerciseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseImplToJson(
      this,
    );
  }
}

abstract class _Exercise implements Exercise {
  const factory _Exercise(
      {required final String id,
      required final String name,
      required final String muscleGroup,
      required final String equipmentType,
      final String? videoUrl,
      final String? gifUrl,
      final String? imageUrl,
      required final List<String> primaryMuscles,
      required final List<String> secondaryMuscles}) = _$ExerciseImpl;

  factory _Exercise.fromJson(Map<String, dynamic> json) =
      _$ExerciseImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get muscleGroup;
  @override
  String get equipmentType;
  @override
  String? get videoUrl;
  @override
  String? get gifUrl;
  @override
  String? get imageUrl;
  @override
  List<String> get primaryMuscles;
  @override
  List<String> get secondaryMuscles;
  @override
  @JsonKey(ignore: true)
  _$$ExerciseImplCopyWith<_$ExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoutineExercise _$RoutineExerciseFromJson(Map<String, dynamic> json) {
  return _RoutineExercise.fromJson(json);
}

/// @nodoc
mixin _$RoutineExercise {
  String get id => throw _privateConstructorUsedError;
  String get routineId => throw _privateConstructorUsedError;
  String get exerciseId => throw _privateConstructorUsedError;
  int get orderIndex => throw _privateConstructorUsedError;
  int get targetSets => throw _privateConstructorUsedError;
  int get targetReps => throw _privateConstructorUsedError;
  int? get targetRepsMin => throw _privateConstructorUsedError;
  int? get targetRepsMax => throw _privateConstructorUsedError;
  double get targetWeight => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoutineExerciseCopyWith<RoutineExercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutineExerciseCopyWith<$Res> {
  factory $RoutineExerciseCopyWith(
          RoutineExercise value, $Res Function(RoutineExercise) then) =
      _$RoutineExerciseCopyWithImpl<$Res, RoutineExercise>;
  @useResult
  $Res call(
      {String id,
      String routineId,
      String exerciseId,
      int orderIndex,
      int targetSets,
      int targetReps,
      int? targetRepsMin,
      int? targetRepsMax,
      double targetWeight});
}

/// @nodoc
class _$RoutineExerciseCopyWithImpl<$Res, $Val extends RoutineExercise>
    implements $RoutineExerciseCopyWith<$Res> {
  _$RoutineExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? routineId = null,
    Object? exerciseId = null,
    Object? orderIndex = null,
    Object? targetSets = null,
    Object? targetReps = null,
    Object? targetRepsMin = freezed,
    Object? targetRepsMax = freezed,
    Object? targetWeight = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      routineId: null == routineId
          ? _value.routineId
          : routineId // ignore: cast_nullable_to_non_nullable
              as String,
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as String,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      targetSets: null == targetSets
          ? _value.targetSets
          : targetSets // ignore: cast_nullable_to_non_nullable
              as int,
      targetReps: null == targetReps
          ? _value.targetReps
          : targetReps // ignore: cast_nullable_to_non_nullable
              as int,
      targetRepsMin: freezed == targetRepsMin
          ? _value.targetRepsMin
          : targetRepsMin // ignore: cast_nullable_to_non_nullable
              as int?,
      targetRepsMax: freezed == targetRepsMax
          ? _value.targetRepsMax
          : targetRepsMax // ignore: cast_nullable_to_non_nullable
              as int?,
      targetWeight: null == targetWeight
          ? _value.targetWeight
          : targetWeight // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoutineExerciseImplCopyWith<$Res>
    implements $RoutineExerciseCopyWith<$Res> {
  factory _$$RoutineExerciseImplCopyWith(_$RoutineExerciseImpl value,
          $Res Function(_$RoutineExerciseImpl) then) =
      __$$RoutineExerciseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String routineId,
      String exerciseId,
      int orderIndex,
      int targetSets,
      int targetReps,
      int? targetRepsMin,
      int? targetRepsMax,
      double targetWeight});
}

/// @nodoc
class __$$RoutineExerciseImplCopyWithImpl<$Res>
    extends _$RoutineExerciseCopyWithImpl<$Res, _$RoutineExerciseImpl>
    implements _$$RoutineExerciseImplCopyWith<$Res> {
  __$$RoutineExerciseImplCopyWithImpl(
      _$RoutineExerciseImpl _value, $Res Function(_$RoutineExerciseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? routineId = null,
    Object? exerciseId = null,
    Object? orderIndex = null,
    Object? targetSets = null,
    Object? targetReps = null,
    Object? targetRepsMin = freezed,
    Object? targetRepsMax = freezed,
    Object? targetWeight = null,
  }) {
    return _then(_$RoutineExerciseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      routineId: null == routineId
          ? _value.routineId
          : routineId // ignore: cast_nullable_to_non_nullable
              as String,
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as String,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      targetSets: null == targetSets
          ? _value.targetSets
          : targetSets // ignore: cast_nullable_to_non_nullable
              as int,
      targetReps: null == targetReps
          ? _value.targetReps
          : targetReps // ignore: cast_nullable_to_non_nullable
              as int,
      targetRepsMin: freezed == targetRepsMin
          ? _value.targetRepsMin
          : targetRepsMin // ignore: cast_nullable_to_non_nullable
              as int?,
      targetRepsMax: freezed == targetRepsMax
          ? _value.targetRepsMax
          : targetRepsMax // ignore: cast_nullable_to_non_nullable
              as int?,
      targetWeight: null == targetWeight
          ? _value.targetWeight
          : targetWeight // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoutineExerciseImpl implements _RoutineExercise {
  const _$RoutineExerciseImpl(
      {required this.id,
      required this.routineId,
      required this.exerciseId,
      required this.orderIndex,
      required this.targetSets,
      required this.targetReps,
      this.targetRepsMin,
      this.targetRepsMax,
      required this.targetWeight});

  factory _$RoutineExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutineExerciseImplFromJson(json);

  @override
  final String id;
  @override
  final String routineId;
  @override
  final String exerciseId;
  @override
  final int orderIndex;
  @override
  final int targetSets;
  @override
  final int targetReps;
  @override
  final int? targetRepsMin;
  @override
  final int? targetRepsMax;
  @override
  final double targetWeight;

  @override
  String toString() {
    return 'RoutineExercise(id: $id, routineId: $routineId, exerciseId: $exerciseId, orderIndex: $orderIndex, targetSets: $targetSets, targetReps: $targetReps, targetRepsMin: $targetRepsMin, targetRepsMax: $targetRepsMax, targetWeight: $targetWeight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutineExerciseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.routineId, routineId) ||
                other.routineId == routineId) &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.targetSets, targetSets) ||
                other.targetSets == targetSets) &&
            (identical(other.targetReps, targetReps) ||
                other.targetReps == targetReps) &&
            (identical(other.targetRepsMin, targetRepsMin) ||
                other.targetRepsMin == targetRepsMin) &&
            (identical(other.targetRepsMax, targetRepsMax) ||
                other.targetRepsMax == targetRepsMax) &&
            (identical(other.targetWeight, targetWeight) ||
                other.targetWeight == targetWeight));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      routineId,
      exerciseId,
      orderIndex,
      targetSets,
      targetReps,
      targetRepsMin,
      targetRepsMax,
      targetWeight);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutineExerciseImplCopyWith<_$RoutineExerciseImpl> get copyWith =>
      __$$RoutineExerciseImplCopyWithImpl<_$RoutineExerciseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutineExerciseImplToJson(
      this,
    );
  }
}

abstract class _RoutineExercise implements RoutineExercise {
  const factory _RoutineExercise(
      {required final String id,
      required final String routineId,
      required final String exerciseId,
      required final int orderIndex,
      required final int targetSets,
      required final int targetReps,
      final int? targetRepsMin,
      final int? targetRepsMax,
      required final double targetWeight}) = _$RoutineExerciseImpl;

  factory _RoutineExercise.fromJson(Map<String, dynamic> json) =
      _$RoutineExerciseImpl.fromJson;

  @override
  String get id;
  @override
  String get routineId;
  @override
  String get exerciseId;
  @override
  int get orderIndex;
  @override
  int get targetSets;
  @override
  int get targetReps;
  @override
  int? get targetRepsMin;
  @override
  int? get targetRepsMax;
  @override
  double get targetWeight;
  @override
  @JsonKey(ignore: true)
  _$$RoutineExerciseImplCopyWith<_$RoutineExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoutineSetTarget _$RoutineSetTargetFromJson(Map<String, dynamic> json) {
  return _RoutineSetTarget.fromJson(json);
}

/// @nodoc
mixin _$RoutineSetTarget {
  int get setIndex => throw _privateConstructorUsedError;
  int? get targetReps => throw _privateConstructorUsedError;
  double? get targetWeight => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoutineSetTargetCopyWith<RoutineSetTarget> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutineSetTargetCopyWith<$Res> {
  factory $RoutineSetTargetCopyWith(
          RoutineSetTarget value, $Res Function(RoutineSetTarget) then) =
      _$RoutineSetTargetCopyWithImpl<$Res, RoutineSetTarget>;
  @useResult
  $Res call({int setIndex, int? targetReps, double? targetWeight});
}

/// @nodoc
class _$RoutineSetTargetCopyWithImpl<$Res, $Val extends RoutineSetTarget>
    implements $RoutineSetTargetCopyWith<$Res> {
  _$RoutineSetTargetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? setIndex = null,
    Object? targetReps = freezed,
    Object? targetWeight = freezed,
  }) {
    return _then(_value.copyWith(
      setIndex: null == setIndex
          ? _value.setIndex
          : setIndex // ignore: cast_nullable_to_non_nullable
              as int,
      targetReps: freezed == targetReps
          ? _value.targetReps
          : targetReps // ignore: cast_nullable_to_non_nullable
              as int?,
      targetWeight: freezed == targetWeight
          ? _value.targetWeight
          : targetWeight // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoutineSetTargetImplCopyWith<$Res>
    implements $RoutineSetTargetCopyWith<$Res> {
  factory _$$RoutineSetTargetImplCopyWith(_$RoutineSetTargetImpl value,
          $Res Function(_$RoutineSetTargetImpl) then) =
      __$$RoutineSetTargetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int setIndex, int? targetReps, double? targetWeight});
}

/// @nodoc
class __$$RoutineSetTargetImplCopyWithImpl<$Res>
    extends _$RoutineSetTargetCopyWithImpl<$Res, _$RoutineSetTargetImpl>
    implements _$$RoutineSetTargetImplCopyWith<$Res> {
  __$$RoutineSetTargetImplCopyWithImpl(_$RoutineSetTargetImpl _value,
      $Res Function(_$RoutineSetTargetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? setIndex = null,
    Object? targetReps = freezed,
    Object? targetWeight = freezed,
  }) {
    return _then(_$RoutineSetTargetImpl(
      setIndex: null == setIndex
          ? _value.setIndex
          : setIndex // ignore: cast_nullable_to_non_nullable
              as int,
      targetReps: freezed == targetReps
          ? _value.targetReps
          : targetReps // ignore: cast_nullable_to_non_nullable
              as int?,
      targetWeight: freezed == targetWeight
          ? _value.targetWeight
          : targetWeight // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoutineSetTargetImpl implements _RoutineSetTarget {
  const _$RoutineSetTargetImpl(
      {required this.setIndex, this.targetReps, this.targetWeight});

  factory _$RoutineSetTargetImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutineSetTargetImplFromJson(json);

  @override
  final int setIndex;
  @override
  final int? targetReps;
  @override
  final double? targetWeight;

  @override
  String toString() {
    return 'RoutineSetTarget(setIndex: $setIndex, targetReps: $targetReps, targetWeight: $targetWeight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutineSetTargetImpl &&
            (identical(other.setIndex, setIndex) ||
                other.setIndex == setIndex) &&
            (identical(other.targetReps, targetReps) ||
                other.targetReps == targetReps) &&
            (identical(other.targetWeight, targetWeight) ||
                other.targetWeight == targetWeight));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, setIndex, targetReps, targetWeight);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutineSetTargetImplCopyWith<_$RoutineSetTargetImpl> get copyWith =>
      __$$RoutineSetTargetImplCopyWithImpl<_$RoutineSetTargetImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutineSetTargetImplToJson(
      this,
    );
  }
}

abstract class _RoutineSetTarget implements RoutineSetTarget {
  const factory _RoutineSetTarget(
      {required final int setIndex,
      final int? targetReps,
      final double? targetWeight}) = _$RoutineSetTargetImpl;

  factory _RoutineSetTarget.fromJson(Map<String, dynamic> json) =
      _$RoutineSetTargetImpl.fromJson;

  @override
  int get setIndex;
  @override
  int? get targetReps;
  @override
  double? get targetWeight;
  @override
  @JsonKey(ignore: true)
  _$$RoutineSetTargetImplCopyWith<_$RoutineSetTargetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoutineExerciseWithDetails _$RoutineExerciseWithDetailsFromJson(
    Map<String, dynamic> json) {
  return _RoutineExerciseWithDetails.fromJson(json);
}

/// @nodoc
mixin _$RoutineExerciseWithDetails {
  String get id => throw _privateConstructorUsedError;
  String get routineId => throw _privateConstructorUsedError;
  String get exerciseId => throw _privateConstructorUsedError;
  int get orderIndex => throw _privateConstructorUsedError;
  int get targetSets => throw _privateConstructorUsedError;
  int get targetReps => throw _privateConstructorUsedError;
  int? get targetRepsMin => throw _privateConstructorUsedError;
  int? get targetRepsMax => throw _privateConstructorUsedError;
  double get targetWeight => throw _privateConstructorUsedError;
  Exercise get exercise => throw _privateConstructorUsedError;
  List<RoutineSetTarget> get sets => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoutineExerciseWithDetailsCopyWith<RoutineExerciseWithDetails>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutineExerciseWithDetailsCopyWith<$Res> {
  factory $RoutineExerciseWithDetailsCopyWith(RoutineExerciseWithDetails value,
          $Res Function(RoutineExerciseWithDetails) then) =
      _$RoutineExerciseWithDetailsCopyWithImpl<$Res,
          RoutineExerciseWithDetails>;
  @useResult
  $Res call(
      {String id,
      String routineId,
      String exerciseId,
      int orderIndex,
      int targetSets,
      int targetReps,
      int? targetRepsMin,
      int? targetRepsMax,
      double targetWeight,
      Exercise exercise,
      List<RoutineSetTarget> sets});

  $ExerciseCopyWith<$Res> get exercise;
}

/// @nodoc
class _$RoutineExerciseWithDetailsCopyWithImpl<$Res,
        $Val extends RoutineExerciseWithDetails>
    implements $RoutineExerciseWithDetailsCopyWith<$Res> {
  _$RoutineExerciseWithDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? routineId = null,
    Object? exerciseId = null,
    Object? orderIndex = null,
    Object? targetSets = null,
    Object? targetReps = null,
    Object? targetRepsMin = freezed,
    Object? targetRepsMax = freezed,
    Object? targetWeight = null,
    Object? exercise = null,
    Object? sets = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      routineId: null == routineId
          ? _value.routineId
          : routineId // ignore: cast_nullable_to_non_nullable
              as String,
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as String,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      targetSets: null == targetSets
          ? _value.targetSets
          : targetSets // ignore: cast_nullable_to_non_nullable
              as int,
      targetReps: null == targetReps
          ? _value.targetReps
          : targetReps // ignore: cast_nullable_to_non_nullable
              as int,
      targetRepsMin: freezed == targetRepsMin
          ? _value.targetRepsMin
          : targetRepsMin // ignore: cast_nullable_to_non_nullable
              as int?,
      targetRepsMax: freezed == targetRepsMax
          ? _value.targetRepsMax
          : targetRepsMax // ignore: cast_nullable_to_non_nullable
              as int?,
      targetWeight: null == targetWeight
          ? _value.targetWeight
          : targetWeight // ignore: cast_nullable_to_non_nullable
              as double,
      exercise: null == exercise
          ? _value.exercise
          : exercise // ignore: cast_nullable_to_non_nullable
              as Exercise,
      sets: null == sets
          ? _value.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as List<RoutineSetTarget>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ExerciseCopyWith<$Res> get exercise {
    return $ExerciseCopyWith<$Res>(_value.exercise, (value) {
      return _then(_value.copyWith(exercise: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RoutineExerciseWithDetailsImplCopyWith<$Res>
    implements $RoutineExerciseWithDetailsCopyWith<$Res> {
  factory _$$RoutineExerciseWithDetailsImplCopyWith(
          _$RoutineExerciseWithDetailsImpl value,
          $Res Function(_$RoutineExerciseWithDetailsImpl) then) =
      __$$RoutineExerciseWithDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String routineId,
      String exerciseId,
      int orderIndex,
      int targetSets,
      int targetReps,
      int? targetRepsMin,
      int? targetRepsMax,
      double targetWeight,
      Exercise exercise,
      List<RoutineSetTarget> sets});

  @override
  $ExerciseCopyWith<$Res> get exercise;
}

/// @nodoc
class __$$RoutineExerciseWithDetailsImplCopyWithImpl<$Res>
    extends _$RoutineExerciseWithDetailsCopyWithImpl<$Res,
        _$RoutineExerciseWithDetailsImpl>
    implements _$$RoutineExerciseWithDetailsImplCopyWith<$Res> {
  __$$RoutineExerciseWithDetailsImplCopyWithImpl(
      _$RoutineExerciseWithDetailsImpl _value,
      $Res Function(_$RoutineExerciseWithDetailsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? routineId = null,
    Object? exerciseId = null,
    Object? orderIndex = null,
    Object? targetSets = null,
    Object? targetReps = null,
    Object? targetRepsMin = freezed,
    Object? targetRepsMax = freezed,
    Object? targetWeight = null,
    Object? exercise = null,
    Object? sets = null,
  }) {
    return _then(_$RoutineExerciseWithDetailsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      routineId: null == routineId
          ? _value.routineId
          : routineId // ignore: cast_nullable_to_non_nullable
              as String,
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as String,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      targetSets: null == targetSets
          ? _value.targetSets
          : targetSets // ignore: cast_nullable_to_non_nullable
              as int,
      targetReps: null == targetReps
          ? _value.targetReps
          : targetReps // ignore: cast_nullable_to_non_nullable
              as int,
      targetRepsMin: freezed == targetRepsMin
          ? _value.targetRepsMin
          : targetRepsMin // ignore: cast_nullable_to_non_nullable
              as int?,
      targetRepsMax: freezed == targetRepsMax
          ? _value.targetRepsMax
          : targetRepsMax // ignore: cast_nullable_to_non_nullable
              as int?,
      targetWeight: null == targetWeight
          ? _value.targetWeight
          : targetWeight // ignore: cast_nullable_to_non_nullable
              as double,
      exercise: null == exercise
          ? _value.exercise
          : exercise // ignore: cast_nullable_to_non_nullable
              as Exercise,
      sets: null == sets
          ? _value._sets
          : sets // ignore: cast_nullable_to_non_nullable
              as List<RoutineSetTarget>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoutineExerciseWithDetailsImpl implements _RoutineExerciseWithDetails {
  const _$RoutineExerciseWithDetailsImpl(
      {required this.id,
      required this.routineId,
      required this.exerciseId,
      required this.orderIndex,
      required this.targetSets,
      required this.targetReps,
      this.targetRepsMin,
      this.targetRepsMax,
      required this.targetWeight,
      required this.exercise,
      required final List<RoutineSetTarget> sets})
      : _sets = sets;

  factory _$RoutineExerciseWithDetailsImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$RoutineExerciseWithDetailsImplFromJson(json);

  @override
  final String id;
  @override
  final String routineId;
  @override
  final String exerciseId;
  @override
  final int orderIndex;
  @override
  final int targetSets;
  @override
  final int targetReps;
  @override
  final int? targetRepsMin;
  @override
  final int? targetRepsMax;
  @override
  final double targetWeight;
  @override
  final Exercise exercise;
  final List<RoutineSetTarget> _sets;
  @override
  List<RoutineSetTarget> get sets {
    if (_sets is EqualUnmodifiableListView) return _sets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sets);
  }

  @override
  String toString() {
    return 'RoutineExerciseWithDetails(id: $id, routineId: $routineId, exerciseId: $exerciseId, orderIndex: $orderIndex, targetSets: $targetSets, targetReps: $targetReps, targetRepsMin: $targetRepsMin, targetRepsMax: $targetRepsMax, targetWeight: $targetWeight, exercise: $exercise, sets: $sets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutineExerciseWithDetailsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.routineId, routineId) ||
                other.routineId == routineId) &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.targetSets, targetSets) ||
                other.targetSets == targetSets) &&
            (identical(other.targetReps, targetReps) ||
                other.targetReps == targetReps) &&
            (identical(other.targetRepsMin, targetRepsMin) ||
                other.targetRepsMin == targetRepsMin) &&
            (identical(other.targetRepsMax, targetRepsMax) ||
                other.targetRepsMax == targetRepsMax) &&
            (identical(other.targetWeight, targetWeight) ||
                other.targetWeight == targetWeight) &&
            (identical(other.exercise, exercise) ||
                other.exercise == exercise) &&
            const DeepCollectionEquality().equals(other._sets, _sets));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      routineId,
      exerciseId,
      orderIndex,
      targetSets,
      targetReps,
      targetRepsMin,
      targetRepsMax,
      targetWeight,
      exercise,
      const DeepCollectionEquality().hash(_sets));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutineExerciseWithDetailsImplCopyWith<_$RoutineExerciseWithDetailsImpl>
      get copyWith => __$$RoutineExerciseWithDetailsImplCopyWithImpl<
          _$RoutineExerciseWithDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutineExerciseWithDetailsImplToJson(
      this,
    );
  }
}

abstract class _RoutineExerciseWithDetails
    implements RoutineExerciseWithDetails {
  const factory _RoutineExerciseWithDetails(
          {required final String id,
          required final String routineId,
          required final String exerciseId,
          required final int orderIndex,
          required final int targetSets,
          required final int targetReps,
          final int? targetRepsMin,
          final int? targetRepsMax,
          required final double targetWeight,
          required final Exercise exercise,
          required final List<RoutineSetTarget> sets}) =
      _$RoutineExerciseWithDetailsImpl;

  factory _RoutineExerciseWithDetails.fromJson(Map<String, dynamic> json) =
      _$RoutineExerciseWithDetailsImpl.fromJson;

  @override
  String get id;
  @override
  String get routineId;
  @override
  String get exerciseId;
  @override
  int get orderIndex;
  @override
  int get targetSets;
  @override
  int get targetReps;
  @override
  int? get targetRepsMin;
  @override
  int? get targetRepsMax;
  @override
  double get targetWeight;
  @override
  Exercise get exercise;
  @override
  List<RoutineSetTarget> get sets;
  @override
  @JsonKey(ignore: true)
  _$$RoutineExerciseWithDetailsImplCopyWith<_$RoutineExerciseWithDetailsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
