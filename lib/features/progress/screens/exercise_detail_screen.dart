import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitzella/core/services/fitness_data_service.dart';
import 'package:fitzella/features/progress/widgets/progress_widgets.dart';
import 'package:fitzella/features/workout/widgets/exercise_gif.dart';

class ProgressExerciseDetailScreen extends ConsumerStatefulWidget {
  final String exerciseId;
  final int initialTab;

  const ProgressExerciseDetailScreen({
    super.key,
    required this.exerciseId,
    this.initialTab = 0,
  });

  @override
  ConsumerState<ProgressExerciseDetailScreen> createState() =>
      _ProgressExerciseDetailScreenState();
}

class _ProgressExerciseDetailScreenState
    extends ConsumerState<ProgressExerciseDetailScreen> {
  late int _tab = widget.initialTab;
  int _metric = 0;
  int _range = 4;

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
      final error = catalog.error ?? history.error;
      return Scaffold(
        backgroundColor: colors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Could not load exercise progress: $error',
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
    final exercise = (catalog.value ?? const []).where(
      (row) => row['id'] == widget.exerciseId,
    ).firstOrNull;
    if (exercise == null) {
      return Scaffold(
        backgroundColor: colors.background,
        body: Center(
          child: Text('Exercise not found in your library.',
              style: TextStyle(color: colors.textSecondary)),
        ),
      );
    }

    final sessions = <Map<String, dynamic>>[];
    for (final session in history.value ?? const <Map<String, dynamic>>[]) {
      final sets = (session['logged_sets'] as List? ?? const [])
          .cast<Map<String, dynamic>>()
          .where((set) => set['exercise_id'] == widget.exerciseId)
          .toList();
      if (sets.isNotEmpty) sessions.add({'session': session, 'sets': sets});
    }
    final cutoff = _range == 4
        ? null
        : DateTime.now().subtract(
            Duration(days: const [30, 90, 180, 365, 365][_range]),
          );
    final filtered = sessions.where((entry) {
      final date = DateTime.parse(
        (entry['session'] as Map<String, dynamic>)['started_at'] as String,
      ).toLocal();
      return cutoff == null || !date.isBefore(cutoff);
    }).toList();
    final name = exercise['name'] as String? ?? 'Exercise';

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
                onChanged: (index) => setState(() => _tab = index),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _tab == 0
                  ? _about(colors, exercise)
                  : _tab == 1
                      ? _history(colors, filtered)
                      : _progress(colors, filtered),
            ),
          ],
        ),
      ),
    );
  }

  Widget _about(dynamic colors, Map<String, dynamic> exercise) {
    final muscle = exercise['muscle_group'] as String? ?? '—';
    final equipment = exercise['equipment_type'] as String? ?? '—';
    final name = exercise['name'] as String? ?? '';
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 1,
            child: ExerciseGif(
              name: name,
              gifUrl: exerciseDemoUrl(exercise),
              expand: true,
              borderRadius: 16,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ProgressSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Exercise details',
                  style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 14),
              _detailRow(colors, 'Muscle group', muscle),
              const SizedBox(height: 10),
              _detailRow(colors, 'Equipment', equipment),
            ],
          ),
        ),
      ],
    );
  }

  Widget _history(dynamic colors, List<Map<String, dynamic>> sessions) {
    if (sessions.isEmpty) {
      return Center(
        child: Text('No logged sets for this exercise yet.',
            style: TextStyle(color: colors.textSecondary)),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: sessions.map((entry) {
        final session = entry['session'] as Map<String, dynamic>;
        final sets = entry['sets'] as List<Map<String, dynamic>>;
        final date = DateTime.parse(session['started_at'] as String).toLocal();
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ProgressSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: TextStyle(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...sets.map((set) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text(
                        'Set ${set['set_index']}: ${set['weight']} lb × ${set['reps']} reps',
                        style: TextStyle(color: colors.textSecondary),
                      ),
                    )),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _progress(dynamic colors, List<Map<String, dynamic>> sessions) {
    final points = <FlSpot>[];
    for (var i = 0; i < sessions.length; i++) {
      final sets = sessions[i]['sets'] as List<Map<String, dynamic>>;
      final top = sets.fold<double>(0, (best, set) {
        final weight = (set['weight'] as num?)?.toDouble() ?? 0;
        final reps = (set['reps'] as num?)?.toInt() ?? 0;
        final value = _metric == 0
            ? weight
            : _metric == 1
                ? reps.toDouble()
                : weight * reps;
        return value > best ? value : best;
      });
      points.add(FlSpot(i.toDouble(), top));
    }
    final metricLabel = const ['Best set weight', 'Best set reps', 'Set volume'][_metric];
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(3, (index) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ProgressChip(
                    label: const ['Weight', 'Reps', 'Volume'][index],
                    selected: _metric == index,
                    onTap: () => setState(() => _metric = index),
                  ),
                )),
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(5, (index) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ProgressChip(
                    label: const ['1M', '3M', '6M', '1Y', 'All'][index],
                    selected: _range == index,
                    onTap: () => setState(() => _range = index),
                  ),
                )),
          ),
        ),
        const SizedBox(height: 14),
        ProgressSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(metricLabel,
                  style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              if (points.isEmpty)
                Text('No data in this time range.',
                    style: TextStyle(color: colors.textSecondary))
              else if (points.length == 1)
                Text(points.single.y.toStringAsFixed(1),
                    style: TextStyle(
                        color: colors.accent,
                        fontSize: 28,
                        fontWeight: FontWeight.w800))
              else
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: points,
                          isCurved: true,
                          color: colors.accent,
                          barWidth: 2.5,
                          dotData: const FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _detailRow(dynamic colors, String label, String value) => Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: colors.textSecondary))),
          Text(value,
              style: TextStyle(
                  color: colors.textPrimary, fontWeight: FontWeight.w600)),
        ],
      );
}
