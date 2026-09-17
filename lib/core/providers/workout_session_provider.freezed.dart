// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_session_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WorkoutSessionState {
  TodaysWorkout? get workout => throw _privateConstructorUsedError;
  bool get isRestDay => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  String? get sessionId => throw _privateConstructorUsedError;
  String? get sessionStartedAt => throw _privateConstructorUsedError;
  Set<String> get completedExerciseIds => throw _privateConstructorUsedError;
  Set<String> get approvedExerciseIds => throw _privateConstructorUsedError;
  bool get hasActiveSession => throw _privateConstructorUsedError;
  Map<String, String> get supersets => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WorkoutSessionStateCopyWith<WorkoutSessionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutSessionStateCopyWith<$Res> {
  factory $WorkoutSessionStateCopyWith(
          WorkoutSessionState value, $Res Function(WorkoutSessionState) then) =
      _$WorkoutSessionStateCopyWithImpl<$Res, WorkoutSessionState>;
  @useResult
  $Res call(
      {TodaysWorkout? workout,
      bool isRestDay,
      bool loading,
      String? sessionId,
      String? sessionStartedAt,
      Set<String> completedExerciseIds,
      Set<String> approvedExerciseIds,
      bool hasActiveSession,
      Map<String, String> supersets});

  $TodaysWorkoutCopyWith<$Res>? get workout;
}

/// @nodoc
class _$WorkoutSessionStateCopyWithImpl<$Res, $Val extends WorkoutSessionState>
    implements $WorkoutSessionStateCopyWith<$Res> {
  _$WorkoutSessionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workout = freezed,
    Object? isRestDay = null,
    Object? loading = null,
    Object? sessionId = freezed,
    Object? sessionStartedAt = freezed,
    Object? completedExerciseIds = null,
    Object? approvedExerciseIds = null,
    Object? hasActiveSession = null,
    Object? supersets = null,
  }) {
    return _then(_value.copyWith(
      workout: freezed == workout
          ? _value.workout
          : workout // ignore: cast_nullable_to_non_nullable
              as TodaysWorkout?,
      isRestDay: null == isRestDay
          ? _value.isRestDay
          : isRestDay // ignore: cast_nullable_to_non_nullable
              as bool,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionStartedAt: freezed == sessionStartedAt
          ? _value.sessionStartedAt
          : sessionStartedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      completedExerciseIds: null == completedExerciseIds
          ? _value.completedExerciseIds
          : completedExerciseIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      approvedExerciseIds: null == approvedExerciseIds
          ? _value.approvedExerciseIds
          : approvedExerciseIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      hasActiveSession: null == hasActiveSession
          ? _value.hasActiveSession
          : hasActiveSession // ignore: cast_nullable_to_non_nullable
              as bool,
      supersets: null == supersets
          ? _value.supersets
          : supersets // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TodaysWorkoutCopyWith<$Res>? get workout {
    if (_value.workout == null) {
      return null;
    }

    return $TodaysWorkoutCopyWith<$Res>(_value.workout!, (value) {
      return _then(_value.copyWith(workout: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WorkoutSessionStateImplCopyWith<$Res>
    implements $WorkoutSessionStateCopyWith<$Res> {
  factory _$$WorkoutSessionStateImplCopyWith(_$WorkoutSessionStateImpl value,
          $Res Function(_$WorkoutSessionStateImpl) then) =
      __$$WorkoutSessionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {TodaysWorkout? workout,
      bool isRestDay,
      bool loading,
      String? sessionId,
      String? sessionStartedAt,
      Set<String> completedExerciseIds,
      Set<String> approvedExerciseIds,
      bool hasActiveSession,
      Map<String, String> supersets});

  @override
  $TodaysWorkoutCopyWith<$Res>? get workout;
}

/// @nodoc
class __$$WorkoutSessionStateImplCopyWithImpl<$Res>
    extends _$WorkoutSessionStateCopyWithImpl<$Res, _$WorkoutSessionStateImpl>
    implements _$$WorkoutSessionStateImplCopyWith<$Res> {
  __$$WorkoutSessionStateImplCopyWithImpl(_$WorkoutSessionStateImpl _value,
      $Res Function(_$WorkoutSessionStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workout = freezed,
    Object? isRestDay = null,
    Object? loading = null,
    Object? sessionId = freezed,
    Object? sessionStartedAt = freezed,
    Object? completedExerciseIds = null,
    Object? approvedExerciseIds = null,
    Object? hasActiveSession = null,
    Object? supersets = null,
  }) {
    return _then(_$WorkoutSessionStateImpl(
      workout: freezed == workout
          ? _value.workout
          : workout // ignore: cast_nullable_to_non_nullable
              as TodaysWorkout?,
      isRestDay: null == isRestDay
          ? _value.isRestDay
          : isRestDay // ignore: cast_nullable_to_non_nullable
              as bool,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionStartedAt: freezed == sessionStartedAt
          ? _value.sessionStartedAt
          : sessionStartedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      completedExerciseIds: null == completedExerciseIds
          ? _value._completedExerciseIds
          : completedExerciseIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      approvedExerciseIds: null == approvedExerciseIds
          ? _value._approvedExerciseIds
          : approvedExerciseIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      hasActiveSession: null == hasActiveSession
          ? _value.hasActiveSession
          : hasActiveSession // ignore: cast_nullable_to_non_nullable
              as bool,
      supersets: null == supersets
          ? _value._supersets
          : supersets // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc

class _$WorkoutSessionStateImpl implements _WorkoutSessionState {
  const _$WorkoutSessionStateImpl(
      {this.workout,
      this.isRestDay = false,
      this.loading = false,
      this.sessionId,
      this.sessionStartedAt,
      final Set<String> completedExerciseIds = const {},
      final Set<String> approvedExerciseIds = const {},
      this.hasActiveSession = false,
      final Map<String, String> supersets = const {}})
      : _completedExerciseIds = completedExerciseIds,
        _approvedExerciseIds = approvedExerciseIds,
        _supersets = supersets;

  @override
  final TodaysWorkout? workout;
  @override
  @JsonKey()
  final bool isRestDay;
  @override
  @JsonKey()
  final bool loading;
  @override
  final String? sessionId;
  @override
  final String? sessionStartedAt;
  final Set<String> _completedExerciseIds;
  @override
  @JsonKey()
  Set<String> get completedExerciseIds {
    if (_completedExerciseIds is EqualUnmodifiableSetView)
      return _completedExerciseIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_completedExerciseIds);
  }

  final Set<String> _approvedExerciseIds;
  @override
  @JsonKey()
  Set<String> get approvedExerciseIds {
    if (_approvedExerciseIds is EqualUnmodifiableSetView)
      return _approvedExerciseIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_approvedExerciseIds);
  }

  @override
  @JsonKey()
  final bool hasActiveSession;
  final Map<String, String> _supersets;
  @override
  @JsonKey()
  Map<String, String> get supersets {
    if (_supersets is EqualUnmodifiableMapView) return _supersets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_supersets);
  }

  @override
  String toString() {
    return 'WorkoutSessionState(workout: $workout, isRestDay: $isRestDay, loading: $loading, sessionId: $sessionId, sessionStartedAt: $sessionStartedAt, completedExerciseIds: $completedExerciseIds, approvedExerciseIds: $approvedExerciseIds, hasActiveSession: $hasActiveSession, supersets: $supersets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutSessionStateImpl &&
            (identical(other.workout, workout) || other.workout == workout) &&
            (identical(other.isRestDay, isRestDay) ||
                other.isRestDay == isRestDay) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.sessionStartedAt, sessionStartedAt) ||
                other.sessionStartedAt == sessionStartedAt) &&
            const DeepCollectionEquality()
                .equals(other._completedExerciseIds, _completedExerciseIds) &&
            const DeepCollectionEquality()
                .equals(other._approvedExerciseIds, _approvedExerciseIds) &&
            (identical(other.hasActiveSession, hasActiveSession) ||
                other.hasActiveSession == hasActiveSession) &&
            const DeepCollectionEquality()
                .equals(other._supersets, _supersets));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      workout,
      isRestDay,
      loading,
      sessionId,
      sessionStartedAt,
      const DeepCollectionEquality().hash(_completedExerciseIds),
      const DeepCollectionEquality().hash(_approvedExerciseIds),
      hasActiveSession,
      const DeepCollectionEquality().hash(_supersets));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutSessionStateImplCopyWith<_$WorkoutSessionStateImpl> get copyWith =>
      __$$WorkoutSessionStateImplCopyWithImpl<_$WorkoutSessionStateImpl>(
          this, _$identity);
}

abstract class _WorkoutSessionState implements WorkoutSessionState {
  const factory _WorkoutSessionState(
      {final TodaysWorkout? workout,
      final bool isRestDay,
      final bool loading,
      final String? sessionId,
      final String? sessionStartedAt,
      final Set<String> completedExerciseIds,
      final Set<String> approvedExerciseIds,
      final bool hasActiveSession,
      final Map<String, String> supersets}) = _$WorkoutSessionStateImpl;

  @override
  TodaysWorkout? get workout;
  @override
  bool get isRestDay;
  @override
  bool get loading;
  @override
  String? get sessionId;
  @override
  String? get sessionStartedAt;
  @override
  Set<String> get completedExerciseIds;
  @override
  Set<String> get approvedExerciseIds;
  @override
  bool get hasActiveSession;
  @override
  Map<String, String> get supersets;
  @override
  @JsonKey(ignore: true)
  _$$WorkoutSessionStateImplCopyWith<_$WorkoutSessionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
