import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../services/theme_service.dart';
import '../services/localization_service.dart';
import '../services/secure_storage_service.dart';
import '../services/logger_service.dart';
import 'app_settings_event.dart';
import 'app_settings_state.dart';

@singleton
class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  final ThemeService _themeService;
  final LocalizationService _localizationService;
  final SecureStorageService _secureStorage;
  final LoggerService _logger;

  AppSettingsBloc(
    this._themeService,
    this._localizationService,
    this._secureStorage,
    this._logger,
  ) : super(AppSettingsInitial()) {
    on<LoadAppSettings>(_onLoadAppSettings);
    on<ChangeTheme>(_onChangeTheme);
    on<ChangeLanguage>(_onChangeLanguage);
  }

  Future<void> _onLoadAppSettings(
    LoadAppSettings event,
    Emitter<AppSettingsState> emit,
  ) async {
    try {
      emit(AppSettingsLoading());

      final themeMode = await _themeService.getCurrentThemeMode();
      final locale = await _localizationService.getCurrentLocale();

      emit(AppSettingsLoaded(
        themeMode: themeMode,
        locale: locale,
      ));

      _logger.debug('App settings loaded: theme=$themeMode, locale=$locale');
    } catch (e, stackTrace) {
      _logger.error('Failed to load app settings', e, stackTrace);
      // Emit default settings on error
      emit(const AppSettingsLoaded(
        themeMode: AppThemeMode.dark,
        locale: Locale('tr', 'TR'),
      ));
    }
  }

  Future<void> _onChangeTheme(
    ChangeTheme event,
    Emitter<AppSettingsState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is AppSettingsLoaded) {
        final newThemeMode =
            event.isDark ? AppThemeMode.dark : AppThemeMode.light;

        // Save to storage
        await _secureStorage.write('theme', event.isDark ? 'dark' : 'light');
        await _themeService.setThemeMode(newThemeMode);

        // Emit updated state
        emit(currentState.copyWith(themeMode: newThemeMode));

        _logger.debug('Theme changed to: $newThemeMode');
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to change theme', e, stackTrace);
    }
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<AppSettingsState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is AppSettingsLoaded) {
        final newLocale = Locale(event.languageCode);

        // Save to storage
        await _secureStorage.write('language', event.languageCode);
        await _localizationService.setLocale(newLocale);

        // Emit updated state
        emit(currentState.copyWith(locale: newLocale));

        _logger.debug('Language changed to: $newLocale');
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to change language', e, stackTrace);
    }
  }
}
