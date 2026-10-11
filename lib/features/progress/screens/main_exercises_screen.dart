import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitzella/core/services/fitness_data_service.dart';
import 'package:fitzella/features/progress/widgets/progress_widgets.dart';
import 'package:fitzella/features/workout/widgets/exercise_gif.dart';

class MainExercisesScreen extends ConsumerStatefulWidget {
  const MainExercisesScreen({super.key});

  @override
  ConsumerState<MainExercisesScreen> createState() => _MainExercisesScreenState();
}

class _MainExercisesScreenState extends ConsumerState<MainExercisesScreen> {
  int _range = 1; // 3M
  final _ranges = const ['1M', '3M', '6M', '1Y', 'All'];

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    final days = const [30, 90, 180, 365, null][_range];
    final items = ref.watch(mainExercisesProvider(days));
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
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
              child: items.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Could not load exercises: $error',
                          style: TextStyle(color: colors.textPrimary)),
                      TextButton(
                        onPressed: () => ref.invalidate(mainExercisesProvider(days)),
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
                data: (rows) => rows.isEmpty
                    ? Center(
                        child: Text('No logged exercises in this time range.',
                            style: TextStyle(color: colors.textSecondary)))
                    : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                itemCount: rows.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final item = rows[i];
                  return ProgressSurfaceCard(
                    onTap: () => context.push('/progress/exercise/${item['id']}'),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 28,
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(color: colors.accent, fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                        ),
                        ExerciseGif(
                          name: item['name'] as String? ?? '',
                          size: 40,
                          borderRadius: 10,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name'] as String, style: TextStyle(color: colors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                              Text(item['muscle'] as String, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${item['sessions']} sessions', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700)),
                            Text('${(item['volume'] as num).toStringAsFixed(0)} lb total', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
