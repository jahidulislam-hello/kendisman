import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitzella/core/theme/app_theme.dart';

/// Provider for shared preferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});

/// Theme preference storage key
const String _themePreferenceKey = 'theme_preference';

/// Theme notifier managing the app's theme state
class ThemeNotifier extends StateNotifier<AppThemeData> {
  final SharedPreferences _prefs;

  ThemeNotifier(this._prefs) : super(_loadInitialTheme(_prefs));

  static AppThemeData _loadInitialTheme(SharedPreferences prefs) {
    final preferenceString = prefs.getString(_themePreferenceKey);
    final preference = ThemePreference.values.byName(
      preferenceString ?? ThemePreference.dark.name,
    );

    final scheme = _resolveScheme(preference);
    return AppThemeData.forScheme(scheme, preference: preference);
  }

  static ColorSchemeType _resolveScheme(ThemePreference preference) {
    switch (preference) {
      case ThemePreference.light:
        return ColorSchemeType.light;
      case ThemePreference.dark:
        return ColorSchemeType.dark;
      case ThemePreference.system:
        final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
        return brightness == Brightness.light ? ColorSchemeType.light : ColorSchemeType.dark;
    }
  }

  /// Update theme preference and persist
  Future<void> setPreference(ThemePreference preference) async {
    await _prefs.setString(_themePreferenceKey, preference.name);

    final scheme = _resolveScheme(preference);
    state = AppThemeData.forScheme(scheme, preference: preference);
  }

  /// Toggle between light and dark (skips system)
  Future<void> toggleTheme() async {
    final newPreference =
        state.scheme == ColorSchemeType.light ? ThemePreference.dark : ThemePreference.light;
    await setPreference(newPreference);
  }

  ThemePreference get currentPreference => state.preference;
}

/// Provider for theme notifier
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppThemeData>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(prefs);
});

/// Provider for current theme data (for easy access in widgets)
final appThemeProvider = Provider<AppThemeData>((ref) {
  return ref.watch(themeNotifierProvider);
});

/// Provider for current color scheme type
final colorSchemeProvider = Provider<ColorSchemeType>((ref) {
  return ref.watch(appThemeProvider).scheme;
});

/// Provider for current colors
final appColorsProvider = Provider<AppColors>((ref) {
  return ref.watch(appThemeProvider).colors;
});
