import 'dart:async';
import 'dart:developer' as developer;

import 'package:fitzella/core/providers/auth_provider.dart';
import 'package:fitzella/core/services/profile_prefs_service.dart';
import 'package:fitzella/core/theme/app_theme.dart';
import 'package:fitzella/core/theme/theme_provider.dart';
import 'package:fitzella/features/auth/widgets/buttons.dart';
import 'package:fitzella/features/auth/widgets/cards.dart';
import 'package:fitzella/features/auth/widgets/inputs.dart';
import 'package:flutter/material.dart';
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
        final cached = ref.read(cachedProfileProvider);
        final onboarded = (auth.profile?.id == auth.session?.user.id &&
                auth.profile?.onboarded == true) ||
            (cached?.userId == auth.session?.user.id &&
                cached?.onboarded == true);
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

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  bool _loading = false;
  int _resendCooldown = 30;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    _startResendCooldown();
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
    _cooldownTimer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _handleVerify() async {
    final code = _controllers.map((c) => c.text).join();
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
          _showAuthSnack(context,
              message: 'Email confirmed. Welcome to Fitzella!');
          context.go('/onboarding/welcome');
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
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    if (index == 5 && value.isNotEmpty) {
      _handleVerify();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final isRecovery = widget.purpose == 'recovery';

    return AuthScreen(
      title: isRecovery ? 'Reset Your Password' : 'Confirm Your Email',
      subtitle: widget.email.isEmpty
          ? 'Open the confirmation email from Fitzella, or enter the 6-digit code if included.'
          : isRecovery
              ? 'We sent a reset code to ${widget.email}. Enter the 6-digit code below.'
              : 'We sent a confirmation to ${widget.email}. Enter the 6-digit code, or tap Confirm in the email.',
      showBack: true,
      child: Column(
        children: [
          const VGap(AppSpacing.lg),
          Text(
            isRecovery
                ? 'Enter the code from your Fitzella email to continue.'
                : 'After you tap “Confirm email address” in your inbox, Fitzella will open automatically.',
            textAlign: TextAlign.center,
            style:
                AppTypography.secondary.copyWith(color: colors.textSecondary),
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
                  maxLength: 1,
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
                  ? 'Resend Email (${_resendCooldown}s)'
                  : 'Resend Email',
              style: AppTypography.body.copyWith(
                color: _resendCooldown > 0 ? colors.textMuted : colors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
