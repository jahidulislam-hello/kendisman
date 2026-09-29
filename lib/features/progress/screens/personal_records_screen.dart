import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fitzella/core/services/fitness_data_service.dart';
import 'package:fitzella/features/progress/widgets/progress_widgets.dart';

class PersonalRecordItem {
  const PersonalRecordItem({
    required this.id,
    required this.name,
    required this.category,
    required this.record,
    required this.delta,
    required this.date,
    required this.previous,
    required this.current,
  });

  final String id;
  final String name;
  final String category;
  final String record;
  final String delta;
  final DateTime date;
  final String previous;
  final String current;
}

class PersonalRecordsScreen extends ConsumerStatefulWidget {
  const PersonalRecordsScreen({super.key});

  @override
  ConsumerState<PersonalRecordsScreen> createState() => _PersonalRecordsScreenState();
}

class _PersonalRecordsScreenState extends ConsumerState<PersonalRecordsScreen> {
  int _cat = 0;
  final _cats = const ['All', 'Upper Body', 'Lower Body', 'Core'];

  List<PersonalRecordItem> _items = const [];

  List<PersonalRecordItem> _filterItems() {
    final cat = _cats[_cat];
    if (cat == 'All') return _items;
    return _items.where((e) => e.category == cat).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    final records = ref.watch(personalRecordsProvider);
    if (records.isLoading) {
      return Scaffold(
        backgroundColor: colors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (records.hasError) {
      return Scaffold(
        backgroundColor: colors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Could not load personal records: ${records.error}',
                  style: TextStyle(color: colors.textPrimary)),
              TextButton(
                onPressed: () => ref.invalidate(personalRecordsProvider),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }
    _items = (records.value ?? const []).map((row) {
      final muscle = (row['muscle_group'] as String? ?? '').toLowerCase();
      final category = muscle.contains('leg')
          ? 'Lower Body'
          : muscle.contains('core') || muscle.contains('ab')
              ? 'Core'
              : 'Upper Body';
      final weight = (row['weight'] as num?)?.toDouble() ?? 0;
      final reps = (row['reps'] as num?)?.toInt() ?? 0;
      final current = '${weight.toStringAsFixed(1)} lb × $reps';
      final previousRm = (row['previous_one_rm'] as num?)?.toDouble();
      return PersonalRecordItem(
        id: row['exercise_id'] as String,
        name: row['name'] as String? ?? 'Exercise',
        category: category,
        record: current,
        delta: row['delta'] == null
            ? 'Best'
            : '+${(row['delta'] as num).toStringAsFixed(1)} 1RM',
        date: row['date'] as DateTime,
        previous: previousRm == null
            ? 'First record'
            : '${previousRm.toStringAsFixed(1)} lb est. 1RM',
        current: '${(row['one_rm'] as num).toStringAsFixed(1)} lb est. 1RM',
      );
    }).toList();
    final items = _filterItems();
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 20, 0),
              child: ProgressBackHeader(
                title: 'Personal records',
                showBackText: false,
                largeTitle: false,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: List.generate(_cats.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ProgressChip(
                      label: _cats[i],
                      selected: _cat == i,
                      onTap: () => setState(() => _cat = i),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                children: [
                  Row(
                    children: [
                      Text('Recent PRs', style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      Text('${items.length} exercises', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, i) {
                        final item = items[i];
                        return GestureDetector(
                          onTap: () => context.push('/progress/exercise/${item.id}'),
                          child: Container(
                            width: 130,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: colors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: colors.success.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(item.delta, style: TextStyle(color: colors.success, fontSize: 11, fontWeight: FontWeight.w700)),
                                  ),
                                ),
                                const Spacer(),
                                Center(child: Icon(Icons.fitness_center, color: colors.accent, size: 28)),
                                const Spacer(),
                                Text(
                                  item.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: colors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700),
                                ),
                                Text(item.record, style: TextStyle(color: colors.textSecondary, fontSize: 11)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text('History', style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  ...List.generate(items.length, (i) {
                    final item = items[i];
                    final isLast = i == items.length - 1;
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 36,
                            child: Column(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: colors.success, width: 1.5),
                                  ),
                                  child: Icon(Icons.fitness_center, color: colors.accent, size: 16),
                                ),
                                if (!isLast)
                                  Expanded(
                                    child: Container(width: 1.5, color: colors.border),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => context.push('/progress/exercise/${item.id}'),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item.name, style: TextStyle(color: colors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                                          Text(DateFormat('d MMM').format(item.date), style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                                          const SizedBox(height: 2),
                                          RichText(
                                            text: TextSpan(
                                              style: TextStyle(color: colors.textSecondary, fontSize: 12),
                                              children: [
                                                TextSpan(text: '${item.previous} → '),
                                                TextSpan(text: item.current, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: colors.success.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(item.delta, style: TextStyle(color: colors.success, fontSize: 11, fontWeight: FontWeight.w700)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
