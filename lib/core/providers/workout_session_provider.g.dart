// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentWorkoutHash() => r'7f506a0dafdf61271fbdfe9a2b075322d514c2f7';

/// Providers for easy access
///
/// Copied from [currentWorkout].
@ProviderFor(currentWorkout)
final currentWorkoutProvider = AutoDisposeProvider<TodaysWorkout?>.internal(
  currentWorkout,
  name: r'currentWorkoutProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentWorkoutHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentWorkoutRef = AutoDisposeProviderRef<TodaysWorkout?>;
String _$isRestDayHash() => r'a615ebac9b723b6dd31d5cb5d784aeaef002e30a';

/// See also [isRestDay].
@ProviderFor(isRestDay)
final isRestDayProvider = AutoDisposeProvider<bool>.internal(
  isRestDay,
  name: r'isRestDayProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isRestDayHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsRestDayRef = AutoDisposeProviderRef<bool>;
String _$workoutLoadingHash() => r'bcdb226a93804dbc11475a303e62ecefcade7db0';

/// See also [workoutLoading].
@ProviderFor(workoutLoading)
final workoutLoadingProvider = AutoDisposeProvider<bool>.internal(
  workoutLoading,
  name: r'workoutLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workoutLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WorkoutLoadingRef = AutoDisposeProviderRef<bool>;
String _$sessionIdHash() => r'e7be7d9c4688d78026ef926571f605998cd46050';

/// See also [sessionId].
@ProviderFor(sessionId)
final sessionIdProvider = AutoDisposeProvider<String?>.internal(
  sessionId,
  name: r'sessionIdProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sessionIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SessionIdRef = AutoDisposeProviderRef<String?>;
String _$sessionStartedAtHash() => r'cfde29a88a27dbf4b3b32f77bf77c277330abc5a';

/// See also [sessionStartedAt].
@ProviderFor(sessionStartedAt)
final sessionStartedAtProvider = AutoDisposeProvider<String?>.internal(
  sessionStartedAt,
  name: r'sessionStartedAtProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sessionStartedAtHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SessionStartedAtRef = AutoDisposeProviderRef<String?>;
String _$completedExerciseIdsHash() =>
    r'2ead899b3b9db22a9db9d7359e662d64e120ba10';

/// See also [completedExerciseIds].
@ProviderFor(completedExerciseIds)
final completedExerciseIdsProvider = AutoDisposeProvider<Set<String>>.internal(
  completedExerciseIds,
  name: r'completedExerciseIdsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$completedExerciseIdsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CompletedExerciseIdsRef = AutoDisposeProviderRef<Set<String>>;
String _$hasActiveSessionHash() => r'e6985a4f6f4d22e7ae12610af7d83cddc22e5e70';

/// See also [hasActiveSession].
@ProviderFor(hasActiveSession)
final hasActiveSessionProvider = AutoDisposeProvider<bool>.internal(
  hasActiveSession,
  name: r'hasActiveSessionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasActiveSessionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HasActiveSessionRef = AutoDisposeProviderRef<bool>;
String _$approvedExerciseIdsHash() =>
    r'2cc86629bbc821bd872f979920986acb854cf817';

/// See also [approvedExerciseIds].
@ProviderFor(approvedExerciseIds)
final approvedExerciseIdsProvider = AutoDisposeProvider<Set<String>>.internal(
  approvedExerciseIds,
  name: r'approvedExerciseIdsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$approvedExerciseIdsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ApprovedExerciseIdsRef = AutoDisposeProviderRef<Set<String>>;
String _$supersetsHash() => r'8798702bafebb29f379741529313aab094053fb8';

/// See also [supersets].
@ProviderFor(supersets)
final supersetsProvider = AutoDisposeProvider<Map<String, String>>.internal(
  supersets,
  name: r'supersetsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$supersetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SupersetsRef = AutoDisposeProviderRef<Map<String, String>>;
String _$workoutSessionNotifierHash() =>
    r'9bdcaa9f51e01e11f4abec32e4e7e436a6350548';

/// Workout session notifier
///
/// Copied from [WorkoutSessionNotifier].
@ProviderFor(WorkoutSessionNotifier)
final workoutSessionNotifierProvider = AutoDisposeNotifierProvider<
    WorkoutSessionNotifier, WorkoutSessionState>.internal(
  WorkoutSessionNotifier.new,
  name: r'workoutSessionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workoutSessionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WorkoutSessionNotifier = AutoDisposeNotifier<WorkoutSessionState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
