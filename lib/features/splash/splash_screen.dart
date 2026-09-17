import 'dart:async';

import 'package:fitzella/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// First launch screen — branded Fitzella splash.
/// After a short delay, navigates to the welcome (01) screen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.go('/welcome');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const colors = AppColors.dark;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _AppIcon(),
                const SizedBox(height: 56),
                Text(
                  'Welcome to Fitzella',
                  textAlign: TextAlign.center,
                  style: AppTypography.sheetTitle.copyWith(
                    fontSize: 24,
                    color: colors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Discover new features, personalize your experience, '
                  'and start your fitness journey with us today.',
                  textAlign: TextAlign.center,
                  style: AppTypography.secondary.copyWith(
                    color: colors.textSecondary,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppIcon extends StatelessWidget {
  const _AppIcon();

  @override
  Widget build(BuildContext context) {
    const colors = AppColors.dark;
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        color: const Color(0xFF161A2C),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.accent.withValues(alpha: 0.15),
            blurRadius: 24,
            spreadRadius: -4,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        'fitzella',
        style: TextStyle(
          fontSize: 15,
          fontWeight: AppWeight.extraBold,
          color: colors.accent,
          letterSpacing: -0.4,
        ),
      ),
    );
  }
}
