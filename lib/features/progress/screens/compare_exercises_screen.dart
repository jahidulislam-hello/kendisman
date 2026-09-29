import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitzella/core/services/fitness_data_service.dart';
import 'package:fitzella/features/progress/widgets/progress_widgets.dart';

class CompareExercisesScreen extends ConsumerStatefulWidget {
  const CompareExercisesScreen({super.key});

  @override
  ConsumerState<CompareExercisesScreen> createState() =>
      _CompareExercisesScreenState();
}

class _CompareExercisesScreenState
    extends ConsumerState<CompareExercisesScreen> {
  int _range = 3;
  final _ranges = const ['1M', '3M', '6M', 'All'];
  final List<String> _selected = [];
  final _colors = const [
    Color(0xFF2563EB),
    Color(0xFF22C55E),
    Color(0xFFF59E0B),
    Color(0xFFA855F7),
  ];

  Future<void> _openPicker(List<Map<String, dynamic>> exercises) async {
    final available = exercises
        .where((exercise) => !_selected.contains(exercise['id']))
        .toList();
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: ListView(
          children: available
              .map((exercise) => ListTile(
                    title: Text(exercise['name'] as String),
                    subtitle:
                        Text(exercise['muscle_group'] as String? ?? ''),
                    onTap: () =>
                        Navigator.pop(context, exercise['id'] as String),
                  ))
              .toList(),
        ),
      ),
    );
    if (result != null && mounted && _selected.length < _colors.length) {
      setState(() => _selected.add(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    final catalog = ref.watch(exerciseCatalogProvider);
    final history = ref.watch(workoutHistoryProvider);
    if (catalog.isLoading || history.isLoading) {
      return Scaffold(
        backgroundColor: colors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (catalog.hasError || history.hasError) {
      return Scaffold(
        backgroundColor: colors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Could not load exercise comparison data.',
                  style: TextStyle(color: colors.textPrimary)),
              TextButton(
                onPressed: () {
                  ref.invalidate(exerciseCatalogProvider);
                  ref.invalidate(workoutHistoryProvider);
                },
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }
    final exercises = catalog.value ?? const <Map<String, dynamic>>[];
    final sessions = history.value ?? const <Map<String, dynamic>>[];
    final selectedRows = _selected
        .map((id) => exercises
            .where((exercise) => exercise['id'] == id)
            .firstOrNull)
        .whereType<Map<String, dynamic>>()
        .toList();
    final cutoff = _range == 3
        ? null
        : DateTime.now().subtract(
            Duration(days: const [30, 90, 180, 365][_range]),
          );

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
                trailing: IconButton(
                  onPressed: _selected.length >= _colors.length
                      ? null
                      : () => _openPicker(exercises),
                  icon: const Icon(Icons.add),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  if (_selected.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Add exercises with logged sets to compare estimated one-rep max progress.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.textSecondary),
                      ),
                    ),
                  ...selectedRows.asMap().entries.map((entry) {
                    final color = _colors[entry.key % _colors.length];
                    final id = entry.value['id'] as String;
                    final best = _bestSeries(id, sessions, cutoff);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ProgressSurfaceCard(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: color, shape: BoxShape.circle)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                  entry.value['name'] as String? ?? 'Exercise',
                                  style: TextStyle(
                                      color: colors.textPrimary,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Text(
                              best.isEmpty
                                  ? 'No logged sets'
                                  : '${best.last.y.toStringAsFixed(1)} lb',
                              style: TextStyle(color: colors.textSecondary),
                            ),
                            IconButton(
                              onPressed: () =>
                                  setState(() => _selected.remove(id)),
                              icon: Icon(Icons.close,
                                  color: colors.textMuted, size: 18),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(_ranges.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ProgressChip(
                          label: _ranges[index],
                          selected: _range == index,
                          onTap: () => setState(() => _range = index),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 14),
                  ProgressSurfaceCard(
                    child: SizedBox(
                      height: 240,
                      child: selectedRows.isEmpty ||
                              selectedRows.every((exercise) =>
                                  _bestSeries(exercise['id'] as String,
                                      sessions, cutoff).isEmpty)
                          ? Center(
                              child: Text(
                                  'No exercise progress to chart for this range.',
                                  style:
                                      TextStyle(color: colors.textSecondary)))
                          : LineChart(
                              LineChartData(
                                gridData: const FlGridData(show: false),
                                titlesData: const FlTitlesData(show: false),
                                borderData: FlBorderData(show: false),
                                lineBarsData: selectedRows
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final spots = _bestSeries(
                                      entry.value['id'] as String,
                                      sessions,
                                      cutoff);
                                  return LineChartBarData(
                                    spots: spots,
                                    isCurved: true,
                                    color:
                                        _colors[entry.key % _colors.length],
                                    barWidth: 3,
                                    dotData: const FlDotData(show: true),
                                  );
                                }).where((line) => line.spots.length > 1).toList(),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Estimated one-rep max uses the logged weight and reps (Epley formula).',
                    style: TextStyle(color: colors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _bestSeries(
    String exerciseId,
    List<Map<String, dynamic>> sessions,
    DateTime? cutoff,
  ) {
    final points = <FlSpot>[];
    for (final session in sessions.reversed) {
      final date = DateTime.parse(session['started_at'] as String).toLocal();
      if (cutoff != null && date.isBefore(cutoff)) continue;
      final sets = (session['logged_sets'] as List? ?? const [])
          .cast<Map<String, dynamic>>()
          .where((set) => set['exercise_id'] == exerciseId);
      var best = 0.0;
      for (final set in sets) {
        final weight = (set['weight'] as num?)?.toDouble() ?? 0;
        final reps = (set['reps'] as num?)?.toInt() ?? 0;
        final estimate = reps > 0 ? weight * (1 + reps / 30) : weight;
        if (estimate > best) best = estimate;
      }
      if (best > 0) points.add(FlSpot(points.length.toDouble(), best));
    }
    return points;
  }
}
