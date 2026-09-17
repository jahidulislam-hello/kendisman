import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/features/workout/data/workout_data.dart';

class WorkoutCompleteScreen extends ConsumerStatefulWidget {
  const WorkoutCompleteScreen({super.key});

  @override
  ConsumerState<WorkoutCompleteScreen> createState() => _WorkoutCompleteScreenState();
}

class _WorkoutCompleteScreenState extends ConsumerState<WorkoutCompleteScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = AnimationController(vsync: this, duration: const Duration(seconds: 3))..forward();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final workout = ref.watch(activeWorkoutProvider);
    final volume = workout.exercises.fold<double>(0, (p, e) {
      return p + e.sets.where((s) => s.done).fold<double>(0, (sp, s) => sp + (s.weight * s.reps));
    });
    final top = workout.exercises.isEmpty
        ? null
        : workout.exercises.first;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => context.go('/workout'),
                    icon: Icon(Icons.close, color: colors.textPrimary),
                  ),
                ),
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(color: colors.accent, shape: BoxShape.circle),
                    child: Icon(Icons.check, color: colors.onAccent, size: 40),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Great work!', textAlign: TextAlign.center, style: TextStyle(color: colors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(
                  '${workout.title.isEmpty ? 'Day 1' : workout.title} · 5 Sept',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.textSecondary),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(child: _stat(colors, '${workout.exercises.length}', 'Exercises')),
                    const SizedBox(width: 10),
                    Expanded(child: _stat(colors, '${workout.loggedSets}', 'Sets')),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _stat(colors, '42m', 'Duration')),
                    const SizedBox(width: 10),
                    Expanded(child: _stat(colors, '1:15', 'Avg rest')),
                  ],
                ),
                const SizedBox(height: 10),
                _stat(colors, '${_fmt(volume)} lb', 'Total volume', full: true),
                const SizedBox(height: 22),
                Text('MUSCLES TARGETED', style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: colors.border)),
                  child: Column(
                    children: [
                      Icon(Icons.accessibility_new, size: 120, color: colors.accent.withValues(alpha: 0.85)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: colors.accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
                        child: Text(top?.muscle ?? 'Full Body', style: TextStyle(color: colors.accent, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text('TOP PERFORMANCES', style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                const SizedBox(height: 10),
                ...workout.exercises.map((e) {
                  final best = e.sets.isEmpty ? null : e.sets.reduce((a, b) => (a.weight * a.reps) >= (b.weight * b.reps) ? a : b);
                  if (best == null) return const SizedBox.shrink();
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: colors.border)),
                    child: Row(
                      children: [
                        Expanded(child: Text(e.name, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700))),
                        Text('${best.weight.toStringAsFixed(0)} lb × ${best.reps}', style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.textPrimary,
                    side: BorderSide(color: colors.border),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Share', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 28),
                Text('Nice work!', textAlign: TextAlign.center, style: TextStyle(color: colors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 14),
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [colors.accent.withValues(alpha: 0.85), colors.accent],
                    ),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('42m', style: TextStyle(color: colors.onAccent, fontSize: 28, fontWeight: FontWeight.w800)),
                              Text('DURATION', style: TextStyle(color: colors.onAccent.withValues(alpha: 0.8), fontSize: 11, fontWeight: FontWeight.w700)),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(_fmt(volume), style: TextStyle(color: colors.onAccent, fontSize: 28, fontWeight: FontWeight.w800)),
                              Text('VOLUME (LB)', style: TextStyle(color: colors.onAccent.withValues(alpha: 0.8), fontSize: 11, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.circle, color: colors.onAccent, size: 18),
                          const SizedBox(width: 8),
                          Text('fitzella', style: TextStyle(color: colors.onAccent, fontWeight: FontWeight.w800, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _photoBtn(colors, 'Add photo')),
                    const SizedBox(width: 10),
                    Expanded(child: _photoBtn(colors, 'Take photo')),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Photos stay on your device — nothing is uploaded.', textAlign: TextAlign.center, style: TextStyle(color: colors.textMuted, fontSize: 12)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => context.go('/workout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.accent,
                      foregroundColor: colors.onAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('SHARE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _confetti,
              builder: (context, _) => CustomPaint(
                size: MediaQuery.of(context).size,
                painter: _ConfettiPainter(progress: _confetti.value),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(dynamic colors, String value, String label, {bool full = false}) {
    return Container(
      width: full ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: colors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextStyle(color: colors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: colors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _photoBtn(dynamic colors, String label) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.textPrimary,
        side: BorderSide(color: colors.border),
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }

  String _fmt(double v) {
    final n = v.round();
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final idx = s.length - i;
      buf.write(s[i]);
      if (idx > 1 && idx % 3 == 1) buf.write(',');
    }
    // simpler:
    return n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }
}

class _ConfettiPainter extends CustomPainter {
  final double progress;
  _ConfettiPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(7);
    final colors = [
      const Color(0xFFEF4444),
      const Color(0xFF3B82F6),
      const Color(0xFFF59E0B),
      const Color(0xFF22C55E),
      const Color(0xFFA855F7),
    ];
    for (var i = 0; i < 48; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = (rnd.nextDouble() * size.height * 0.7) + progress * 40;
      final paint = Paint()..color = colors[i % colors.length].withValues(alpha: (1 - progress * 0.4).clamp(0.2, 1));
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rnd.nextDouble() * math.pi);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: 8, height: 14), const Radius.circular(2)), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => oldDelegate.progress != progress;
}

class WorkoutNewRoutineScreen extends ConsumerStatefulWidget {
  const WorkoutNewRoutineScreen({super.key});

  @override
  ConsumerState<WorkoutNewRoutineScreen> createState() => _WorkoutNewRoutineScreenState();
}

class _WorkoutNewRoutineScreenState extends ConsumerState<WorkoutNewRoutineScreen> {
  final name = TextEditingController(text: 'Push day');
  final List<String> exerciseIds = [];

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.chevron_left, color: colors.textPrimary)),
                  Expanded(child: Text('New Routine', textAlign: TextAlign.center, style: TextStyle(color: colors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700))),
                  TextButton(
                    onPressed: exerciseIds.isEmpty ? null : () => Navigator.pop(context),
                    child: Text('SAVE', style: TextStyle(color: exerciseIds.isEmpty ? colors.textMuted : colors.accent, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  Text('ROUTINE NAME', style: TextStyle(color: colors.textMuted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: name,
                    style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colors.surface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.border)),
                    ),
                  ),
                  if (exerciseIds.isEmpty) ...[
                    const SizedBox(height: 10),
                    Text('Add at least one exercise.', style: TextStyle(color: colors.danger, fontWeight: FontWeight.w600)),
                  ],
                  const SizedBox(height: 16),
                  ...exerciseIds.map((id) {
                    final e = WorkoutCatalog.byId(id);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: colors.border)),
                      child: Text(e.name, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w700)),
                    );
                  }),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () async {
                        final id = await context.push<String>('/workout/add-exercise');
                        if (id != null) setState(() => exerciseIds.add(id));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.accent,
                        foregroundColor: colors.onAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('+ Add Exercises', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
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
}
