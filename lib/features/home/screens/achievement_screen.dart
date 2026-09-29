import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitzella/core/services/fitness_data_service.dart';
import 'package:fitzella/core/theme/app_theme.dart';
import 'package:fitzella/core/theme/theme_provider.dart';

class AchievementScreen extends ConsumerWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final history = ref.watch(workoutHistoryProvider);
    if (history.isLoading) {
      return Scaffold(
        backgroundColor: colors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (history.hasError) {
      return Scaffold(
        backgroundColor: colors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Could not load achievements: ${history.error}',
                  style: TextStyle(color: colors.textPrimary)),
              TextButton(
                onPressed: () => ref.invalidate(workoutHistoryProvider),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    final sessions = [...history.value ?? const <Map<String, dynamic>>[]]
      ..sort((a, b) => DateTime.parse(a['started_at'] as String)
          .compareTo(DateTime.parse(b['started_at'] as String)));
    final bestByExercise = <String, double>{};
    final exerciseIds = <String>{};
    final workoutDays = <DateTime>{};
    var totalSets = 0;
    var personalRecords = 0;
    var totalVolume = 0.0;
    for (final session in sessions) {
      final started = DateTime.parse(session['started_at'] as String).toLocal();
      workoutDays.add(DateTime(started.year, started.month, started.day));
      final sessionBests = <String, double>{};
      final sets = (session['logged_sets'] as List? ?? const [])
          .cast<Map<String, dynamic>>();
      totalSets += sets.length;
      for (final set in sets) {
        final exerciseId = set['exercise_id'] as String;
        exerciseIds.add(exerciseId);
        final weight = (set['weight'] as num?)?.toDouble() ?? 0;
        final reps = (set['reps'] as num?)?.toInt() ?? 0;
        totalVolume += weight * reps;
        final estimate = reps > 0 ? weight * (1 + reps / 30) : weight;
        if (estimate > (sessionBests[exerciseId] ?? 0)) {
          sessionBests[exerciseId] = estimate;
        }
      }
      for (final entry in sessionBests.entries) {
        if (entry.value > (bestByExercise[entry.key] ?? 0)) {
          personalRecords++;
          bestByExercise[entry.key] = entry.value;
        }
      }
    }

    final today = DateTime.now();
    var streak = 0;
    var streakDay = DateTime(today.year, today.month, today.day);
    if (!workoutDays.contains(streakDay)) {
      streakDay = streakDay.subtract(const Duration(days: 1));
    }
    while (workoutDays.contains(streakDay)) {
      streak++;
      streakDay = streakDay.subtract(const Duration(days: 1));
    }
    final xp = sessions.length * 100 + totalSets * 10 + personalRecords * 25;
    final level = xp ~/ 1000 + 1;
    final xpInLevel = xp % 1000;
    final badges = [
      _Badge('First Rep', 'Log your first workout', Icons.fitness_center,
          sessions.isNotEmpty, progress: '${sessions.length}/1'),
      _Badge('Getting Started', 'Log 10 workouts', Icons.fitness_center,
          sessions.length >= 10, progress: '${sessions.length}/10'),
      _Badge('First PR', 'Set a personal record', Icons.emoji_events,
          personalRecords >= 1, progress: '$personalRecords/1'),
      _Badge('Record Breaker', 'Set 10 personal records', Icons.emoji_events,
          personalRecords >= 10, progress: '$personalRecords/10'),
      _Badge('Century Sets', 'Log 100 sets', Icons.layers, totalSets >= 100,
          progress: '$totalSets/100'),
      _Badge('Set Machine', 'Log 500 sets', Icons.layers, totalSets >= 500,
          progress: '$totalSets/500'),
      _Badge('Explorer', 'Train 5 different exercises',
          Icons.grid_view_rounded, exerciseIds.length >= 5,
          progress: '${exerciseIds.length}/5'),
      _Badge('Well-Rounded', 'Train 10 different exercises',
          Icons.grid_view_rounded, exerciseIds.length >= 10,
          progress: '${exerciseIds.length}/10'),
    ];
    final earnedBadges = badges.where((badge) => badge.earned).length;

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
                              Text('$level', style: TextStyle(color: colors.onAccent, fontSize: 26, fontWeight: FontWeight.w800, height: 1)),
                              Text('LVL', style: TextStyle(color: colors.onAccent.withValues(alpha: 0.9), fontSize: 11, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$xp XP', style: TextStyle(color: colors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: xpInLevel / 1000,
                                  minHeight: 8,
                                  backgroundColor: colors.background,
                                  color: colors.accent,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('$xpInLevel / 1000 to level ${level + 1}', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: _StatCard(colors: colors, value: '${sessions.length}', label: 'Workouts')),
                      const SizedBox(width: 10),
                      Expanded(child: _StatCard(colors: colors, value: '$streak', label: 'Day streak')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _StatCard(colors: colors, value: '$personalRecords', label: 'PRs set')),
                      const SizedBox(width: 10),
                      Expanded(child: _StatCard(colors: colors, value: '${totalVolume.toStringAsFixed(0)} lb', label: 'Volume lifted')),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Text('BADGES', style: TextStyle(color: colors.textMuted, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.6)),
                      const Spacer(),
                      Text('$earnedBadges/${badges.length}', style: TextStyle(color: colors.accent, fontSize: 13, fontWeight: FontWeight.w800)),
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
