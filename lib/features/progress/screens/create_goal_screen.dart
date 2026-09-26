import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fitzella/features/progress/widgets/progress_widgets.dart';

enum GoalType { strength, bodyComp, consistency, muscleGain }

class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  GoalType _type = GoalType.strength;
  int _bodyMetric = 0; // 0 body fat, 1 weight
  final _targetCtrl = TextEditingController(text: '220');
  final _exercise = 'Cable Fly';
  DateTime _date = DateTime(2026, 9, 14);

  @override
  void dispose() {
    _targetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);
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
                        onTap: () => setState(() => _type = GoalType.strength),
                      ),
                      _TypeCard(
                        label: 'Body Comp',
                        icon: Icons.person_outline,
                        selected: _type == GoalType.bodyComp,
                        onTap: () => setState(() => _type = GoalType.bodyComp),
                      ),
                      _TypeCard(
                        label: 'Consistency',
                        icon: Icons.water_drop_outlined,
                        selected: _type == GoalType.consistency,
                        onTap: () => setState(() => _type = GoalType.consistency),
                      ),
                      _TypeCard(
                        label: 'Muscle Gain',
                        icon: Icons.sports_mma,
                        selected: _type == GoalType.muscleGain,
                        onTap: () => setState(() => _type = GoalType.muscleGain),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ..._fieldsForType(context),
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
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.accent,
                        foregroundColor: colors.onAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Create goal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
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

  List<Widget> _fieldsForType(BuildContext context) {
    final colors = progressColors(context);
    switch (_type) {
      case GoalType.strength:
        return [
          _label(context, 'EXERCISE'),
          _selectorField(context, _exercise, onTap: () {}),
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
            _bodyMetric == 0 ? 'Starting point: 16.4%' : 'Starting point: 175 lb',
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
          Text('Baseline lean mass: 151 lb', style: TextStyle(color: colors.textMuted, fontSize: 12)),
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
      firstDate: DateTime(2026, 1, 1),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _date = picked);
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
