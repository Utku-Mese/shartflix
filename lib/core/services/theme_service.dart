import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../constants/app_theme.dart';
import 'logger_service.dart';

enum AppThemeMode { light, dark, system }

@lazySingleton
class ThemeService {
  final SharedPreferences _prefs;
  final LoggerService _logger;

  ThemeService(this._prefs, this._logger);

  Future<AppThemeMode> getCurrentThemeMode() async {
    try {
      final themeIndex = _prefs.getInt(AppConstants.themeKey);
      if (themeIndex != null && themeIndex < AppThemeMode.values.length) {
        final themeMode = AppThemeMode.values[themeIndex];
        _logger.debug('Current theme mode: $themeMode');
        return themeMode;
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to get current theme mode', e, stackTrace);
    }

    return AppThemeMode.dark; // Default dark theme
  }

  Future<void> setThemeMode(AppThemeMode themeMode) async {
    try {
      await _prefs.setInt(AppConstants.themeKey, themeMode.index);
      _logger.debug('Theme mode set to: $themeMode');
    } catch (e, stackTrace) {
      _logger.error('Failed to set theme mode', e, stackTrace);
    }
  }

  ThemeData getThemeData(AppThemeMode themeMode, Brightness systemBrightness) {
    switch (themeMode) {
      case AppThemeMode.light:
        return AppTheme.lightTheme;
      case AppThemeMode.dark:
        return AppTheme.darkTheme;
      case AppThemeMode.system:
        return systemBrightness == Brightness.dark
            ? AppTheme.darkTheme
            : AppTheme.lightTheme;
    }
  }

  Future<void> toggleTheme() async {
    final currentMode = await getCurrentThemeMode();
    final newMode = currentMode == AppThemeMode.dark
        ? AppThemeMode.light
        : AppThemeMode.dark;
    await setThemeMode(newMode);
  }

  String getThemeName(AppThemeMode themeMode) {
    switch (themeMode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }

  IconData getThemeIcon(AppThemeMode themeMode) {
    switch (themeMode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
