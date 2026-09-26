import 'dart:async';

import 'package:fitzella/core/providers/auth_provider.dart';
import 'package:fitzella/core/services/profile_prefs_service.dart';
import 'package:fitzella/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// First launch screen — branded Fitzella splash.
/// After a short delay:
/// - signed in + onboarded → /home
/// - signed in + not onboarded → /onboarding/welcome
/// - otherwise → /welcome (intro → sign in)
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1800), _navigateNext);
  }

  Future<void> _navigateNext() async {
    if (!mounted) return;

    // Wait briefly if auth profile is still loading.
    var auth = ref.read(authNotifierProvider);
    if (auth.loading && auth.session != null) {
      for (var i = 0; i < 20; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        if (!mounted) return;
        auth = ref.read(authNotifierProvider);
        if (!auth.loading) break;
      }
    }

    final cached = ref.read(cachedProfileProvider) ??
        ref.read(profilePrefsServiceProvider).load();
    final session = auth.session;
    final onboarded =
        auth.profile?.onboarded == true || cached?.onboarded == true;

    if (!mounted) return;
    if (session != null && !auth.pendingPasswordRecovery) {
      context.go(onboarded ? '/home' : '/onboarding/welcome');
    } else {
      context.go('/welcome');
    }
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
                  'Fitzella',
                  textAlign: TextAlign.center,
                  style: AppTypography.sheetTitle.copyWith(
                    fontSize: 24,
                    color: colors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Track workouts. Build strength.',
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
      width: 94,
      height: 94,
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
        'Fitzella',
        style: TextStyle(
          fontSize: 14,
          fontWeight: AppWeight.extraBold,
          color: colors.accent,
          letterSpacing: -0.4,
        ),
      ),
    );
  }
}
