import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/features/workout/data/workout_data.dart';
import 'package:fitzella/features/workout/sheets/exercise_options_sheet.dart';
import 'package:fitzella/features/workout/sheets/finish_workout_sheet.dart';

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  Timer? _timer;
  Timer? _restTimer;
  int _elapsed = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsed++);
    });
    _restTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      ref.read(activeWorkoutProvider.notifier).tickRest();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }

  String get _elapsedLabel {
    final m = _elapsed ~/ 60;
    final s = _elapsed % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final state = ref.watch(activeWorkoutProvider);
    final notifier = ref.read(activeWorkoutProvider.notifier);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 12, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.chevron_left, color: colors.textPrimary, size: 28),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: colors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(_elapsedLabel, style: TextStyle(color: colors.accent, fontWeight: FontWeight.w700)),
                  ),
                  const Spacer(),
                  if (state.canFinish)
                    ElevatedButton(
                      onPressed: () async {
                        final unfinished = state.totalSets - state.loggedSets;
                        if (unfinished > 0) {
                          final action = await showFinishWorkoutSheet(context, unfinished);
                          if (action == FinishAction.complete) {
                            notifier.completeAllUnfinished();
                            if (context.mounted) context.pushReplacement('/workout/summary');
                          } else if (action == FinishAction.discard) {
                            notifier.discardSetsAndFinish();
                            if (context.mounted) context.pushReplacement('/workout/summary');
                          }
                        } else {
                          notifier.completeAllUnfinished();
                          if (context.mounted) context.pushReplacement('/workout/summary');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF22C55E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('FINISH WORKOUT', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.border),
                      ),
                      child: Text('FINISH WORKOUT', style: TextStyle(color: colors.textMuted, fontWeight: FontWeight.w800, fontSize: 12)),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                children: [
                  Text(state.title, style: TextStyle(color: colors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(
                    '${state.exercises.length} exercises · ${state.totalSets} sets',
                    style: TextStyle(color: colors.textSecondary, fontSize: 13),
                  ),
                  if (!state.canFinish) ...[
                    const SizedBox(height: 4),
                    Text('Log at least one set to finish.', style: TextStyle(color: colors.textMuted, fontSize: 13)),
                  ],
                  const SizedBox(height: 14),
                  if (state.exercises.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Text('No exercises yet', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700, fontSize: 16)),
                          const SizedBox(height: 8),
                          Text('Add exercises to start logging sets.', style: TextStyle(color: colors.textSecondary)),
                        ],
                      ),
                    ),
                  ...List.generate(state.exercises.length, (ei) {
                    final ex = state.exercises[ei];
                    final allDone = ex.sets.every((s) => s.done);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
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
                                Text('${ei + 1}', style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.w700)),
                                const SizedBox(width: 8),
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(color: colors.background, borderRadius: BorderRadius.circular(8)),
                                  child: Icon(Icons.fitness_center, color: colors.accent, size: 18),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(ex.name, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w800)),
                                      Text(
                                        '${ex.sets.length} sets · ${ex.sets.first.weight.toStringAsFixed(0)} lb × ${ex.sets.first.reps}',
                                        style: TextStyle(color: colors.textSecondary, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                if (allDone) Icon(Icons.check_circle, color: colors.accent, size: 22),
                                IconButton(
                                  onPressed: () => notifier.toggleExpand(ei),
                                  icon: Icon(ex.expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: colors.textMuted),
                                ),
                                IconButton(
                                  onPressed: () => showExerciseOptionsSheet(context, ex.name, onRemove: () => notifier.removeExercise(ei)),
                                  icon: Icon(Icons.more_horiz, color: colors.textMuted),
                                ),
                              ],
                            ),
                            if (ex.expanded) ...[
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  _h(colors, 'SET', 1),
                                  _h(colors, 'PREV', 2),
                                  _h(colors, 'WEIGHT', 2),
                                  _h(colors, 'REPS', 2),
                                  const SizedBox(width: 36),
                                ],
                              ),
                              ...List.generate(ex.sets.length, (si) {
                                final set = ex.sets[si];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text('${si + 1}', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700))),
                                      Expanded(flex: 2, child: Text('—', style: TextStyle(color: colors.textMuted))),
                                      Expanded(
                                        flex: 2,
                                        child: _numField(colors, set.weight.toStringAsFixed(0), (v) {
                                          final n = double.tryParse(v);
                                          if (n != null) notifier.updateSet(ei, si, weight: n);
                                        }),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        flex: 2,
                                        child: _numField(colors, '${set.reps}', (v) {
                                          final n = int.tryParse(v);
                                          if (n != null) notifier.updateSet(ei, si, reps: n);
                                        }),
                                      ),
                                      const SizedBox(width: 6),
                                      GestureDetector(
                                        onTap: () => notifier.toggleSet(ei, si),
                                        child: Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: set.done ? colors.accent : Colors.transparent,
                                            border: Border.all(color: set.done ? colors.accent : colors.border, width: 1.5),
                                          ),
                                          child: set.done ? Icon(Icons.check, color: colors.onAccent, size: 16) : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () => notifier.addSet(ei),
                                    child: Text('+ Add set', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w700)),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () => notifier.removeExercise(ei),
                                    child: Text('Remove', style: TextStyle(color: colors.danger, fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                              if (allDone)
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colors.accent,
                                      foregroundColor: colors.onAccent,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: const Text('Finish exercise', style: TextStyle(fontWeight: FontWeight.w700)),
                                  ),
                                )
                              else if (ei < state.exercises.length - 1)
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () => notifier.toggleExpand(ei + 1),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: colors.textPrimary,
                                      side: BorderSide(color: colors.border),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: Text('Next: ${state.exercises[ei + 1].name}'),
                                  ),
                                ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () async {
                      final id = await context.push<String>('/workout/add-exercise');
                      if (id != null) {
                        notifier.addExercise(WorkoutCatalog.byId(id));
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.accent,
                      side: BorderSide(color: colors.accent, style: BorderStyle.solid),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('+ Add exercise', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      notifier.discardWorkout();
                      Navigator.pop(context);
                    },
                    child: Text('Discard workout', style: TextStyle(color: colors.danger, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
            if (state.restRunning || state.restExerciseName != null)
              _RestBar(colors: colors, state: state, onAdjust: notifier.adjustRest, onSkip: notifier.skipRest),
          ],
        ),
      ),
    );
  }

  Widget _h(dynamic colors, String t, int flex) => Expanded(
        flex: flex,
        child: Text(t, style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.w700)),
      );

  Widget _numField(dynamic colors, String value, ValueChanged<String> onChanged) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      keyboardType: TextInputType.number,
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

class _RestBar extends StatelessWidget {
  final dynamic colors;
  final ActiveWorkoutState state;
  final ValueChanged<int> onAdjust;
  final VoidCallback onSkip;

  const _RestBar({required this.colors, required this.state, required this.onAdjust, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: state.restProgress.clamp(0.0, 1.0),
            minHeight: 3,
            backgroundColor: colors.border,
            color: colors.accent,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (state.restExerciseName ?? '').toUpperCase(),
                        style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.4),
                      ),
                      Text(formatRest(state.restSeconds), style: TextStyle(color: colors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                _circleBtn(colors, '-15', () => onAdjust(-15)),
                const SizedBox(width: 8),
                _circleBtn(colors, '+15', () => onAdjust(15)),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onSkip,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accent,
                    foregroundColor: colors.onAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  ),
                  child: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(dynamic colors, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.background,
          shape: BoxShape.circle,
          border: Border.all(color: colors.border),
        ),
        child: Text(label, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700, fontSize: 12)),
      ),
    );
  }
}
