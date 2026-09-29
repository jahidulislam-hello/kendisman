import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:fitzella/core/services/fitness_data_service.dart';
import 'package:fitzella/features/progress/data/progress_models.dart';
import 'package:fitzella/features/progress/widgets/progress_widgets.dart';

class HistoryTab extends ConsumerStatefulWidget {
  final ProgressWorkout? selectedWorkout;
  final ValueChanged<ProgressWorkout> onSelectWorkout;
  final VoidCallback onClearSelection;

  const HistoryTab({
    super.key,
    required this.selectedWorkout,
    required this.onSelectWorkout,
    required this.onClearSelection,
  });

  @override
  ConsumerState<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends ConsumerState<HistoryTab> {
  static const _dateRanges = ['This week', 'This month', 'Last 3 months', 'All time'];

  String _dateRange = 'All time';
  final Set<String> _muscles = {};
  final Set<String> _routines = {};
  String _workoutName = 'Quick Workout';
  List<ProgressWorkout> _workouts = const [];

  List<ProgressWorkout> get _filtered {
    return _workouts.where((w) {
      if (_muscles.isNotEmpty && !_muscles.any(w.muscles.contains)) {
        return false;
      }
      if (_routines.isNotEmpty && !_routines.contains(w.routineTag)) return false;
      final now = DateTime.now();
      if (_dateRange == 'This week') {
        return w.date.isAfter(now.subtract(const Duration(days: 7)));
      }
      if (_dateRange == 'This month') {
        return w.date.year == now.year && w.date.month == now.month;
      }
      if (_dateRange == 'Last 3 months') {
        return w.date.isAfter(now.subtract(const Duration(days: 90)));
      }
      return true;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _dateRange = 'All time';
      _muscles.clear();
      _routines.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    final history = ref.watch(workoutHistoryProvider);
    if (history.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (history.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Could not load workout history: ${history.error}',
                  style: TextStyle(color: colors.textPrimary),
                  textAlign: TextAlign.center),
              TextButton(
                onPressed: () => ref.invalidate(workoutHistoryProvider),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }
    final rawHistory = history.value ?? const <Map<String, dynamic>>[];
    final orderedHistory = rawHistory.toList()
      ..sort((a, b) => DateTime.parse(a['started_at'] as String)
          .compareTo(DateTime.parse(b['started_at'] as String)));
    final bestByExercise = <String, double>{};
    final recordsBySession = <String, int>{};
    for (final session in orderedHistory) {
      final setRows = (session['logged_sets'] as List? ?? const [])
          .cast<Map<String, dynamic>>();
      final sessionBest = <String, double>{};
      for (final set in setRows) {
        final exerciseId = set['exercise_id'] as String;
        final weight = (set['weight'] as num?)?.toDouble() ?? 0;
        final reps = (set['reps'] as num?)?.toInt() ?? 0;
        final estimate = reps > 0 ? weight * (1 + reps / 30) : weight;
        if (estimate > (sessionBest[exerciseId] ?? 0)) {
          sessionBest[exerciseId] = estimate;
        }
      }
      var records = 0;
      for (final entry in sessionBest.entries) {
        if (entry.value > (bestByExercise[entry.key] ?? 0)) {
          records++;
          bestByExercise[entry.key] = entry.value;
        }
      }
      recordsBySession[session['id'] as String] = records;
    }
    _workouts = rawHistory
        .map((row) => _toProgressWorkout(
              row,
              records: recordsBySession[row['id'] as String] ?? 0,
            ))
        .toList();
    if (widget.selectedWorkout != null) {
      return _SessionDetail(
        workout: widget.selectedWorkout!,
        workoutName: widget.selectedWorkout!.routineTag == 'Quick Workout'
            ? _workoutName
            : widget.selectedWorkout!.routineTag,
        onNameChanged: (n) async {
          try {
            await ref.read(fitnessDataServiceProvider).renameQuickWorkout(
                  widget.selectedWorkout!.id,
                  n,
                );
            if (mounted) {
              setState(() {
                _workoutName = n;
                ref.invalidate(workoutHistoryProvider);
              });
            }
          } catch (error) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Could not rename workout: $error')),
              );
            }
          }
        },
        onBack: widget.onClearSelection,
      );
    }

    final items = _filtered;
    final routineTags = _workouts.map((workout) => workout.routineTag).toSet().toList()
      ..sort();
    final muscleGroups = _workouts.expand((workout) => workout.muscles).toSet().toList()
      ..sort();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        const ProgressFilterLabel('Date range'),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _dateRanges.map((r) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ProgressChip(
                  label: r,
                  selected: _dateRange == r,
                  onTap: () => setState(() => _dateRange = r),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        const ProgressFilterLabel('Muscle group'),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: muscleGroups.map((m) {
              final selected = _muscles.contains(m);
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ProgressChip(
                  label: m[0].toUpperCase() + m.substring(1),
                  selected: selected,
                  onTap: () => setState(() {
                    if (selected) {
                      _muscles.remove(m);
                    } else {
                      _muscles.add(m);
                    }

                  }),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        const ProgressFilterLabel('Routine day'),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: routineTags.map((r) {
              final selected = _routines.contains(r);
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ProgressChip(
                  label: r,
                  selected: selected,
                  onTap: () => setState(() {
                    if (selected) {
                      _routines.remove(r);
                    } else {
                      _routines.add(r);
                    }
                  }),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Text(
                '(${items.length}) workouts',
                style: TextStyle(color: colors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _clearFilters,
              child: Text(
                'Clear all',
                style: TextStyle(color: colors.accent, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          _EmptyHistory(onReset: _clearFilters, onViewAll: _clearFilters)
        else
          ...items.map((w) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _WorkoutCard(
                  workout: w,
                  onOpen: () => widget.onSelectWorkout(w),
                ),
              )),
      ],
    );
  }

  ProgressWorkout _toProgressWorkout(
    Map<String, dynamic> row, {
    required int records,
  }) {
    final started = DateTime.parse(row['started_at'] as String).toLocal();
    final completed = DateTime.parse(row['completed_at'] as String).toLocal();
    final routine = row['routines'] as Map<String, dynamic>?;
    final title = routine?['name'] as String? ??
        row['routine_name'] as String? ??
        'Quick Workout';
    final rawSets = (row['logged_sets'] as List? ?? const [])
        .cast<Map<String, dynamic>>();
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final set in rawSets) {
      final exerciseId = set['exercise_id'] as String? ?? '';
      grouped.putIfAbsent(exerciseId, () => []).add(set);
    }
    final sessionExercises = <SessionExercise>[];
    final names = <String>[];
    final muscles = <String>{};
    var volume = 0.0;
    for (final entry in grouped.entries) {
      final first = entry.value.first;
      final exercise = first['exercises'] as Map<String, dynamic>? ?? {};
      final name = exercise['name'] as String? ?? 'Exercise';
      final muscle = exercise['muscle_group'] as String? ?? '';
      final equipment = exercise['equipment_type'] as String? ?? '';
      names.add(name);
      if (muscle.isNotEmpty) muscles.add(muscle.toLowerCase());
      final sets = entry.value.map((set) {
        final weight = (set['weight'] as num?)?.toDouble() ?? 0;
        final reps = (set['reps'] as num?)?.toInt() ?? 0;
        volume += weight * reps;
        final oneRm = reps > 0 ? weight * (1 + reps / 30) : weight;
        return SessionSet(
          set: (set['set_index'] as num?)?.toInt() ?? 0,
          weightReps: '${weight.toStringAsFixed(1)} lb × $reps reps',
          oneRm: '${oneRm.toStringAsFixed(1)} lb',
        );
      }).toList();
      sessionExercises.add(SessionExercise(
        name: name,
        subtitle: [muscle, equipment].where((part) => part.isNotEmpty).join(' • '),
        initials: name
            .split(' ')
            .where((part) => part.isNotEmpty)
            .take(2)
            .map((part) => part[0].toUpperCase())
            .join(),
        sets: sets,
      ));
    }
    final duration = completed.difference(started).inMinutes;
    return ProgressWorkout(
      id: row['id'] as String,
      title: DateFormat('EEEE').format(started),
      date: started,
      time: DateFormat('HH:mm').format(started),
      routineTag: title,
      tagAccent: routine != null,
      exercises: names,
      muscles: muscles,
      setsLogged: rawSets.length,
      duration: '${duration}m',
      volume: '${volume.toStringAsFixed(0)} lb',
      records: records,
      sessionExercises: sessionExercises,
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onViewAll;

  const _EmptyHistory({required this.onReset, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    return ProgressSurfaceCard(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.bar_chart_rounded, color: colors.accent, size: 34),
              ),
              Positioned(
                right: -4,
                bottom: -4,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: colors.accent,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(Icons.search, color: colors.onAccent, size: 15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'No workouts match these filters',
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a wider date range, or clear the filters to see your complete training history.',
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.textSecondary, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Reset Filters'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accent,
                foregroundColor: colors.onAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onViewAll,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.surface,
                foregroundColor: colors.textPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('View All Workouts'),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final ProgressWorkout workout;
  final VoidCallback onOpen;

  const _WorkoutCard({required this.workout, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    final date = DateFormat('d MMM yyyy').format(workout.date);
    return ProgressSurfaceCard(
      onTap: onOpen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(date, style: TextStyle(color: colors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: workout.tagAccent
                      ? colors.accent.withValues(alpha: 0.18)
                      : colors.border,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  workout.routineTag,
                  style: TextStyle(
                    color: workout.tagAccent ? const Color(0xFF60A5FA) : colors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(workout.time, style: TextStyle(color: colors.textMuted, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            workout.exercises.join(', '),
            style: TextStyle(color: colors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.fitness_center, color: colors.accent, size: 16),
              const SizedBox(width: 6),
              Text(
                '${workout.setsLogged} sets logged',
                style: TextStyle(color: colors.textSecondary, fontSize: 13),
              ),
              const Spacer(),
              Icon(Icons.chevron_right, color: colors.textMuted),
            ],
          ),
        ],
      ),
    );
  }
}

class _SessionDetail extends StatelessWidget {
  final ProgressWorkout workout;
  final String workoutName;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onBack;

  const _SessionDetail({
    required this.workout,
    required this.workoutName,
    required this.onNameChanged,
    required this.onBack,
  });

  Future<void> _showMenu(BuildContext context) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final sheetColors = progressColors(ctx);
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          decoration: BoxDecoration(
            color: sheetColors.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(workoutName, style: TextStyle(color: sheetColors.textSecondary, fontSize: 14)),
              const SizedBox(height: 16),
              _menuRow(ctx, Icons.edit_outlined, 'Edit Workout Name', 'edit'),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: sheetColors.background,
                    foregroundColor: sheetColors.textPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (action == 'edit' && context.mounted) {
      final controller = TextEditingController(text: workoutName);
      final saved = await showDialog<String>(
        context: context,
        builder: (ctx) {
          final dialogColors = progressColors(ctx);
          return Dialog(
            backgroundColor: dialogColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Workout Name',
                    style: TextStyle(color: dialogColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    style: TextStyle(color: dialogColors.textPrimary),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: dialogColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: TextButton.styleFrom(
                            backgroundColor: dialogColors.border,
                            foregroundColor: dialogColors.textPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, controller.text.trim()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: dialogColors.accent,
                            foregroundColor: dialogColors.onAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
      if (saved != null && saved.isNotEmpty) onNameChanged(saved);
    }
  }

  Widget _menuRow(BuildContext ctx, IconData icon, String label, String value) {
    final colors = progressColors(ctx);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () => Navigator.pop(ctx, value),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colors.border,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: colors.textPrimary, size: 20),
      ),
      title: Text(label, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    final dateLabel = DateFormat('HH:mm, EEEE, d MMM yyyy')
        .format(DateTime(workout.date.year, workout.date.month, workout.date.day, 12, 22));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) onBack();
      },
      child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.title,
                    style: TextStyle(color: colors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(dateLabel, style: TextStyle(color: colors.textSecondary, fontSize: 13)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _showMenu(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.border),
                ),
                child: Icon(Icons.more_vert, color: colors.textPrimary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(color: colors.accent, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(
                  workoutName,
                  style: const TextStyle(color: Color(0xFF60A5FA), fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _StatMini(icon: Icons.schedule, label: 'DURATION', value: workout.duration)),
            const SizedBox(width: 8),
            Expanded(child: _StatMini(icon: Icons.inventory_2_outlined, label: 'VOLUME', value: workout.volume)),
            const SizedBox(width: 8),
            Expanded(child: _StatMini(icon: Icons.emoji_events_outlined, label: 'RECORDS', value: '${workout.records}')),
          ],
        ),
        const SizedBox(height: 14),
        ...workout.sessionExercises.map((ex) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ProgressSurfaceCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: colors.accent,
                          child: Text(ex.initials, style: TextStyle(color: colors.onAccent, fontWeight: FontWeight.w700, fontSize: 12)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ex.name, style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                              Text(ex.subtitle, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('EST. 1RM', style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.w600)),
                            Text('Strength Calc', style: TextStyle(color: colors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(child: Text('SET', style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.w700))),
                        Expanded(flex: 3, child: Text('WEIGHT & REPS', style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.w700))),
                        Expanded(child: Text('1RM VALUE', textAlign: TextAlign.right, style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.w700))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...ex.sets.map((s) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: colors.border,
                                    child: Text('${s.set}', style: TextStyle(color: colors.textPrimary, fontSize: 12)),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(s.weightReps, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600)),
                              ),
                              Expanded(
                                child: Text(s.oneRm, textAlign: TextAlign.right, style: TextStyle(color: colors.textSecondary)),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            )),
      ],
      ),
    );
  }
}

class _StatMini extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatMini({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    return ProgressSurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.accent, size: 18),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.4)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
