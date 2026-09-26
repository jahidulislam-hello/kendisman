import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fitzella/core/theme/app_theme.dart';
import 'package:fitzella/features/progress/data/progress_mock_data.dart';
import 'package:fitzella/features/progress/widgets/progress_widgets.dart';

class GoalsTab extends StatefulWidget {
  const GoalsTab({super.key});

  @override
  State<GoalsTab> createState() => _GoalsTabState();
}

class _GoalsTabState extends State<GoalsTab> {
  int _sub = 0; // 0 active, 1 completed

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
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
        if (_sub == 0) ..._active(colors) else ..._completed(colors),
      ],
    );
  }

  List<Widget> _active(AppColors colors) {
    final goals = ProgressMockData.activeGoals;
    return [
      Row(
        children: [
          Expanded(child: _GoalCard(goal: goals[0])),
          const SizedBox(width: 10),
          Expanded(child: _GoalCard(goal: goals[1])),
        ],
      ),
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
              Icon(Icons.add_circle_outline, color: colors.textSecondary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Set a new target goal',
                style: TextStyle(color: colors.textSecondary, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _completed(AppColors colors) {
    return [
      ProgressSurfaceCard(
        color: const Color(0xFF13261C),
        borderColor: const Color(0xFF1F3A28),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: colors.success, size: 16),
                      const SizedBox(width: 6),
                      Text('Goal Milestone Reached', style: TextStyle(color: colors.success, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('1 Goal Completed 🎉', style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text('Target surpassed ahead of schedule', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: colors.accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.emoji_events, color: Color(0xFFFBBF24), size: 28),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      ProgressSurfaceCard(
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.water_drop, color: Color(0xFF60A5FA), size: 16),
                const SizedBox(width: 6),
                const Text('CONSISTENCY', style: TextStyle(color: Color(0xFF60A5FA), fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.4)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Done', style: TextStyle(color: colors.success, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.accent, width: 4),
                    color: colors.accent,
                  ),
                  child: Icon(Icons.check, color: colors.onAccent),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Train 3x a week for a month', style: TextStyle(color: colors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('Current: 2 lb • Due 24 Aug 2026', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: colors.border, height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.history, color: colors.success, size: 16),
                const SizedBox(width: 6),
                Text('Finished Aug 24, 2024', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                const Spacer(),
                Text('Details', style: TextStyle(color: colors.accent, fontSize: 13, fontWeight: FontWeight.w600)),
                Icon(Icons.chevron_right, color: colors.accent, size: 18),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      ProgressSurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('🙌', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text('HABIT CONTINUITY', style: TextStyle(color: colors.textPrimary, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.4)),
                const Spacer(),
                Text('4-Week Run', style: TextStyle(color: colors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(4, (i) {
                final last = i == 3;
                final weekColor = last ? const Color(0xFF22C55E) : colors.accent;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: i == 3 ? 0 : 8),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: weekColor),
                    ),
                    child: Column(
                      children: [
                        Text('WK ${i + 1}', style: TextStyle(color: weekColor, fontSize: 11, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(color: weekColor, shape: BoxShape.circle),
                          child: Icon(Icons.check, color: colors.onAccent, size: 14),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    ];
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
