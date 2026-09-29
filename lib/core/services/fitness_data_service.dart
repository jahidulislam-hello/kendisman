import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:fitzella/core/services/supabase_service.dart';

final fitnessDataServiceProvider = Provider<FitnessDataService>(
  (ref) => FitnessDataService(ref.watch(supabaseClientProvider)),
);

final workoutHistoryProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(fitnessDataServiceProvider).fetchWorkoutHistory();
});

final workoutSessionDetailProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, sessionId) {
  return ref.watch(fitnessDataServiceProvider).fetchWorkoutSession(sessionId);
});

final exerciseCatalogProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(fitnessDataServiceProvider).fetchExercises();
});

final routineLibraryProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(fitnessDataServiceProvider).fetchPrograms();
});

final goalsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(fitnessDataServiceProvider).fetchGoals();
});

final goalDetailProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, goalId) {
  return ref.watch(fitnessDataServiceProvider).fetchGoal(goalId);
});

final bodyMeasurementsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(fitnessDataServiceProvider).fetchMeasurements();
});

final personalRecordsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(fitnessDataServiceProvider).fetchPersonalRecords();
});

final mainExercisesProvider =
    FutureProvider.family<List<Map<String, dynamic>>, int?>((ref, days) {
  return ref.watch(fitnessDataServiceProvider).fetchMainExercises(days: days);
});

final accountPreferencesProvider =
    FutureProvider<Map<String, dynamic>>((ref) {
  return ref.watch(fitnessDataServiceProvider).fetchAccountPreferences();
});

class FitnessDataService {
  FitnessDataService(this._client);

  final SupabaseClient _client;

  String get _userId {
    final id = _client.auth.currentUser?.id;
    if (id == null) throw StateError('Sign in to access your fitness data.');
    return id;
  }

  Future<Map<String, dynamic>> fetchAccountPreferences() async {
    return await _client
        .from('users')
        .select(
          'unit_preference,theme_preference,distance_preference,'
          'body_measurement_preference,notifications_enabled,notification_days,'
          'rest_timer_enabled,rest_timer_default_override_seconds,'
          'language_preference,timer_sound_preference',
        )
        .eq('id', _userId)
        .single();
  }

  Future<void> updateAccountPreference(String column, dynamic value) async {
    const allowed = {
      'distance_preference',
      'body_measurement_preference',
      'notification_days',
      'language_preference',
      'timer_sound_preference',
    };
    if (!allowed.contains(column)) {
      throw ArgumentError.value(column, 'column', 'Unsupported preference');
    }
    await _client
        .from('users')
        .update({column: value}).eq('id', _userId);
  }

  Future<void> submitFeedback({
    required String category,
    required String message,
  }) async {
    final text = message.trim();
    if (text.isEmpty) throw ArgumentError('Feedback cannot be empty.');
    const categories = {'feature_request', 'bug_report', 'general_feedback'};
    if (!categories.contains(category)) {
      throw ArgumentError.value(category, 'category', 'Unsupported feedback type');
    }
    await _client.from('user_feedback').insert({
      'user_id': _userId,
      'category': category,
      'message': text,
    });
  }

  Future<List<Map<String, dynamic>>> fetchExercises() async {
    final rows = await _client
        .from('exercises')
        .select('id,name,muscle_group,equipment_type,is_custom')
        .or('is_custom.eq.false,created_by_user_id.eq.$_userId')
        .order('name');
    return List<Map<String, dynamic>>.from(rows);
  }

  Future<List<Map<String, dynamic>>> fetchPrograms() async {
    final rows = await _client
        .from('programs')
        .select(
          'id,name,is_active,is_ai_generated,routines(id,name,day_index,'
          'routine_exercises(id,exercise_id,order_index,target_sets,target_reps,target_weight,'
          'exercises(id,name,muscle_group,equipment_type)))',
        )
        .eq('user_id', _userId)
        .order('created_at');
    return List<Map<String, dynamic>>.from(rows);
  }

  Future<void> activateProgram(String id) async {
    await _client
        .from('programs')
        .update({'is_active': false})
        .eq('user_id', _userId)
        .eq('is_active', true);
    await _client
        .from('programs')
        .update({'is_active': true})
        .eq('user_id', _userId)
        .eq('id', id);
  }

  Future<List<Map<String, dynamic>>> fetchSchedule(String programId) async {
    final rows = await _client
        .from('plan_schedule')
        .select('weekday,routine_id')
        .eq('program_id', programId)
        .order('weekday');
    return List<Map<String, dynamic>>.from(rows);
  }

  Future<void> saveSchedule({
    required String programId,
    required String programName,
    required Map<int, String> weekdayRoutines,
  }) async {
    await _client
        .from('programs')
        .update({'name': programName.trim()})
        .eq('user_id', _userId)
        .eq('id', programId);
    await _client.from('plan_schedule').delete().eq('program_id', programId);
    if (weekdayRoutines.isNotEmpty) {
      await _client.from('plan_schedule').insert(
            weekdayRoutines.entries
                .map((entry) => {
                      'program_id': programId,
                      'weekday': entry.key,
                      'routine_id': entry.value,
                    })
                .toList(),
          );
    }
  }

  Future<void> createProgram({
    required String name,
    required List<List<Map<String, dynamic>>> days,
  }) async {
    final userId = _userId;
    final program = await _client
        .from('programs')
        .insert({'user_id': userId, 'name': name.trim(), 'is_active': false})
        .select('id')
        .single();
    final programId = program['id'] as String;
    try {
      for (var dayIndex = 0; dayIndex < days.length; dayIndex++) {
        final routine = await _client
            .from('routines')
            .insert({
              'user_id': userId,
              'program_id': programId,
              'name': 'Day ${dayIndex + 1}',
              'day_index': dayIndex,
            })
            .select('id')
            .single();
        final routineId = routine['id'] as String;
        for (var order = 0; order < days[dayIndex].length; order++) {
          final item = days[dayIndex][order];
          final itemExerciseId = item['id'] as String?;
          final exerciseId = itemExerciseId != null &&
                  RegExp(
                    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
                  ).hasMatch(itemExerciseId)
              ? itemExerciseId
              : await exerciseIdForName(item['name'] as String);
          await _client.from('routine_exercises').insert({
            'routine_id': routineId,
            'exercise_id': exerciseId,
            'order_index': order,
            'target_sets': int.parse(item['sets'] as String),
            'target_reps': int.parse(item['reps'] as String),
            'target_weight': double.parse(item['weight'] as String),
          });
        }
      }
    } catch (_) {
      await _client
          .from('programs')
          .delete()
          .eq('id', programId)
          .eq('user_id', userId);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchWorkoutHistory({int? limit}) async {
    if (limit != null) return _fetchWorkoutHistoryPage(offset: 0, limit: limit);
    const pageSize = 500;
    var offset = 0;
    final sessions = <Map<String, dynamic>>[];
    while (true) {
      final page = await _fetchWorkoutHistoryPage(
        offset: offset,
        limit: pageSize,
      );
      sessions.addAll(page);
      if (page.length < pageSize) return sessions;
      offset += pageSize;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchWorkoutHistoryPage({
    required int offset,
    required int limit,
  }) async {
    final rows = await _client
        .from('workout_sessions')
        .select(
          'id,routine_id,started_at,completed_at,routine_name,'
          'routines(name),logged_sets(id,exercise_id,set_index,reps,weight,rpe,completed_at,'
          'exercises(id,name,muscle_group,equipment_type))',
        )
        .eq('user_id', _userId)
        .not('completed_at', 'is', null)
        .order('started_at', ascending: false)
        .order('id')
        .range(offset, offset + limit - 1);
    return List<Map<String, dynamic>>.from(rows);
  }

  Future<Map<String, dynamic>?> fetchWorkoutSession(String sessionId) async {
    final session = await _client
        .from('workout_sessions')
        .select(
          'id,routine_id,started_at,completed_at,routine_name,'
          'routines(name),logged_sets(id,exercise_id,set_index,reps,weight,rpe,completed_at,'
          'exercises(id,name,muscle_group,equipment_type))',
        )
        .eq('user_id', _userId)
        .eq('id', sessionId)
        .maybeSingle();
    return session;
  }

  Future<List<Map<String, dynamic>>> fetchPersonalRecords() async {
    final sessions = await fetchWorkoutHistory();
    final byExercise = <String, List<Map<String, dynamic>>>{};
    for (final session in sessions) {
      final date = DateTime.parse(session['started_at'] as String).toLocal();
      for (final set in (session['logged_sets'] as List? ?? const [])
          .cast<Map<String, dynamic>>()) {
        final exerciseId = set['exercise_id'] as String;
        final exercise = set['exercises'] as Map<String, dynamic>? ?? {};
        final weight = (set['weight'] as num?)?.toDouble() ?? 0;
        final reps = (set['reps'] as num?)?.toInt() ?? 0;
        final item = <String, dynamic>{
          'exercise_id': exerciseId,
          'name': exercise['name'] as String? ?? 'Exercise',
          'muscle_group': exercise['muscle_group'] as String? ?? '',
          'weight': weight,
          'reps': reps,
          'one_rm': reps > 0 ? weight * (1 + reps / 30) : weight,
          'date': date,
        };
        byExercise.putIfAbsent(exerciseId, () => []).add(item);
      }
    }
    final records = <Map<String, dynamic>>[];
    for (final exerciseRows in byExercise.values) {
      exerciseRows.sort((a, b) =>
          (b['one_rm'] as double).compareTo(a['one_rm'] as double));
      final best = exerciseRows.first;
      final latest = exerciseRows.toList()
        ..sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
      final previousValue = exerciseRows
          .where((row) =>
              (row['date'] as DateTime).isBefore(best['date'] as DateTime))
          .firstOrNull;
      final previous = previousValue == null ? null : previousValue['one_rm'] as double;
      records.add({
        ...best,
        'latest_date': latest.first['date'],
        'previous_one_rm': previous,
        'delta': previous == null ? null : (best['one_rm'] as double) - previous,
      });
    }
    records.sort((a, b) =>
        (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    return records;
  }

  Future<List<Map<String, dynamic>>> fetchMainExercises({int? days}) async {
    final sessions = await fetchWorkoutHistory();
    final cutoff =
        days == null ? null : DateTime.now().subtract(Duration(days: days));
    final uses = <String, Map<String, dynamic>>{};
    for (final session in sessions) {
      final date = DateTime.parse(session['started_at'] as String).toLocal();
      if (cutoff != null && date.isBefore(cutoff)) continue;
      final sessionExerciseIds = <String>{};
      for (final set in (session['logged_sets'] as List? ?? const [])
          .cast<Map<String, dynamic>>()) {
        final id = set['exercise_id'] as String;
        final exercise = set['exercises'] as Map<String, dynamic>? ?? {};
        final row = uses.putIfAbsent(id, () => {
              'id': id,
              'name': exercise['name'] as String? ?? 'Exercise',
              'muscle': exercise['muscle_group'] as String? ?? '',
              'sessions': 0,
              'volume': 0.0,
            });
        row['volume'] = (row['volume'] as double) +
            ((set['weight'] as num?)?.toDouble() ?? 0) *
                ((set['reps'] as num?)?.toInt() ?? 0);
        sessionExerciseIds.add(id);
      }
      for (final id in sessionExerciseIds) {
        uses[id]!['sessions'] = (uses[id]!['sessions'] as int) + 1;
      }
    }
    final result = uses.values.toList()
      ..sort((a, b) => (b['sessions'] as int).compareTo(a['sessions'] as int));
    return result;
  }

  Future<Map<String, dynamic>?> fetchActiveSession() async {
    return await _client
        .from('workout_sessions')
        .select(
          'id,routine_id,started_at,routine_name,'
          'routines(id,name,program_id,day_index,routine_exercises(id,exercise_id,'
          'order_index,target_sets,target_reps,target_weight,exercises(id,name,muscle_group,equipment_type))),'
          'logged_sets(id,exercise_id,set_index,reps,weight,exercises(id,name,muscle_group,equipment_type))',
        )
        .eq('user_id', _userId)
        .isFilter('completed_at', null)
        .order('started_at', ascending: false)
        .limit(1)
        .maybeSingle();
  }

  Future<Map<String, dynamic>> startSession(
      {String? routineId, String? title}) async {
    final userId = _userId;
    final user = await _client
        .from('users')
        .select('mode')
        .eq('id', userId)
        .single();
    return await _client
        .from('workout_sessions')
        .insert({
          'user_id': userId,
          'routine_id': routineId,
          'routine_name': title,
          'mode_at_time': user['mode'] ?? 'manual',
        })
        .select('id,started_at,routine_id')
        .single();
  }

  Future<Map<String, dynamic>> fetchRoutine(String id) async {
    return await _client
        .from('routines')
        .select(
          'id,name,routine_exercises(id,exercise_id,order_index,target_sets,'
          'target_reps,target_reps_min,target_reps_max,target_weight,'
          'exercises(id,name,muscle_group,equipment_type))',
        )
        .eq('user_id', _userId)
        .eq('id', id)
        .single();
  }

  Future<void> logSet({
    required String sessionId,
    required String exerciseId,
    required int setIndex,
    required int reps,
    required double weight,
    double? rpe,
  }) async {
    await _client.from('logged_sets').insert({
      'session_id': sessionId,
      'exercise_id': exerciseId,
      'set_index': setIndex,
      'reps': reps,
      'weight': weight,
      'rpe': rpe,
    });
  }

  Future<void> removeExerciseSets(
      String sessionId, String exerciseId) async {
    await _client
        .from('logged_sets')
        .delete()
        .eq('session_id', sessionId)
        .eq('exercise_id', exerciseId);
  }

  Future<void> removeLoggedSet({
    required String sessionId,
    required String exerciseId,
    required int setIndex,
  }) async {
    await _client
        .from('logged_sets')
        .delete()
        .eq('session_id', sessionId)
        .eq('exercise_id', exerciseId)
        .eq('set_index', setIndex);
  }

  Future<void> updateLoggedSet({
    required String sessionId,
    required String exerciseId,
    required int setIndex,
    required int reps,
    required double weight,
  }) async {
    await _client
        .from('logged_sets')
        .update({'reps': reps, 'weight': weight})
        .eq('session_id', sessionId)
        .eq('exercise_id', exerciseId)
        .eq('set_index', setIndex);
  }

  Future<String> exerciseIdForName(String name) async {
    final row = await _client
        .from('exercises')
        .select('id')
        .eq('name', name)
        .limit(1)
        .maybeSingle();
    if (row == null) {
      throw StateError('“$name” is not available in the exercise library.');
    }

    return row['id'] as String;
  }

  Future<Map<String, dynamic>> fetchExercise(String id) async {
    return await _client
        .from('exercises')
        .select('id,name,muscle_group,equipment_type')
        .eq('id', id)
        .single();
  }

  Future<void> finishSession(String id) async {
    await _client
        .from('workout_sessions')
        .update({'completed_at': DateTime.now().toUtc().toIso8601String()})
        .eq('id', id)
        .eq('user_id', _userId);
  }

  Future<void> renameQuickWorkout(String id, String name) async {
    await _client
        .from('workout_sessions')
        .update({'routine_name': name.trim()})
        .eq('id', id)
        .eq('user_id', _userId)
        .isFilter('routine_id', null);
  }

  Future<void> discardSession(String id) async {
    await _client
        .from('workout_sessions')
        .delete()
        .eq('id', id)
        .eq('user_id', _userId);
  }

  Future<List<Map<String, dynamic>>> fetchGoals(
      {String? status}) async {
    final userId = _userId;
    var query = _client
        .from('goals')
        .select('*,exercises(name)')
        .eq('user_id', userId);
    if (status != null) query = query.eq('status', status);
    final rows = await query.order('created_at', ascending: false);
    final goals = List<Map<String, dynamic>>.from(rows);
    final now = DateTime.now();
    final startOfWeek =
        DateTime(now.year, now.month, now.day - (now.weekday - 1));
    for (final goal in goals) {
      final target = (goal['target_value'] as num?)?.toDouble() ?? 0;
      final start = (goal['start_value'] as num?)?.toDouble();
      double current = 0;
      switch (goal['goal_type']) {
        case 'strength':
          final exerciseId = goal['exercise_id'] as String?;
          if (exerciseId != null) {
            final row = await _client
                .from('logged_sets')
                .select('weight,workout_sessions!inner(user_id)')
                .eq('exercise_id', exerciseId)
                .eq('workout_sessions.user_id', userId)
                .order('weight', ascending: false)
                .limit(1)
                .maybeSingle();
            current = (row?['weight'] as num?)?.toDouble() ?? 0;
          }
          break;
        case 'body_comp':
          final metric = goal['metric'] as String?;
          final column = metric == 'body_fat' ? 'body_fat_pct' : 'weight_lb';
          final row = await _client
              .from('body_measurements')
              .select(column)
              .eq('user_id', userId)
              .not(column, 'is', null)
              .order('measured_on', ascending: false)
              .limit(1)
              .maybeSingle();
          current = (row?[column] as num?)?.toDouble() ?? start ?? 0;
          break;
        case 'consistency':
          final count = await _client
              .from('workout_sessions')
              .select('id')
              .eq('user_id', userId)
              .not('completed_at', 'is', null)
              .gte('started_at', startOfWeek.toUtc().toIso8601String());
          current = (count as List).length.toDouble();
          break;
      }
      final isDecrease = goal['direction'] == 'decrease';
      final span = start == null ? target : (target - start).abs();
      final progress = span == 0
          ? (current >= target ? 100 : 0)
          : isDecrease
              ? ((start! - current) / span * 100)
              : ((current - (start ?? 0)) / span * 100);
      goal['current_value'] = current;
      goal['progress_percent'] = progress.clamp(0, 100).round();
    }
    return goals;
  }

  Future<Map<String, dynamic>?> fetchGoal(String goalId) async {
    final goals = await fetchGoals();
    return goals.where((goal) => goal['id'] == goalId).firstOrNull;
  }

  Future<void> createGoal({
    required String type,
    required String title,
    required double targetValue,
    String? exerciseId,
    String? metric,
    double? startValue,
    DateTime? dueDate,
  }) async {
    await _client.from('goals').insert({
      'user_id': _userId,
      'goal_type': type,
      'title': title,
      'target_value': targetValue,
      'exercise_id': exerciseId,
      'metric': metric,
      'start_value': startValue,
      'direction':
          startValue != null && targetValue < startValue ? 'decrease' : 'increase',
      'due_date': dueDate?.toIso8601String().substring(0, 10),
    });
  }

  Future<void> deleteGoal(String goalId) async {
    await _client.from('goals').delete().eq('id', goalId).eq('user_id', _userId);
  }

  Future<void> completeGoal(String goalId) async {
    await _client.from('goals').update({
      'status': 'completed',
      'completed_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', goalId).eq('user_id', _userId);
  }

  Future<List<Map<String, dynamic>>> fetchMeasurements({int? limit}) async {
    if (limit != null) {
      return _fetchMeasurementPage(offset: 0, limit: limit);
    }
    const pageSize = 500;
    var offset = 0;
    final measurements = <Map<String, dynamic>>[];
    while (true) {
      final page = await _fetchMeasurementPage(
        offset: offset,
        limit: pageSize,
      );
      measurements.addAll(page);
      if (page.length < pageSize) return measurements;
      offset += pageSize;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchMeasurementPage({
    required int offset,
    required int limit,
  }) async {
    final rows = await _client
        .from('body_measurements')
        .select('id,measured_on,weight_lb,body_fat_pct')
        .eq('user_id', _userId)
        .order('measured_on', ascending: false)
        .order('id')
        .range(offset, offset + limit - 1);
    return List<Map<String, dynamic>>.from(rows);
  }

  Future<void> addMeasurement({
    required DateTime measuredOn,
    double? weightLb,
    double? bodyFatPct,
  }) async {
    if (weightLb == null && bodyFatPct == null) {
      throw ArgumentError('Enter body weight or body-fat percentage.');
    }
    await _client.from('body_measurements').insert({
      'user_id': _userId,
      'measured_on': measuredOn.toIso8601String().substring(0, 10),
      'weight_lb': weightLb,
      'body_fat_pct': bodyFatPct,
    });
  }

  Future<double?> fetchLatestMeasurementValue(String metric) async {
    final column = switch (metric) {
      'body_fat' => 'body_fat_pct',
      'weight' => 'weight_lb',
      _ => throw ArgumentError.value(metric, 'metric', 'Unsupported measurement'),
    };
    final row = await _client
        .from('body_measurements')
        .select(column)
        .eq('user_id', _userId)
        .not(column, 'is', null)
        .order('measured_on', ascending: false)
        .limit(1)
        .maybeSingle();
    return (row?[column] as num?)?.toDouble();
  }

  Future<Map<String, dynamic>> fetchHomeSummary() async {
    final userId = _userId;
    final now = DateTime.now();
    final startOfWeek =
        DateTime(now.year, now.month, now.day - (now.weekday - 1));
    final lastWeek = startOfWeek.subtract(const Duration(days: 7));
    final rows = await _client
        .from('workout_sessions')
        .select('id,started_at,completed_at,routine_id,routines(name),'
            'logged_sets(reps,weight)')
        .eq('user_id', userId)
        .not('completed_at', 'is', null)
        .gte('started_at', lastWeek.toUtc().toIso8601String())
        .order('started_at', ascending: false);
    final sessions = List<Map<String, dynamic>>.from(rows);
    var volumeThisWeek = 0.0;
    var volumeLastWeek = 0.0;
    var setsThisWeek = 0;
    var workoutsThisWeek = 0;
    var minutesThisWeek = 0;
    final weekDays = <String>{};
    for (final session in sessions) {
      final started = DateTime.parse(session['started_at'] as String).toLocal();
      final completed = DateTime.parse(session['completed_at'] as String).toLocal();
      final isThisWeek = !started.isBefore(startOfWeek);
      final sets = List<Map<String, dynamic>>.from(
          (session['logged_sets'] as List? ?? const []).cast<Map<String, dynamic>>());
      final volume = sets.fold<double>(
        0,
        (total, set) =>
            total + ((set['weight'] as num?)?.toDouble() ?? 0) *
                ((set['reps'] as num?)?.toInt() ?? 0),
      );
      if (isThisWeek) {
        volumeThisWeek += volume;
        setsThisWeek += sets.length;
        workoutsThisWeek++;
        minutesThisWeek += completed.difference(started).inMinutes;
        weekDays.add('${started.year}-${started.month}-${started.day}');
      } else {
        volumeLastWeek += volume;
      }
    }
    final programs = await _client
        .from('programs')
        .select('id,name,routines(id,name,day_index,routine_exercises(id))')
        .eq('user_id', userId)
        .eq('is_active', true)
        .maybeSingle();
    Map<String, dynamic>? nextRoutine;
    if (programs != null) {
      final routines = (programs['routines'] as List? ?? const [])
          .cast<Map<String, dynamic>>()
        ..sort((a, b) => (a['day_index'] as int? ?? 0)
            .compareTo(b['day_index'] as int? ?? 0));
      final schedule = await _client
          .from('plan_schedule')
          .select('routine_id,weekday')
          .eq('program_id', programs['id'])
          .order('weekday');
      final scheduleRows = List<Map<String, dynamic>>.from(schedule);
      final today = scheduleRows
          .where((entry) => entry['weekday'] == now.weekday - 1)
          .firstOrNull;
      if (scheduleRows.isEmpty) {
        nextRoutine = routines.isEmpty ? null : routines.first;
      } else if (today != null) {
        nextRoutine = routines
            .where((routine) => routine['id'] == today['routine_id'])
            .firstOrNull;
      }
    }
    final streakWeeks = await _fetchWeeklyStreak(userId, startOfWeek);
    return {
      'volume_this_week': volumeThisWeek,
      'volume_last_week': volumeLastWeek,
      'minutes_this_week': minutesThisWeek,
      'sets_this_week': setsThisWeek,
      'workouts_this_week': workoutsThisWeek,
      'week_days': weekDays,
      'program': programs,
      'next_routine': nextRoutine,
      'last_session': sessions.isEmpty ? null : sessions.first,
      'streak_weeks': streakWeeks,
    };
  }

  /// Consecutive Monday-based weeks with at least one completed workout.
  /// The current week only extends the streak; an empty current week does
  /// not break it until the week is over.
  Future<int> _fetchWeeklyStreak(String userId, DateTime startOfWeek) async {
    final rows = await _client
        .from('workout_sessions')
        .select('started_at')
        .eq('user_id', userId)
        .not('completed_at', 'is', null)
        .order('started_at', ascending: false);
    final weeks = <DateTime>{};
    for (final row in rows) {
      final started = DateTime.parse(row['started_at'] as String).toLocal();
      weeks.add(DateTime(
          started.year, started.month, started.day - (started.weekday - 1)));
    }
    var week = weeks.contains(startOfWeek)
        ? startOfWeek
        : DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day - 7);
    var streak = 0;
    while (weeks.contains(week)) {
      streak++;
      week = DateTime(week.year, week.month, week.day - 7);
    }
    return streak;
  }
}

final homeSummaryProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return ref.watch(fitnessDataServiceProvider).fetchHomeSummary();
});
