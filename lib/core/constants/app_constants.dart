class AppConstants {
  // App Info
  static const String appName = 'Shartflix';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxUsernameLength = 50;

  // UI
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 18.0;
  static const double defaultElevation = 4.0;

  // Image
  static const double defaultImageQuality = 0.8;
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
}
