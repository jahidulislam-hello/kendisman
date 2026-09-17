import 'package:fitzella/features/auth/widgets/buttons.dart';
import 'package:fitzella/features/auth/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitzella/core/theme/app_theme.dart';
import 'package:fitzella/core/theme/theme_provider.dart';


/// Themed text field
class AppTextField extends ConsumerStatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final TextCapitalization textCapitalization;
  final AutovalidateMode autovalidateMode;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  @override
  ConsumerState<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends ConsumerState<AppTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: AppTypography.body.copyWith(
            color: colors.textPrimary,
            fontWeight: AppWeight.medium,
          )),
          const VGap(AppSpacing.xs),
        ],
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          onTap: widget.onTap,
          inputFormatters: widget.inputFormatters,
          validator: widget.validator,
          textCapitalization: widget.textCapitalization,
          autovalidateMode: widget.autovalidateMode,
          style: AppTypography.body.copyWith(color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: widget.hint,
            helperText: widget.helperText,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: colors.textMuted,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                  )
                : widget.suffixIcon,
            counterText: '',
          ),
        ),
      ],
    );
  }
}

/// Themed search field
class SearchField extends ConsumerWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final String hint;
  final bool autoFocus;

  const SearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.onClear,
    this.hint = 'Search...',
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final ctrl = controller ?? TextEditingController();

    return TextField(
      controller: ctrl,
      autofocus: autoFocus,
      onChanged: onChanged,
      style: AppTypography.body.copyWith(color: colors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.body.copyWith(color: colors.textMuted),
        prefixIcon: Icon(Icons.search, color: colors.textMuted, size: 20),
        suffixIcon: ctrl.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: colors.textMuted, size: 20),
                onPressed: () {
                  ctrl.clear();
                  onClear?.call();
                  onChanged?.call('');
                },
              )
            : null,
        filled: true,
        fillColor: colors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: BorderSide(color: colors.accent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

/// Number input with increment/decrement buttons
class NumberInput extends ConsumerStatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final double step;
  final String? label;
  final String? unit;
  final String? suffix;
  final int decimals;

  const NumberInput({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0,
    this.max = double.infinity,
    this.step = 1,
    this.label,
    this.unit,
    this.suffix,
    this.decimals = 0,
  });

  @override
  ConsumerState<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends ConsumerState<NumberInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _formatValue(widget.value));
  }

  @override
  void didUpdateWidget(covariant NumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = _formatValue(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatValue(double value) {
    return widget.decimals > 0
        ? value.toStringAsFixed(widget.decimals)
        : value.round().toString();
  }

  void _increment() {
    final newValue = (widget.value + widget.step).clamp(widget.min, widget.max);
    widget.onChanged?.call(newValue);
  }

  void _decrement() {
    final newValue = (widget.value - widget.step).clamp(widget.min, widget.max);
    widget.onChanged?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: AppTypography.body.copyWith(
            color: colors.textPrimary,
            fontWeight: AppWeight.medium,
          )),
          const VGap(AppSpacing.xs),
        ],
        Row(
          children: [
            CircularIconButton(
              icon: Icons.remove,
              size: 44,
              iconSize: 20,
              onPressed: widget.value > widget.min ? _decrement : null,
              iconColor: widget.value > widget.min ? colors.textPrimary : colors.disabled,
            ),
            const HGap(AppSpacing.md),
            Expanded(
              child: TextField(
                controller: _controller,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: widget.decimals > 0,
                  signed: widget.min < 0,
                ),
                style: AppTypography.body.copyWith(
                  color: colors.textPrimary,
                  fontWeight: AppWeight.semibold,
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  hintText: widget.suffix ?? widget.unit,
                  hintStyle: AppTypography.body.copyWith(color: colors.textMuted),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                onSubmitted: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) {
                    widget.onChanged?.call(parsed.clamp(widget.min, widget.max));
                  }
                },
              ),
            ),
            const HGap(AppSpacing.md),
            CircularIconButton(
              icon: Icons.add,
              size: 44,
              iconSize: 20,
              onPressed: widget.value < widget.max ? _increment : null,
              iconColor: widget.value < widget.max ? colors.textPrimary : colors.disabled,
            ),
          ],
        ),
      ],
    );
  }
}

/// Segmented control
class SegmentedControl<T> extends ConsumerWidget {
  final T value;
  final ValueChanged<T>? onChanged;
  final List<SegmentOption<T>> options;
  final EdgeInsetsGeometry? padding;

  const SegmentedControl({
    super.key,
    required this.value,
    this.onChanged,
    required this.options,
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    return Container(
      padding: padding ?? const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final isSelected = option.value == value;
          return GestureDetector(
            onTap: () => onChanged?.call(option.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isSelected ? colors.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (option.icon != null) ...[
                    Icon(
                      option.icon,
                      size: 16,
                      color: isSelected ? colors.onAccent : colors.textSecondary,
                    ),
                    const HGap(AppSpacing.xs),
                  ],
                  Text(
                    option.label,
                    style: AppTypography.launcherText.copyWith(
                      color: isSelected ? colors.onAccent : colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SegmentOption<T> {
  final T value;
  final String label;
  final IconData? icon;

  const SegmentOption({required this.value, required this.label, this.icon});
}