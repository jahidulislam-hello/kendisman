import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Welcome screen — exact 01.png design.
/// Invisible hit targets over the image "Sign in" and arrow → Sign In.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const _asset = 'assets/images/welcome_01.png';

  void _goSignIn(BuildContext context) => context.go('/auth/login');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-bleed design image (no extra "Sign in" text on top)
          Center(
            child: Image.asset(
              _asset,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stack) {
                debugPrint('Welcome image failed: $error');
                return _WelcomeFallback(onSignIn: () => _goSignIn(context));
              },
            ),
          ),

          // Invisible tap over baked-in "Sign in" (top-right)
          Positioned(
            top: MediaQuery.paddingOf(context).top,
            right: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _goSignIn(context),
              child: const SizedBox(width: 110, height: 52),
            ),
          ),

          // Invisible tap over baked-in blue arrow (bottom-center)
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.paddingOf(context).bottom + 8,
            child: Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _goSignIn(context),
                child: const SizedBox(width: 80, height: 80),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeFallback extends StatelessWidget {
  final VoidCallback onSignIn;
  const _WelcomeFallback({required this.onSignIn});

  static const _orange = Color(0xFFFF9F0A);
  static const _blue = Color(0xFF2F69FE);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onSignIn,
              child: const Text('Sign in', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          const Spacer(),
          const Icon(Icons.public, color: _orange, size: 120),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_rounded, color: _orange, size: 28),
              Icon(Icons.star_rounded, color: _orange, size: 28),
              Icon(Icons.star_rounded, color: _orange, size: 28),
              Icon(Icons.star_rounded, color: _orange, size: 28),
              Icon(Icons.star_rounded, color: _orange, size: 28),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Millions', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800)),
          const Text('of users choice', style: TextStyle(color: Colors.white, fontSize: 16)),
          const Spacer(),
          GestureDetector(
            onTap: onSignIn,
            child: Container(
              width: 64,
              height: 64,
              margin: const EdgeInsets.only(bottom: 28),
              decoration: const BoxDecoration(color: _blue, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
