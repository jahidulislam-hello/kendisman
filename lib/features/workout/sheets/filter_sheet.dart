import 'package:flutter/material.dart';
import 'package:fitzella/core/services/fitness_data_service.dart';
import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<Set<String>?> showFilterSheet(BuildContext context, {required Set<String> selected}) {
  return showModalBottomSheet<Set<String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _FilterSheet(initial: Set.of(selected)),
  );
}

class _FilterSheet extends ConsumerStatefulWidget {
  final Set<String> initial;
  const _FilterSheet({required this.initial});

  @override
  ConsumerState<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<_FilterSheet> {
  late Set<String> selected;
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    selected = widget.initial;
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  static List<String> _distinct(List<Map<String, dynamic>> rows, String key) =>
      rows
          .map((row) => (row[key] as String? ?? '').toLowerCase())
          .where((value) => value.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

  static String _label(String value) =>
      value.isEmpty ? value : value[0].toUpperCase() + value.substring(1);

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final rows = ref.watch(exerciseCatalogProvider).value ??
        const <Map<String, dynamic>>[];
    final equipmentTypes = _distinct(rows, 'equipment_type');
    final muscleGroups = _distinct(rows, 'muscle_group');
    final selectedLower = selected.map((e) => e.toLowerCase()).toSet();
    final count = selected.isEmpty
        ? rows.length
        : rows
            .where((row) => selectedLower.contains(
                (row['equipment_type'] as String? ?? '').toLowerCase()))
            .length;
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: colors.border, borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 12, 8),
            child: Row(
              children: [
                Text('Filter', style: TextStyle(color: colors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                const Spacer(),
                IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: colors.textPrimary)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('EQUIPMENT', style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  const SizedBox(height: 14),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: equipmentTypes.map((eq) {
                        final on = selectedLower.contains(eq);
                        return Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: GestureDetector(
                            onTap: () => setState(() {
                              if (on) {
                                selected.removeWhere((e) => e.toLowerCase() == eq);
                              } else {
                                selected.add(eq);
                              }
                            }),
                            child: Column(
                              children: [
                                Container(
                                  width: 58,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colors.background,
                                    border: Border.all(color: on ? colors.accent : colors.border, width: on ? 2 : 1),
                                  ),
                                  child: Icon(_icon(eq), color: on ? colors.accent : colors.textSecondary),
                                ),
                                const SizedBox(height: 6),
                                Text(_label(eq), style: TextStyle(color: on ? colors.accent : colors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('MUSCLE GROUP', style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: muscleGroups.map((m) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: colors.background,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: colors.border),
                        ),
                        child: Text(_label(m), style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.w600, fontSize: 12)),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => setState(() => selected.clear()),
                    child: Text('Clear All', style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.w600)),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, selected),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.accent,
                      foregroundColor: colors.onAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('SHOW $count EXERCISES', style: const TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _icon(String eq) {
    switch (eq) {
      case 'barbell':
        return Icons.fitness_center;
      case 'dumbbell':
        return Icons.sports_gymnastics;
      case 'machine':
        return Icons.precision_manufacturing_outlined;
      case 'cable':
        return Icons.cable;
      default:
        return Icons.accessibility_new;
    }
  }
}
