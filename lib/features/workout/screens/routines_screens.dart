import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/core/services/fitness_data_service.dart';
import 'package:fitzella/features/workout/data/workout_data.dart';

class YourRoutinesScreen extends ConsumerWidget {
  const YourRoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final programs = ref.watch(routineLibraryProvider);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.chevron_left, color: colors.textPrimary, size: 26),
                    label: Text('Back', style: TextStyle(color: colors.textPrimary)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text('Your routines', style: TextStyle(color: colors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: programs.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Could not load your routines: $error',
                            style: TextStyle(color: colors.textPrimary),
                            textAlign: TextAlign.center),
                        TextButton(
                          onPressed: () => ref.invalidate(routineLibraryProvider),
                          child: const Text('Try again'),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (rows) {
                  final plans = rows.map((row) {
                    final routines = (row['routines'] as List? ?? const [])
                        .cast<Map<String, dynamic>>()
                      ..sort((a, b) => (a['day_index'] as int? ?? 0)
                          .compareTo(b['day_index'] as int? ?? 0));
                    return PlanDef(
                      id: row['id'] as String,
                      name: row['name'] as String? ?? 'Program',
                      active: row['is_active'] as bool? ?? false,
                      aiGenerated: row['is_ai_generated'] as bool? ?? false,
                      days: routines.map((routine) {
                        final exercises =
                            (routine['routine_exercises'] as List? ?? const [])
                                .cast<Map<String, dynamic>>()
                              ..sort((a, b) =>
                                  (a['order_index'] as int? ?? 0)
                                      .compareTo(b['order_index'] as int? ?? 0));
                        return RoutineDay(
                          id: routine['id'] as String,
                          name: routine['name'] as String? ?? 'Workout',
                          exerciseIds: exercises
                              .map((item) => item['exercise_id'] as String)
                              .toList(),
                          exerciseNames: exercises
                              .map((item) =>
                                  (item['exercises'] as Map<String, dynamic>?)?['name'] as String? ??
                                  'Exercise')
                              .toList(),
                          tag: '',
                        );
                      }).toList(),
                    );
                  }).toList();
                  if (plans.isEmpty) {
                    return Center(
                      child: Text('No routines yet. Build a routine to get started.',
                          style: TextStyle(color: colors.textSecondary),
                          textAlign: TextAlign.center),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    itemCount: plans.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                  final plan = plans[i];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: plan.active ? colors.accent : colors.border, width: plan.active ? 1.5 : 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(plan.name, style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
                            if (plan.active) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: colors.accent, borderRadius: BorderRadius.circular(20)),
                                child: Text('Active', style: TextStyle(color: colors.onAccent, fontSize: 11, fontWeight: FontWeight.w800)),
                              ),
                            ],
                            const Spacer(),
                            Icon(Icons.chevron_right, color: colors.accent),
                          ],
                        ),
                        if (plan.aiGenerated)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text('AI-generated', style: TextStyle(color: colors.textMuted, fontSize: 12)),
                          ),
                        const SizedBox(height: 8),
                        Text('View progress chart', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            if (!plan.active)
                              Expanded(
                                child: _btn(colors, 'Activate', () async {
                                  try {
                                    await ref.read(fitnessDataServiceProvider).activateProgram(plan.id);
                                    ref.invalidate(routineLibraryProvider);
                                    ref.invalidate(homeSummaryProvider);
                                  } catch (error) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Could not activate routine: $error')),
                                      );
                                    }
                                  }
                                }),
                              ),
                            if (!plan.active) const SizedBox(width: 8),
                            Expanded(
                              child: _btn(colors, 'Edit', () => context.push('/workout/build-routine')),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _btn(colors, 'Weekly Schedule', () => context.push('/workout/weekly-schedule', extra: plan)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () => context.push('/workout/build-routine'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accent,
                foregroundColor: colors.onAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('+ Build a new routine', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _btn(dynamic colors, String label, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.textPrimary,
        side: BorderSide(color: colors.border),
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
    );
  }
}

class WorkoutBuildRoutineScreen extends ConsumerStatefulWidget {
  const WorkoutBuildRoutineScreen({super.key});

  @override
  ConsumerState<WorkoutBuildRoutineScreen> createState() => _WorkoutBuildRoutineScreenState();
}

class _DayEx {
  String id;
  String name;
  String sets;
  String r1;
  String r2;
  String weight;
  _DayEx({
    required this.id,
    required this.name,
    required this.sets,
    required this.r1,
    required this.r2,
    required this.weight,
  });
}

class _Day {
  String title;
  List<_DayEx> exercises;
  _Day({required this.title, required this.exercises});
}

class _WorkoutBuildRoutineScreenState extends ConsumerState<WorkoutBuildRoutineScreen> {
  final name = TextEditingController();
  bool _saving = false;
  String? _saveError;
  final days = <_Day>[
    _Day(title: 'Day 1', exercises: []),
  ];

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  Future<void> _saveRoutine() async {
    if (name.text.trim().isEmpty ||
        days.isEmpty ||
        days.any((day) => day.exercises.isEmpty)) {
      setState(() => _saveError =
          'Enter a routine name and add at least one exercise to each day.');
      return;
    }
    setState(() {
      _saving = true;
      _saveError = null;
    });
    try {
      await ref.read(fitnessDataServiceProvider).createProgram(
            name: name.text.trim(),
            days: days
                .map((day) => day.exercises
                    .map((exercise) => <String, dynamic>{
                          'name': exercise.name,
                          'sets': exercise.sets,
                          'reps': exercise.r1,
                          'weight': exercise.weight,
                        })
                    .toList())
                .toList(),
          );
      ref.invalidate(routineLibraryProvider);
      ref.invalidate(homeSummaryProvider);
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _saveError = 'Could not save routine: $error';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final emptyDay = days.any((d) => d.exercises.isEmpty);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.chevron_left, color: colors.textPrimary, size: 26),
                    label: Text('Back', style: TextStyle(color: colors.textPrimary)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text('Build routine', style: TextStyle(color: colors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  if (_saveError != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(_saveError!,
                          style: TextStyle(color: colors.danger)),
                    ),
                  if (emptyDay)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text('"Day ${days.indexWhere((d) => d.exercises.isEmpty) + 1}" needs at least one exercise.', style: TextStyle(color: colors.danger, fontWeight: FontWeight.w600)),
                    ),
                  Text('ROUTINE NAME', style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: name,
                    style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colors.surface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('TRAINING DAYS PER WEEK: ${days.length}', style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),
                  ...List.generate(days.length, (di) {
                    final day = days[di];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: colors.border)),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: colors.background, borderRadius: BorderRadius.circular(10)),
                            child: Text(day.title, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(height: 10),
                          ...List.generate(day.exercises.length, (ei) {
                            final ex = day.exercises[ei];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: colors.background, borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: Text(ex.name, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w800))),
                                      TextButton(
                                        onPressed: () => setState(() => day.exercises.removeAt(ei)),
                                        child: Text('Remove', style: TextStyle(color: colors.danger, fontWeight: FontWeight.w700)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      _field(colors, 'SETS', ex.sets, (v) => ex.sets = v),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('REPS', style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.w700)),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Expanded(child: _box(colors, ex.r1, (v) => ex.r1 = v)),
                                                Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: Text('-', style: TextStyle(color: colors.textMuted))),
                                                Expanded(child: _box(colors, ex.r2, (v) => ex.r2 = v)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _field(colors, 'WEIGHT (LB)', ex.weight, (v) => ex.weight = v, flex: 2),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () async {
                                final id = await context.push<String>('/workout/add-exercise');
                                if (id != null) {
                                  try {
                                    final exercises = await ref
                                        .read(exerciseCatalogProvider.future);
                                    final exercise = exercises.firstWhere(
                                        (item) => item['id'] == id);
                                    final exerciseName =
                                        exercise['name'] as String;
                                    if (mounted) {
                                      setState(() => day.exercises.add(_DayEx(
                                            id: id,
                                            name: exerciseName,
                                            sets: '3',
                                            r1: '8',
                                            r2: '8',
                                            weight: '0',
                                          )));
                                    }
                                  } catch (error) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Could not add exercise: $error')),
                                      );
                                    }
                                  }
                                }
                              },
                              child: Text('+ Add exercise', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w800)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  TextButton(
                    onPressed: () => setState(() => days.add(_Day(title: 'Day ${days.length + 1}', exercises: []))),
                    child: Text('+ Add another day', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.accent,
                        foregroundColor: colors.onAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _saving ? null : _saveRoutine,
                      child: Text(_saving ? 'Saving…' : 'Save routine', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(dynamic colors, String label, String value, ValueChanged<String> onChanged, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          _box(colors, value, onChanged),
        ],
      ),
    );
  }

  Widget _box(dynamic colors, String value, ValueChanged<String> onChanged) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: colors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: colors.border)),
      ),
    );
  }
}

class WeeklyScheduleScreen extends ConsumerStatefulWidget {
  final PlanDef? plan;
  const WeeklyScheduleScreen({super.key, this.plan});

  @override
  ConsumerState<WeeklyScheduleScreen> createState() => _WeeklyScheduleScreenState();
}

class _WeeklyScheduleScreenState extends ConsumerState<WeeklyScheduleScreen> {
  late TextEditingController name;
  final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final assigned = <String, String?>{};
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.plan?.name ?? 'jml');
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    final plan = widget.plan;
    if (plan == null) return;
    try {
      final rows = await ref.read(fitnessDataServiceProvider).fetchSchedule(plan.id);
      if (!mounted) return;
      setState(() {
        for (final row in rows) {
          final weekday = (row['weekday'] as num).toInt();
          if (weekday >= 0 && weekday < days.length) {
            final routine = plan.days
                .where((day) => day.id == row['routine_id'])
                .firstOrNull;
            if (routine != null) assigned[days[weekday]] = routine.name;
          }
        }
      });
    } catch (error) {
      if (mounted) setState(() => _error = 'Could not load schedule: $error');
    }
  }

  Future<void> _saveSchedule(PlanDef plan) async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final schedule = <int, String>{};
      for (var weekday = 0; weekday < days.length; weekday++) {
        final routineName = assigned[days[weekday]];
        if (routineName == null) continue;
        final routine = plan.days.where((day) => day.name == routineName).firstOrNull;
        if (routine != null) schedule[weekday] = routine.id;
      }
      await ref.read(fitnessDataServiceProvider).saveSchedule(
            programId: plan.id,
            programName: name.text,
            weekdayRoutines: schedule,
          );
      ref.invalidate(routineLibraryProvider);
      ref.invalidate(homeSummaryProvider);
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Could not save schedule: $error';
        });
      }
    }
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final plan = widget.plan;
    if (plan == null) {
      return Scaffold(
        backgroundColor: colors.background,
        body: Center(
          child: Text('Select a saved program to edit its schedule.',
              style: TextStyle(color: colors.textPrimary)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.chevron_left, color: colors.textPrimary, size: 28)),
                  Expanded(child: Text('Weekly Schedule', textAlign: TextAlign.center, style: TextStyle(color: colors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700))),
                  TextButton(
                    onPressed: _saving ? null : () => _saveSchedule(plan),
                    child: Text(_saving ? 'SAVING…' : 'SAVE', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(_error!, style: TextStyle(color: colors.danger)),
                    ),
                  Text('PLAN NAME', style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: name,
                    style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colors.surface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text('SCHEDULE', style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  const SizedBox(height: 10),
                  ...days.map((d) {
                    final value = assigned[d];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: colors.border)),
                      child: Row(
                        children: [
                          Expanded(child: Text(d, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w800))),
                          TextButton(
                            onPressed: () async {
                              final picked = await showModalBottomSheet<String>(
                                context: context,
                                backgroundColor: colors.surface,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                                builder: (ctx) => SafeArea(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(width: 40, height: 4, decoration: BoxDecoration(color: colors.border, borderRadius: BorderRadius.circular(2))),
                                        const SizedBox(height: 12),
                                        Text(d, style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
                                        const SizedBox(height: 14),
                                        ...plan.days.map((day) => Padding(
                                              padding: const EdgeInsets.only(bottom: 8),
                                              child: ListTile(
                                                onTap: () => Navigator.pop(ctx, day.name),
                                                tileColor: colors.background,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                title: Text(day.name, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700)),
                                              ),
                                            )),
                                        OutlinedButton(
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            context.push('/workout/new-routine');
                                          },
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: colors.accent,
                                            side: BorderSide(color: colors.border),
                                            minimumSize: const Size.fromHeight(48),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          ),
                                          child: const Text('+ New Routine', style: TextStyle(fontWeight: FontWeight.w800)),
                                        ),
                                        TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: TextStyle(color: colors.textSecondary))),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                              if (picked != null) setState(() => assigned[d] = picked);
                            },
                            child: Text(value ?? '+ Add Routine', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w800)),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
