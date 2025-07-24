import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import 'logger_service.dart';

@lazySingleton
class LocalizationService {
  final SharedPreferences _prefs;
  final LoggerService _logger;

  LocalizationService(this._prefs, this._logger);

  static const List<Locale> supportedLocales = [
    Locale('tr', 'TR'),
    Locale('en', 'US'),
  ];

  static const Locale defaultLocale = Locale('tr', 'TR');

  Future<Locale> getCurrentLocale() async {
    try {
      final languageCode = _prefs.getString(AppConstants.languageKey);
      if (languageCode != null) {
        final locale = Locale(languageCode);
        _logger.debug('Current locale: $locale');
        return locale;
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to get current locale', e, stackTrace);
    }

    return defaultLocale;
  }

  Future<void> setLocale(Locale locale) async {
    try {
      await _prefs.setString(AppConstants.languageKey, locale.languageCode);
      _logger.debug('Locale set to: $locale');
    } catch (e, stackTrace) {
      _logger.error('Failed to set locale', e, stackTrace);
    }
  }

  Future<void> setEnglish() async {
    await setLocale(const Locale('en', 'US'));
  }

  Future<void> setTurkish() async {
    await setLocale(const Locale('tr', 'TR'));
  }

  bool isSupported(Locale locale) {
    return supportedLocales.any((supportedLocale) =>
        supportedLocale.languageCode == locale.languageCode);
  }

  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'tr':
        return 'Türkçe';
      default:
        return 'Unknown';
    }
  }

  String getLanguageNativeName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'tr':
        return 'Türkçe';
      default:
        return 'Unknown';
    }
  }
}
