import 'package:flutter/material.dart';
import 'package:fitzella/core/theme/app_theme.dart';

const Color kOnboardingProgress = Color(0xFFF5A623);
const Color kOnboardingBlue = Color(0xFF3B82F6);
const Color kOnboardingGreen = Color(0xFF34C759);

class OnboardingProgressBar extends StatelessWidget {
  final int step; // 1-10
  final AppColors colors;

  const OnboardingProgressBar({super.key, required this.step, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: List.generate(10, (i) {
              final active = i < step;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: i == 9 ? 0 : 3),
                  decoration: BoxDecoration(
                    color: active ? kOnboardingProgress : colors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$step/10',
          style: TextStyle(color: colors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class OnboardingBackButton extends StatelessWidget {
  final AppColors colors;
  final VoidCallback? onPressed;

  const OnboardingBackButton({super.key, required this.colors, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.maybePop(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: colors.border),
        ),
        child: Icon(Icons.chevron_left, color: colors.textPrimary, size: 26),
      ),
    );
  }
}

class OnboardingStepHeader extends StatelessWidget {
  final AppColors colors;
  final IconData? icon;
  final int step;
  final String title;
  final String? subtitle;

  const OnboardingStepHeader({
    super.key,
    required this.colors,
    this.icon,
    required this.step,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: colors.textPrimary, fontSize: 28, fontWeight: FontWeight.w800, height: 1.15),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: TextStyle(color: colors.textSecondary, fontSize: 15, height: 1.4),
          ),
        ],
      ],
    );
  }
}

class OnboardingPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? background;
  final Color? foreground;

  const OnboardingPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.background,
    this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    final bg = background ?? kOnboardingBlue;
    final fg = foreground ?? Colors.white;
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor: bg.withValues(alpha: 0.4),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(label, style: TextStyle(color: fg, fontSize: 16, fontWeight: FontWeight.w800)),
      ),
    );
  }
}

class OnboardingOptionCard extends StatelessWidget {
  final AppColors colors;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const OnboardingOptionCard({
    super.key,
    required this.colors,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? kOnboardingBlue : colors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(color: colors.textSecondary, fontSize: 13, height: 1.3)),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? kOnboardingBlue : Colors.transparent,
                  border: Border.all(
                    color: selected ? kOnboardingBlue : colors.border,
                    width: 1.5,
                  ),
                ),
                child: selected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingUnitToggle extends StatelessWidget {
  final AppColors colors;
  final String left;
  final String right;
  final bool leftSelected;
  final ValueChanged<bool> onChanged;

  const OnboardingUnitToggle({
    super.key,
    required this.colors,
    required this.left,
    required this.right,
    required this.leftSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Expanded(child: _seg(left, leftSelected, () => onChanged(true))),
          Expanded(child: _seg(right, !leftSelected, () => onChanged(false))),
        ],
      ),
    );
  }

  Widget _seg(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? kOnboardingBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : colors.textSecondary,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class OnboardingStepScaffold extends StatelessWidget {
  final AppColors colors;
  final int step;
  final Widget body;
  final String continueLabel;
  final VoidCallback? onContinue;
  final VoidCallback? onBack;
  final Color? continueColor;

  const OnboardingStepScaffold({
    super.key,
    required this.colors,
    required this.step,
    required this.body,
    this.continueLabel = 'Continue',
    this.onContinue,
    this.onBack,
    this.continueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 20, 0),
              child: Row(
                children: [
                  OnboardingBackButton(colors: colors, onPressed: onBack),
                  const SizedBox(width: 12),
                  Expanded(child: OnboardingProgressBar(step: step, colors: colors)),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: body,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: OnboardingPrimaryButton(
                label: continueLabel,
                onPressed: onContinue,
                background: continueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingWheelPicker extends StatefulWidget {
  final AppColors colors;
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final double width;
  final double itemExtent;

  const OnboardingWheelPicker({
    super.key,
    required this.colors,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.width = 90,
    this.itemExtent = 44,
  });

  @override
  State<OnboardingWheelPicker> createState() => _OnboardingWheelPickerState();
}

class _OnboardingWheelPickerState extends State<OnboardingWheelPicker> {
  late FixedExtentScrollController _controller;
  bool _ignoreSelection = false;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: widget.selectedIndex);
  }

  @override
  void didUpdateWidget(covariant OnboardingWheelPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex &&
        _controller.hasClients &&
        _controller.selectedItem != widget.selectedIndex) {
      // jumpToItem notifies listeners synchronously; defer to avoid setState-during-build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_controller.hasClients) return;
        if (_controller.selectedItem == widget.selectedIndex) return;
        _ignoreSelection = true;
        _controller.jumpToItem(widget.selectedIndex);
        _ignoreSelection = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSelectedItemChanged(int index) {
    if (_ignoreSelection) return;
    widget.onSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.itemExtent * 3.2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: widget.itemExtent,
            decoration: BoxDecoration(
              color: kOnboardingBlue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kOnboardingBlue.withValues(alpha: 0.25)),
            ),
          ),
          ListWheelScrollView.useDelegate(
            controller: _controller,
            itemExtent: widget.itemExtent,
            perspective: 0.002,
            diameterRatio: 1.4,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: _onSelectedItemChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: widget.items.length,
              builder: (context, index) {
                final selected = index == widget.selectedIndex;
                return Center(
                  child: Text(
                    widget.items[index],
                    style: TextStyle(
                      color: selected ? widget.colors.textPrimary : widget.colors.textMuted,
                      fontSize: selected ? 22 : 18,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
