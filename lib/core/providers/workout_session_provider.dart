import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:fitzella/core/models/session/workout_session.dart';
import 'package:fitzella/core/models/workout/exercise.dart';
import 'package:fitzella/core/models/program/program.dart';
import 'package:fitzella/core/providers/auth_provider.dart';

part 'workout_session_provider.g.dart';
part 'workout_session_provider.freezed.dart';

/// Workout session state
@freezed
abstract class WorkoutSessionState with _$WorkoutSessionState {
  const factory WorkoutSessionState({
    TodaysWorkout? workout,
    @Default(false) bool isRestDay,
    @Default(false) bool loading,
    String? sessionId,
    String? sessionStartedAt,
    @Default({}) Set<String> completedExerciseIds,
    @Default({}) Set<String> approvedExerciseIds,
    @Default(false) bool hasActiveSession,
    @Default({}) Map<String, String> supersets,
  }) = _WorkoutSessionState;
}

/// Workout session notifier
@riverpod
class WorkoutSessionNotifier extends _$WorkoutSessionNotifier {
  @override
  WorkoutSessionState build() {
    // Listen to auth changes to refresh workout
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.session != previous?.session) {
        refreshWorkout();
      }
    });
    
    // Frontend-only: start idle (not loading) so Home can render without backend.
    return const WorkoutSessionState(loading: false);
  }

  Future<void> refreshWorkout() async {
    final authState = ref.read(authNotifierProvider);
    if (authState.session == null) return;
    
    state = state.copyWith(loading: true);
    
    try {
      // TODO: Implement actual workout data fetching
      // For now, set empty state
      state = state.copyWith(
        workout: null,
        isRestDay: false,
        loading: false,
        sessionId: null,
        sessionStartedAt: null,
        completedExerciseIds: {},
        approvedExerciseIds: {},
        hasActiveSession: false,
        supersets: {},
      );
    } catch (e) {
      state = state.copyWith(loading: false);
    }
  }

  Future<String?> ensureSession() async {
    if (state.sessionId != null) return state.sessionId;
    if (state.workout == null || ref.read(authNotifierProvider).session == null) {
      throw Exception('No active routine to log against');
    }
    
    // TODO: Create session in database
    // final created = await startSession(...);
    // state = state.copyWith(sessionId: created.id, sessionStartedAt: created.startedAt);
    
    return state.sessionId;
  }

  Future<void> submitExercise(TodaysWorkoutItem item, List<SetEntry> sets) async {
    final sessionId = await ensureSession();
    // TODO: Log sets to database
    
    final completed = {...state.completedExerciseIds, item.exerciseId};
    state = state.copyWith(completedExerciseIds: completed);
  }

  void approveExercise(String exerciseId) {
    final approved = {...state.approvedExerciseIds, exerciseId};
    state = state.copyWith(approvedExerciseIds: approved);
  }

  Future<void> startWorkoutSession() async {
    await ensureSession();
  }

  Future<void> startWorkoutForRoutine(Routine routine) async {
    final authState = ref.read(authNotifierProvider);
    if (authState.session == null || authState.profile == null) return;
    
    // TODO: Build workout for routine and create session
    state = state.copyWith(
      workout: TodaysWorkout(routine: routine, items: []),
      sessionId: null,
      sessionStartedAt: null,
      completedExerciseIds: {},
      approvedExerciseIds: {},
      hasActiveSession: false,
      supersets: {},
    );
  }

  Future<void> startEmptyWorkout() async {
    final authState = ref.read(authNotifierProvider);
    if (authState.session == null || authState.profile == null) return;
    
    // TODO: Create empty workout session
    final quickRoutine = Routine(
      id: '',
      userId: '',
      name: 'Quick Workout',
      isAiGenerated: false,
      programId: '',
      dayIndex: 0,
    );
    
    state = state.copyWith(
      workout: TodaysWorkout(routine: quickRoutine, items: []),
      sessionId: null,
      sessionStartedAt: null,
      completedExerciseIds: {},
      approvedExerciseIds: {},
      hasActiveSession: false,
      supersets: {},
    );
  }

  Future<String?> finishWorkout() async {
    final finishedId = state.sessionId;
    if (finishedId != null) {
      // TODO: Complete session in database
      
      // Check if empty and discard if needed
      // final setCount = await fetchSessionSetCounts(finishedId);
      // if (!hasCompletableWork(setCount)) { await deleteSession(finishedId); return null; }
    }
    
    state = state.copyWith(
      sessionId: null,
      sessionStartedAt: null,
      completedExerciseIds: {},
      approvedExerciseIds: {},
      hasActiveSession: false,
      supersets: {},
    );
    
    await refreshWorkout();
    return finishedId;
  }

  Future<void> discardWorkout() async {
    if (state.sessionId == null) return;
    // TODO: Delete session from database
    
    state = state.copyWith(
      sessionId: null,
      sessionStartedAt: null,
      completedExerciseIds: {},
      approvedExerciseIds: {},
      hasActiveSession: false,
      supersets: {},
    );
    
    await refreshWorkout();
  }

  Future<void> addAdHocExercise(Exercise exercise) async {
    if (state.workout == null) return;
    if (state.workout!.items.any((i) => i.exerciseId == exercise.id)) return;
    
    // TODO: Build ad hoc workout item
    final newItem = TodaysWorkoutItem(
      id: '',
      exerciseId: exercise.id,
      name: exercise.name,
      muscleGroup: exercise.muscleGroup,
      targetSets: 3,
      targetRepsMin: 8,
      targetRepsMax: 12,
      targetWeight: 0,
      suggestionWeight: null,
    );
    
    final items = [...state.workout!.items, newItem];
    state = state.copyWith(workout: state.workout!.copyWith(items: items));
  }

  Future<void> removeExerciseFromWorkout(String exerciseId) async {
    if (state.workout == null) return;
    
    if (state.sessionId != null) {
      // TODO: Delete exercise sets from database
      // await deleteExerciseSets(state.sessionId!, exerciseId);
    }
    
    final items = state.workout!.items.where((i) => i.exerciseId != exerciseId).toList();
    final completed = {...state.completedExerciseIds}..remove(exerciseId);
    final approved = {...state.approvedExerciseIds}..remove(exerciseId);
    final supersets = Map<String, String>.from(state.supersets)..remove(exerciseId);
    
    state = state.copyWith(
      workout: state.workout!.copyWith(items: items),
      completedExerciseIds: completed,
      approvedExerciseIds: approved,
      supersets: supersets,
    );
  }

  Future<void> replaceExercise(String oldExerciseId, Exercise newExercise) async {
    if (state.workout == null) return;
    if (state.workout!.items.any((i) => i.exerciseId == newExercise.id)) return;
    
    if (state.sessionId != null) {
      // TODO: Delete old exercise sets and superset membership
    }
    
    final newItem = TodaysWorkoutItem(
      id: '',
      exerciseId: newExercise.id,
      name: newExercise.name,
      muscleGroup: newExercise.muscleGroup,
      targetSets: 3,
      targetRepsMin: 8,
      targetRepsMax: 12,
      targetWeight: 0,
      suggestionWeight: null,
    );
    
    final items = state.workout!.items.map((i) => 
      i.exerciseId == oldExerciseId ? newItem : i
    ).toList();
    
    final completed = {...state.completedExerciseIds}..remove(oldExerciseId);
    final approved = {...state.approvedExerciseIds}..remove(oldExerciseId);
    final supersets = Map<String, String>.from(state.supersets)..remove(oldExerciseId);
    
    state = state.copyWith(
      workout: state.workout!.copyWith(items: items),
      completedExerciseIds: completed,
      approvedExerciseIds: approved,
      supersets: supersets,
    );
  }

  Future<void> createSupersetGroup(List<String> exerciseIds) async {
    if (state.sessionId == null || exerciseIds.length < 2) return;
    // TODO: Create superset in database
  }

  Future<void> addExerciseToSupersetGroup(String exerciseId, String groupId) async {
    if (state.sessionId == null) return;
    // TODO: Add to superset in database
  }

  Future<void> removeExerciseFromSuperset(String exerciseId) async {
    if (state.sessionId == null) return;
    // TODO: Remove from superset in database
    
    final supersets = Map<String, String>.from(state.supersets)..remove(exerciseId);
    state = state.copyWith(supersets: supersets);
  }
}

/// Providers for easy access
@riverpod
TodaysWorkout? currentWorkout(Ref ref) => ref.watch(workoutSessionNotifierProvider).workout;

@riverpod
bool isRestDay(Ref ref) => ref.watch(workoutSessionNotifierProvider).isRestDay;

@riverpod
bool workoutLoading(Ref ref) => ref.watch(workoutSessionNotifierProvider).loading;

@riverpod
String? sessionId(Ref ref) => ref.watch(workoutSessionNotifierProvider).sessionId;

@riverpod
String? sessionStartedAt(Ref ref) => ref.watch(workoutSessionNotifierProvider).sessionStartedAt;

@riverpod
Set<String> completedExerciseIds(Ref ref) => ref.watch(workoutSessionNotifierProvider).completedExerciseIds;

@riverpod
bool hasActiveSession(Ref ref) => ref.watch(workoutSessionNotifierProvider).hasActiveSession;

@riverpod
Set<String> approvedExerciseIds(Ref ref) => ref.watch(workoutSessionNotifierProvider).approvedExerciseIds;

@riverpod
Map<String, String> supersets(Ref ref) => ref.watch(workoutSessionNotifierProvider).supersets;