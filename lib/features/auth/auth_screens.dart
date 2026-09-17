import 'dart:async';
import 'dart:developer' as developer;

import 'package:fitzella/core/providers/auth_provider.dart';
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

void _showAuthError(String message) {
  _authLog('ERROR: $message');
}

void _showAuthInfo(String message) {
  _authLog(message);
}

/// Base auth screen with common layout
class AuthScreen extends ConsumerWidget {
  final Widget child;
  final String? title;
  final String? subtitle;

  const AuthScreen({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null) ...[
                Text(title!, style: AppTypography.screenTitle.copyWith(color: colors.textPrimary)),
                if (subtitle != null) ...[
                  const VGap(AppSpacing.xs),
                  Text(subtitle!, style: AppTypography.secondary.copyWith(color: colors.textSecondary)),
                ],
                const VGap(AppSpacing.xl),
              ],
              Expanded(
                child: SingleChildScrollView(
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
        _showAuthInfo('Sign in success → /home');
        context.go('/home');
      },
      error: _showAuthError,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);

    return AuthScreen(
      title: 'Welcome Back',
      subtitle: 'Sign in to continue your fitness journey',
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
              validator: (value) {
                if (value == null || value.isEmpty) return 'Email is required';
                if (!value.contains('@')) return 'Enter a valid email';
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
              onFieldSubmitted: (_) => _handleLogin(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: colors.textMuted,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Password is required';
                if (value.length < 6) return 'Password must be at least 6 characters';
                return null;
              },
            ),
            const VGap(AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.go('/auth/forgot-password'),
                child: Text('Forgot Password?', style: AppTypography.secondary.copyWith(color: colors.accent)),
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
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Text('or continue with', style: AppTypography.small.copyWith(color: colors.textMuted)),
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
                    onPressed: () {},
                  ),
                ),
                const HGap(AppSpacing.md),
                Expanded(
                  child: SecondaryButton(
                    title: 'Google',
                    leading: Image.network('https://www.google.com/favicon.ico', width: 20, height: 20),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const VGap(AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account? ', style: AppTypography.body.copyWith(color: colors.textSecondary)),
                TextButton(
                  onPressed: () => context.go('/auth/signup'),
                  child: Text('Sign Up', style: AppTypography.body.copyWith(color: colors.accent, fontWeight: FontWeight.w600)),
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
      _showAuthError('Please accept the terms and conditions');
      return;
    }
    setState(() => _loading = true);
    final email = _emailController.text.trim();
    _showAuthInfo('Sign up started for $email');
    final result = await ref.read(authNotifierProvider.notifier).signUp(
          email,
          _passwordController.text,
        );
    if (!mounted) return;
    setState(() => _loading = false);

    result.when(
      success: (needsVerification) {
        if (needsVerification) {
          _showAuthInfo('Sign up needs email confirmation → OTP screen');
          context.go('/auth/verify-otp?email=${Uri.encodeComponent(email)}&purpose=signup');
        } else {
          _showAuthInfo('Sign up complete (session ready) → onboarding');
          context.go('/onboarding/welcome');
        }
      },
      error: _showAuthError,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);

    return AuthScreen(
      title: 'Create Account',
      subtitle: 'Start your fitness journey today',
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
              validator: (value) {
                if (value == null || value.isEmpty) return 'Email is required';
                if (!value.contains('@')) return 'Enter a valid email';
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
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: colors.textMuted,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Password is required';
                if (value.length < 6) return 'Password must be at least 6 characters';
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
              onFieldSubmitted: (_) => _handleSignup(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                  color: colors.textMuted,
                ),
                onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please confirm password';
                if (value != _passwordController.text) return 'Passwords do not match';
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                const HGap(AppSpacing.xs),
                Expanded(
                  child: Text(
                    'I agree to the Terms of Service and Privacy Policy',
                    style: AppTypography.small.copyWith(color: colors.textSecondary),
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
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Text('or continue with', style: AppTypography.small.copyWith(color: colors.textMuted)),
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
                    onPressed: () {},
                  ),
                ),
                const HGap(AppSpacing.md),
                Expanded(
                  child: SecondaryButton(
                    title: 'Google',
                    leading: Image.network('https://www.google.com/favicon.ico', width: 20, height: 20),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const VGap(AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account? ', style: AppTypography.body.copyWith(color: colors.textSecondary)),
                TextButton(
                  onPressed: () => context.go('/auth/login'),
                  child: Text('Sign In', style: AppTypography.body.copyWith(color: colors.accent, fontWeight: FontWeight.w600)),
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
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final email = _emailController.text.trim();
    final result = await ref.read(authNotifierProvider.notifier).sendPasswordResetOtp(email);
    if (!mounted) return;
    setState(() => _loading = false);

    result.when(
      success: (_) {
        _showAuthInfo('Password reset email requested for $email');
        setState(() => _sent = true);
      },
      error: _showAuthError,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);

    if (_sent) {
      return AuthScreen(
        title: 'Check Your Email',
        subtitle: 'We\'ve sent a password reset link to ${_emailController.text}',
        child: Column(
          children: [
            const VGap(AppSpacing.xl),
            Icon(Icons.mark_email_read_outlined, size: 64, color: colors.accent),
            const VGap(AppSpacing.lg),
            Text(
              'Check your inbox (and spam folder) for a password reset link.',
              style: AppTypography.body.copyWith(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const VGap(AppSpacing.xl),
            PrimaryButton(
              title: 'Back to Sign In',
              onPressed: () => context.go('/auth/login'),
            ),
          ],
        ),
      );
    }

    return AuthScreen(
      title: 'Forgot Password?',
      subtitle: 'Enter your email and we\'ll send you a reset link',
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
              onFieldSubmitted: (_) => _handleSubmit(),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Email is required';
                if (!value.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const VGap(AppSpacing.lg),
            PrimaryButton(
              title: 'Send Reset Link',
              loading: _loading,
              onPressed: _handleSubmit,
            ),
            const VGap(AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Remember your password? ', style: AppTypography.body.copyWith(color: colors.textSecondary)),
                TextButton(
                  onPressed: () => context.go('/auth/login'),
                  child: Text('Sign In', style: AppTypography.body.copyWith(color: colors.accent, fontWeight: FontWeight.w600)),
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
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
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
        _showAuthInfo('Password reset complete → login');
        context.go('/auth/login');
      },
      error: _showAuthError,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);

    return AuthScreen(
      title: 'Set New Password',
      subtitle: 'Your new password must be different from previous ones',
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
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: colors.textMuted,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Password is required';
                if (value.length < 6) return 'Password must be at least 6 characters';
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
              onFieldSubmitted: (_) => _handleReset(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                  color: colors.textMuted,
                ),
                onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please confirm password';
                if (value != _passwordController.text) return 'Passwords do not match';
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
    if (code.length != 6) return;
    if (widget.email.isEmpty) {
      _showAuthError('Missing email. Please sign up again.');
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
          _showAuthInfo('Recovery OTP verified → reset password');
          context.go('/auth/reset-password');
        } else {
          _showAuthInfo('Signup OTP verified → onboarding');
          context.go('/onboarding/welcome');
        }
      },
      error: _showAuthError,
    );
  }

  Future<void> _handleResend() async {
    if (widget.email.isEmpty || _resendCooldown > 0) return;
    setState(() => _loading = true);
    _showAuthInfo('Resend email requested for ${widget.email}');
    final result = widget.purpose == 'recovery'
        ? await ref.read(authNotifierProvider.notifier).sendPasswordResetOtp(widget.email)
        : await ref.read(authNotifierProvider.notifier).resendSignupOtp(widget.email);
    if (!mounted) return;
    setState(() => _loading = false);

    result.when(
      success: (_) {
        _startResendCooldown(30);
        _showAuthInfo('Email sent. Check inbox and spam.');
      },
      error: (message) {
        if (message.toLowerCase().contains('rate limit')) {
          _startResendCooldown(60);
        }
        _showAuthError(message);
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

    return AuthScreen(
      title: 'Confirm Your Email',
      subtitle: widget.email.isEmpty
          ? 'Open the confirmation link we emailed you, or enter the 6-digit code if your email includes one.'
          : 'We sent a confirmation link to ${widget.email}. Tap Confirm in that email to finish, or enter a 6-digit code if provided.',
      child: Column(
        children: [
          const VGap(AppSpacing.lg),
          Text(
            'After you tap “Confirm email address” in your inbox, this app will open automatically.',
            textAlign: TextAlign.center,
            style: AppTypography.secondary.copyWith(color: colors.textSecondary),
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
                  style: AppTypography.statNumber.copyWith(color: colors.textPrimary),
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
              _resendCooldown > 0 ? 'Resend Email (${_resendCooldown}s)' : 'Resend Email',
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