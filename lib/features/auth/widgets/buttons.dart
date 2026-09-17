import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitzella/core/theme/app_theme.dart';
import 'package:fitzella/core/theme/theme_provider.dart';

/// Gradient button matching the React Native GradientButton component
class GradientButton extends ConsumerWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool loading;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double height;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final TextStyle? textStyle;

  const GradientButton({
    super.key,
    required this.title,
    this.onPressed,
    this.loading = false,
    this.leading,
    this.trailing,
    this.padding,
    this.width,
    this.height = 52,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final bgColor = backgroundColor ?? colors.accent;
    final fgColor = foregroundColor ?? colors.onAccent;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: 0,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.pill),
          ),
          disabledBackgroundColor: bgColor.withValues(alpha: 0.6),
          disabledForegroundColor: fgColor.withValues(alpha: 0.6),
        ),
        child: loading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leading != null) ...[leading!, const SizedBox(width: 8)],
                  Text(
                    title,
                    style: textStyle ?? AppTypography.startButton.copyWith(color: fgColor),
                  ),
                  if (trailing != null) ...[const SizedBox(width: 8), trailing!],
                ],
              ),
      ),
    );
  }
}

/// Primary button variant
class PrimaryButton extends GradientButton {
  const PrimaryButton({
    super.key,
    required super.title,
    super.onPressed,
    super.loading,
    super.leading,
    super.trailing,
    super.width,
  });
}

/// Secondary button variant
class SecondaryButton extends ConsumerWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool loading;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const SecondaryButton({
    super.key,
    required this.title,
    this.onPressed,
    this.loading = false,
    this.leading,
    this.trailing,
    this.padding,
    this.width,
    this.height = 52,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.accent,
          side: BorderSide(color: colors.accent, width: 1.5),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.pill),
          ),
          disabledForegroundColor: colors.accent.withValues(alpha: 0.4),
        ),
        child: loading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leading != null) ...[leading!, const SizedBox(width: 8)],
                  Text(title, style: AppTypography.launcherText),
                  if (trailing != null) ...[const SizedBox(width: 8), trailing!],
                ],
              ),
      ),
    );
  }
}

/// Ghost button variant
class GhostButton extends ConsumerWidget {
  final String title;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const GhostButton({
    super.key,
    required this.title,
    this.onPressed,
    this.leading,
    this.trailing,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final btnColor = color ?? colors.accent;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: btnColor,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: AppTypography.body.copyWith(fontWeight: AppWeight.semibold),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 8)],
          Text(title),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }
}

/// Icon button with themed colors
class ThemedIconButton extends ConsumerWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final String? tooltip;

  const ThemedIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 24,
    this.color,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final iconColor = color ?? colors.textPrimary;
    final bgColor = backgroundColor ?? colors.surface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.pill),
        child: Container(
          padding: padding ?? const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: colors.border, width: 0.5),
          ),
          child: Icon(icon, size: size, color: iconColor),
        ),
      ),
    );
  }
}

/// Circular icon button
class CircularIconButton extends ConsumerWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  final Color? iconColor;
  final Color? backgroundColor;
  final String? tooltip;

  const CircularIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 40,
    this.iconSize = 20,
    this.iconColor,
    this.backgroundColor,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final bgColor = backgroundColor ?? colors.surface;
    final fgColor = iconColor ?? colors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(size / 2),
            border: Border.all(color: colors.border, width: 0.5),
          ),
          child: Icon(icon, size: iconSize, color: fgColor),
        ),
      ),
    );
  }
}