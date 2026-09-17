import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:fitzella/features/progress/widgets/progress_widgets.dart';

class MeasureTab extends StatefulWidget {
  const MeasureTab({super.key});

  @override
  State<MeasureTab> createState() => _MeasureTabState();
}

class _MeasureTabState extends State<MeasureTab> {
  int _range = 3; // 1Y
  final _ranges = const ['1M', '3M', '6M', '1Y'];

  @override
  Widget build(BuildContext context) {
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
                  const Expanded(
                    child: Text('BODY WEIGHT', style: TextStyle(color: Color(0xFF6B6B75), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.monitor_weight_outlined, color: Color(0xFF2563EB), size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text('175 lb', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Row(
                children: [
                  DeltaBadge(text: '-3.0 lb', down: true),
                  SizedBox(width: 8),
                  Text('vs 1Y ago', style: TextStyle(color: Color(0xFF9B9BA5), fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 90,
                child: LineChart(
                  LineChartData(
                    minY: 174,
                    maxY: 179,
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (v, m) {
                            if (v == 178 || v == 175) {
                              return Text(v.toInt().toString(), style: const TextStyle(color: Color(0xFF6B6B75), fontSize: 10));
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 178),
                          FlSpot(1, 177.2),
                          FlSpot(2, 176.5),
                          FlSpot(3, 176.1),
                          FlSpot(4, 175.4),
                          FlSpot(5, 175),
                        ],
                        isCurved: true,
                        color: const Color(0xFF2563EB),
                        barWidth: 2.5,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF2563EB).withValues(alpha: 0.35),
                              const Color(0xFF2563EB).withValues(alpha: 0.0),
                            ],
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
        const SizedBox(height: 12),
        ProgressSurfaceCard(
          child: Row(
            children: [
              SizedBox(
                width: 78,
                height: 78,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 78,
                      height: 78,
                      child: CircularProgressIndicator(
                        value: 0.82,
                        strokeWidth: 8,
                        backgroundColor: const Color(0xFF2A2A32),
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                    const Text('82%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BODY FAT', style: TextStyle(color: Color(0xFF6B6B75), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                    SizedBox(height: 4),
                    Text('18.2%', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        DeltaBadge(text: '-0.8%', down: true),
                        SizedBox(width: 8),
                        Text('this month', style: TextStyle(color: Color(0xFF9B9BA5), fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Row(
          children: [
            Text('Measurements', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
            Spacer(),
            Text('inches', style: TextStyle(color: Color(0xFF9B9BA5), fontSize: 12)),
          ],
        ),
        const SizedBox(height: 10),
        ProgressSurfaceCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _MeasureRow(
                iconColor: const Color(0xFF2563EB),
                label: 'Chest',
                value: '42.0"',
                delta: '+0.5"',
                deltaUp: true,
                spark: const [41.5, 41.6, 41.7, 41.8, 41.9, 42.0],
                sparkEnd: '41.5"',
              ),
              const Divider(height: 1, color: Color(0xFF26262E)),
              _MeasureRow(
                iconColor: const Color(0xFF22C55E),
                label: 'Waist',
                value: '32.0"',
                delta: '-0.5"',
                deltaUp: false,
                spark: const [32.5, 32.4, 32.3, 32.2, 32.1, 32.0],
                sparkEnd: '32.5"',
                sparkColor: const Color(0xFF22C55E),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MeasureRow extends StatelessWidget {
  final Color iconColor;
  final String label;
  final String value;
  final String delta;
  final bool deltaUp;
  final List<double> spark;
  final String sparkEnd;
  final Color sparkColor;

  const _MeasureRow({
    required this.iconColor,
    required this.label,
    required this.value,
    required this.delta,
    required this.deltaUp,
    required this.spark,
    required this.sparkEnd,
    this.sparkColor = const Color(0xFF2563EB),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.straighten, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: (deltaUp ? const Color(0xFF2563EB) : const Color(0xFF22C55E)).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        delta,
                        style: TextStyle(
                          color: deltaUp ? const Color(0xFF60A5FA) : const Color(0xFF4ADE80),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 70,
            height: 36,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(spark.length, (i) => FlSpot(i.toDouble(), spark[i])),
                    isCurved: true,
                    color: sparkColor,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
