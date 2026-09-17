import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/features/profile/widgets/profile_widgets.dart';

class BuildRoutineScreen extends ConsumerStatefulWidget {
  const BuildRoutineScreen({super.key});

  @override
  ConsumerState<BuildRoutineScreen> createState() => _BuildRoutineScreenState();
}

class _DayExercise {
  String name;
  String sets;
  String repsMin;
  String repsMax;
  String weight;

  _DayExercise({
    required this.name,
    this.sets = '3',
    this.repsMin = '8',
    this.repsMax = '8',
    this.weight = '95',
  });
}

class _DayBlock {
  String title;
  List<_DayExercise> exercises;

  _DayBlock({required this.title, required this.exercises});
}

class _BuildRoutineScreenState extends ConsumerState<BuildRoutineScreen> {
  final _name = TextEditingController(text: 'Day 3 jml');
  final days = <_DayBlock>[
    _DayBlock(
      title: 'Day 1',
      exercises: [
        _DayExercise(name: 'Barbell Back Squat', weight: '135'),
      ],
    ),
  ];

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);

    return ProfileScaffold(
      title: 'Build routine',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          const ProfileSectionLabel('Routine name'),
          TextField(
            controller: _name,
            style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              filled: true,
              fillColor: colors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'TRAINING DAYS PER WEEK: ${days.length}',
            style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5),
          ),
          const SizedBox(height: 14),
          ...List.generate(days.length, (di) {
            final day = days[di];
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: colors.background,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(day.title, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700)),
                          ),
                        ),
                        if (days.length > 1)
                          TextButton(
                            onPressed: () => setState(() => days.removeAt(di)),
                            child: Text('Remove day', style: TextStyle(color: colors.danger, fontWeight: FontWeight.w600)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(day.exercises.length, (ei) {
                      final ex = day.exercises[ei];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colors.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(ex.name, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700)),
                                  ),
                                  TextButton(
                                    onPressed: () => setState(() => day.exercises.removeAt(ei)),
                                    child: Text('Remove', style: TextStyle(color: colors.danger, fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  _miniField(colors, 'SETS', ex.sets, (v) => ex.sets = v),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('REPS', style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Expanded(child: _box(colors, ex.repsMin, (v) => ex.repsMin = v)),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 6),
                                              child: Text('-', style: TextStyle(color: colors.textMuted)),
                                            ),
                                            Expanded(child: _box(colors, ex.repsMax, (v) => ex.repsMax = v)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _miniField(colors, 'WEIGHT (LB)', ex.weight, (v) => ex.weight = v, flex: 2),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () async {
                          final name = await context.push<String>('/profile/add-exercise');
                          if (name != null) {
                            setState(() => day.exercises.add(_DayExercise(name: name, weight: '40')));
                          }
                        },
                        child: Text('+ Add exercise', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          TextButton(
            onPressed: () => setState(() {
              days.add(_DayBlock(title: 'Day ${days.length + 1}', exercises: []));
            }),
            child: Text('+ Add another day', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w700)),
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
              child: const Text('Save routine', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniField(dynamic colors, String label, String value, ValueChanged<String> onChanged, {int flex = 1}) {
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
      keyboardType: TextInputType.number,
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

class NewRoutineScreen extends ConsumerStatefulWidget {
  const NewRoutineScreen({super.key});

  @override
  ConsumerState<NewRoutineScreen> createState() => _NewRoutineScreenState();
}

class _NewRoutineScreenState extends ConsumerState<NewRoutineScreen> {
  final _name = TextEditingController(text: 'Push day');
  final muscle = 'Chest';
  final sets = List.generate(4, (i) => {'lb': '0', 'reps': '8'});

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            ProfileBackHeader(
              title: 'New Routine',
              centeredTitle: true,
              trailing: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('SAVE', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w800)),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  const ProfileSectionLabel('Routine name'),
                  TextField(
                    controller: _name,
                    style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colors.surface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const ProfileSectionLabel('Muscle groups'),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: colors.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(muscle, style: TextStyle(color: colors.accent, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Add at least one exercise.', style: TextStyle(color: colors.danger, fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colors.border),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text('Cable Fly', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700))),
                            Icon(Icons.more_vert, color: colors.textMuted),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _h(colors, 'SET', flex: 1),
                            _h(colors, 'PREVIOUS', flex: 2),
                            _h(colors, 'LB', flex: 2),
                            _h(colors, 'REPS', flex: 2),
                            const SizedBox(width: 28),
                          ],
                        ),
                        ...List.generate(sets.length, (i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Expanded(child: Text('${i + 1}', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700))),
                                Expanded(flex: 2, child: Text('—', style: TextStyle(color: colors.textMuted))),
                                Expanded(
                                  flex: 2,
                                  child: _small(colors, sets[i]['lb']!, (v) => sets[i]['lb'] = v),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  flex: 2,
                                  child: _small(colors, sets[i]['reps']!, (v) => sets[i]['reps'] = v),
                                ),
                                IconButton(
                                  onPressed: () => setState(() => sets.removeAt(i)),
                                  icon: Icon(Icons.delete_outline, color: colors.danger, size: 20),
                                ),
                              ],
                            ),
                          );
                        }),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () => setState(() => sets.add({'lb': '0', 'reps': '8'})),
                            child: Text('+ Add Set', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    final name = await context.push<String>('/profile/add-exercise');
                    if (name != null && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added $name')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accent,
                    foregroundColor: colors.onAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('+ Add Exercises', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _h(dynamic colors, String t, {int flex = 1}) => Expanded(
        flex: flex,
        child: Text(t, style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.w700)),
      );

  Widget _small(dynamic colors, String value, ValueChanged<String> onChanged) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: colors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: colors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: colors.border)),
      ),
    );
  }
}

class AddExerciseScreen extends ConsumerStatefulWidget {
  const AddExerciseScreen({super.key});

  @override
  ConsumerState<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends ConsumerState<AddExerciseScreen> {
  String query = '';
  final exercises = const [
    ('Barbell Back Squat', 'Legs'),
    ('Barbell Bench Press', 'Chest'),
    ('Barbell Row', 'Back'),
    ('Cable Crunch', 'Core'),
    ('Cable Fly', 'Chest'),
    ('Conventional Deadlift', 'Back'),
    ('Dumbbell Bicep Curl', 'Arms'),
    ('Hammer Curl', 'Arms'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final filtered = exercises.where((e) => e.$1.toLowerCase().contains(query.toLowerCase())).toList();

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
                    label: Text('Cancel', style: TextStyle(color: colors.textPrimary, fontSize: 16)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text('Add exercise', style: TextStyle(color: colors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: TextField(
                onChanged: (v) => setState(() => query = v),
                style: TextStyle(color: colors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search exercises',
                  hintStyle: TextStyle(color: colors.textMuted),
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => Divider(color: colors.border, height: 1),
                itemBuilder: (context, i) {
                  final e = filtered[i];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(e.$1, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700)),
                    subtitle: Text(e.$2, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                    trailing: TextButton(
                      onPressed: () => Navigator.pop(context, e.$1),
                      child: Text('Add', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700)),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: Text(
                  "Can't find it? Create a custom exercise",
                  style: TextStyle(
                    color: colors.textPrimary,
                    decoration: TextDecoration.underline,
                    decorationColor: colors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
