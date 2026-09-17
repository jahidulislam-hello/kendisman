import 'package:fitzella/core/theme/app_theme.dart';
import 'package:fitzella/features/auth/auth_widgets.dart';
import 'package:flutter/material.dart';


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _newObscured = true;
  bool _confirmObscured = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.dark;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const AuthStepHeader(title: 'Reset Password'),
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
                    'Reset Password',
                    textAlign: TextAlign.center,
                    style: AppTypography.sheetTitle.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  LabeledAuthField(
                    label: '',
                    hint: 'Enter New Password',
                    controller: _newPasswordController,
                    obscureText: _newObscured,
                    prefixIcon: Icons.key_outlined,
                    suffixIcon: _newObscured
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    onSuffixTap: () {
                      setState(() => _newObscured = !_newObscured);
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  LabeledAuthField(
                    label: '',
                    hint: 'Confirm New Password',
                    controller: _confirmPasswordController,
                    obscureText: _confirmObscured,
                    prefixIcon: Icons.key_outlined,
                    suffixIcon: _confirmObscured
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    onSuffixTap: () {
                      setState(() => _confirmObscured = !_confirmObscured);
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryAuthButton(
                label: 'Reset Password',
                onPressed: () {
                  // TODO: submit the new password, then return to Sign In.
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/sign-in',
                    (route) => false,
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
