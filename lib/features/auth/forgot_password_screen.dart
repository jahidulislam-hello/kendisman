import 'package:fitzella/core/theme/app_theme.dart';
import 'package:fitzella/features/auth/auth_widgets.dart';
import 'package:flutter/material.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.dark;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const AuthStepHeader(title: 'Enter Email'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthCard(
                children: [
                  Text(
                    'Forgot Password',
                    textAlign: TextAlign.center,
                    style: AppTypography.sheetTitle.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Welcome Back! Please enter your details.',
                    textAlign: TextAlign.center,
                    style: AppTypography.secondary.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  LabeledAuthField(
                    label: '',
                    hint: 'Input your email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.mail_outline,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryAuthButton(
                label: 'Verify',
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/otp-verification',
                    arguments: _emailController.text.trim().isEmpty
                        ? 'aljamil248@gmail.com'
                        : _emailController.text.trim(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
