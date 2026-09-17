import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fitzella/features/progress/data/progress_mock_data.dart';
import 'package:fitzella/features/progress/widgets/progress_widgets.dart';

class HistoryTab extends StatefulWidget {
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
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  String _dateRange = 'All time';
  final Set<String> _muscles = {};
  final Set<String> _routines = {};
  String _workoutName = 'Quick Workout';
  /// When true, History mirrors screenshot 01 (no workouts).
  bool _forceEmpty = false;

  List<ProgressWorkout> get _filtered {
    if (_forceEmpty) return const [];
    return ProgressMockData.workouts.where((w) {
      if (_muscles.isNotEmpty) {
        final tags = w.exercises.join(' ').toLowerCase();
        final matchMuscle = _muscles.any((m) {
          final key = m.toLowerCase();
          if (key == 'legs') return tags.contains('leg') || tags.contains('squat') || tags.contains('deadlift') || w.routineTag == 'Legs';
          if (key == 'chest') return tags.contains('bench') || tags.contains('fly') || tags.contains('chest');
          if (key == 'back') return tags.contains('row') || tags.contains('deadlift') || tags.contains('pulldown');
          if (key == 'arms') return tags.contains('curl') || tags.contains('tricep');
          if (key == 'shoulders') return tags.contains('press') && tags.contains('overhead') || tags.contains('face pull');
          return false;
        });
        if (!matchMuscle) return false;
      }
      if (_routines.isNotEmpty && !_routines.contains(w.routineTag)) return false;
      final now = DateTime(2026, 9, 16);
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
      _forceEmpty = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedWorkout != null) {
      return _SessionDetail(
        workout: widget.selectedWorkout!,
        workoutName: widget.selectedWorkout!.routineTag == 'Quick Workout'
            ? _workoutName
            : widget.selectedWorkout!.routineTag,
        onNameChanged: (n) => setState(() => _workoutName = n),
        onBack: widget.onClearSelection,
      );
    }

    final items = _filtered;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        const ProgressFilterLabel('Date range'),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ProgressMockData.dateRanges.map((r) {
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
            children: ProgressMockData.muscleGroups.map((m) {
              final selected = _muscles.contains(m);
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ProgressChip(
                  label: m,
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
            children: ProgressMockData.routineDays.map((r) {
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
            GestureDetector(
              onLongPress: () => setState(() => _forceEmpty = !_forceEmpty),
              child: Text(
                '(${items.length}) workouts',
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _clearFilters,
              child: const Text(
                'Clear all',
                style: TextStyle(color: Color(0xFF2563EB), fontSize: 14, fontWeight: FontWeight.w600),
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
}

class _EmptyHistory extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onViewAll;

  const _EmptyHistory({required this.onReset, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
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
                  color: const Color(0xFF121218),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.bar_chart_rounded, color: Color(0xFF2563EB), size: 34),
              ),
              Positioned(
                right: -4,
                bottom: -4,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(Icons.search, color: Colors.white, size: 15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'No workouts match these filters',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try a wider date range, or clear the filters to see your complete training history.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF9B9BA5), fontSize: 13, height: 1.4),
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
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
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
                backgroundColor: const Color(0xFF22222A),
                foregroundColor: Colors.white,
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
    final date = DateFormat('d MMM yyyy').format(workout.date);
    return ProgressSurfaceCard(
      onTap: onOpen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(date, style: const TextStyle(color: Color(0xFF9B9BA5), fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: workout.tagAccent
                      ? const Color(0xFF2563EB).withValues(alpha: 0.18)
                      : const Color(0xFF2A2A32),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  workout.routineTag,
                  style: TextStyle(
                    color: workout.tagAccent ? const Color(0xFF60A5FA) : const Color(0xFF9B9BA5),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(workout.time, style: const TextStyle(color: Color(0xFF6B6B75), fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            workout.exercises.join(', '),
            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.fitness_center, color: Color(0xFF2563EB), size: 16),
              const SizedBox(width: 6),
              Text(
                '${workout.setsLogged} sets logged',
                style: const TextStyle(color: Color(0xFF9B9BA5), fontSize: 13),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, color: Color(0xFF6B6B75)),
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
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C22),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(workoutName, style: const TextStyle(color: Color(0xFF9B9BA5), fontSize: 14)),
              const SizedBox(height: 16),
              _menuRow(ctx, Icons.edit_outlined, 'Edit Workout Name', 'edit'),
              _menuRow(ctx, Icons.schedule_outlined, 'Adjust Start/End Time', 'time'),
              _menuRow(ctx, Icons.note_alt_outlined, 'Add Note', 'note'),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B0B0F),
                    foregroundColor: Colors.white,
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
          return Dialog(
            backgroundColor: const Color(0xFF1C1C22),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Edit Workout Name',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF0B0B0F),
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
                            backgroundColor: const Color(0xFF2A2A32),
                            foregroundColor: Colors.white,
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
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
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
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () => Navigator.pop(ctx, value),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A32),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(dateLabel, style: const TextStyle(color: Color(0xFF9B9BA5), fontSize: 13)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _showMenu(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF17171C),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF26262E)),
                ),
                child: const Icon(Icons.more_vert, color: Colors.white),
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
              color: const Color(0xFF2563EB).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(color: Color(0xFF2563EB), shape: BoxShape.circle),
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
                          backgroundColor: const Color(0xFF2563EB),
                          child: Text(ex.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ex.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                              Text(ex.subtitle, style: const TextStyle(color: Color(0xFF9B9BA5), fontSize: 12)),
                            ],
                          ),
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('EST. 1RM', style: TextStyle(color: Color(0xFF6B6B75), fontSize: 10, fontWeight: FontWeight.w600)),
                            Text('Strength Calc', style: TextStyle(color: Color(0xFF2563EB), fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Row(
                      children: [
                        Expanded(child: Text('SET', style: TextStyle(color: Color(0xFF6B6B75), fontSize: 11, fontWeight: FontWeight.w700))),
                        Expanded(flex: 3, child: Text('WEIGHT & REPS', style: TextStyle(color: Color(0xFF6B6B75), fontSize: 11, fontWeight: FontWeight.w700))),
                        Expanded(child: Text('1RM VALUE', textAlign: TextAlign.right, style: TextStyle(color: Color(0xFF6B6B75), fontSize: 11, fontWeight: FontWeight.w700))),
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
                                    backgroundColor: const Color(0xFF2A2A32),
                                    child: Text('${s.set}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(s.weightReps, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                              ),
                              Expanded(
                                child: Text(s.oneRm, textAlign: TextAlign.right, style: const TextStyle(color: Color(0xFFCFCFD6))),
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
    return ProgressSurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2563EB), size: 18),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Color(0xFF6B6B75), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.4)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
