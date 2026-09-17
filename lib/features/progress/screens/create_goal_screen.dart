import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.chevron_left, color: Colors.black87, size: 26),
                    label: const Text('Back', style: TextStyle(color: Colors.black87, fontSize: 16)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                children: [
                  const Text(
                    'New Goal',
                    style: TextStyle(color: Colors.black87, fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  const Text('GOAL TYPE', style: TextStyle(color: Color(0xFF8E8E98), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
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
                  ..._fieldsForType(),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: Color(0xFF2563EB), size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Progress will be automatically tracked based on your workout logs and body measurements.',
                            style: TextStyle(color: Color(0xFF5C5C66), fontSize: 13, height: 1.35),
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
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
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

  List<Widget> _fieldsForType() {
    switch (_type) {
      case GoalType.strength:
        return [
          _label('EXERCISE'),
          _selectorField(_exercise, onTap: () {}),
          const SizedBox(height: 14),
          _label('TARGET WEIGHT (LB)'),
          _inputField(_targetCtrl),
          const SizedBox(height: 14),
          _label('TARGET DATE'),
          _selectorField(DateFormat('d MMM yyyy').format(_date), onTap: _pickDate),
        ];
      case GoalType.bodyComp:
        return [
          _label('METRIC'),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _metricPill('Body fat', _bodyMetric == 0, () => setState(() => _bodyMetric = 0)),
                ),
                Expanded(
                  child: _metricPill('Weight', _bodyMetric == 1, () => setState(() => _bodyMetric = 1)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _bodyMetric == 0 ? 'Starting point: 16.4%' : 'Starting point: 175 lb',
            style: const TextStyle(color: Color(0xFF8E8E98), fontSize: 12),
          ),
          const SizedBox(height: 14),
          _label(_bodyMetric == 0 ? 'TARGET BODY FAT (%)' : 'TARGET WEIGHT (LB)'),
          _inputField(_targetCtrl),
          const SizedBox(height: 14),
          _label('TARGET DATE'),
          _selectorField(DateFormat('d MMM yyyy').format(_date), onTap: _pickDate),
        ];
      case GoalType.consistency:
        return [
          _label('SESSIONS PER WEEK'),
          _inputField(_targetCtrl),
        ];
      case GoalType.muscleGain:
        return [
          const Text('Baseline lean mass: 151 lb', style: TextStyle(color: Color(0xFF8E8E98), fontSize: 12)),
          const SizedBox(height: 14),
          _label('TARGET LEAN MASS (LB)'),
          _inputField(_targetCtrl),
          const SizedBox(height: 14),
          _label('TARGET DATE'),
          _selectorField(DateFormat('d MMM yyyy').format(_date), onTap: _pickDate),
        ];
    }
  }

  Widget _metricPill(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2563EB) : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF5C5C66),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: const TextStyle(color: Color(0xFF8E8E98), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
      );

  Widget _inputField(TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _selectorField(String value, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(child: Text(value, style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600))),
            const Icon(Icons.chevron_right, color: Color(0xFF2563EB)),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE8F0FF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? const Color(0xFF2563EB) : Colors.transparent, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFD6E4FF) : const Color(0xFFF0F0F3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: selected ? const Color(0xFF2563EB) : const Color(0xFF8E8E98)),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? const Color(0xFF2563EB) : const Color(0xFF5C5C66),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
