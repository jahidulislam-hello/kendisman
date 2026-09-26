import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fitzella/features/progress/data/progress_mock_data.dart';
import 'package:fitzella/features/progress/widgets/progress_widgets.dart';

class ProgressExerciseDetailScreen extends StatefulWidget {
  final String exerciseId;
  final int initialTab;

  const ProgressExerciseDetailScreen({
    super.key,
    required this.exerciseId,
    this.initialTab = 0,
  });

  @override
  State<ProgressExerciseDetailScreen> createState() => _ProgressExerciseDetailScreenState();
}

class _ProgressExerciseDetailScreenState extends State<ProgressExerciseDetailScreen> {
  late int _tab;
  int _metric = 0;
  int _range = 4; // ALL for leg press screenshot
  final _metrics = const ['Weight', 'Reps', 'Volume'];
  final _ranges = const ['1M', '3M', '6M', '1Y', 'ALL'];

  @override
  void initState() {
    super.initState();
    _tab = widget.initialTab;
    if (widget.exerciseId == 'conventional-deadlift') {
      _range = 1; // 3M per screenshot 10
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    final name = ProgressMockData.exerciseName(widget.exerciseId);
    final stats = ProgressMockData.exerciseStats[widget.exerciseId] ??
        ProgressMockData.exerciseStats['leg-press']!;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
              child: ProgressBackHeader(title: name),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ProgressSegmentedTabs(
                tabs: const ['About', 'History', 'Progress'],
                index: _tab,
                onChanged: (i) => setState(() => _tab = i),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: IndexedStack(
                index: _tab,
                children: [
                  _AboutTab(exerciseId: widget.exerciseId, stats: stats),
                  _HistoryTab(exerciseId: widget.exerciseId),
                  _ProgressTab(
                    exerciseId: widget.exerciseId,
                    stats: stats,
                    metric: _metric,
                    range: _range,
                    metrics: _metrics,
                    ranges: _ranges,
                    onMetric: (i) => setState(() => _metric = i),
                    onRange: (i) => setState(() => _range = i),
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

class _AboutTab extends StatelessWidget {
  final String exerciseId;
  final Map<String, String> stats;

  const _AboutTab({required this.exerciseId, required this.stats});

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    final primary = stats['primaryMuscle'] ?? 'QUADS (PRIMARY)';
    final secondary = (stats['secondaryMuscles'] ?? 'GLUTES').split(',');
    final hasInstructions = exerciseId == 'leg-press';

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        if (!hasInstructions)
          ProgressSurfaceCard(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 36),
                child: Text('Video demo coming soon', style: TextStyle(color: colors.textSecondary)),
              ),
            ),
          ),
        if (!hasInstructions) const SizedBox(height: 10),
        ProgressSurfaceCard(
          onTap: () {},
          child: Row(
            children: [
              Expanded(
                child: Text('Watch how-to videos on YouTube', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600)),
              ),
              Icon(Icons.chevron_right, color: colors.accent),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const ProgressFilterLabel('Muscles involved'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _MuscleTag(label: primary, primary: true),
            ...secondary.map((s) => _MuscleTag(label: s.trim(), primary: false)),
          ],
        ),
        const SizedBox(height: 18),
        const ProgressFilterLabel('Instructions'),
        const SizedBox(height: 10),
        if (!hasInstructions)
          Text('Instructions coming soon', style: TextStyle(color: colors.textSecondary))
        else
          ProgressSurfaceCard(
            child: Column(
              children: List.generate(ProgressMockData.legPressInstructions.length, (i) {
                return Padding(
                  padding: EdgeInsets.only(bottom: i == ProgressMockData.legPressInstructions.length - 1 ? 0 : 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: colors.accent.withValues(alpha: 0.2),
                        child: Text('${i + 1}', style: TextStyle(color: colors.accent, fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          ProgressMockData.legPressInstructions[i],
                          style: TextStyle(color: colors.textPrimary, fontSize: 14, height: 1.35),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

class _MuscleTag extends StatelessWidget {
  final String label;
  final bool primary;
  const _MuscleTag({required this.label, required this.primary});

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: primary ? colors.accent.withValues(alpha: 0.12) : colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary ? colors.accent : colors.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: primary ? colors.accent : colors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  final String exerciseId;
  const _HistoryTab({required this.exerciseId});

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    final sessions = ProgressMockData.exerciseHistory[exerciseId] ??
        ProgressMockData.exerciseHistory['leg-press']!;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: sessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final session = sessions[i];
        return ProgressSurfaceCard(
          child: Column(
            children: [
              Row(
                children: [
                  Text(session.dateLabel, style: TextStyle(color: colors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text('1RM', style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 10),
              ...session.sets.map((s) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: colors.border,
                        child: Text('${s.set}', style: TextStyle(color: colors.textPrimary, fontSize: 12)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(s.weightReps, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600)),
                      ),
                      if (s.isPr) ...[
                        Icon(Icons.emoji_events, color: colors.accent, size: 16),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        s.oneRm,
                        style: TextStyle(
                          color: s.isPr ? colors.accent : colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _ProgressTab extends StatelessWidget {
  final String exerciseId;
  final Map<String, String> stats;
  final int metric;
  final int range;
  final List<String> metrics;
  final List<String> ranges;
  final ValueChanged<int> onMetric;
  final ValueChanged<int> onRange;

  const _ProgressTab({
    required this.exerciseId,
    required this.stats,
    required this.metric,
    required this.range,
    required this.metrics,
    required this.ranges,
    required this.onMetric,
    required this.onRange,
  });

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    final best = ProgressMockData.bestSets[exerciseId] ?? ProgressMockData.bestSets['leg-press']!;
    final isDeadlift = exerciseId == 'conventional-deadlift';

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        ProgressSegmentedTabs(
          tabs: metrics,
          index: metric,
          onChanged: onMetric,
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(ranges.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ProgressChip(
                  label: ranges[i],
                  selected: range == i,
                  onTap: () => onRange(i),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 14),
        ProgressSurfaceCard(
          child: SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minY: isDeadlift ? 220 : 265,
                maxY: isDeadlift ? 270 : 315,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (_) => FlLine(color: colors.border, strokeWidth: 1, dashArray: [4, 4]),
                  getDrawingVerticalLine: (_) => FlLine(color: colors.border, strokeWidth: 1, dashArray: [4, 4]),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 34,
                      getTitlesWidget: (v, m) => Text(v.toInt().toString(), style: TextStyle(color: colors.textMuted, fontSize: 10)),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, m) {
                        final labels = isDeadlift
                            ? const ['Jul 5', 'Jul 26', 'Aug 23', 'Sep 6']
                            : const ['Jul 7', 'Jul 28', 'Aug 18', 'Sep 1'];
                        final i = v.toInt();
                        if (i < 0 || i >= labels.length) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(labels[i], style: TextStyle(color: colors.textMuted, fontSize: 10)),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: isDeadlift
                        ? const [FlSpot(0, 225), FlSpot(1, 240), FlSpot(2, 255), FlSpot(3, 262.5)]
                        : const [FlSpot(0, 270), FlSpot(1, 285), FlSpot(2, 300), FlSpot(3, 307.5)],
                    isCurved: true,
                    color: colors.accent,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (s, p, b, i) => FlDotCirclePainter(radius: 4, color: colors.accent, strokeWidth: 2, strokeColor: colors.surface),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colors.accent.withValues(alpha: 0.3),
                          colors.accent.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        const ProgressFilterLabel('Summary statistics'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _StatCard(label: 'Est. 1RM', value: stats['est1rm']!)),
            const SizedBox(width: 10),
            Expanded(child: _StatCard(label: 'Personal Record', value: stats['pr']!)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _StatCard(label: 'Total Volume', value: stats['volume']!)),
            const SizedBox(width: 10),
            Expanded(child: _StatCard(label: 'Total Reps', value: stats['reps']!)),
          ],
        ),
        const SizedBox(height: 18),
        const ProgressFilterLabel('Best sets'),
        const SizedBox(height: 10),
        ProgressSurfaceCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: best.map((b) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(b.weightReps, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700)),
                              Text(b.date, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(b.oneRm, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700)),
                            Text('1RM', style: TextStyle(color: colors.textMuted, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (b != best.last) Divider(height: 1, color: colors.border),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    return ProgressSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(color: colors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
