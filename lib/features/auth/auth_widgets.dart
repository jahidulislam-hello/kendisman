import 'package:fitzella/core/theme/app_theme.dart';
import 'package:flutter/material.dart';


/// Rounded, filled text field with a small uppercase label above it,
/// matching the EMAIL / PASSWORD / FULL NAME inputs in the designs.
class LabeledAuthField extends StatelessWidget {
  const LabeledAuthField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.input + 2),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label.isNotEmpty)
            Text(
              label.toUpperCase(),
              style: AppTypography.small.copyWith(
                color: colors.textMuted,
                fontWeight: AppWeight.semibold,
                letterSpacing: 0.6,
              ),
            ),
          if (label.isNotEmpty) const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              if (prefixIcon != null) ...[
                Icon(prefixIcon, size: 18, color: colors.textMuted),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  style: AppTypography.body.copyWith(
                    color: colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: AppTypography.body.copyWith(
                      color: colors.textMuted,
                    ),
                  ),
                ),
              ),
              if (suffixIcon != null)
                GestureDetector(
                  onTap: onSuffixTap,
                  child: Icon(suffixIcon, size: 18, color: colors.textMuted),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Full-width blue CTA button with a trailing arrow.
class PrimaryAuthButton extends StatelessWidget {
  const PrimaryAuthButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.dark;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.accent,
          foregroundColor: colors.onAccent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.input + 2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppTypography.resumeText.copyWith(
                color: colors.onAccent,
                fontWeight: AppWeight.bold,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(Icons.arrow_forward, size: 18, color: colors.onAccent),
          ],
        ),
      ),
    );
  }
}

/// "Continue with Google" outlined button.
class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.dark;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: colors.surface,
          side: BorderSide(color: colors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.input + 2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _GoogleG(size: 18),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Continue with Google',
              style: AppTypography.body.copyWith(
                color: colors.textPrimary,
                fontWeight: AppWeight.semibold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Minimal 4-color "G" mark drawn without external assets.
/// Swap for `Image.asset('assets/icons/google.png')` if you have the
/// official asset.
class _GoogleG extends StatelessWidget {
  const _GoogleG({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final center = Offset(r, r);
    final rect = Rect.fromCircle(center: center, radius: r);

    final colorsSweep = [
      const Color(0xFF4285F4),
      const Color(0xFF34A853),
      const Color(0xFFFBBC05),
      const Color(0xFFEA4335),
      const Color(0xFF4285F4),
    ];
    final sweep = SweepGradient(colors: colorsSweep);
    final paint = Paint()..shader = sweep.createShader(rect);
    canvas.drawCircle(center, r, paint);

    final holePaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, r * 0.42, holePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// "or" divider used between the Google button and the email fields.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.dark;
    return Row(
      children: [
        Expanded(child: Divider(color: colors.border, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'or',
            style: AppTypography.secondary.copyWith(color: colors.textMuted),
          ),
        ),
        Expanded(child: Divider(color: colors.border, height: 1)),
      ],
    );
  }
}

/// Centered header used on Sign In / Sign Up: app icon + wordmark.
class AuthLogoHeader extends StatelessWidget {
  const AuthLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.dark;
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colors.textPrimary,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.fitness_center, size: 22, color: colors.background),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'fitzella',
          style: TextStyle(
            fontSize: 20,
            fontWeight: AppWeight.extraBold,
            color: colors.textPrimary,
            letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }
}

/// Back-chevron circle + centered title, used on the password-recovery
/// screens (Enter Email / Verification Code / Reset Password).
class AuthStepHeader extends StatelessWidget implements PreferredSizeWidget {
  const AuthStepHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.dark;
    return AppBar(
      backgroundColor: colors.background,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.lg),
        child: Material(
          color: colors.surface,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.of(context).maybePop(),
            child: SizedBox(
              width: 36,
              height: 36,
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: colors.textPrimary,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        title,
        style: AppTypography.cardTitle.copyWith(
          color: colors.textPrimary,
          fontWeight: AppWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Card container used to hold the form content on the recovery screens.
class AuthCard extends StatelessWidget {
  const AuthCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border),
      ),
      child: Column(children: children),
    );
  }
}
