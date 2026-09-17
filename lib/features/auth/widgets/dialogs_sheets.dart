import 'package:fitzella/features/auth/widgets/buttons.dart';
import 'package:fitzella/features/auth/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitzella/core/theme/app_theme.dart';
import 'package:fitzella/core/theme/theme_provider.dart';



/// Bottom sheet with grabber
class AppBottomSheet extends ConsumerWidget {
  final Widget child;
  final String? title;
  final Widget? leading;
  final Widget? trailing;
  final double? maxHeight;
  final bool isDismissible;
  final VoidCallback? onClose;
  final EdgeInsetsGeometry? padding;

  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.leading,
    this.trailing,
    this.maxHeight,
    this.isDismissible = true,
    this.onClose,
    this.padding,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    Widget? leading,
    Widget? trailing,
    double? maxHeight,
    bool isDismissible = true,
    VoidCallback? onClose,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppBottomSheet(
        child: child,
        title: title,
        leading: leading,
        trailing: trailing,
        maxHeight: maxHeight,
        isDismissible: isDismissible,
        onClose: onClose,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final mediaQuery = MediaQuery.of(context);
    final maxH = maxHeight ?? mediaQuery.size.height * 0.85;

    return Container(
      constraints: BoxConstraints(maxHeight: maxH),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: colors.border, width: 0.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grabber
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.md),
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Header
          if (title != null || leading != null || trailing != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  if (leading != null) ...[leading!, const HGap(AppSpacing.md)],
                  Expanded(
                    child: Text(
                      title ?? '',
                      style: AppTypography.sheetTitle.copyWith(color: colors.textPrimary),
                      textAlign: leading != null ? TextAlign.left : TextAlign.center,
                    ),
                  ),
                  if (trailing != null) trailing!,
                  if (leading == null && trailing == null && onClose != null)
                    IconButton(
                      icon: Icon(Icons.close, color: colors.textSecondary, size: 22),
                      onPressed: onClose ?? () => Navigator.pop(context),
                    ),
                ],
              ),
            ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: child,
            ),
          ),

          // Bottom padding for safe area
          SizedBox(height: mediaQuery.padding.bottom + AppSpacing.xxl),
        ],
      ),
    );
  }
}

/// Confirmation dialog
Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  bool isDestructive = false,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => _ConfirmDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      isDestructive: isDestructive,
    ),
  );
}

class _ConfirmDialog extends ConsumerWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;

  const _ConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.isDestructive,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final confirmColor = isDestructive ? colors.danger : colors.accent;

    return AlertDialog(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
      title: Text(title, style: AppTypography.cardTitle.copyWith(color: colors.textPrimary)),
      content: Text(message, style: AppTypography.body.copyWith(color: colors.textPrimary)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelText, style: AppTypography.body.copyWith(
            color: colors.textSecondary,
            fontWeight: AppWeight.semibold,
          )),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor,
            foregroundColor: colors.onAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
          ),
          child: Text(confirmText, style: AppTypography.startButton.copyWith(color: colors.onAccent)),
        ),
      ],
    );
  }
}

/// Action sheet (list of options)
Future<T?> showActionSheet<T>({
  required BuildContext context,
  required String title,
  required List<ActionSheetOption<T>> options,
  T? cancelOption,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _ActionSheet<T>(
      title: title,
      options: options,
      cancelOption: cancelOption,
    ),
  );
}

class ActionSheetOption<T> {
  final T value;
  final String label;
  final IconData? icon;
  final bool isDestructive;

  const ActionSheetOption({
    required this.value,
    required this.label,
    this.icon,
    this.isDestructive = false,
  });
}

class _ActionSheet<T> extends ConsumerWidget {
  final String title;
  final List<ActionSheetOption<T>> options;
  final T? cancelOption;

  const _ActionSheet({
    required this.title,
    required this.options,
    this.cancelOption,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final mediaQuery = MediaQuery.of(context);

    return Container(
      constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.7),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: colors.border, width: 0.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grabber
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.md),
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.md,
            ),
            child: Text(title, style: AppTypography.sheetTitle.copyWith(color: colors.textPrimary)),
          ),

          // Options
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              itemCount: options.length,
              separatorBuilder: (_, __) => const VGap(AppSpacing.xs),
              itemBuilder: (context, index) {
                final option = options[index];
                final textColor = option.isDestructive ? colors.danger : colors.textPrimary;

                return ListTile(
                  leading: option.icon != null
                      ? Icon(option.icon, color: textColor, size: 22)
                      : null,
                  title: Text(option.label, style: AppTypography.body.copyWith(
                    color: textColor,
                    fontWeight: AppWeight.medium,
                  )),
                  onTap: () => Navigator.pop(context, option.value),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
                  tileColor: colors.background,
                );
              },
            ),
          ),

          // Cancel option
          if (cancelOption != null) ...[
            const AppDivider(margin: EdgeInsets.symmetric(vertical: AppSpacing.md)),
            ListTile(
              title: Text('Cancel', style: AppTypography.body.copyWith(
                color: colors.textPrimary,
                fontWeight: AppWeight.bold,
              )),
              onTap: () => Navigator.pop(context, cancelOption),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
              tileColor: colors.background,
            ),
          ],

          SizedBox(height: mediaQuery.padding.bottom + AppSpacing.xxl),
        ],
      ),
    );
  }
}

/// Loading overlay
class LoadingOverlay extends ConsumerWidget {
  final bool visible;
  final Widget child;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.visible,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    return Stack(
      children: [
        child,
        if (visible)
          Container(
            color: colors.background.withValues(alpha: 0.8),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: colors.accent),
                  if (message != null) ...[
                    const VGap(AppSpacing.lg),
                    Text(message!, style: AppTypography.body.copyWith(color: colors.textSecondary)),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Empty state widget
class EmptyState extends ConsumerWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(icon, size: 40, color: colors.accent),
            ),
            const VGap(AppSpacing.lg),
            Text(title, style: AppTypography.cardTitle.copyWith(color: colors.textPrimary), textAlign: TextAlign.center),
            if (subtitle != null) ...[
              const VGap(AppSpacing.sm),
              Text(subtitle!, style: AppTypography.secondary.copyWith(color: colors.textSecondary), textAlign: TextAlign.center),
            ],
            if (action != null) ...[
              const VGap(AppSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Error state widget
class ErrorState extends ConsumerWidget {
  final String message;
  final VoidCallback? onRetry;
  final String retryText;

  const ErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.retryText = 'Try Again',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.danger.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(Icons.error_outline, size: 40, color: colors.danger),
            ),
            const VGap(AppSpacing.lg),
            Text('Something went wrong', style: AppTypography.cardTitle.copyWith(color: colors.textPrimary), textAlign: TextAlign.center),
            const VGap(AppSpacing.sm),
            Text(message, style: AppTypography.secondary.copyWith(color: colors.textSecondary), textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const VGap(AppSpacing.lg),
              PrimaryButton(title: retryText, onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}