import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Muscle icon (flexed bicep / muscle)
class MuscleIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const MuscleIcon({
    super.key,
    this.size = 20,
    this.color,
  });

  static const String _svgData = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M12.4 13.4a2.5 2.5 0 0 1-3.4-3.4"/>
  <path d="M13.5 7.5c-.7-.5-1.5-.8-2.3-.9C7.8 6.3 5 8.8 5 12c0 2.2 1.2 4.1 3 5.1"/>
  <path d="M17.5 10.5c.3-.5.5-1 .5-1.6a3 3 0 0 0-3-3c-.6 0-1.1.2-1.6.5"/>
  <path d="m15.5 13.5 1.5 1.5c1.4 1.4 3.5 1.4 4.9 0l.1-.1c1.4-1.4 1.4-3.5 0-4.9l-1.5-1.5"/>
  <path d="M18.5 6.5 20 5"/>
  <path d="M5.5 15.5 4 17"/>
  <path d="m7.5 19.5-1 1"/>
</svg>
''';

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? Theme.of(context).colorScheme.primary;
    return SvgPicture.string(
      _svgData,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
    );
  }
}

/// Renders a dedicated muscle group icon, featuring [MuscleIcon] for muscles/arms/all
class MuscleGroupIcon extends StatelessWidget {
  final String muscle;
  final double size;
  final Color? color;

  const MuscleGroupIcon({
    super.key,
    required this.muscle,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? Theme.of(context).colorScheme.primary;
    final m = muscle.trim().toLowerCase();

    if (m == 'all' ||
        m == 'arms' ||
        m == 'biceps' ||
        m == 'triceps' ||
        m == 'forearms' ||
        m == 'muscle' ||
        m.isEmpty) {
      return MuscleIcon(size: size, color: iconColor);
    }
    if (m == 'chest') {
      return Icon(Icons.accessibility_new, size: size, color: iconColor);
    }
    if (m == 'back' || m == 'lats' || m == 'traps') {
      return Icon(Icons.shield_outlined, size: size, color: iconColor);
    }
    if (m == 'shoulders' || m == 'delts') {
      return Icon(Icons.sports_gymnastics, size: size, color: iconColor);
    }
    if (m == 'legs' ||
        m == 'quads' ||
        m == 'hamstrings' ||
        m == 'calves' ||
        m == 'glutes') {
      return Icon(Icons.directions_walk, size: size, color: iconColor);
    }
    if (m == 'core' || m == 'waist' || m == 'abs') {
      return Icon(Icons.self_improvement, size: size, color: iconColor);
    }
    if (m == 'cardio') {
      return Icon(Icons.directions_run, size: size, color: iconColor);
    }

    return MuscleIcon(size: size, color: iconColor);
  }
}
