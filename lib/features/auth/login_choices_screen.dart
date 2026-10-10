import 'package:fitzella/core/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Sign-in choices shown after the welcome intro.
/// Email opens the existing sign-in form. Apple and Google leave the app
/// and return through the login callback.
class LoginChoicesScreen extends ConsumerStatefulWidget {
  const LoginChoicesScreen({super.key});

  @override
  ConsumerState<LoginChoicesScreen> createState() => _LoginChoicesScreenState();
}

class _LoginChoicesScreenState extends ConsumerState<LoginChoicesScreen> {
  String? _busy;

  static const _bg = Color(0xFF0C0E14);
  static const _muted = Color(0xFF9B9BA8);
  static const _outline = Color(0xFF3A3F4B);

  Future<void> _continueWith(OAuthProvider provider) async {
    if (_busy != null) return;
    setState(() => _busy = provider.name);
    final result = await ref
        .read(authNotifierProvider.notifier)
        .signInWithProvider(provider);
    if (!mounted) return;
    setState(() => _busy = null);
    result.when(
      success: (_) {},
      error: (message) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Material(
                  color: const Color(0xFF1A1D27),
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    onTap: () => context.go('/welcome'),
                    borderRadius: BorderRadius.circular(24),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(10, 8, 14, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chevron_left, color: Colors.white, size: 20),
                          SizedBox(width: 2),
                          Text(
                            'Welcome',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 3),
              const Text(
                'FITZELLA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.6,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Welcome back to Fitzella',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Resume your journey to smarter workouts',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _muted,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 32),
              _ChoiceButton(
                label: 'Continue with Apple',
                filled: true,
                loading: _busy == OAuthProvider.apple.name,
                leading: const Icon(Icons.apple, color: Color(0xFF111114), size: 22),
                onPressed: _busy == null
                    ? () => _continueWith(OAuthProvider.apple)
                    : null,
              ),
              const SizedBox(height: 12),
              _ChoiceButton(
                label: 'Continue with Google',
                loading: _busy == OAuthProvider.google.name,
                leading: SvgPicture.string(_googleMark, width: 18, height: 18),
                onPressed: _busy == null
                    ? () => _continueWith(OAuthProvider.google)
                    : null,
              ),
              const SizedBox(height: 12),
              _ChoiceButton(
                label: 'Continue with Email',
                leading: const Icon(Icons.mail_outline, color: Colors.white, size: 20),
                onPressed: _busy == null
                    ? () => context.push('/auth/login')
                    : null,
              ),
              const SizedBox(height: 22),
              const Text.rich(
                TextSpan(
                  style: TextStyle(color: _muted, fontSize: 12, height: 1.45),
                  children: [
                    TextSpan(text: 'By continuing you agree to our '),
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: '\nand '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final String label;
  final Widget leading;
  final VoidCallback? onPressed;
  final bool filled;
  final bool loading;

  const _ChoiceButton({
    required this.label,
    required this.leading,
    required this.onPressed,
    this.filled = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = filled ? const Color(0xFF111114) : Colors.white;
    return SizedBox(
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: filled ? Colors.white : Colors.transparent,
          foregroundColor: foreground,
          side: BorderSide(
            color: filled ? Colors.white : _LoginChoicesScreenState._outline,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: loading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: foreground,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  leading,
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: TextStyle(
                      color: foreground,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

const _googleMark = '''
<svg viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">
  <path fill="#FFC107" d="M43.6 20.5H42V20H24v8h11.3C33.7 32.7 29.3 36 24 36c-6.6 0-12-5.4-12-12s5.4-12 12-12c3.1 0 5.8 1.2 8 3.1l5.7-5.7C34.2 6.1 29.4 4 24 4 12.9 4 4 12.9 4 24s8.9 20 20 20 20-8.9 20-20c0-1.3-.1-2.7-.4-3.5z"/>
  <path fill="#FF3D00" d="M6.3 14.7l6.6 4.8C14.7 16 19 12 24 12c3.1 0 5.8 1.2 8 3.1l5.7-5.7C34.2 6.1 29.4 4 24 4 16.3 4 9.6 8.3 6.3 14.7z"/>
  <path fill="#4CAF50" d="M24 44c5.2 0 10-2 13.6-5.2l-6.3-5.3C29.2 35.1 26.7 36 24 36c-5.3 0-9.7-3.3-11.3-8l-6.5 5C9.5 39.6 16.2 44 24 44z"/>
  <path fill="#1976D2" d="M43.6 20.5H42V20H24v8h11.3c-1.1 3.2-3.5 5.7-6.6 7.2l6.3 5.3C37.4 38.3 44 33 44 24c0-1.3-.1-2.7-.4-3.5z"/>
</svg>
''';
