import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/features/workout/data/workout_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showClockSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _ClockSheet(),
  );
}

class _ClockSheet extends ConsumerStatefulWidget {
  const _ClockSheet();

  @override
  ConsumerState<_ClockSheet> createState() => _ClockSheetState();
}

class _ClockSheetState extends ConsumerState<_ClockSheet> {
  int tab = 0; // 0 timer, 1 stopwatch
  int timerSeconds = 60;
  int stopwatchMs = 0;
  bool running = false;
  Timer? ticker;

  @override
  void dispose() {
    ticker?.cancel();
    super.dispose();
  }

  void _start() {
    ticker?.cancel();
    setState(() => running = true);
    ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted) return;
      setState(() {
        if (tab == 0) {
          if (timerSeconds <= 0) {
            running = false;
            ticker?.cancel();
          } else if (stopwatchMs % 10 == 0) {
            // every 1s roughly via 100ms * 10
          }
          if (DateTime.now().millisecond < 120) {
            // handled below
          }
        } else {
          stopwatchMs += 100;
        }
      });
    });
    if (tab == 0) {
      ticker?.cancel();
      ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted || !running) return;
        setState(() {
          if (timerSeconds <= 0) {
            running = false;
            ticker?.cancel();
          } else {
            timerSeconds--;
          }
        });
      });
    }
  }

  void _reset() {
    ticker?.cancel();
    setState(() {
      running = false;
      stopwatchMs = 0;
      timerSeconds = 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final progress = 1 - (timerSeconds / 60);

    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: colors.border, borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color: colors.textPrimary)),
                Expanded(child: Text('Clock', textAlign: TextAlign.center, style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.w800))),
                IconButton(onPressed: () {}, icon: Icon(Icons.wb_sunny_outlined, color: colors.textPrimary)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: colors.background, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Expanded(child: _tab('Timer', 0, colors)),
                  Expanded(child: _tab('Stopwatch', 1, colors)),
                ],
              ),
            ),
          ),
          Expanded(
            child: tab == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: CircularProgressIndicator(
                                value: progress.clamp(0.0, 1.0),
                                strokeWidth: 10,
                                backgroundColor: colors.border,
                                color: colors.accent,
                              ),
                            ),
                            Text(formatRest(timerSeconds), style: TextStyle(color: colors.textPrimary, fontSize: 42, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(onPressed: () => setState(() => timerSeconds = (timerSeconds - 15).clamp(0, 600)), child: Text('-15s', style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.w700))),
                          TextButton(onPressed: () => setState(() => timerSeconds = (timerSeconds + 15).clamp(0, 600)), child: Text('+15s', style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.w700))),
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      _stopwatchLabel(),
                      style: TextStyle(color: colors.textPrimary, fontSize: 48, fontWeight: FontWeight.w800, fontFeatures: const [FontFeature.tabularFigures()]),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: tab == 0
                ? SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: running ? _reset : _start,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.accent,
                        foregroundColor: colors.onAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(running ? 'RESET' : 'START', style: const TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  )
                : Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: stopwatchMs == 0 && !running ? null : _reset,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.background,
                            foregroundColor: colors.textPrimary,
                            disabledForegroundColor: colors.textMuted,
                            elevation: 0,
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('RESET', style: TextStyle(fontWeight: FontWeight.w800)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (running) {
                              ticker?.cancel();
                              setState(() => running = false);
                            } else {
                              _start();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.accent,
                            foregroundColor: colors.onAccent,
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(running ? 'STOP' : 'START', style: const TextStyle(fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _tab(String label, int i, dynamic colors) {
    final on = tab == i;
    return GestureDetector(
      onTap: () {
        ticker?.cancel();
        setState(() {
          tab = i;
          running = false;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: on ? colors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: on ? colors.onAccent : colors.textSecondary, fontWeight: FontWeight.w700)),
      ),
    );
  }

  String _stopwatchLabel() {
    final total = stopwatchMs;
    final m = (total ~/ 60000).toString().padLeft(2, '0');
    final s = ((total % 60000) ~/ 1000).toString().padLeft(2, '0');
    final cs = ((total % 1000) ~/ 10).toString().padLeft(2, '0');
    return '$m:$s.$cs';
  }
}
