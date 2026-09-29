import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/core/services/fitness_data_service.dart';
import 'package:fitzella/features/workout/data/workout_data.dart';
import 'package:fitzella/features/workout/sheets/filter_sheet.dart';

class WorkoutAddExerciseScreen extends ConsumerStatefulWidget {
  const WorkoutAddExerciseScreen({super.key});

  @override
  ConsumerState<WorkoutAddExerciseScreen> createState() => _WorkoutAddExerciseScreenState();
}

class _WorkoutAddExerciseScreenState extends ConsumerState<WorkoutAddExerciseScreen> {
  String query = '';
  String muscle = 'All';
  final Set<String> equipment = {};

  List<Map<String, dynamic>> filtered(List<Map<String, dynamic>> rows) {
    return rows.where((e) {
      final q = query.trim().toLowerCase();
      final name = (e['name'] as String? ?? '').toLowerCase();
      final group = e['muscle_group'] as String? ?? '';
      final equipmentType = e['equipment_type'] as String? ?? '';
      if (q.isNotEmpty && !name.contains(q)) return false;
      if (muscle != 'All' && group.toLowerCase() != muscle.toLowerCase()) return false;
      if (equipment.isNotEmpty &&
          !equipment.any((item) => item.toLowerCase() == equipmentType.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final catalog = ref.watch(exerciseCatalogProvider);
    final rows = catalog.value ?? const <Map<String, dynamic>>[];
    final items = filtered(rows);
    final muscles = ['All', ...rows
        .map((row) => row['muscle_group'] as String? ?? '')
        .where((group) => group.isNotEmpty)
        .toSet()
        .toList()
      ..sort()];

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.chevron_left, color: colors.textPrimary, size: 26),
                    label: Text('Back', style: TextStyle(color: colors.textPrimary, fontSize: 16)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text('Add exercise', style: TextStyle(color: colors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 4),
                    child: Text(
                      "Adds to today's session only — your saved routine is unchanged.",
                      style: TextStyle(color: colors.textSecondary, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => query = v),
                      style: TextStyle(color: colors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search all exercises',
                        hintStyle: TextStyle(color: colors.textMuted),
                        prefixIcon: Icon(Icons.search, color: colors.textMuted),
                        filled: true,
                        fillColor: colors.surface,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async {
                      final result = await showFilterSheet(context, selected: equipment);
                      if (result != null) {
                        setState(() {
                          equipment
                            ..clear()
                            ..addAll(result);
                        });
                      }
                    },
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: equipment.isEmpty ? colors.border : colors.accent),
                      ),
                      child: Icon(Icons.tune, color: equipment.isEmpty ? colors.textPrimary : colors.accent, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 88,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: muscles.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final m = muscles[i];
                  final selected = muscle == m;
                  return GestureDetector(
                    onTap: () => setState(() => muscle = m),
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected ? colors.accent.withValues(alpha: 0.15) : colors.surface,
                            border: Border.all(color: selected ? colors.accent : colors.border, width: selected ? 2 : 1),
                          ),
                          child: Icon(
                            WorkoutCatalog.muscleIcon(m),
                            color: selected ? colors.accent : colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          m,
                          style: TextStyle(
                            color: selected ? colors.accent : colors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Row(
                children: [
                  Text('All exercises', style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text('${items.length}', style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            Expanded(
              child: catalog.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Could not load exercise library: $error',
                          style: TextStyle(color: colors.textPrimary)),
                      TextButton(
                        onPressed: () => ref.invalidate(exerciseCatalogProvider),
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
                data: (_) => items.isEmpty
                    ? Center(
                        child: Text('No exercises match these filters.',
                            style: TextStyle(color: colors.textSecondary)))
                    : GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.78,
                ),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final e = items[i];
                  final name = e['name'] as String? ?? 'Exercise';
                  final group = e['muscle_group'] as String? ?? '';
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: Container(
                              width: 72,

                              height: 72,
                              decoration: BoxDecoration(
                                color: colors.background,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(WorkoutCatalog.muscleIcon(group), color: colors.accent, size: 34),
                            ),
                          ),
                        ),
                        Text(name, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w800, fontSize: 13)),
                        const SizedBox(height: 2),
                        Text(group, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context, e['id'] as String),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.accent.withValues(alpha: 0.15),
                              foregroundColor: colors.accent,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Add', style: TextStyle(fontWeight: FontWeight.w800)),
                          ),
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
