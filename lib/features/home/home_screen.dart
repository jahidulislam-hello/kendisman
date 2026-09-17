import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitzella/core/theme/app_theme.dart';
import 'package:fitzella/core/theme/theme_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            _Header(colors: colors),
            const SizedBox(height: 18),
            _UpNextCard(colors: colors, onContinue: () => context.go('/workout')),
            const SizedBox(height: 22),
            _WeeklySnapshot(colors: colors),
            const SizedBox(height: 22),
            _ThisWeekCalendar(colors: colors),
            const SizedBox(height: 18),
            _AchievementsCard(
              colors: colors,
              onTap: () => context.push('/home/achievements'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final AppColors colors;
  const _Header({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: colors.accent, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text('D', style: TextStyle(color: colors.onAccent, fontSize: 22, fontWeight: FontWeight.w800)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Saturday, 5 Sept', style: TextStyle(color: colors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text('Ready, demo_athlete?', style: TextStyle(color: colors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ],
    );
  }
}

class _UpNextCard extends StatelessWidget {
  final AppColors colors;
  final VoidCallback onContinue;
  const _UpNextCard({required this.colors, required this.onContinue});

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
              Text('~10m', style: TextStyle(color: colors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
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
                    Text('Plan · Week 1', style: TextStyle(color: colors.textSecondary, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text('Day 1', style: TextStyle(color: colors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colors.accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.accent.withValues(alpha: 0.45)),
                    ),
                    child: Icon(Icons.tag, color: colors.accent, size: 18),
                  ),
                  const SizedBox(height: 8),
                  ...[28.0, 18.0, 22.0].map(
                    (w) => Container(
                      margin: const EdgeInsets.only(bottom: 3),
                      width: w,
                      height: 3,
                      decoration: BoxDecoration(color: colors.border, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('3 exercises', style: TextStyle(color: colors.textMuted, fontSize: 11)),
                ],
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
  const _WeeklySnapshot({required this.colors});

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFFA78BFA);
    const green = Color(0xFF4ADE80);
    const orange = Color(0xFFFB923C);
    const yellow = Color(0xFFFBBF24);

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
                    Text('31,240 lb', style: TextStyle(color: colors.textPrimary, fontSize: 30, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF87171).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF87171).withValues(alpha: 0.55)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_upward, size: 12, color: Color(0xFFF87171)),
                          SizedBox(width: 2),
                          Text('48.1% vs last week', style: TextStyle(color: Color(0xFFF87171), fontSize: 11, fontWeight: FontWeight.w700)),
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
                    maxY: 4,
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [FlSpot(0, 1.2), FlSpot(1, 2.1), FlSpot(2, 1.8), FlSpot(3, 3.6), FlSpot(4, 2.4)],
                        isCurved: true,
                        color: colors.accent,
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                          checkToShowDot: (s, _) => s.x == 3,
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
            Expanded(child: _MetricCard(colors: colors, icon: Icons.layers, color: purple, label: 'SETS', value: '17', sub: '17 per workout')),
            const SizedBox(width: 10),
            Expanded(child: _MetricCard(colors: colors, icon: Icons.calendar_today, color: green, label: 'WORKOUTS', value: '1/2', sub: '1 remaining')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _MetricCard(colors: colors, icon: Icons.schedule, color: orange, label: 'TIME', value: '1h', sub: '2h 17m last week')),
            const SizedBox(width: 10),
            Expanded(child: _MetricCard(colors: colors, icon: Icons.local_fire_department, color: yellow, label: 'STREAK', value: '0', sub: 'day streak')),
          ],
        ),
      ],
    );
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
  const _ThisWeekCalendar({required this.colors});

  @override
  Widget build(BuildContext context) {
    const days = [
      _Day('M', '31', DayState.past),
      _Day('T', '2', DayState.done),
      _Day('W', '3', DayState.past),
      _Day('T', '4', DayState.past),
      _Day('F', '5', DayState.past),
      _Day('S', '6', DayState.today),
      _Day('S', '7', DayState.future),
    ];

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

class _AchievementsCard extends StatelessWidget {
  final AppColors colors;
  final VoidCallback onTap;
  const _AchievementsCard({required this.colors, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFD4A017).withValues(alpha: 0.65)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 70,
                height: 36,
                child: Stack(
                  children: [
                    _badge(0, const Color(0xFFFBBF24), Icons.emoji_events),
                    _badge(18, colors.accent, Icons.local_fire_department),
                    _badge(36, colors.success, Icons.star),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('This Week Achievements', style: TextStyle(color: colors.textPrimary, fontSize: 15, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text('8 badges earned · Level 24', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colors.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(double left, Color color, IconData icon) {
    return Positioned(
      left: left,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: colors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 1.5),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}
