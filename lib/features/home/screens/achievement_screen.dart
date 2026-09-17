import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitzella/core/theme/app_theme.dart';
import 'package:fitzella/core/theme/theme_provider.dart';

class AchievementScreen extends ConsumerWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    const badges = [
      _Badge('First Rep', 'Log your first workout', Icons.fitness_center, true),
      _Badge('Getting Started', 'Log 10 workouts', Icons.fitness_center, true),
      _Badge('First PR', 'Set a personal record', Icons.emoji_events, true),
      _Badge('Record Breaker', 'Set 10 personal records', Icons.emoji_events, true),
      _Badge('Century Sets', 'Log 100 sets', Icons.layers, true),
      _Badge('Set Machine', 'Log 500 sets', Icons.layers, false, progress: '425/500'),
      _Badge('Explorer', 'Train 5 different exercises', Icons.grid_view_rounded, true),
      _Badge('Well-Rounded', 'Train 10 different exercises', Icons.grid_view_rounded, true),
    ];

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.border),
                      ),
                      child: Icon(Icons.chevron_left, color: colors.textPrimary),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Achievement',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: colors.accent.withValues(alpha: 0.7)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(color: colors.accent, shape: BoxShape.circle),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('24', style: TextStyle(color: colors.onAccent, fontSize: 26, fontWeight: FontWeight.w800, height: 1)),
                              Text('LVL', style: TextStyle(color: colors.onAccent.withValues(alpha: 0.9), fontSize: 11, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('11,870 XP', style: TextStyle(color: colors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: 370 / 500,
                                  minHeight: 8,
                                  backgroundColor: colors.background,
                                  color: colors.accent,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('370 / 500 to level 25', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: _StatCard(colors: colors, value: '26', label: 'Workouts')),
                      const SizedBox(width: 10),
                      Expanded(child: _StatCard(colors: colors, value: '0', label: 'Day streak')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _StatCard(colors: colors, value: '100', label: 'PRs set')),
                      const SizedBox(width: 10),
                      Expanded(child: _StatCard(colors: colors, value: '483,973 lb', label: 'Volume lifted')),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Text('BADGES', style: TextStyle(color: colors.textMuted, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.6)),
                      const Spacer(),
                      Text('8/12', style: TextStyle(color: colors.accent, fontSize: 13, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: badges.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.95,
                    ),
                    itemBuilder: (context, i) => _BadgeCard(colors: colors, badge: badges[i]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final AppColors colors;
  final String value;
  final String label;
  const _StatCard({required this.colors, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextStyle(color: colors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: colors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}

class _Badge {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool earned;
  final String? progress;
  const _Badge(this.title, this.subtitle, this.icon, this.earned, {this.progress});
}

class _BadgeCard extends StatelessWidget {
  final AppColors colors;
  final _Badge badge;
  const _BadgeCard({required this.colors, required this.badge});

  @override
  Widget build(BuildContext context) {
    final dim = !badge.earned;
    return Opacity(
      opacity: dim ? 0.55 : 1,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: badge.earned ? colors.accent.withValues(alpha: 0.15) : colors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(badge.icon, color: badge.earned ? colors.accent : colors.textMuted, size: 18),
            ),
            const SizedBox(height: 12),
            Text(badge.title, style: TextStyle(color: colors.textPrimary, fontSize: 15, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(badge.subtitle, style: TextStyle(color: colors.textSecondary, fontSize: 12, height: 1.25)),
            const Spacer(),
            Text(
              badge.earned ? 'Earned' : (badge.progress ?? ''),
              style: TextStyle(
                color: badge.earned ? colors.accent : colors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
