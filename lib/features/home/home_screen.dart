import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:fitzella/core/services/profile_prefs_service.dart';
import 'package:fitzella/core/services/fitness_data_service.dart';
import 'package:fitzella/core/theme/app_theme.dart';
import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/features/home/achievement_progress.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final profile = ref.watch(cachedProfileProvider);
    final summary = ref.watch(homeSummaryProvider);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            _Header(colors: colors, profile: profile),
            const SizedBox(height: 18),
            summary.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 36),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => _HomeLoadError(
                message: error.toString(),
                onRetry: () => ref.invalidate(homeSummaryProvider),
                colors: colors,
              ),
              data: (data) => Column(
                children: [
                  _UpNextCard(
                    colors: colors,
                    workoutName: _nextRoutineName(data),
                    exerciseCount: _nextExerciseCount(data),
                    onContinue: () => context.go('/workout'),
                  ),
                  const SizedBox(height: 22),
                  _WeeklySnapshot(colors: colors, summary: data),
                  const SizedBox(height: 22),
                  _ThisWeekCalendar(
                    colors: colors,
                    workedDays: (data['week_days'] as Set<String>?) ?? const {},
                  ),
                  const SizedBox(height: 18),
                  _AchievementsCard(
                    colors: colors,
                    onTap: () => context.push('/home/achievements'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _nextRoutineName(Map<String, dynamic> data) {
    final program = data['program'] as Map<String, dynamic>?;
    final routine = data['next_routine'] as Map<String, dynamic>?;
    if (routine == null) {
      return program == null ? 'No routine scheduled' : 'Rest day';
    }
    return '${program?['name'] ?? 'Routine'} · ${routine['name']}';
  }

  int _nextExerciseCount(Map<String, dynamic> data) {
    final routine = data['next_routine'] as Map<String, dynamic>?;
    return (routine?['routine_exercises'] as List? ?? const []).length;
  }
}

class _HomeLoadError extends StatelessWidget {
  const _HomeLoadError({
    required this.message,
    required this.onRetry,
    required this.colors,
  });

  final String message;
  final VoidCallback onRetry;
  final AppColors colors;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          children: [
            Text('Could not load your workout summary.',
                style: TextStyle(color: colors.textPrimary)),
            const SizedBox(height: 4),
            Text(message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: colors.textMuted, fontSize: 12)),
            TextButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      );
}

class _Header extends StatelessWidget {
  final AppColors colors;
  final CachedProfile? profile;
  const _Header({required this.colors, this.profile});

  @override
  Widget build(BuildContext context) {
    final name = profile?.displayName ?? 'Athlete';
    final initial = profile?.initial ?? 'A';
    final dateLabel = DateFormat('EEEE, d MMM').format(DateTime.now());

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: colors.accent, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(initial, style: TextStyle(color: colors.onAccent, fontSize: 22, fontWeight: FontWeight.w800)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dateLabel, style: TextStyle(color: colors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text('Ready, $name?', style: TextStyle(color: colors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ],
    );
  }
}

class _UpNextCard extends StatelessWidget {
  final AppColors colors;
  final String workoutName;
  final int exerciseCount;
  final VoidCallback onContinue;
  const _UpNextCard({
    required this.colors,
    required this.workoutName,
    required this.exerciseCount,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(width: 7, height: 7, decoration: BoxDecoration(color: colors.accent, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text('UP NEXT', style: TextStyle(color: colors.accent, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.6)),
              const Spacer(),
              Icon(Icons.schedule, size: 14, color: colors.textMuted),
              const SizedBox(width: 4),
              Text('$exerciseCount exercises', style: TextStyle(color: colors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(workoutName.contains('·') ? workoutName.split('·').first.trim() : 'Training plan', style: TextStyle(color: colors.textSecondary, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(workoutName.contains('·') ? workoutName.split('·').last.trim() : workoutName, style: TextStyle(color: colors.textPrimary, fontSize: 24, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),

            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: onContinue,
              icon: Icon(Icons.play_arrow_rounded, color: colors.onAccent, size: 22),
              label: Text('CONTINUE WORKOUT', style: TextStyle(color: colors.onAccent, fontWeight: FontWeight.w800, letterSpacing: 0.3)),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accent,
                foregroundColor: colors.onAccent,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklySnapshot extends StatelessWidget {
  final AppColors colors;
  final Map<String, dynamic> summary;
  const _WeeklySnapshot({required this.colors, required this.summary});

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFFA78BFA);
    const green = Color(0xFF4ADE80);
    const orange = Color(0xFFFB923C);
    const yellow = Color(0xFFFBBF24);
    final currentVolume =
        (summary['volume_this_week'] as num? ?? 0).toDouble() / 1000;
    final previousVolume =
        (summary['volume_last_week'] as num? ?? 0).toDouble() / 1000;
    final maxVolume =
        (currentVolume > previousVolume ? currentVolume : previousVolume)
            .clamp(1.0, double.infinity);

    return Column(
      children: [
        Row(
          children: [
            Text('Weekly Snapshot', style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
            const Spacer(),
            Text('Week 1', style: TextStyle(color: colors.accent, fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: colors.accent.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(Icons.tag, size: 12, color: colors.accent),
                        ),
                        const SizedBox(width: 6),
                        Text('VOLUME · this week', style: TextStyle(color: colors.textSecondary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.3)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('${_formatNumber(summary['volume_this_week'] as num? ?? 0)} kg', style: TextStyle(color: colors.textPrimary, fontSize: 30, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF87171).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF87171).withValues(alpha: 0.55)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.compare_arrows,
                            size: 12,
                            color: Color(0xFFF87171),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${_volumeDelta(summary)} vs last week',
                            style: const TextStyle(
                              color: Color(0xFFF87171),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 90,
                height: 56,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: maxVolume,
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, previousVolume),
                          FlSpot(1, currentVolume),
                        ],
                        isCurved: true,
                        color: colors.accent,
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                          checkToShowDot: (s, _) => s.x == 1,
                          getDotPainter: (s, p, b, i) => FlDotCirclePainter(
                            radius: 4,
                            color: colors.accent,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [colors.accent.withValues(alpha: 0.25), colors.accent.withValues(alpha: 0)],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _MetricCard(colors: colors, icon: Icons.layers, color: purple, label: 'SETS', value: '${summary['sets_this_week'] ?? 0}', sub: 'this week')),
            const SizedBox(width: 10),
            Expanded(child: _MetricCard(colors: colors, icon: Icons.calendar_today, color: green, label: 'WORKOUTS', value: '${summary['workouts_this_week'] ?? 0}', sub: 'this week')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _MetricCard(colors: colors, icon: Icons.schedule, color: orange, label: 'TIME', value: '${(summary['minutes_this_week'] as int? ?? 0) ~/ 60}h', sub: '${summary['minutes_this_week'] ?? 0} minutes this week')),
            const SizedBox(width: 10),
            Expanded(child: _MetricCard(colors: colors, icon: Icons.local_fire_department, color: yellow, label: 'STREAK', value: '${summary['streak_weeks'] ?? 0}', sub: (summary['streak_weeks'] as int? ?? 0) == 1 ? 'week in a row' : 'weeks in a row')),
          ],
        ),
      ],
    );
  }

  String _formatNumber(num number) => number.toStringAsFixed(0);

  String _volumeDelta(Map<String, dynamic> data) {
    final previous = (data['volume_last_week'] as num? ?? 0).toDouble();
    if (previous == 0) return '—';
    final current = (data['volume_this_week'] as num? ?? 0).toDouble();
    final percent = ((current - previous) / previous * 100).toStringAsFixed(1);
    return '${current >= previous ? '+' : ''}$percent%';
  }
}

class _MetricCard extends StatelessWidget {
  final AppColors colors;
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final String sub;

  const _MetricCard({
    required this.colors,
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.4)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: color, fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(sub, style: TextStyle(color: colors.textMuted, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ThisWeekCalendar extends StatelessWidget {
  final AppColors colors;
  final Set<String> workedDays;
  const _ThisWeekCalendar({required this.colors, required this.workedDays});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final monday = DateTime(today.year, today.month, today.day)
        .subtract(Duration(days: today.weekday - 1));
    final days = List.generate(7, (i) {
      final date = monday.add(Duration(days: i));
      final key = '${date.year}-${date.month}-${date.day}';
      return _Day(
        const ['M', 'T', 'W', 'T', 'F', 'S', 'S'][i],
        '${date.day}',
        workedDays.contains(key)
            ? DayState.done
            : date.isAfter(today)
                ? DayState.future
                : date.day == today.day &&
                        date.month == today.month &&
                        date.year == today.year
                    ? DayState.today
                    : DayState.past,
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('This Week', style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.map((d) {
              Color bg;
              Color fg;
              Widget child;
              switch (d.state) {
                case DayState.done:
                  bg = colors.success;
                  fg = Colors.white;
                  child = const Icon(Icons.check, size: 16, color: Colors.white);
                case DayState.today:
                  bg = colors.accent;
                  fg = colors.onAccent;
                  child = Text(d.date, style: TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: 13));
                case DayState.future:
                  bg = colors.background;
                  fg = colors.textMuted;
                  child = Text(d.date, style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 13));
                case DayState.past:
                  bg = colors.background;
                  fg = colors.textSecondary;
                  child = Text(d.date, style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 13));
              }
              return Column(
                children: [
                  Text(d.label, style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: bg,
                      shape: BoxShape.circle,
                      border: d.state == DayState.past || d.state == DayState.future
                          ? Border.all(color: colors.border)
                          : null,
                    ),
                    child: child,
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

enum DayState { past, done, today, future }

class _Day {
  final String label;
  final String date;
  final DayState state;
  const _Day(this.label, this.date, this.state);
}

class _AchievementsCard extends ConsumerWidget {
  final AppColors colors;
  final VoidCallback onTap;
  const _AchievementsCard({required this.colors, required this.onTap});

  static const _chipColors = [
    Color(0xFF60A5FA),
    Color(0xFF4ADE80),
    Color(0xFFFB923C),
    Color(0xFFC084FC),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(workoutHistoryProvider);
    final progress = history.maybeWhen(
      data: AchievementProgress.fromSessions,
      orElse: () => AchievementProgress.empty,
    );
    final badges = progress.badges.where((badge) => badge.earned).toList();
    final summary = history.maybeWhen(
      data: (_) => '${progress.earnedCount} badges earned · Level ${progress.level}',
      orElse: () => 'Badges · Level',
    );

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Weekly achievements',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 6,
                    child: Text(
                      summary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: colors.textMuted, size: 20),
                ],
              ),
              if (badges.isNotEmpty) ...[
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var i = 0; i < badges.length; i++) ...[
                        if (i > 0) const SizedBox(width: 8),
                        _AchievementChip(
                          badge: badges[i],
                          color: _chipColors[i % _chipColors.length],
                          muted: colors.textMuted,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AchievementChip extends StatelessWidget {
  final AchievementBadge badge;
  final Color color;
  final Color muted;

  const _AchievementChip({
    required this.badge,
    required this.color,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    final earned = badge.earned;
    final tint = earned ? color : muted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: earned ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tint.withValues(alpha: earned ? 0.45 : 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badge.icon, size: 14, color: tint),
          const SizedBox(width: 6),
          Text(
            badge.title,
            style: TextStyle(
              color: tint,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
