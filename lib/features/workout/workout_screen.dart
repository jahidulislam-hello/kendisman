import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitzella/core/theme/app_theme.dart';
import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/features/workout/data/workout_data.dart';
import 'package:fitzella/features/workout/sheets/clock_sheet.dart';
import 'package:fitzella/features/workout/sheets/routine_preview_sheet.dart';

class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final active = ref.watch(activeWorkoutProvider);
    final plans = ref.watch(plansProvider);
    final plan = plans.firstWhere((p) => p.active, orElse: () => plans.first);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Row(
              children: [
                Text('Workout', style: AppTypography.screenTitle.copyWith(color: colors.textPrimary)),
                const Spacer(),
                GestureDetector(
                  onTap: () => showClockSheet(context),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.border),
                    ),
                    child: Icon(Icons.timer_outlined, color: colors.textPrimary, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (active.hasSession) ...[
              _PrimaryBtn(
                colors: colors,
                label: 'Workout in progress — Resume',
                showDot: true,
                onTap: () => context.push('/workout/active'),
              ),
              const SizedBox(height: 10),
            ],
            _PrimaryBtn(
              colors: colors,
              label: 'Start Empty Workout',
              onTap: () {
                ref.read(activeWorkoutProvider.notifier).startEmpty();
                context.push('/workout/active');
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _SecondaryBtn(
                    colors: colors,
                    label: '+ New Routine',
                    onTap: () => context.push('/workout/new-routine'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SecondaryBtn(
                    colors: colors,
                    label: '+ New Plan',
                    onTap: () => context.push('/workout/routines'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            GestureDetector(
              onTap: () => context.push('/workout/routines'),
              child: Row(
                children: [
                  Text(plan.name, style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  Icon(Icons.chevron_right, color: colors.textMuted),
                ],
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final screenW = constraints.maxWidth;
                // Show ~2.2 cards at a time on any screen width
                final cardWidth = (screenW * 0.44).clamp(140.0, 220.0);
                final cardHeight = (cardWidth * 0.95).clamp(130.0, 200.0);
                return SizedBox(
                  height: cardHeight,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: plan.days.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, i) {
                      final day = plan.days[i];
                      final names = day.exerciseIds.map((id) => WorkoutCatalog.byId(id).name).toList();
                      return _RoutineDayCard(
                        colors: colors,
                        day: day,
                        names: names,
                        onTap: () => showRoutinePreviewSheet(context, day),
                        width: cardWidth,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryBtn extends StatelessWidget {
  final AppColors colors;
  final String label;
  final VoidCallback onTap;
  final bool showDot;

  const _PrimaryBtn({required this.colors, required this.label, required this.onTap, this.showDot = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.accent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            children: [
              if (showDot) ...[
                Container(width: 8, height: 8, decoration: BoxDecoration(color: colors.onAccent, shape: BoxShape.circle)),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(label, style: TextStyle(color: colors.onAccent, fontSize: 15, fontWeight: FontWeight.w700)),
              ),
              if (showDot) Icon(Icons.chevron_right, color: colors.onAccent),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryBtn extends StatelessWidget {
  final AppColors colors;
  final String label;
  final VoidCallback onTap;

  const _SecondaryBtn({required this.colors, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border),
          ),
          child: Text(label, style: TextStyle(color: colors.accent, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}

class _RoutineDayCard extends StatefulWidget {
  final AppColors colors;
  final RoutineDay day;
  final List<String> names;
  final VoidCallback onTap;
  final double width;

  const _RoutineDayCard({
    required this.colors,
    required this.day,
    required this.names,
    required this.onTap,
    this.width = 170,
  });

  @override
  State<_RoutineDayCard> createState() => _RoutineDayCardState();
}

class _RoutineDayCardState extends State<_RoutineDayCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final fontSize = (widget.width * 0.094).clamp(13.0, 17.0);
    final subFontSize = (widget.width * 0.076).clamp(11.0, 14.0);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Material(
          color: widget.colors.surface,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
            splashColor: widget.colors.accent.withValues(alpha: 0.12),
            highlightColor: widget.colors.accent.withValues(alpha: 0.06),
            child: Container(
              width: widget.width,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: widget.colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.day.name,
                    style: TextStyle(color: widget.colors.textPrimary, fontSize: fontSize, fontWeight: FontWeight.w800),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  ...widget.names.take(3).map(
                        (n) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '• $n',
                            style: TextStyle(color: widget.colors.textSecondary, fontSize: subFontSize),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                  const Spacer(),
                  Text('Last: not yet', style: TextStyle(color: widget.colors.textMuted, fontSize: subFontSize - 1)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
