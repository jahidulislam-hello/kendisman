import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:fitzella/core/services/fitness_data_service.dart';
import 'package:fitzella/features/progress/data/progress_models.dart';
import 'package:fitzella/features/progress/widgets/progress_widgets.dart';

class GoalsTab extends ConsumerStatefulWidget {
  const GoalsTab({super.key});

  @override
  ConsumerState<GoalsTab> createState() => _GoalsTabState();
}

class _GoalsTabState extends ConsumerState<GoalsTab> {
  int _sub = 0; // 0 active, 1 completed

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    final goals = ref.watch(goalsProvider);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Row(
          children: [
            _SubChip(
              label: 'Active',
              selected: _sub == 0,
              showDot: true,
              onTap: () => setState(() => _sub = 0),
            ),
            const SizedBox(width: 8),
            _SubChip(
              label: 'Completed',
              selected: _sub == 1,
              badge: _sub == 1 ? '1' : null,
              onTap: () => setState(() => _sub = 1),
            ),
          ],
        ),
        const SizedBox(height: 16),
        goals.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Column(
            children: [
              Text('Could not load goals: $error',
                  style: TextStyle(color: colors.danger)),
              TextButton(
                onPressed: () => ref.invalidate(goalsProvider),
                child: const Text('Try again'),
              ),
            ],
          ),
          data: (rows) {
            final filtered = rows
                .where((row) =>
                    row['status'] == (_sub == 0 ? 'active' : 'completed'))
                .map(_toGoal)
                .toList();
            if (filtered.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Text(
                  _sub == 0
                      ? 'No active goals yet. Set a goal to track your progress.'
                      : 'You have no completed goals yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.textSecondary),
                ),
              );
            }
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: filtered
                  .map((goal) => SizedBox(
                        width: (MediaQuery.sizeOf(context).width - 50) / 2,
                        child: _GoalCard(goal: goal),
                      ))
                  .toList(),
            );
          },
        ),
        if (_sub == 0) ...[
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => context.push('/progress/create-goal'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.border, width: 1.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline,
                      color: colors.textSecondary, size: 20),
                  const SizedBox(width: 8),
                  Text('Set a new target goal',
                      style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  ActiveGoal _toGoal(Map<String, dynamic> row) {
    final exerciseName =
        (row['exercises'] as Map<String, dynamic>?)?['name'] as String?;
    final title = row['title'] as String? ??
        (exerciseName == null ? 'Goal' : '$exerciseName strength goal');
    final currentValue = (row['current_value'] as num?)?.toDouble() ?? 0;
    final current = row['goal_type'] == 'consistency'
        ? '${currentValue.toInt()} sessions this week'
        : row['metric'] == 'body_fat'
            ? '${currentValue.toStringAsFixed(1)}%'
            : '${currentValue.toStringAsFixed(1)} lb';
    final due = row['due_date'] == null
        ? 'Ongoing'
        : DateFormat('d MMM yyyy').format(DateTime.parse(row['due_date']));
    return ActiveGoal(
      id: row['id'] as String,
      type: (row['goal_type'] as String? ?? 'strength').toUpperCase(),
      title: title,
      percent: (row['progress_percent'] as num?)?.toInt() ?? 0,
      current: current,
      due: due,
    );
  }

}

class _SubChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool showDot;
  final String? badge;
  final VoidCallback onTap;

  const _SubChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.showDot = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? colors.accent : colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? colors.accent : colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDot && selected) ...[
              Container(width: 6, height: 6, decoration: BoxDecoration(color: colors.onAccent, shape: BoxShape.circle)),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? colors.onAccent : colors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: colors.onAccent, shape: BoxShape.circle),
                child: Text(badge!, style: TextStyle(color: colors.accent, fontSize: 11, fontWeight: FontWeight.w800)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final ActiveGoal goal;
  const _GoalCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    final isConsistency = goal.type == 'CONSISTENCY';
    return ProgressSurfaceCard(
      child: Column(
        children: [
          Row(
            children: [
              Icon(isConsistency ? Icons.water_drop : Icons.swap_horiz, color: const Color(0xFF60A5FA), size: 14),
              const SizedBox(width: 4),
              Text(goal.type, style: const TextStyle(color: Color(0xFF60A5FA), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.4)),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: 88,
            height: 88,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 88,
                  height: 88,
                  child: CircularProgressIndicator(
                    value: goal.percent / 100,
                    strokeWidth: 8,
                    backgroundColor: colors.border,
                    color: colors.accent,
                  ),
                ),
                Text('${goal.percent}%', style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            goal.title,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700, height: 1.25),
          ),
          const SizedBox(height: 10),
          Text('Current: ${goal.current}', style: TextStyle(color: colors.textSecondary, fontSize: 11)),
          Text('Due ${goal.due}', style: TextStyle(color: colors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}
