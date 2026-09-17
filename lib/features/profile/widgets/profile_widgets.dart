import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitzella/core/theme/app_theme.dart';
import 'package:fitzella/core/theme/theme_provider.dart';

class ProfileBackHeader extends ConsumerWidget {
  final String title;
  final Widget? trailing;
  final bool centeredTitle;

  const ProfileBackHeader({
    super.key,
    required this.title,
    this.trailing,
    this.centeredTitle = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    if (centeredTitle) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Icon(Icons.chevron_left, color: colors.textPrimary, size: 28),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
            trailing ?? const SizedBox(width: 48),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextButton.icon(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: Icon(Icons.chevron_left, color: colors.textPrimary, size: 26),
                label: Text('Back', style: TextStyle(color: colors.textPrimary, fontSize: 16)),
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4)),
              ),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(title, style: AppTypography.screenTitle.copyWith(color: colors.textPrimary)),
          ),
        ],
      ),
    );
  }
}

class ProfileSectionLabel extends ConsumerWidget {
  final String text;
  const ProfileSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: colors.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class ProfileGroupCard extends ConsumerWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  const ProfileGroupCard({
    super.key,
    required this.children,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border, width: 0.5),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              Divider(height: 1, thickness: 0.5, color: colors.border, indent: 56),
          ],
        ],
      ),
    );
  }
}

class ProfileSettingsTile extends ConsumerWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? value;
  final bool external;
  final Color? iconColor;
  final Color? iconBg;
  final Color? titleColor;
  final VoidCallback? onTap;
  final Widget? trailing;

  const ProfileSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.external = false,
    this.iconColor,
    this.iconBg,
    this.titleColor,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final accent = iconColor ?? colors.accent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg ?? accent.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor ?? colors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                  ],
                ],
              ),
            ),
            if (value != null)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(value!, style: TextStyle(color: colors.textSecondary, fontSize: 14)),
              ),
            trailing ??
                Icon(
                  external ? Icons.north_east : Icons.chevron_right,
                  color: colors.textMuted,
                  size: external ? 16 : 22,
                ),
          ],
        ),
      ),
    );
  }
}

class ProfileScaffold extends ConsumerWidget {
  final String title;
  final Widget body;
  final Widget? trailing;
  final bool centeredTitle;
  final bool resizeToAvoidBottomInset;

  const ProfileScaffold({
    super.key,
    required this.title,
    required this.body,
    this.trailing,
    this.centeredTitle = false,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return Scaffold(
      backgroundColor: colors.background,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileBackHeader(title: title, trailing: trailing, centeredTitle: centeredTitle),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

void profilePush(BuildContext context, String path) => context.push(path);
