import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitzella/core/services/fitness_data_service.dart';

class WorkoutExerciseDef {
  final String id;
  final String name;
  final String muscle;
  final String equipment;
  final int defaultSets;
  final double defaultWeight;
  final int defaultReps;

  const WorkoutExerciseDef({
    required this.id,
    required this.name,
    required this.muscle,
    required this.equipment,
    this.defaultSets = 3,
    this.defaultWeight = 40,
    this.defaultReps = 8,
  });
}

class RoutineDay {
  final String id;
  final String name;
  final List<String> exerciseIds;
  final List<String> exerciseNames;
  final String tag;

  const RoutineDay({
    required this.id,
    required this.name,
    required this.exerciseIds,
    this.exerciseNames = const [],
    this.tag = '',
  });
}

class PlanDef {
  final String id;
  final String name;
  final bool active;
  final bool aiGenerated;
  final List<RoutineDay> days;

  const PlanDef({
    required this.id,
    required this.name,
    this.active = false,
    this.aiGenerated = false,
    required this.days,
  });

  PlanDef copyWith({bool? active}) => PlanDef(
        id: id,
        name: name,
        active: active ?? this.active,
        aiGenerated: aiGenerated,
        days: days,
      );
}

class LoggedSet {
  double weight;
  int reps;
  bool done;

  LoggedSet({required this.weight, required this.reps, this.done = false});
}

class ActiveExercise {
  final String id;
  final String name;
  final String muscle;
  bool expanded;
  final List<LoggedSet> sets;

  ActiveExercise({
    required this.id,
    required this.name,
    required this.muscle,
    this.expanded = true,
    required this.sets,
  });
}

class ActiveWorkoutState {
  final bool hasSession;
  final String title;
  final List<ActiveExercise> exercises;
  final int restSeconds;
  final int restTotal;
  final bool restRunning;
  final String? restExerciseName;
  final DateTime? startedAt;
  final bool finished;
  final String? sessionId;
  final String? backendError;
  final bool saving;

  const ActiveWorkoutState({
    this.hasSession = false,
    this.title = 'Empty Workout',
    this.exercises = const [],
    this.restSeconds = 60,
    this.restTotal = 60,
    this.restRunning = false,
    this.restExerciseName,
    this.startedAt,
    this.finished = false,
    this.sessionId,
    this.backendError,
    this.saving = false,
  });

  int get loggedSets => exercises.fold(0, (p, e) => p + e.sets.where((s) => s.done).length);
  int get totalSets => exercises.fold(0, (p, e) => p + e.sets.length);
  bool get canFinish => loggedSets > 0;
  double get restProgress => restTotal == 0 ? 0 : (restTotal - restSeconds) / restTotal;

  ActiveWorkoutState copyWith({
    bool? hasSession,
    String? title,
    List<ActiveExercise>? exercises,
    int? restSeconds,
    int? restTotal,
    bool? restRunning,
    String? restExerciseName,
    DateTime? startedAt,
    bool? finished,
    String? sessionId,
    String? backendError,
    bool? saving,
    bool clearRestName = false,
    bool clearBackendError = false,
  }) {
    return ActiveWorkoutState(
      hasSession: hasSession ?? this.hasSession,
      title: title ?? this.title,
      exercises: exercises ?? this.exercises,
      restSeconds: restSeconds ?? this.restSeconds,
      restTotal: restTotal ?? this.restTotal,
      restRunning: restRunning ?? this.restRunning,
      restExerciseName: clearRestName ? null : (restExerciseName ?? this.restExerciseName),
      startedAt: startedAt ?? this.startedAt,
      finished: finished ?? this.finished,
      sessionId: sessionId ?? this.sessionId,
      backendError: clearBackendError ? null : (backendError ?? this.backendError),
      saving: saving ?? this.saving,
    );
  }
}

class ActiveWorkoutNotifier extends StateNotifier<ActiveWorkoutState> {
  ActiveWorkoutNotifier(this._ref) : super(const ActiveWorkoutState()) {
    Future.microtask(restoreActiveSession);
  }

  final Ref _ref;
  int _mutation = 0;
  FitnessDataService get _data => _ref.read(fitnessDataServiceProvider);
  ActiveWorkoutState get currentState => state;

  Future<void> restoreActiveSession() async {
    final mutation = _mutation;
    try {
      final session = await _data.fetchActiveSession();
      if (mutation != _mutation || session == null) return;
      final routine = session['routines'] as Map<String, dynamic>?;
      final routineItems =
          (routine?['routine_exercises'] as List? ?? const [])
              .cast<Map<String, dynamic>>();
      final logged =
          (session['logged_sets'] as List? ?? const [])
              .cast<Map<String, dynamic>>();
      final byExercise = <String, List<Map<String, dynamic>>>{};
      for (final set in logged) {
        byExercise
            .putIfAbsent(set['exercise_id'] as String, () => [])
            .add(set);
      }
      final exerciseIds = <String>{
        ...routineItems.map((item) => item['exercise_id'] as String),
        ...byExercise.keys,
      };
      final exercises = <ActiveExercise>[];
      for (final id in exerciseIds) {
        final item = routineItems
            .where((entry) => entry['exercise_id'] == id)
            .firstOrNull;
        final setsForExercise = byExercise[id] ?? const [];
        final exercise = item?['exercises'] as Map<String, dynamic>? ??
            (setsForExercise.isEmpty
                ? null
                : setsForExercise.first['exercises'] as Map<String, dynamic>?);
        if (exercise == null) continue;
        final setCount = (item?['target_sets'] as num?)?.toInt() ??
            setsForExercise.fold<int>(
              0,
              (max, set) => (set['set_index'] as num).toInt() > max
                  ? (set['set_index'] as num).toInt()
                  : max,
            );
        final targets = List.generate(setCount, (index) {
          final saved = setsForExercise
              .where((set) => (set['set_index'] as num).toInt() == index + 1)
              .firstOrNull;
          return LoggedSet(
            weight: (saved?['weight'] as num?)?.toDouble() ??
                (item?['target_weight'] as num?)?.toDouble() ??
                0,
            reps: (saved?['reps'] as num?)?.toInt() ??
                (item?['target_reps'] as num?)?.toInt() ??
                8,
            done: saved != null,
          );
        });
        exercises.add(ActiveExercise(
          id: id,
          name: exercise['name'] as String? ?? 'Exercise',
          muscle: exercise['muscle_group'] as String? ?? '',
          sets: targets,
        ));
      }
      state = ActiveWorkoutState(
        hasSession: true,
        title: routine?['name'] as String? ??
            session['routine_name'] as String? ??
            'Quick Workout',
        exercises: exercises,
        startedAt: DateTime.parse(session['started_at'] as String),
        sessionId: session['id'] as String,
      );
    } catch (error) {
      if (mutation == _mutation) {
        state = state.copyWith(backendError: error.toString());
      }
    }
  }

  Future<void> startEmpty() async {
    _mutation++;
    state = state.copyWith(saving: true, clearBackendError: true);
    try {
      final session = await _data.startSession(title: 'Empty Workout');
      state = ActiveWorkoutState(
        hasSession: true,
        title: 'Empty Workout',
        exercises: [],
        startedAt: DateTime.parse(session['started_at'] as String),
        sessionId: session['id'] as String,
      );
    } catch (error) {
      state = state.copyWith(saving: false, backendError: error.toString());
    }
  }

  Future<void> startFromDay(RoutineDay day) async {
    _mutation++;
    try {
      final routine = await _data.fetchRoutine(day.id);
      final items = (routine['routine_exercises'] as List? ?? const [])
          .cast<Map<String, dynamic>>()
        ..sort((a, b) => (a['order_index'] as int? ?? 0)
            .compareTo(b['order_index'] as int? ?? 0));
      final exercises = items.map((item) {
        final exercise = item['exercises'] as Map<String, dynamic>;
        final count = (item['target_sets'] as num?)?.toInt() ?? 3;
        final reps = (item['target_reps'] as num?)?.toInt() ??
            (item['target_reps_min'] as num?)?.toInt() ??
            8;
        final weight = (item['target_weight'] as num?)?.toDouble() ?? 0;
        return ActiveExercise(
          id: exercise['id'] as String,
          name: exercise['name'] as String? ?? 'Exercise',
          muscle: exercise['muscle_group'] as String? ?? '',
          sets: List.generate(
            count,
            (_) => LoggedSet(weight: weight, reps: reps),
          ),
        );
      }).toList();
      final session = await _data.startSession(routineId: day.id);
      state = ActiveWorkoutState(
        hasSession: true,
        title: routine['name'] as String? ?? day.name,
        exercises: exercises,
        startedAt: DateTime.parse(session['started_at'] as String),
        sessionId: session['id'] as String,
      );
    } catch (error) {
      state = state.copyWith(
        hasSession: false,
        saving: false,
        backendError: error.toString(),
      );
    }
  }

  void resume() {
    if (!state.hasSession) return;
    state = state.copyWith(finished: false);
  }

  void addExercise(WorkoutExerciseDef def) {
    final list = [...state.exercises];
    list.add(ActiveExercise(
      id: def.id,
      name: def.name,
      muscle: def.muscle,
      sets: List.generate(
        def.defaultSets,
        (_) => LoggedSet(weight: def.defaultWeight, reps: def.defaultReps),
      ),
    ));
    state = state.copyWith(exercises: list);
  }

  Future<void> addExerciseFromLibrary(String id) async {
    try {
      final exercise = await _data.fetchExercise(id);
      if (state.exercises.any((item) => item.id == id)) return;
      final list = [
        ...state.exercises,
        ActiveExercise(
          id: id,
          name: exercise['name'] as String? ?? 'Exercise',
          muscle: exercise['muscle_group'] as String? ?? '',
          sets: List.generate(3, (_) => LoggedSet(weight: 0, reps: 8)),
        ),
      ];
      state = state.copyWith(exercises: list);
    } catch (error) {
      state = state.copyWith(backendError: error.toString());
    }
  }

  Future<void> toggleSet(int exerciseIndex, int setIndex) async {
    final list = [...state.exercises];
    final ex = list[exerciseIndex];
    final sets = [...ex.sets];
    final wasDone = sets[setIndex].done;
    final sessionId = state.sessionId;
    if (sessionId == null) {
      state = state.copyWith(backendError: 'Start a workout before logging sets.');
      return;
    }
    state = state.copyWith(saving: true, clearBackendError: true);
    try {
      final exerciseId = _isUuid(ex.id)
          ? ex.id
          : await _data.exerciseIdForName(ex.name);
      if (wasDone) {
        await _data.removeLoggedSet(
          sessionId: sessionId,
          exerciseId: exerciseId,
          setIndex: setIndex + 1,
        );
      } else {
        await _data.logSet(
          sessionId: sessionId,
          exerciseId: exerciseId,
          setIndex: setIndex + 1,
          reps: sets[setIndex].reps,
          weight: sets[setIndex].weight,
        );
      }
    } catch (error) {
      state = state.copyWith(saving: false, backendError: error.toString());
      return;
    }
    sets[setIndex].done = !wasDone;
    list[exerciseIndex] = ActiveExercise(
      id: ex.id,
      name: ex.name,
      muscle: ex.muscle,
      expanded: ex.expanded,
      sets: sets,
    );
    state = state.copyWith(exercises: list, saving: false);
    if (!wasDone) {
      startRest(ex.name);
    }
  }

  Future<void> updateSet(int exerciseIndex, int setIndex,
      {double? weight, int? reps}) async {
    final list = [...state.exercises];
    final ex = list[exerciseIndex];
    final sets = [...ex.sets];
    if (weight != null) sets[setIndex].weight = weight;
    if (reps != null) sets[setIndex].reps = reps;
    if (sets[setIndex].done && state.sessionId != null) {
      try {
        final exerciseId = _isUuid(ex.id)
            ? ex.id
            : await _data.exerciseIdForName(ex.name);
        await _data.updateLoggedSet(
          sessionId: state.sessionId!,
          exerciseId: exerciseId,
          setIndex: setIndex + 1,
          reps: sets[setIndex].reps,
          weight: sets[setIndex].weight,
        );
      } catch (error) {
        state = state.copyWith(backendError: error.toString());
        return;
      }
    }
    list[exerciseIndex] = ActiveExercise(
      id: ex.id,
      name: ex.name,
      muscle: ex.muscle,
      expanded: ex.expanded,
      sets: sets,
    );
    state = state.copyWith(exercises: list);
  }

  void addSet(int exerciseIndex) {
    final list = [...state.exercises];
    final ex = list[exerciseIndex];
    final last = ex.sets.isNotEmpty ? ex.sets.last : LoggedSet(weight: 40, reps: 8);
    final sets = [...ex.sets, LoggedSet(weight: last.weight, reps: last.reps)];
    list[exerciseIndex] = ActiveExercise(
      id: ex.id,
      name: ex.name,
      muscle: ex.muscle,
      expanded: ex.expanded,
      sets: sets,
    );
    state = state.copyWith(exercises: list);
  }

  Future<void> removeExercise(int index) async {
    final exercise = state.exercises[index];
    if (state.sessionId != null) {
      try {
        final exerciseId = _isUuid(exercise.id)
            ? exercise.id
            : await _data.exerciseIdForName(exercise.name);
        await _data.removeExerciseSets(state.sessionId!, exerciseId);
      } catch (error) {
        state = state.copyWith(backendError: error.toString());
        return;
      }
    }
    final list = [...state.exercises]..removeAt(index);
    state = state.copyWith(exercises: list);
  }

  void toggleExpand(int index) {
    final list = [...state.exercises];
    final ex = list[index];
    list[index] = ActiveExercise(
      id: ex.id,
      name: ex.name,
      muscle: ex.muscle,
      expanded: !ex.expanded,
      sets: ex.sets,
    );
    state = state.copyWith(exercises: list);
  }

  Future<void> completeAllUnfinished() async {
    final sessionId = state.sessionId;
    if (sessionId == null) return;
    state = state.copyWith(saving: true, clearBackendError: true);
    try {
      for (final exercise in state.exercises) {
        final exerciseId = _isUuid(exercise.id)
            ? exercise.id
            : await _data.exerciseIdForName(exercise.name);
        for (var i = 0; i < exercise.sets.length; i++) {
          final set = exercise.sets[i];
          if (!set.done) {
            await _data.logSet(
              sessionId: sessionId,
              exerciseId: exerciseId,
              setIndex: i + 1,
              reps: set.reps,
              weight: set.weight,
            );
            set.done = true;
          }

        }
      }
      await _data.finishSession(sessionId);
    } catch (error) {
      state = state.copyWith(saving: false, backendError: error.toString());
      return;
    }
    final list = state.exercises.map((ex) {
      for (final s in ex.sets) {
        s.done = true;
      }
      return ex;
    }).toList();
    state = state.copyWith(
      exercises: list,
      finished: true,
      hasSession: false,
      clearRestName: true,
      restRunning: false,
      saving: false,
    );
  }

  bool _isUuid(String value) => RegExp(
        r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
      ).hasMatch(value);

  Future<void> discardSetsAndFinish() async {
    final sessionId = state.sessionId;
    if (sessionId == null) return;
    state = state.copyWith(saving: true, clearBackendError: true);
    try {
      await _data.finishSession(sessionId);
      state = state.copyWith(
        finished: true,
        hasSession: false,
        clearRestName: true,
        restRunning: false,
        saving: false,
      );
    } catch (error) {
      state = state.copyWith(saving: false, backendError: error.toString());
    }
  }

  Future<void> discardWorkout() async {
    _mutation++;
    final id = state.sessionId;
    if (id != null) {
      try {
        await _data.discardSession(id);
      } catch (error) {
        state = state.copyWith(backendError: error.toString());
        return;
      }
    }
    state = const ActiveWorkoutState();
  }

  void startRest(String name, {int seconds = 60}) {
    state = state.copyWith(
      restRunning: true,
      restSeconds: seconds,
      restTotal: seconds,
      restExerciseName: name,
    );
  }

  void tickRest() {
    if (!state.restRunning) return;
    if (state.restSeconds <= 0) {
      state = state.copyWith(restRunning: false, restSeconds: 0);
      return;
    }
    state = state.copyWith(restSeconds: state.restSeconds - 1);
  }

  void adjustRest(int delta) {
    final next = (state.restSeconds + delta).clamp(0, 600);
    final total = state.restTotal < next ? next : state.restTotal;
    state = state.copyWith(restSeconds: next, restTotal: total, restRunning: true);
  }

  void skipRest() {
    state = state.copyWith(restRunning: false, restSeconds: 0, clearRestName: true);
  }
}

final activeWorkoutProvider =
    StateNotifierProvider<ActiveWorkoutNotifier, ActiveWorkoutState>((ref) => ActiveWorkoutNotifier(ref));

class WorkoutCatalog {
  static IconData muscleIcon(String muscle) {
    switch (muscle.toLowerCase()) {
      case 'chest':
        return Icons.accessibility_new;
      case 'shoulders':
      case 'delts':
        return Icons.sports_gymnastics;
      case 'back':
      case 'lats':
      case 'traps':
        return Icons.shield_outlined;
      case 'arms':
      case 'biceps':
      case 'triceps':
      case 'forearms':
        return Icons.fitness_center;
      case 'legs':
      case 'quads':
      case 'hamstrings':
      case 'calves':
      case 'glutes':
        return Icons.directions_walk;
      case 'core':
      case 'waist':
      case 'abs':
        return Icons.self_improvement;
      case 'cardio':
        return Icons.directions_run;
      default:
        return Icons.fitness_center;
    }
  }
}

String formatRest(int seconds) {
  final m = seconds ~/ 60;
  final s = seconds % 60;
  return '$m:${s.toString().padLeft(2, '0')}';
}
