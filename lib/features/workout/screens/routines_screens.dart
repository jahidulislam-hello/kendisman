import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/features/workout/data/workout_data.dart';

class YourRoutinesScreen extends ConsumerWidget {
  const YourRoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final plans = ref.watch(plansProvider);

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
              child: ListView.separated(
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
                                child: _btn(colors, 'Activate', () => ref.read(plansProvider.notifier).activate(plan.id)),
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
  _DayEx({required this.id, required this.name, this.sets = '3', this.r1 = '8', this.r2 = '8', this.weight = '20'});
}

class _Day {
  String title;
  List<_DayEx> exercises;
  _Day({required this.title, required this.exercises});
}

class _WorkoutBuildRoutineScreenState extends ConsumerState<WorkoutBuildRoutineScreen> {
  final name = TextEditingController(text: 'Jgh');
  final days = <_Day>[
    _Day(title: 'Day 6', exercises: [_DayEx(id: 'dbc', name: 'Dumbbell Bicep Curl')]),
  ];

  @override
  void dispose() {
    name.dispose();
    super.dispose();
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
                                  final def = WorkoutCatalog.byId(id);
                                  setState(() => day.exercises.add(_DayEx(id: def.id, name: def.name, weight: def.defaultWeight.toStringAsFixed(0))));
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
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.accent,
                        foregroundColor: colors.onAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Save routine', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
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

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.plan?.name ?? 'jml');
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final plan = widget.plan ?? ref.watch(plansProvider).firstWhere((p) => p.active);

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
                    onPressed: () => Navigator.pop(context),
                    child: Text('SAVE', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
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
