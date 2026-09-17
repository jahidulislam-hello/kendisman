import 'package:flutter/material.dart';

/// Color scheme type matching the React Native app
enum ColorSchemeType { light, dark }

/// User's theme preference
enum ThemePreference { system, light, dark }

/// Theme colors matching the React Native spec exactly
@immutable
class AppColors {
  final Color background;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accent;
  final Color onAccent;
  final Color danger;
  final Color success;
  final Color disabled;

  const AppColors({
    required this.background,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accent,
    required this.onAccent,
    required this.danger,
    required this.success,
    required this.disabled,
  });

  /// Dark color palette (matches React Native darkColors exactly)
  static const AppColors dark = AppColors(
    background: Color(0xFF0B0B0F),
    surface: Color(0xFF17171C),
    border: Color(0xFF26262E),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF9B9BA5),
    textMuted: Color(0xFF6B6B75),
    accent: Color(0xFF2563EB),
    onAccent: Color(0xFFFFFFFF),
    danger: Color(0xFFF87171),
    success: Color(0xFF4ADE80),
    disabled: Color(0xFF3A3D44),
  );

  /// Light color palette (matches React Native lightColors exactly)
  static const AppColors light = AppColors(
    background: Color(0xFFF5F5F7),
    surface: Color(0xFFFFFFFF),
    border: Color(0xFFE2E2E8),
    textPrimary: Color(0xFF111114),
    textSecondary: Color(0xFF5C5C66),
    textMuted: Color(0xFF8E8E98),
    accent: Color(0xFF2563EB),
    onAccent: Color(0xFFFFFFFF),
    danger: Color(0xFFDC2626),
    success: Color(0xFF16A34A),
    disabled: Color(0xFFC9C9D1),
  );

  /// Get colors for a specific scheme
  static AppColors get(ColorSchemeType scheme) {
    return scheme == ColorSchemeType.light ? light : dark;
  }

  /// Convert hex string to Color
  static Color hexToColor(String hex) {
    final cleanHex = hex.replaceAll('#', '');
    final value = int.parse(cleanHex, radix: 16);
    return Color(value | 0xFF000000);
  }

  /// Convert Color to hex string for charts
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  /// Get RGB string for chart libraries (e.g., "37, 99, 235")
  static String colorToRgb(Color color) {
    return '${color.red}, ${color.green}, ${color.blue}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppColors &&
          runtimeType == other.runtimeType &&
          background == other.background &&
          surface == other.surface &&
          border == other.border &&
          textPrimary == other.textPrimary &&
          textSecondary == other.textSecondary &&
          textMuted == other.textMuted &&
          accent == other.accent &&
          onAccent == other.onAccent &&
          danger == other.danger &&
          success == other.success &&
          disabled == other.disabled;

  @override
  int get hashCode => Object.hash(
        background,
        surface,
        border,
        textPrimary,
        textSecondary,
        textMuted,
        accent,
        onAccent,
        danger,
        success,
        disabled,
      );
}

/// Border radius constants
class AppRadius {
  static const double card = 16.0;
  static const double pill = 20.0;
  static const double badge = 10.0;
  static const double input = 10.0;
}

/// Spacing constants
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
}

/// Layout constants
class AppLayout {
  static const double screenPadding = AppSpacing.xl;
  static const double cardGap = AppSpacing.md;
  static const double cardPadding = AppSpacing.lg;
}

/// Font weight constants
class AppWeight {
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
}

/// Typography constants matching React Native theme
class AppTypography {
  // Screen title: 28px bold
  static const TextStyle screenTitle = TextStyle(
    fontSize: 28,
    fontWeight: AppWeight.bold,
    letterSpacing: -0.5,
  );

  // Section header: 13px semibold uppercase gray
  static const TextStyle sectionHeader = TextStyle(
    fontSize: 13,
    fontWeight: AppWeight.semibold,
    letterSpacing: 0.4,
    textBaseline: TextBaseline.alphabetic,
  );

  // Card title: 17px semibold
  static const TextStyle cardTitle = TextStyle(
    fontSize: 17,
    fontWeight: AppWeight.semibold,
  );

  // Body text: 15px regular
  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: AppWeight.regular,
    height: 21 / 15,
  );

  // Large stat numbers: 36px bold
  static const TextStyle statNumber = TextStyle(
    fontSize: 36,
    fontWeight: AppWeight.bold,
  );

  // Secondary/caption text: 13px regular
  static const TextStyle secondary = TextStyle(
    fontSize: 13,
    fontWeight: AppWeight.regular,
    height: 18 / 13,
  );

  // Small text: 11px regular
  static const TextStyle small = TextStyle(
    fontSize: 11,
    fontWeight: AppWeight.regular,
  );

  // Up next pill text: 11px bold uppercase
  static const TextStyle upNextPill = TextStyle(
    fontSize: 11,
    fontWeight: AppWeight.extraBold,
    letterSpacing: 0.6,
  );

  // Start button text: 15px semibold uppercase
  static const TextStyle startButton = TextStyle(
    fontSize: 15,
    fontWeight: AppWeight.semibold,
    letterSpacing: 0.4,
  );

  // Routine name: 16px bold
  static const TextStyle routineName = TextStyle(
    fontSize: 16,
    fontWeight: AppWeight.bold,
  );

  // Routine sub: 12px semibold
  static const TextStyle routineSub = TextStyle(
    fontSize: 12,
    fontWeight: AppWeight.semibold,
  );

  // Sheet title: 22px bold
  static const TextStyle sheetTitle = TextStyle(
    fontSize: 22,
    fontWeight: AppWeight.bold,
  );

  // Sheet edit: 14px semibold
  static const TextStyle sheetEdit = TextStyle(
    fontSize: 14,
    fontWeight: AppWeight.semibold,
  );

  // Sheet pill text: 13px bold
  static const TextStyle sheetPill = TextStyle(
    fontSize: 13,
    fontWeight: AppWeight.bold,
  );

  // Sheet row name: 16px semibold
  static const TextStyle sheetRowName = TextStyle(
    fontSize: 16,
    fontWeight: AppWeight.semibold,
  );

  // Sheet row muscle: 13px regular
  static const TextStyle sheetRowMuscle = TextStyle(
    fontSize: 13,
    fontWeight: AppWeight.regular,
  );

  // Greeting: 22px extra bold
  static const TextStyle greeting = TextStyle(
    fontSize: 22,
    fontWeight: AppWeight.extraBold,
  );

  // Date line: 13px semibold
  static const TextStyle dateLine = TextStyle(
    fontSize: 13,
    fontWeight: AppWeight.semibold,
  );

  // Rest title: 26px extra bold
  static const TextStyle restTitle = TextStyle(
    fontSize: 26,
    fontWeight: AppWeight.extraBold,
  );

  // Rest subtitle: 15px regular
  static const TextStyle restSubtitle = TextStyle(
    fontSize: 15,
    fontWeight: AppWeight.regular,
  );

  // Rest choose text: 15px extra bold
  static const TextStyle restChooseText = TextStyle(
    fontSize: 15,
    fontWeight: AppWeight.extraBold,
    letterSpacing: 0.3,
  );

  // Hero title: 28px extra bold
  static const TextStyle heroTitle = TextStyle(
    fontSize: 28,
    fontWeight: AppWeight.extraBold,
  );

  // Hero meta: 15px regular
  static const TextStyle heroMeta = TextStyle(
    fontSize: 15,
    fontWeight: AppWeight.regular,
  );

  // Hero duration: 13px bold
  static const TextStyle heroDuration = TextStyle(
    fontSize: 13,
    fontWeight: AppWeight.bold,
  );

  // Avatar text: 18px extra bold
  static const TextStyle avatarText = TextStyle(
    fontSize: 18,
    fontWeight: AppWeight.extraBold,
  );

  // Launcher plus: 17px extra bold
  static const TextStyle launcherPlus = TextStyle(
    fontSize: 17,
    fontWeight: AppWeight.extraBold,
  );

  // Launcher text: 15px bold
  static const TextStyle launcherText = TextStyle(
    fontSize: 15,
    fontWeight: AppWeight.bold,
  );

  // Plan name: 18px extra bold
  static const TextStyle planName = TextStyle(
    fontSize: 18,
    fontWeight: AppWeight.extraBold,
  );

  // Card name: 16px extra bold
  static const TextStyle cardName = TextStyle(
    fontSize: 16,
    fontWeight: AppWeight.extraBold,
  );

  // Card exercise: 13px regular
  static const TextStyle cardExercise = TextStyle(
    fontSize: 13,
    fontWeight: AppWeight.regular,
  );

  // Card more: 13px semibold
  static const TextStyle cardMore = TextStyle(
    fontSize: 13,
    fontWeight: AppWeight.semibold,
  );

  // Card last: 12px semibold
  static const TextStyle cardLast = TextStyle(
    fontSize: 12,
    fontWeight: AppWeight.semibold,
  );

  // Resume text: 15px bold
  static const TextStyle resumeText = TextStyle(
    fontSize: 15,
    fontWeight: AppWeight.bold,
  );

  // Sheet meta: 13px regular
  static const TextStyle sheetMeta = TextStyle(
    fontSize: 13,
    fontWeight: AppWeight.regular,
  );

  // Empty plan: 14px regular
  static const TextStyle emptyPlan = TextStyle(
    fontSize: 14,
    fontWeight: AppWeight.regular,
    height: 20 / 14,
  );

  // Sheet empty: 14px regular
  static const TextStyle sheetEmpty = TextStyle(
    fontSize: 14,
    fontWeight: AppWeight.regular,
  );

  // New row text: 16px bold
  static const TextStyle newRowText = TextStyle(
    fontSize: 16,
    fontWeight: AppWeight.bold,
  );

  // New icon plus: 24px regular
  static const TextStyle newIconPlus = TextStyle(
    fontSize: 24,
    fontWeight: AppWeight.regular,
    height: 26 / 24,
  );
}

/// Complete theme data combining colors and typography
@immutable
class AppThemeData {
  final AppColors colors;
  final ColorSchemeType scheme;
  final ThemePreference preference;

  const AppThemeData({
    required this.colors,
    required this.scheme,
    this.preference = ThemePreference.system,
  });

  /// Create theme data for a specific scheme
  factory AppThemeData.forScheme(ColorSchemeType scheme, {ThemePreference preference = ThemePreference.system}) {
    return AppThemeData(colors: AppColors.get(scheme), scheme: scheme, preference: preference);
  }

  /// Get text style with color applied
  TextStyle textStyle(TextStyle base) {
    return base.copyWith(color: colors.textPrimary);
  }

  TextStyle textStyleSecondary(TextStyle base) {
    return base.copyWith(color: colors.textSecondary);
  }

  TextStyle textStyleMuted(TextStyle base) {
    return base.copyWith(color: colors.textMuted);
  }

  TextStyle textStyleAccent(TextStyle base) {
    return base.copyWith(color: colors.accent);
  }

  TextStyle textStyleOnAccent(TextStyle base) {
    return base.copyWith(color: colors.onAccent);
  }

  TextStyle textStyleDanger(TextStyle base) {
    return base.copyWith(color: colors.danger);
  }

  TextStyle textStyleSuccess(TextStyle base) {
    return base.copyWith(color: colors.success);
  }

  TextStyle textStyleDisabled(TextStyle base) {
    return base.copyWith(color: colors.disabled);
  }
}
