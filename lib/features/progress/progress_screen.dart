import 'package:flutter/material.dart';
import 'package:fitzella/core/theme/app_theme.dart';
import 'package:fitzella/features/progress/data/progress_models.dart';
import 'package:fitzella/features/progress/tabs/goals_tab.dart';
import 'package:fitzella/features/progress/tabs/history_tab.dart';
import 'package:fitzella/features/progress/tabs/measure_tab.dart';
import 'package:fitzella/features/progress/tabs/statistics_tab.dart';
import 'package:fitzella/features/progress/widgets/progress_widgets.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int _tabIndex = 0;
  ProgressWorkout? _selectedWorkout;

  @override
  Widget build(BuildContext context) {
    final colors = progressColors(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  Text(
                    'Progress',
                    style: AppTypography.screenTitle.copyWith(color: colors.textPrimary),
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.border),
                    ),
                    child: Icon(Icons.calendar_today_outlined, color: colors.textPrimary, size: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ProgressSegmentedTabs(
                tabs: const ['History', 'Statistics', 'Measure', 'Goals'],
                index: _tabIndex,
                onChanged: (i) {
                  setState(() {
                    // Re-tapping History closes session detail (same tab bar stays).
                    if (i == 0 && _tabIndex == 0 && _selectedWorkout != null) {
                      _selectedWorkout = null;
                      return;
                    }
                    _tabIndex = i;
                    if (i != 0) _selectedWorkout = null;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: IndexedStack(
                index: _tabIndex,
                children: [
                  HistoryTab(
                    selectedWorkout: _selectedWorkout,
                    onSelectWorkout: (w) => setState(() => _selectedWorkout = w),
                    onClearSelection: () => setState(() => _selectedWorkout = null),
                  ),
                  const StatisticsTab(),
                  const MeasureTab(),
                  const GoalsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
