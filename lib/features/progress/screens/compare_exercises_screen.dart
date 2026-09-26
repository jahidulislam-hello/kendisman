import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fitzella/features/progress/data/progress_mock_data.dart';
import 'package:fitzella/features/progress/widgets/progress_widgets.dart';

class CompareExercisesScreen extends StatefulWidget {
  const CompareExercisesScreen({super.key});

  @override
  State<CompareExercisesScreen> createState() => _CompareExercisesScreenState();
}

class _CompareExercisesScreenState extends State<CompareExercisesScreen> {
  int _range = 3; // All
  final _ranges = const ['1M', '3M', '6M', 'All'];
  final List<String> _selected = ['leg-press', 'barbell-back-squat'];
  final _colors = const [Color(0xFF2563EB), Color(0xFF22C55E), Color(0xFFF59E0B), Color(0xFFA855F7)];

  Future<void> _openPicker() async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SelectExercisesSheet(initial: List.of(_selected)),
    );
    if (result != null) {
      setState(() {
        _selected
          ..clear()
          ..addAll(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 16, 0),
              child: ProgressBackHeader(
                title: 'Compare Exercises',
                showBackText: false,
                largeTitle: false,
                trailing: GestureDetector(
                  onTap: _openPicker,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: colors.border),
                    ),
                    child: Icon(Icons.add, color: colors.textPrimary, size: 20),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  ...List.generate(_selected.length, (i) {
                    final id = _selected[i];
                    final name = ProgressMockData.exerciseName(id);
                    final color = _colors[i % _colors.length];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ProgressSurfaceCard(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                            Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(name, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600)),
                            ),
                            Text('119 lb', style: TextStyle(color: colors.textSecondary, fontSize: 13)),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => setState(() => _selected.removeAt(i)),
                              child: Icon(Icons.close, color: colors.textMuted, size: 18),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(_ranges.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ProgressChip(
                          label: _ranges[i],
                          selected: _range == i,
                          onTap: () => setState(() => _range = i),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 14),
                  ProgressSurfaceCard(
                    child: SizedBox(
                      height: 220,
                      child: LineChart(
                        LineChartData(
                          minY: 80,
                          maxY: 180,
                          gridData: const FlGridData(show: false),
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, m) {
                                  const months = ['Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'];
                                  final i = v.toInt();
                                  if (i < 0 || i >= months.length) return const SizedBox.shrink();
                                  return Text(months[i], style: TextStyle(color: colors.textMuted, fontSize: 11));
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            if (_selected.isNotEmpty)
                              LineChartBarData(
                                spots: const [FlSpot(0, 90), FlSpot(1, 100), FlSpot(2, 110), FlSpot(3, 118), FlSpot(4, 128), FlSpot(5, 140), FlSpot(6, 155)],
                                isCurved: true,
                                color: _colors[0],
                                barWidth: 3,
                                dotData: const FlDotData(show: true),
                                belowBarData: BarAreaData(show: true, color: _colors[0].withValues(alpha: 0.12)),
                              ),
                            if (_selected.length > 1)
                              LineChartBarData(
                                spots: const [FlSpot(0, 105), FlSpot(1, 115), FlSpot(2, 125), FlSpot(3, 135), FlSpot(4, 145), FlSpot(5, 158), FlSpot(6, 170)],
                                isCurved: true,
                                color: _colors[1],
                                barWidth: 3,
                                dotData: const FlDotData(show: true),
                                belowBarData: BarAreaData(show: true, color: _colors[1].withValues(alpha: 0.12)),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _MiniStat(
                          icon: Icons.trending_up,
                          iconColor: const Color(0xFF22C55E),
                          label: '18M PROGRESS',
                          value: '+47%',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _MiniStat(
                          icon: Icons.emoji_events,
                          iconColor: const Color(0xFFF59E0B),
                          label: 'MOST IMPROVED',
                          value: _selected.isEmpty ? '-' : ProgressMockData.exerciseName(_selected.first).split(' ').first,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _MiniStat(
                          icon: Icons.calendar_today,
                          iconColor: colors.accent,
                          label: 'SESSIONS',
                          value: '26',
                        ),
                      ),
                    ],
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

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _MiniStat({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    return ProgressSurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(height: 10),
          Text(label, style: TextStyle(color: colors.textMuted, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
          const SizedBox(height: 4),
          Row(
            children: [
              Flexible(child: Text(value, style: TextStyle(color: colors.textPrimary, fontSize: 15, fontWeight: FontWeight.w800), overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 2),
              Icon(Icons.north_east, color: colors.success, size: 14),
            ],
          ),
        ],
      ),
    );
  }
}

class _SelectExercisesSheet extends StatefulWidget {
  final List<String> initial;
  const _SelectExercisesSheet({required this.initial});

  @override
  State<_SelectExercisesSheet> createState() => _SelectExercisesSheetState();
}

class _SelectExercisesSheetState extends State<_SelectExercisesSheet> {
  late final Set<String> _selected;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selected = widget.initial.toSet();
  }

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    final options = ProgressMockData.exerciseOptions
        .where((e) => e.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Select Exercises', style: TextStyle(color: colors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: colors.surface, shape: BoxShape.circle),
                      child: Icon(Icons.close, color: colors.textPrimary, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                style: TextStyle(color: colors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search all exercises.',
                  hintStyle: TextStyle(color: colors.textMuted),
                  prefixIcon: Icon(Icons.search, color: colors.textMuted),
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: colors.danger, size: 16),
                  const SizedBox(width: 6),
                  Text('MAX 4 EXERCISES', style: TextStyle(color: colors.danger, fontSize: 12, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => setState(() => _selected.clear()),
                    child: Text('Clear All', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                itemCount: options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final ex = options[i];
                  final selected = _selected.contains(ex.id);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selected) {
                          _selected.remove(ex.id);
                        } else if (_selected.length < 4) {
                          _selected.add(ex.id);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: selected ? colors.accent : colors.border, width: selected ? 1.5 : 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: colors.background,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.fitness_center, color: colors.accent, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ex.name, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700)),
                                Text(ex.muscle, style: TextStyle(color: colors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.4)),
                              ],
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selected ? colors.accent : Colors.transparent,
                              border: Border.all(color: selected ? colors.accent : colors.border, width: 1.5),
                            ),
                            child: selected ? Icon(Icons.check, color: colors.onAccent, size: 14) : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, _selected.toList()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accent,
                    foregroundColor: colors.onAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Done', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
