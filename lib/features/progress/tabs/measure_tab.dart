import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:fitzella/core/services/fitness_data_service.dart';
import 'package:fitzella/features/progress/widgets/progress_widgets.dart';

class MeasureTab extends ConsumerStatefulWidget {
  const MeasureTab({super.key});

  @override
  ConsumerState<MeasureTab> createState() => _MeasureTabState();
}

class _MeasureTabState extends ConsumerState<MeasureTab> {
  int _range = 3;
  final _ranges = const ['1M', '3M', '6M', '1Y'];
  bool _saving = false;

  Future<void> _addMeasurement() async {
    final weight = TextEditingController();
    final bodyFat = TextEditingController();
    final result = await showDialog<(double?, double?)>(
      context: context,
      builder: (context) {
        final colors = progressColors(context);
        return AlertDialog(
          title: const Text('Log measurement'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: weight,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Body weight (lb)'),
              ),
              TextField(
                controller: bodyFat,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Body fat (%)'),
              ),
              const SizedBox(height: 8),
              Text('Leave a field blank if you are not recording it.',
                  style: TextStyle(color: colors.textMuted, fontSize: 12)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final weightValue = weight.text.trim().isEmpty
                    ? null
                    : double.tryParse(weight.text.trim());
                final fatValue = bodyFat.text.trim().isEmpty
                    ? null
                    : double.tryParse(bodyFat.text.trim());
                if ((weight.text.trim().isNotEmpty && weightValue == null) ||
                    (bodyFat.text.trim().isNotEmpty && fatValue == null) ||
                    (weightValue == null && fatValue == null)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enter a valid measurement.')),
                  );
                  return;
                }
                Navigator.pop(context, (weightValue, fatValue));
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    weight.dispose();
    bodyFat.dispose();
    if (result == null) return;
    setState(() => _saving = true);
    try {
      await ref.read(fitnessDataServiceProvider).addMeasurement(
            measuredOn: DateTime.now(),
            weightLb: result.$1,
            bodyFatPct: result.$2,
          );
      ref.invalidate(bodyMeasurementsProvider);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save measurement: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    final measurements = ref.watch(bodyMeasurementsProvider);
    return measurements.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Could not load measurements: $error',
                  style: TextStyle(color: colors.textPrimary),
                  textAlign: TextAlign.center),
              TextButton(
                onPressed: () => ref.invalidate(bodyMeasurementsProvider),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
      data: (rows) {
        final cutoff = DateTime.now().subtract(
          Duration(days: const [30, 90, 180, 365][_range]),
        );
        final filtered = rows.where((row) {
          final date = DateTime.tryParse(row['measured_on'] as String? ?? '');
          return date != null && !date.isBefore(cutoff);
        }).toList();
        final weights = filtered
            .where((row) => row['weight_lb'] != null)
            .toList()
            .reversed
            .toList();
        final latestWeight = rows.firstWhere(
          (row) => row['weight_lb'] != null,
          orElse: () => <String, dynamic>{},
        );
        final latestFat = rows.firstWhere(
          (row) => row['body_fat_pct'] != null,
          orElse: () => <String, dynamic>{},
        );
        final spots = weights.asMap().entries.map((entry) {
          return FlSpot(
            entry.key.toDouble(),
            (entry.value['weight_lb'] as num).toDouble(),
          );
        }).toList();
        final values = spots.map((spot) => spot.y).toList();
        final minY = values.isEmpty
            ? 0.0
            : values.reduce((a, b) => a < b ? a : b) - 2;
        final maxY = values.isEmpty
            ? 1.0
            : values.reduce((a, b) => a > b ? a : b) + 2;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Row(
              children: List.generate(_ranges.length, (i) {
                return Padding(
                  padding: EdgeInsets.only(right: i == _ranges.length - 1 ? 0 : 8),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('BODY WEIGHT',
                            style: TextStyle(
                                color: colors.textMuted,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5)),
                      ),
                      Icon(Icons.monitor_weight_outlined,
                          color: colors.accent, size: 20),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    latestWeight.isEmpty
                        ? 'No weight recorded'
                        : '${(latestWeight['weight_lb'] as num).toStringAsFixed(1)} lb',
                    style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w800),
                  ),
                  if (spots.length > 1) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: LineChart(
                        LineChartData(
                          minY: minY,
                          maxY: maxY,
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              color: colors.accent,
                              barWidth: 2.5,
                              dotData: const FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: colors.accent.withValues(alpha: 0.12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (latestWeight.isNotEmpty)
                    Text(
                      'Recorded ${DateFormat('d MMM yyyy').format(DateTime.parse(latestWeight['measured_on'] as String))}',
                      style: TextStyle(color: colors.textMuted, fontSize: 12),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ProgressSurfaceCard(
              child: Row(
                children: [
                  Icon(Icons.percent, color: colors.accent, size: 24),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('BODY FAT',
                            style: TextStyle(
                                color: colors.textMuted,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5)),
                        const SizedBox(height: 4),
                        Text(
                          latestFat.isEmpty
                              ? 'No body-fat measurement'
                              : '${(latestFat['body_fat_pct'] as num).toStringAsFixed(1)}%',
                          style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Text('Measurement history',
                    style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700)),
                const Spacer(),
                TextButton.icon(
                  onPressed: _saving ? null : _addMeasurement,
                  icon: const Icon(Icons.add),
                  label: Text(_saving ? 'Saving…' : 'Log'),
                ),
              ],
            ),
            if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  rows.isEmpty
                      ? 'No measurements yet. Log your first body measurement.'
                      : 'No measurements in this date range.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.textSecondary),
                ),
              )
            else
              ...filtered.map((row) {
                final date = DateTime.parse(row['measured_on'] as String);
                final weight = row['weight_lb'] as num?;
                final fat = row['body_fat_pct'] as num?;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ProgressSurfaceCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(DateFormat('d MMM yyyy').format(date),
                              style: TextStyle(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w600)),
                        ),
                        if (weight != null)
                          Text('${weight.toStringAsFixed(1)} lb',
                              style: TextStyle(color: colors.textSecondary)),
                        if (weight != null && fat != null)
                          const SizedBox(width: 10),
                        if (fat != null)
                          Text('${fat.toStringAsFixed(1)}%',
                              style: TextStyle(color: colors.textSecondary)),
                      ],
                    ),
                  ),
                );
              }),
            const SizedBox(height: 8),
            Text(
              'Body measurements currently support weight and body-fat percentage.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textMuted, fontSize: 12),
            ),
          ],
        );
      },
    );
  }
}
