import 'package:flutter/material.dart';

class AchievementBadge {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool earned;
  final String progress;

  const AchievementBadge(
    this.title,
    this.subtitle,
    this.icon,
    this.earned, {
    required this.progress,
  });
}

class AchievementProgress {
  final int level;
  final int xp;
  final int xpInLevel;
  final int streak;
  final int personalRecords;
  final double totalVolume;
  final int sessionCount;
  final List<AchievementBadge> badges;

  const AchievementProgress({
    required this.level,
    required this.xp,
    required this.xpInLevel,
    required this.streak,
    required this.personalRecords,
    required this.totalVolume,
    required this.sessionCount,
    required this.badges,
  });

  int get earnedCount => badges.where((badge) => badge.earned).length;

  static const empty = AchievementProgress(
    level: 1,
    xp: 0,
    xpInLevel: 0,
    streak: 0,
    personalRecords: 0,
    totalVolume: 0,
    sessionCount: 0,
    badges: [],
  );

  factory AchievementProgress.fromSessions(List<Map<String, dynamic>> raw) {
    final sessions = [...raw]..sort((a, b) => DateTime.parse(a['started_at'] as String)
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
      AchievementBadge('First Rep', 'Log your first workout', Icons.fitness_center,
          sessions.isNotEmpty, progress: '${sessions.length}/1'),
      AchievementBadge('Getting Started', 'Log 10 workouts', Icons.fitness_center,
          sessions.length >= 10, progress: '${sessions.length}/10'),
      AchievementBadge('First PR', 'Set a personal record', Icons.emoji_events,
          personalRecords >= 1, progress: '$personalRecords/1'),
      AchievementBadge('Record Breaker', 'Set 10 personal records', Icons.emoji_events,
          personalRecords >= 10, progress: '$personalRecords/10'),
      AchievementBadge('Century Sets', 'Log 100 sets', Icons.layers, totalSets >= 100,
          progress: '$totalSets/100'),
      AchievementBadge('Set Machine', 'Log 500 sets', Icons.layers, totalSets >= 500,
          progress: '$totalSets/500'),
      AchievementBadge('Explorer', 'Train 5 different exercises',
          Icons.grid_view_rounded, exerciseIds.length >= 5,
          progress: '${exerciseIds.length}/5'),
      AchievementBadge('Well-Rounded', 'Train 10 different exercises',
          Icons.grid_view_rounded, exerciseIds.length >= 10,
          progress: '${exerciseIds.length}/10'),
    ];

    return AchievementProgress(
      level: level,
      xp: xp,
      xpInLevel: xpInLevel,
      streak: streak,
      personalRecords: personalRecords,
      totalVolume: totalVolume,
      sessionCount: sessions.length,
      badges: badges,
    );
  }
}
