import 'package:fitzella/core/theme/app_theme.dart';
import 'package:fitzella/features/auth/auth_widgets.dart';
import 'package:flutter/material.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.dark;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            AppSpacing.xxl,
            AppSpacing.xxl,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AuthLogoHeader(),
              const SizedBox(height: 36),
              Text(
                'Create account.',
                style: AppTypography.screenTitle.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Create an account or log in to explore about our app',
                textAlign: TextAlign.center,
                style: AppTypography.secondary.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              GoogleSignInButton(onPressed: () {}),
              const SizedBox(height: AppSpacing.lg),
              const OrDivider(),
              const SizedBox(height: AppSpacing.lg),
              LabeledAuthField(
                label: 'Full Name',
                hint: 'Al Jamil',
                controller: _nameController,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: AppSpacing.md),
              LabeledAuthField(
                label: 'Email',
                hint: 'alex@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.md),
              LabeledAuthField(
                label: 'Password',
                hint: '••••••••••••',
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryAuthButton(
                label: 'Sign Up',
                onPressed: () {
                  // TODO: wire up real sign-up logic.
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTypography.secondary.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/sign-in');
                    },
                    child: Text(
                      'Sign In',
                      style: AppTypography.secondary.copyWith(
                        color: colors.accent,
                        fontWeight: AppWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
