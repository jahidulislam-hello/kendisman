import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fitzella/features/progress/data/progress_mock_data.dart';
import 'package:fitzella/features/progress/widgets/progress_widgets.dart';

class PersonalRecordsScreen extends StatefulWidget {
  const PersonalRecordsScreen({super.key});

  @override
  State<PersonalRecordsScreen> createState() => _PersonalRecordsScreenState();
}

class _PersonalRecordsScreenState extends State<PersonalRecordsScreen> {
  int _cat = 0;
  final _cats = const ['All', 'Upper Body', 'Lower Body', 'Core'];

  List<PersonalRecordItem> get _items {
    final cat = _cats[_cat];
    if (cat == 'All') return ProgressMockData.personalRecords;
    return ProgressMockData.personalRecords.where((e) => e.category == cat).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    final items = _items;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
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
                      Text('Last 30 days', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
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
