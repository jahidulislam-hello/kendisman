import 'dart:async';
import 'dart:developer' as developer;

import 'package:fitzella/core/providers/auth_provider.dart';
import 'package:fitzella/core/services/profile_prefs_service.dart';
import 'package:fitzella/core/theme/app_theme.dart';
import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/features/auth/widgets/buttons.dart';
import 'package:fitzella/features/auth/widgets/cards.dart';
import 'package:fitzella/features/auth/widgets/inputs.dart';
import 'package:fitzella/core/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void _authLog(String message, {Object? error}) {
  final text = error == null ? '[AUTH] $message' : '[AUTH] $message | $error';
  debugPrint(text);
  developer.log(text, name: 'fitzella.auth', error: error);
}

void _showAuthSnack(
  BuildContext context, {
  required String message,
  bool isError = false,
}) {
  if (isError) {
    _authLog('ERROR: $message');
  } else {
    _authLog(message);
  }
  if (!context.mounted) return;
  final colors = Theme.of(context).colorScheme;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: isError ? colors.onError : colors.onSurface),
        ),
        backgroundColor: isError ? colors.error : null,
      ),
    );
}

bool _checkIsOnboarded(AuthState auth, CachedProfile? cached, String? userId) {
  if (userId == null) return false;
  final profile = auth.profile?.id == userId ? auth.profile : null;
  final profileOnboarded = profile != null &&
      (profile.onboarded ||
          profile.goal != null ||
          profile.heightCm != null ||
          profile.trainingDaysPerWeek != null ||
          profile.equipmentPreference != null);
  final cachedOnboarded = cached?.userId == userId &&
      (cached?.onboarded == true ||
          cached?.goal != null ||
          cached?.heightCm != null ||
          cached?.frequency != null ||
          cached?.equipment != null);
  return profileOnboarded || cachedOnboarded;
}

/// Base auth screen with common layout
class AuthScreen extends ConsumerWidget {
  final Widget child;
  final String? title;
  final String? subtitle;
  final bool showBack;

  const AuthScreen({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: colors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.xl,
            AppSpacing.xl,
            AppSpacing.xl + bottomInset * 0.15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showBack)
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 40, minHeight: 40),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/welcome');
                      }
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: colors.textPrimary, size: 20),
                  ),
                ),
              if (title != null) ...[
                Text(
                  'Fitzella',
                  style: AppTypography.small.copyWith(
                    color: colors.accent,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                const VGap(AppSpacing.sm),
                Text(title!,
                    style: AppTypography.screenTitle
                        .copyWith(color: colors.textPrimary)),
                if (subtitle != null) ...[
                  const VGap(AppSpacing.xs),
                  Text(subtitle!,
                      style: AppTypography.secondary
                          .copyWith(color: colors.textSecondary)),
                ],
                const VGap(AppSpacing.xl),
              ],
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Login screen
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final result = await ref.read(authNotifierProvider.notifier).signIn(
          _emailController.text.trim(),
          _passwordController.text,
        );
    if (!mounted) return;
    setState(() => _loading = false);

    result.when(
      success: (_) {
        final auth = ref.read(authNotifierProvider);
        final cached = ref.read(cachedProfileProvider) ??
            ref.read(profilePrefsServiceProvider).load();
        final onboarded =
            _checkIsOnboarded(auth, cached, auth.session?.user.id);
        _showAuthSnack(
          context,
          message: onboarded
              ? 'Welcome back to Fitzella!'
              : 'Signed in — let\'s finish your Fitzella setup.',
        );
        context.go(onboarded ? '/home' : '/onboarding/welcome');
      },
      error: (message) =>
          _showAuthSnack(context, message: message, isError: true),
    );
  }

  void _socialComingSoon() {
    _showAuthSnack(context,
        message: 'Apple & Google sign-in coming soon to Fitzella.');
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);

    return AuthScreen(
      title: 'Welcome Back',
      subtitle: 'Sign in to continue your Fitzella fitness journey',
      showBack: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: 'Email',
              hint: 'you@example.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              validator: (value) {
                if (value == null || value.isEmpty) return 'Email is required';
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const VGap(AppSpacing.md),
            AppTextField(
              label: 'Password',
              hint: '••••••••',
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onFieldSubmitted: (_) => _handleLogin(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: colors.textMuted,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Password is required';
                if (value.length < 6)
                  return 'Password must be at least 6 characters';
                return null;
              },
            ),
            const VGap(AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.go('/auth/forgot-password'),
                child: Text('Forgot Password?',
                    style:
                        AppTypography.secondary.copyWith(color: colors.accent)),
              ),
            ),
            const VGap(AppSpacing.lg),
            PrimaryButton(
              title: 'Sign In',
              loading: _loading,
              onPressed: _handleLogin,
            ),
            const VGap(AppSpacing.xl),
            Row(
              children: [
                Expanded(child: Divider(color: colors.border)),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Text('or continue with',
                      style: AppTypography.small
                          .copyWith(color: colors.textMuted)),
                ),
                Expanded(child: Divider(color: colors.border)),
              ],
            ),
            const VGap(AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    title: 'Apple',
                    leading: const Icon(Icons.apple, size: 20),
                    onPressed: _socialComingSoon,
                  ),
                ),
                const HGap(AppSpacing.md),
                Expanded(
                  child: SecondaryButton(
                    title: 'Google',
                    leading: Image.network(
                      'https://www.google.com/favicon.ico',
                      width: 20,
                      height: 20,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.g_mobiledata, size: 22),
                    ),
                    onPressed: _socialComingSoon,
                  ),
                ),
              ],
            ),
            const VGap(AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account? ',
                    style: AppTypography.body
                        .copyWith(color: colors.textSecondary)),
                TextButton(
                  onPressed: () => context.go('/auth/signup'),
                  child: Text('Sign Up',
                      style: AppTypography.body.copyWith(
                          color: colors.accent, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Signup screen
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  bool _termsAccepted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_termsAccepted) {
      _showAuthSnack(
        context,
        message: 'Please accept the Terms of Service and Privacy Policy',
        isError: true,
      );
      return;
    }
    setState(() => _loading = true);
    final email = _emailController.text.trim();
    _authLog('Sign up started for $email');
    final result = await ref.read(authNotifierProvider.notifier).signUp(
          email,
          _passwordController.text,
        );
    if (!mounted) return;
    setState(() => _loading = false);

    result.when(
      success: (needsVerification) {
        if (needsVerification) {
          _showAuthSnack(
            context,
            message: 'Check your email for a Fitzella confirmation code.',
          );
          context.go(
              '/auth/verify-otp?email=${Uri.encodeComponent(email)}&purpose=signup');
        } else {
          _showAuthSnack(context, message: 'Welcome to Fitzella!');
          context.go('/onboarding/welcome');
        }
      },
      error: (message) =>
          _showAuthSnack(context, message: message, isError: true),
    );
  }

  void _socialComingSoon() {
    _showAuthSnack(context,
        message: 'Apple & Google sign-in coming soon to Fitzella.');
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);

    return AuthScreen(
      title: 'Create Account',
      subtitle: 'Join Fitzella and start your fitness journey today',
      showBack: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: 'Email',
              hint: 'you@example.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              validator: (value) {
                if (value == null || value.isEmpty) return 'Email is required';
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const VGap(AppSpacing.md),
            AppTextField(
              label: 'Password',
              hint: '••••••••',
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: colors.textMuted,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Password is required';
                if (value.length < 6)
                  return 'Password must be at least 6 characters';
                return null;
              },
            ),
            const VGap(AppSpacing.md),
            AppTextField(
              label: 'Confirm Password',
              hint: '••••••••',
              controller: _confirmController,
              obscureText: _obscureConfirm,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              onFieldSubmitted: (_) => _handleSignup(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                  color: colors.textMuted,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Please confirm password';
                if (value != _passwordController.text)
                  return 'Passwords do not match';
                return null;
              },
            ),
            const VGap(AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _termsAccepted,
                  onChanged: (v) => setState(() => _termsAccepted = v ?? false),
                  activeColor: colors.accent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                const HGap(AppSpacing.xs),
                Expanded(
                  child: Text(
                    'I agree to the Fitzella Terms of Service and Privacy Policy',
                    style: AppTypography.small
                        .copyWith(color: colors.textSecondary),
                  ),
                ),
              ],
            ),
            const VGap(AppSpacing.lg),
            PrimaryButton(
              title: 'Create Account',
              loading: _loading,
              onPressed: _handleSignup,
            ),
            const VGap(AppSpacing.xl),
            Row(
              children: [
                Expanded(child: Divider(color: colors.border)),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Text('or continue with',
                      style: AppTypography.small
                          .copyWith(color: colors.textMuted)),
                ),
                Expanded(child: Divider(color: colors.border)),
              ],
            ),
            const VGap(AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    title: 'Apple',
                    leading: const Icon(Icons.apple, size: 20),
                    onPressed: _socialComingSoon,
                  ),
                ),
                const HGap(AppSpacing.md),
                Expanded(
                  child: SecondaryButton(
                    title: 'Google',
                    leading: Image.network(
                      'https://www.google.com/favicon.ico',
                      width: 20,
                      height: 20,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.g_mobiledata, size: 22),
                    ),
                    onPressed: _socialComingSoon,
                  ),
                ),
              ],
            ),
            const VGap(AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account? ',
                    style: AppTypography.body
                        .copyWith(color: colors.textSecondary)),
                TextButton(
                  onPressed: () => context.go('/auth/login'),
                  child: Text('Sign In',
                      style: AppTypography.body.copyWith(
                          color: colors.accent, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Forgot password screen
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final email = _emailController.text.trim();
    final result = await ref
        .read(authNotifierProvider.notifier)
        .sendPasswordResetOtp(email);
    if (!mounted) return;
    setState(() => _loading = false);

    result.when(
      success: (_) {
        _showAuthSnack(
          context,
          message: 'We sent a Fitzella reset code to $email',
        );
        context.go(
          '/auth/verify-otp?email=${Uri.encodeComponent(email)}&purpose=recovery',
        );
      },
      error: (message) =>
          _showAuthSnack(context, message: message, isError: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);

    return AuthScreen(
      title: 'Forgot Password?',
      subtitle: 'Enter your email and we\'ll send you a Fitzella reset code',
      showBack: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: 'Email',
              hint: 'you@example.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              onFieldSubmitted: (_) => _handleSubmit(),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Email is required';
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const VGap(AppSpacing.lg),
            PrimaryButton(
              title: 'Send Reset Code',
              loading: _loading,
              onPressed: _handleSubmit,
            ),
            const VGap(AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Remember your password? ',
                    style: AppTypography.body
                        .copyWith(color: colors.textSecondary)),
                TextButton(
                  onPressed: () => context.go('/auth/login'),
                  child: Text('Sign In',
                      style: AppTypography.body.copyWith(
                          color: colors.accent, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Reset password screen
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final result = await ref
        .read(authNotifierProvider.notifier)
        .completePasswordReset(_passwordController.text);
    if (!mounted) return;
    setState(() => _loading = false);

    result.when(
      success: (_) {
        _showAuthSnack(context,
            message: 'Password updated. Sign in to Fitzella.');
        context.go('/auth/login');
      },
      error: (message) =>
          _showAuthSnack(context, message: message, isError: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);

    return AuthScreen(
      title: 'Set New Password',
      subtitle: 'Choose a new password for your Fitzella account',
      showBack: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: 'New Password',
              hint: '••••••••',
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: colors.textMuted,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Password is required';
                if (value.length < 6)
                  return 'Password must be at least 6 characters';
                return null;
              },
            ),
            const VGap(AppSpacing.md),
            AppTextField(
              label: 'Confirm Password',
              hint: '••••••••',
              controller: _confirmController,
              obscureText: _obscureConfirm,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              onFieldSubmitted: (_) => _handleReset(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                  color: colors.textMuted,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Please confirm password';
                if (value != _passwordController.text)
                  return 'Passwords do not match';
                return null;
              },
            ),
            const VGap(AppSpacing.lg),
            PrimaryButton(
              title: 'Reset Password',
              loading: _loading,
              onPressed: _handleReset,
            ),
          ],
        ),
      ),
    );
  }
}

/// Verify OTP screen
class VerifyOtpScreen extends ConsumerStatefulWidget {
  final String email;
  final String purpose; // signup | recovery

  const VerifyOtpScreen({
    super.key,
    this.email = '',
    this.purpose = 'signup',
  });

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen>
    with WidgetsBindingObserver {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  bool _loading = false;
  bool _checkingConfirmation = false;
  bool _manualOtpVisible = false;
  int _resendCooldown = 30;
  Timer? _cooldownTimer;
  Timer? _periodicCheckTimer;
  int _periodicCheckTicks = 0;
  StreamSubscription<dynamic>? _authChangeSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startResendCooldown();

    // If this is signup confirmation, start checking periodically in background
    if (widget.purpose != 'recovery') {
      _startPeriodicConfirmationCheck();
    }

    // Direct listener to Supabase auth events
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final client = ref.read(supabaseClientProvider);
      _authChangeSub = client.auth.onAuthStateChange.listen((data) {
        if (!mounted) return;
        if (data.session != null && widget.purpose != 'recovery') {
          _onVerifiedSuccess(data.session!.user.id);
        }
      });
      // Initial check if already confirmed
      _checkConfirmation(silent: true);
    });
  }

  void _startPeriodicConfirmationCheck() {
    _periodicCheckTimer?.cancel();
    _periodicCheckTicks = 0;
    // Check every 4 seconds for up to 3 minutes (45 ticks)
    _periodicCheckTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      _periodicCheckTicks++;
      if (_periodicCheckTicks > 45) {
        timer.cancel();
        return;
      }
      _checkConfirmation(silent: true);
    });
  }

  void _startResendCooldown([int seconds = 30]) {
    _cooldownTimer?.cancel();
    setState(() => _resendCooldown = seconds);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_resendCooldown <= 1) {
        t.cancel();
        setState(() => _resendCooldown = 0);
      } else {
        setState(() => _resendCooldown -= 1);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cooldownTimer?.cancel();
    _periodicCheckTimer?.cancel();
    _authChangeSub?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && widget.purpose != 'recovery') {
      _authLog('App resumed on VerifyOtpScreen, checking confirmation status...');
      _checkConfirmation(silent: true);
    }
  }

  Future<void> _onVerifiedSuccess(String userId) async {
    if (!mounted) return;
    _periodicCheckTimer?.cancel();
    await ref.read(authNotifierProvider.notifier).reloadProfile();
    if (!mounted) return;
    final auth = ref.read(authNotifierProvider);
    final cached = ref.read(cachedProfileProvider) ??
        ref.read(profilePrefsServiceProvider).load();
    final onboarded = _checkIsOnboarded(auth, cached, userId);
    _showAuthSnack(context, message: 'Email confirmed! Welcome to Fitzella.');
    context.go(onboarded ? '/home' : '/onboarding/welcome');
  }

  Future<void> _checkConfirmation({bool silent = false}) async {
    if (_checkingConfirmation || !mounted) return;
    if (!silent) {
      setState(() => _checkingConfirmation = true);
    }

    try {
      final client = ref.read(supabaseClientProvider);
      final session = client.auth.currentSession;
      if (session != null) {
        _authLog('Session already present on checkConfirmation');
        await _onVerifiedSuccess(session.user.id);
        return;
      }

      // Check if credentials are saved from signup to complete sign-in
      final result = await ref
          .read(authNotifierProvider.notifier)
          .checkPendingSignupConfirmation(email: widget.email);

      if (!mounted) return;

      result.when(
        success: (_) {
          final activeSession =
              ref.read(supabaseClientProvider).auth.currentSession;
          if (activeSession != null) {
            _onVerifiedSuccess(activeSession.user.id);
          } else {
            _showAuthSnack(context,
                message: 'Email confirmed! Please sign in.');
            context.go('/auth/login');
          }
        },
        error: (message) {
          if (!silent) {
            final msgLower = message.toLowerCase();
            if (msgLower.contains('confirm') ||
                msgLower.contains('not confirmed')) {
              _showAuthSnack(
                context,
                message:
                    'Email not confirmed yet. Please tap the link sent to ${widget.email}.',
                isError: true,
              );
            } else {
              _showAuthSnack(context, message: message, isError: true);
            }
          }
        },
      );
    } finally {
      if (mounted && !silent) {
        setState(() => _checkingConfirmation = false);
      }
    }
  }

  Future<void> _handleVerify() async {
    final code = _controllers.map((c) => c.text.trim()).join();
    if (code.length != 6) {
      _showAuthSnack(context,
          message: 'Enter the full 6-digit code', isError: true);
      return;
    }
    if (widget.email.isEmpty) {
      _showAuthSnack(
        context,
        message: 'Missing email. Please start again from sign up.',
        isError: true,
      );
      return;
    }

    setState(() => _loading = true);
    final notifier = ref.read(authNotifierProvider.notifier);
    final result = widget.purpose == 'recovery'
        ? await notifier.verifyPasswordResetOtp(widget.email, code)
        : await notifier.verifySignupOtp(widget.email, code);
    if (!mounted) return;
    setState(() => _loading = false);

    result.when(
      success: (_) {
        if (widget.purpose == 'recovery') {
          _showAuthSnack(context,
              message: 'Code verified. Set your new password.');
          context.go('/auth/reset-password');
        } else {
          final auth = ref.read(authNotifierProvider);
          final session = auth.session ??
              ref.read(supabaseClientProvider).auth.currentSession;
          if (session != null) {
            _onVerifiedSuccess(session.user.id);
          } else {
            final cached = ref.read(cachedProfileProvider) ??
                ref.read(profilePrefsServiceProvider).load();
            final onboarded =
                _checkIsOnboarded(auth, cached, auth.session?.user.id);
            _showAuthSnack(context,
                message: 'Email confirmed. Welcome to Fitzella!');
            context.go(onboarded ? '/home' : '/onboarding/welcome');
          }
        }
      },
      error: (message) =>
          _showAuthSnack(context, message: message, isError: true),
    );
  }

  Future<void> _handleResend() async {
    if (widget.email.isEmpty || _resendCooldown > 0) return;
    setState(() => _loading = true);
    _authLog('Resend email requested for ${widget.email}');
    final result = widget.purpose == 'recovery'
        ? await ref
            .read(authNotifierProvider.notifier)
            .sendPasswordResetOtp(widget.email)
        : await ref
            .read(authNotifierProvider.notifier)
            .resendSignupOtp(widget.email);
    if (!mounted) return;
    setState(() => _loading = false);

    result.when(
      success: (_) {
        _startResendCooldown(30);
        _showAuthSnack(context, message: 'Email sent. Check inbox and spam.');
      },
      error: (message) {
        if (message.toLowerCase().contains('rate limit')) {
          _startResendCooldown(60);
        }
        _showAuthSnack(context, message: message, isError: true);
      },
    );
  }

  void _onCodeChanged(String value, int index) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 1) {
      // Handle pasted code or multi-digit input
      for (int i = 0; i < 6 && i < digits.length; i++) {
        _controllers[i].text = digits[i];
      }
      final nextFocus = digits.length < 6 ? digits.length : 5;
      _focusNodes[nextFocus].requestFocus();
      if (digits.length >= 6) {
        _handleVerify();
      }
      return;
    }

    if (digits.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (digits.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    if (index == 5 && digits.isNotEmpty) {
      _handleVerify();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final isRecovery = widget.purpose == 'recovery';

    // Auto-navigate if authenticated via deep link
    ref.listen(authNotifierProvider, (previous, next) {
      if (next.session != null && !next.loading && !isRecovery) {
        _onVerifiedSuccess(next.session!.user.id);
      }
    });

    if (isRecovery) {
      return AuthScreen(
        title: 'Reset Your Password',
        subtitle: widget.email.isEmpty
            ? 'Enter the 6-digit code from your email to set a new password.'
            : 'We sent a 6-digit reset code to ${widget.email}. Enter it below.',
        showBack: true,
        child: Column(
          children: [
            const VGap(AppSpacing.lg),
            Text(
              'Enter the 6-digit code from your email to set a new password.',
              textAlign: TextAlign.center,
              style: AppTypography.secondary
                  .copyWith(color: colors.textSecondary),
            ),
            const VGap(AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Container(
                  width: 48,
                  height: 56,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: TextFormField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    style: AppTypography.statNumber
                        .copyWith(color: colors.textPrimary),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: colors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        borderSide: BorderSide(color: colors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        borderSide: BorderSide(color: colors.accent, width: 2),
                      ),
                    ),
                    onChanged: (v) => _onCodeChanged(v, index),
                  ),
                );
              }),
            ),
            const VGap(AppSpacing.xl),
            PrimaryButton(
              title: 'Verify Code',
              loading: _loading,
              onPressed: _handleVerify,
            ),
            const VGap(AppSpacing.md),
            TextButton(
              onPressed: (_loading || _resendCooldown > 0) ? null : _handleResend,
              child: Text(
                _resendCooldown > 0
                    ? 'Resend Reset Code (${_resendCooldown}s)'
                    : 'Resend Reset Code',
                style: AppTypography.body.copyWith(
                  color: _resendCooldown > 0 ? colors.textMuted : colors.accent,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Signup confirmation UI: prominent email-link verification card + optional OTP fallback
    return AuthScreen(
      title: 'Confirm Your Email',
      subtitle: widget.email.isEmpty
          ? 'Check your inbox to complete your Fitzella registration.'
          : 'We sent a verification link to ${widget.email}',
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VGap(AppSpacing.md),
          // Email Verification Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colors.accent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mark_email_read_outlined,
                    size: 28,
                    color: colors.accent,
                  ),
                ),
                const VGap(AppSpacing.md),
                Text(
                  'Confirm via Email Link',
                  style: AppTypography.sheetTitle.copyWith(
                    color: colors.textPrimary,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const VGap(AppSpacing.xs),
                Text(
                  'Open your email in Gmail and tap the "Confirm Email Address" button.',
                  textAlign: TextAlign.center,
                  style: AppTypography.secondary.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const VGap(AppSpacing.lg),
                PrimaryButton(
                  title: 'I\'ve Confirmed in Email',
                  loading: _checkingConfirmation,
                  onPressed: () => _checkConfirmation(silent: false),
                ),
                const VGap(AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.textMuted,
                      ),
                    ),
                    const HGap(AppSpacing.xs),
                    Text(
                      'Auto-detecting when you confirm...',
                      style: AppTypography.small.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const VGap(AppSpacing.lg),
          // Collapsible or toggleable 6-digit OTP entry
          if (!_manualOtpVisible)
            Center(
              child: TextButton.icon(
                icon: Icon(Icons.pin_outlined, size: 18, color: colors.textSecondary),
                label: Text(
                  'Or enter 6-digit code manually',
                  style: AppTypography.small.copyWith(
                    color: colors.textSecondary,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onPressed: () => setState(() => _manualOtpVisible = true),
              ),
            )
          else ...[
            Row(
              children: [
                Expanded(child: Divider(color: colors.border)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Text(
                    'or enter 6-digit code',
                    style: AppTypography.small.copyWith(color: colors.textMuted),
                  ),
                ),
                Expanded(child: Divider(color: colors.border)),
              ],
            ),
            const VGap(AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Container(
                  width: 46,
                  height: 54,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  child: TextFormField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    style: AppTypography.statNumber
                        .copyWith(color: colors.textPrimary, fontSize: 20),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: colors.background,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        borderSide: BorderSide(color: colors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        borderSide: BorderSide(color: colors.accent, width: 2),
                      ),
                    ),
                    onChanged: (v) => _onCodeChanged(v, index),
                  ),
                );
              }),
            ),
            const VGap(AppSpacing.md),
            SecondaryButton(
              title: 'Verify Code',
              loading: _loading,
              onPressed: _handleVerify,
            ),
          ],
          const VGap(AppSpacing.md),
          Center(
            child: TextButton(
              onPressed: (_loading || _resendCooldown > 0) ? null : _handleResend,
              child: Text(
                _resendCooldown > 0
                    ? 'Resend Email (${_resendCooldown}s)'
                    : 'Resend Confirmation Email',
                style: AppTypography.body.copyWith(
                  color: _resendCooldown > 0 ? colors.textMuted : colors.accent,
                ),
              ),
            ),
          ),
          const VGap(AppSpacing.xs),
          Center(
            child: TextButton(
              onPressed: () => context.go('/auth/login'),
              child: Text(
                'Already confirmed via email link? Sign In',
                style: AppTypography.small
                    .copyWith(color: colors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Handles incoming deep links (e.g. io.fitzella.app://login-callback/)
class AuthCallbackScreen extends ConsumerStatefulWidget {
  final Uri uri;

  const AuthCallbackScreen({super.key, required this.uri});

  @override
  ConsumerState<AuthCallbackScreen> createState() => _AuthCallbackScreenState();
}

class _AuthCallbackScreenState extends ConsumerState<AuthCallbackScreen> {
  String _status = 'Confirming your email...';
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _processCallback();
  }

  Future<void> _processCallback() async {
    _authLog('AuthCallbackScreen processing uri: ${widget.uri}');

    final uri = widget.uri;
    final effectiveUri = uri.hasScheme
        ? uri
        : Uri.parse(
            'io.fitzella.app://login-callback/${uri.hasQuery ? '?${uri.query}' : ''}${uri.hasFragment ? '#${uri.fragment}' : ''}');

    final query = effectiveUri.queryParameters;
    final fragment = Uri.splitQueryString(effectiveUri.fragment);

    // Check for error parameters from Supabase
    final errorDescription = query['error_description'] ??
        fragment['error_description'] ??
        query['error'] ??
        fragment['error'];

    if (errorDescription != null) {
      _authLog('AuthCallback error: $errorDescription');
      if (!mounted) return;
      setState(() {
        _status = errorDescription;
        _isError = true;
      });
      _showAuthSnack(context, message: errorDescription, isError: true);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) context.go('/auth/login');
      return;
    }

    try {
      final client = ref.read(supabaseClientProvider);
      if (client.auth.currentSession == null) {
        await client.auth.getSessionFromUrl(effectiveUri);
      }
    } catch (e) {
      _authLog('AuthCallback getSessionFromUrl error', error: e);
    }

    // If session is still null, try pending credentials if available
    if (ref.read(supabaseClientProvider).auth.currentSession == null) {
      await ref
          .read(authNotifierProvider.notifier)
          .checkPendingSignupConfirmation();
    }

    // Wait briefly for authNotifier to synchronize
    for (int i = 0; i < 20; i++) {
      if (!mounted) return;
      final auth = ref.read(authNotifierProvider);
      final session =
          auth.session ?? ref.read(supabaseClientProvider).auth.currentSession;
      if (session != null) {
        await ref.read(authNotifierProvider.notifier).reloadProfile();
        if (!mounted) return;
        final updatedAuth = ref.read(authNotifierProvider);
        final cached = ref.read(cachedProfileProvider) ??
            ref.read(profilePrefsServiceProvider).load();
        final onboarded =
            _checkIsOnboarded(updatedAuth, cached, session.user.id);

        _showAuthSnack(context,
            message: 'Email confirmed! Welcome to Fitzella.');
        context.go(onboarded ? '/home' : '/onboarding/welcome');
        return;
      }
      await Future.delayed(const Duration(milliseconds: 200));
    }

    if (!mounted) return;
    setState(() {
      _status = 'Email verified! Please sign in to continue.';
      _isError = false;
    });
    _showAuthSnack(context,
        message: 'Email confirmed! Please sign in with your password.');
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) context.go('/auth/login');
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isError)
                Icon(Icons.error_outline_rounded,
                    size: 48, color: colors.danger)
              else
                CircularProgressIndicator(color: colors.accent),
              const VGap(AppSpacing.lg),
              Text(
                'Fitzella',
                style: AppTypography.small.copyWith(
                  color: colors.accent,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
              const VGap(AppSpacing.sm),
              Text(
                _status,
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: _isError ? colors.danger : colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
