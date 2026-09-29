import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/features/workout/data/workout_data.dart';

Future<void> showRoutinePreviewSheet(BuildContext context, RoutineDay day) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _RoutinePreviewSheet(day: day),
  );
}

class _RoutinePreviewSheet extends ConsumerWidget {
  final RoutineDay day;
  const _RoutinePreviewSheet({required this.day});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final exercises = day.exerciseNames.isNotEmpty
        ? day.exerciseNames
            .map((name) => WorkoutExerciseDef(
                  id: '',
                  name: name,
                  muscle: '',
                  equipment: '',
                ))
            .toList()
        : day.exerciseIds.map(WorkoutCatalog.byId).toList();
    final tag = day.tag.isEmpty
        ? '${exercises.length} exercises'
        : day.tag;

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: colors.border, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: colors.textPrimary)),
                  Expanded(child: Text(day.name, textAlign: TextAlign.center, style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800))),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.push('/workout/build-routine', extra: day);
                    },
                    child: Text('Edit', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 14, color: colors.textMuted),
                  const SizedBox(width: 6),
                  Text('${exercises.length} exercises', style: TextStyle(color: colors.textMuted, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(tag, style: TextStyle(color: colors.accent, fontWeight: FontWeight.w700, fontSize: 12)),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: exercises.length,
                  separatorBuilder: (_, __) => Divider(color: colors.border, height: 1),
                  itemBuilder: (context, i) {
                    final e = exercises[i];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(color: colors.background, borderRadius: BorderRadius.circular(10)),
                        child: Icon(Icons.fitness_center, color: colors.accent, size: 20),
                      ),
                      title: Text(e.name, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700)),
                      subtitle: Text(e.muscle.isEmpty ? 'Routine exercise' : e.muscle, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                      trailing: Icon(Icons.info_outline, color: colors.textMuted),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    final notifier = ref.read(activeWorkoutProvider.notifier);
                    await notifier.startFromDay(day, WorkoutCatalog.exercises);
                    if (!context.mounted) return;
                    if (notifier.currentState.sessionId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(notifier.currentState.backendError ?? 'Could not start workout.')),
                      );
                      return;
                    }
                    Navigator.pop(context);
                    context.push('/workout/active');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accent,
                    foregroundColor: colors.onAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Start Workout', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum FinishAction { complete, discard, back }

Future<FinishAction?> showFinishWorkoutSheet(BuildContext context, int unfinished) {
  return showModalBottomSheet<FinishAction>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _FinishSheet(unfinished: unfinished),
  );
}

class _FinishSheet extends ConsumerWidget {
  final int unfinished;
  const _FinishSheet({required this.unfinished});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(24)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: colors.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Text('Finish workout?', style: TextStyle(color: colors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(
            'You still have $unfinished unfinished sets. How would you like to record this session?',
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context, FinishAction.complete),
              icon: const Icon(Icons.check_circle),
              label: const Text('Complete Unfinished', style: TextStyle(fontWeight: FontWeight.w800)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, FinishAction.discard),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.background,
                foregroundColor: colors.textPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: const Text('Discard Sets', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, FinishAction.back),
            child: Text('Go Back', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

Future<void> showExerciseOptionsSheet(BuildContext context, String name, {required VoidCallback onRemove}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Consumer(builder: (context, ref, _) {
        final colors = ref.watch(appColorsProvider);
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name, style: TextStyle(color: colors.textSecondary)),
              const SizedBox(height: 12),
              _opt(colors, Icons.graphic_eq, 'Add Warm-up Sets', colors.textPrimary, () => Navigator.pop(ctx)),
              _opt(colors, Icons.sync, 'Replace Exercise', colors.textPrimary, () => Navigator.pop(ctx)),
              _opt(colors, Icons.bar_chart, 'Create Superset', colors.textPrimary, () => Navigator.pop(ctx)),
              _opt(colors, Icons.close, 'Remove Exercise', colors.danger, () {
                Navigator.pop(ctx);
                onRemove();
              }),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.background,
                    foregroundColor: colors.textPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        );
      });
    },
  );
}

Widget _opt(dynamic colors, IconData icon, String label, Color textColor, VoidCallback onTap) {
  return ListTile(
    onTap: onTap,
    leading: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: colors.background, borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, color: textColor == colors.danger ? colors.danger : colors.textPrimary, size: 20),
    ),
    title: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w700)),
  );
}
