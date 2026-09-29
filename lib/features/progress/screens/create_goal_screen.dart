import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fitzella/core/services/fitness_data_service.dart';
import 'package:fitzella/features/progress/widgets/progress_widgets.dart';

enum GoalType { strength, bodyComp, consistency, muscleGain }

class CreateGoalScreen extends ConsumerStatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  ConsumerState<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends ConsumerState<CreateGoalScreen> {
  GoalType _type = GoalType.strength;
  int _bodyMetric = 0; // 0 body fat, 1 weight
  final _targetCtrl = TextEditingController();
  String? _exerciseId;
  String? _exerciseName;
  DateTime _date = DateTime.now();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _targetCtrl.dispose();
    super.dispose();
  }

  Future<void> _createGoal() async {
    final target = double.tryParse(_targetCtrl.text.trim());
    if (target == null || target <= 0) {
      setState(() => _error = 'Enter a valid target.');
      return;
    }
    if (_type == GoalType.strength && _exerciseId == null) {
      setState(() => _error = 'Choose an exercise for your strength goal.');
      return;
    }
    if (_type == GoalType.muscleGain) {
      setState(() => _error =
          'Lean-mass goals are not available until lean-mass measurements are supported.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      String goalType;
      String title;
      String? metric;
      String? exerciseId;
      double? startValue;
      switch (_type) {
        case GoalType.strength:
          goalType = 'strength';
          title = '${_exerciseName ?? 'Exercise'} · ${target.toStringAsFixed(0)} lb';
          exerciseId = _exerciseId;
          break;
        case GoalType.bodyComp:
          goalType = 'body_comp';
          metric = _bodyMetric == 0 ? 'body_fat' : 'weight';
          title = _bodyMetric == 0
              ? 'Reach ${target.toStringAsFixed(1)}% body fat'
              : 'Reach ${target.toStringAsFixed(1)} lb bodyweight';
          startValue = await ref
              .read(fitnessDataServiceProvider)
              .fetchLatestMeasurementValue(metric);
          break;
        case GoalType.consistency:
          goalType = 'consistency';
          title = 'Train ${target.toStringAsFixed(0)} times per week';
          break;
        case GoalType.muscleGain:
          return;
      }
      await ref.read(fitnessDataServiceProvider).createGoal(
            type: goalType,
            title: title,
            targetValue: target,
            exerciseId: exerciseId,
            metric: metric,
            startValue: startValue,
            dueDate:
                _type == GoalType.consistency ? null : _date,
          );
      ref.invalidate(goalsProvider);
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Could not create goal: $error';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    final exercises = ref.watch(exerciseCatalogProvider);
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.chevron_left, color: colors.textPrimary, size: 26),
                    label: Text('Back', style: TextStyle(color: colors.textPrimary, fontSize: 16)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                children: [
                  Text(
                    'New Goal',
                    style: TextStyle(color: colors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(_error!, style: TextStyle(color: colors.danger)),
                  ],
                  const SizedBox(height: 8),
                  Text('GOAL TYPE', style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.35,
                    children: [
                      _TypeCard(
                        label: 'Strength',
                        icon: Icons.fitness_center,
                        selected: _type == GoalType.strength,
                        onTap: () => setState(() {
                          _type = GoalType.strength;
                          _error = null;
                        }),
                      ),
                      _TypeCard(
                        label: 'Body Comp',
                        icon: Icons.person_outline,
                        selected: _type == GoalType.bodyComp,
                        onTap: () => setState(() {
                          _type = GoalType.bodyComp;
                          _error = null;
                        }),
                      ),
                      _TypeCard(
                        label: 'Consistency',
                        icon: Icons.water_drop_outlined,
                        selected: _type == GoalType.consistency,
                        onTap: () => setState(() {
                          _type = GoalType.consistency;
                          _error = null;
                        }),
                      ),
                      _TypeCard(
                        label: 'Muscle Gain',
                        icon: Icons.sports_mma,
                        selected: _type == GoalType.muscleGain,
                        onTap: () => setState(() {
                          _type = GoalType.muscleGain;
                          _error = null;
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ..._fieldsForType(context, exercises),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: colors.accent, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Progress will be automatically tracked based on your workout logs and body measurements.',
                            style: TextStyle(color: colors.textSecondary, fontSize: 13, height: 1.35),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _createGoal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.accent,
                        foregroundColor: colors.onAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(_saving ? 'Saving…' : 'Create goal', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _fieldsForType(BuildContext context, AsyncValue<List<Map<String, dynamic>>> exercises) {
    final colors = progressColors(context);
    switch (_type) {
      case GoalType.strength:
        return [
          _label(context, 'EXERCISE'),
          _selectorField(
            context,
            _exerciseName ?? 'Choose exercise',
            onTap: () => _chooseExercise(exercises),
          ),
          const SizedBox(height: 14),
          _label(context, 'TARGET WEIGHT (LB)'),
          _inputField(context, _targetCtrl),
          const SizedBox(height: 14),
          _label(context, 'TARGET DATE'),
          _selectorField(context, DateFormat('d MMM yyyy').format(_date), onTap: _pickDate),
        ];
      case GoalType.bodyComp:
        return [
          _label(context, 'METRIC'),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _metricPill(context, 'Body fat', _bodyMetric == 0, () => setState(() => _bodyMetric = 0)),
                ),
                Expanded(
                  child: _metricPill(context, 'Weight', _bodyMetric == 1, () => setState(() => _bodyMetric = 1)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Current measurements are used as your starting point.',
            style: TextStyle(color: colors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 14),
          _label(context, _bodyMetric == 0 ? 'TARGET BODY FAT (%)' : 'TARGET WEIGHT (LB)'),
          _inputField(context, _targetCtrl),
          const SizedBox(height: 14),
          _label(context, 'TARGET DATE'),
          _selectorField(context, DateFormat('d MMM yyyy').format(_date), onTap: _pickDate),
        ];
      case GoalType.consistency:
        return [
          _label(context, 'SESSIONS PER WEEK'),
          _inputField(context, _targetCtrl),
        ];
      case GoalType.muscleGain:
        return [
          Text('Lean-mass measurements are not available yet.', style: TextStyle(color: colors.textMuted, fontSize: 12)),
          const SizedBox(height: 14),
          _label(context, 'TARGET LEAN MASS (LB)'),
          _inputField(context, _targetCtrl),
          const SizedBox(height: 14),
          _label(context, 'TARGET DATE'),
          _selectorField(context, DateFormat('d MMM yyyy').format(_date), onTap: _pickDate),
        ];
    }
  }

  Widget _metricPill(BuildContext context, String label, bool selected, VoidCallback onTap) {
    final colors = progressColors(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? colors.accent : colors.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? colors.onAccent : colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _label(BuildContext context, String text) {
    final colors = progressColors(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
    );
  }

  Widget _inputField(BuildContext context, TextEditingController ctrl) {
    final colors = progressColors(context);
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _selectorField(BuildContext context, String value, {required VoidCallback onTap}) {
    final colors = progressColors(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(child: Text(value, style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600))),
            Icon(Icons.chevron_right, color: colors.accent),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _chooseExercise(
      AsyncValue<List<Map<String, dynamic>>> exercises) async {
    if (exercises.isLoading) return;
    if (exercises.hasError) {
      setState(() => _error = 'Could not load exercises: ${exercises.error}');
      return;
    }
    final selected = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => SafeArea(
        child: ListView(
          children: (exercises.value ?? const [])
              .map((item) => ListTile(
                    title: Text(item['name'] as String),
                    subtitle: Text(item['muscle_group'] as String? ?? ''),
                    onTap: () => Navigator.pop(ctx, item),
                  ))
              .toList(),
        ),
      ),
    );
    if (selected != null && mounted) {
      setState(() {
        _exerciseId = selected['id'] as String;
        _exerciseName = selected['name'] as String;
      });
    }
  }
}

class _TypeCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TypeCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? colors.accent.withValues(alpha: 0.12) : colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? colors.accent : Colors.transparent, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected ? colors.accent.withValues(alpha: 0.2) : colors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: selected ? colors.accent : colors.textMuted),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? colors.accent : colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
