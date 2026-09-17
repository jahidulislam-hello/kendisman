import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitzella/features/progress/data/progress_mock_data.dart';
import 'package:fitzella/features/progress/widgets/progress_widgets.dart';

class MainExercisesScreen extends StatefulWidget {
  const MainExercisesScreen({super.key});

  @override
  State<MainExercisesScreen> createState() => _MainExercisesScreenState();
}

class _MainExercisesScreenState extends State<MainExercisesScreen> {
  int _range = 1; // 3M
  final _ranges = const ['1M', '3M', '6M', '1Y', 'All'];

  @override
  Widget build(BuildContext context) {
    final items = ProgressMockData.mainExercises;
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 20, 0),
              child: ProgressBackHeader(title: 'Main Exercises'),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
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
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final item = items[i];
                  return ProgressSurfaceCard(
                    onTap: () => context.push('/progress/exercise/${item.id}'),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 28,
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(color: Color(0xFF2563EB), fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF121218),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.fitness_center, color: Color(0xFF2563EB), size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                              Text(item.muscle, style: const TextStyle(color: Color(0xFF9B9BA5), fontSize: 12)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${item.sessions} sessions', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                            Text('${item.totalVolume} total', style: const TextStyle(color: Color(0xFF9B9BA5), fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
