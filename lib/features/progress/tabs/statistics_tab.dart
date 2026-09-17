import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fitzella/features/progress/data/progress_mock_data.dart';
import 'package:fitzella/features/progress/widgets/progress_widgets.dart';

class StatisticsTab extends StatefulWidget {
  const StatisticsTab({super.key});

  @override
  State<StatisticsTab> createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab> {
  int _rangeIndex = 2; // 3M
  final _ranges = const ['1W', '1M', '3M', '6M', '1Y', 'All'];

  @override
  Widget build(BuildContext context) {
    final percents = ProgressMockData.musclePercents;
    final values = ProgressMockData.muscleDistribution;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        ProgressNavCard(
          icon: Icons.military_tech_outlined,
          title: 'Personal records',
          subtitle: 'View your all-time bests',
          onTap: () => context.push('/progress/personal-records'),
        ),
        const SizedBox(height: 10),
        ProgressNavCard(
          icon: Icons.show_chart,
          title: 'Compare Exercises',
          subtitle: 'Analyze 1RM across exercises',
          onTap: () => context.push('/progress/compare-exercises'),
        ),
        const SizedBox(height: 10),
        ProgressNavCard(
          icon: Icons.bar_chart_rounded,
          title: 'Main Exercises',
          subtitle: 'Your most frequent training staples',
          onTap: () => context.push('/progress/main-exercises'),
        ),
        const SizedBox(height: 16),
        ProgressSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Muscle Distribution',
                style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_ranges.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ProgressChip(
                        label: _ranges[i],
                        selected: _rangeIndex == i,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        onTap: () => setState(() => _rangeIndex = i),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: RadarChart(
                  RadarChartData(
                    dataSets: [
                      RadarDataSet(
                        dataEntries: [
                          RadarEntry(value: values['Chest']!.toDouble()),
                          RadarEntry(value: values['Back']!.toDouble()),
                          RadarEntry(value: values['Shoulders']!.toDouble()),
                          RadarEntry(value: values['Arms']!.toDouble()),
                          RadarEntry(value: values['Legs']!.toDouble()),
                          RadarEntry(value: values['Core']!.toDouble()),
                        ],
                        fillColor: const Color(0xFF2563EB).withValues(alpha: 0.25),
                        borderColor: const Color(0xFF2563EB),
                        entryRadius: 3,
                        borderWidth: 2,
                      ),
                    ],
                    radarBackgroundColor: Colors.transparent,
                    borderData: FlBorderData(show: false),
                    radarBorderData: const BorderSide(color: Color(0xFF2A2A32)),
                    tickBorderData: const BorderSide(color: Color(0xFF2A2A32)),
                    gridBorderData: const BorderSide(color: Color(0xFF2A2A32), width: 1),
                    ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 10),
                    tickCount: 4,
                    titleTextStyle: const TextStyle(color: Color(0xFF9B9BA5), fontSize: 11, fontWeight: FontWeight.w600),
                    getTitle: (index, angle) {
                      const titles = ['Chest', 'Back', 'Shoulders', 'Arms', 'Legs', 'Core'];
                      final v = values[titles[index]]!;
                      return RadarChartTitle(text: '${titles[index]}\n$v', angle: angle);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...percents.entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 78,
                        child: Text(e.key, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: e.value / 100,
                            minHeight: 8,
                            backgroundColor: const Color(0xFF2A2A32),
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 36,
                        child: Text('${e.value}%', textAlign: TextAlign.right, style: const TextStyle(color: Color(0xFF9B9BA5), fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

// ignore: unused_element
double _radarMax(Map<String, int> values) => values.values.fold<double>(0, (p, e) => math.max(p, e.toDouble()));
