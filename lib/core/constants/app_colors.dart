import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFE50914);
  static const Color primaryDark = Color(0xFF6F060B);

  // Secondary Colors
  static const Color secondary = Color(0x22FFFFFF);
  static const Color secondaryLight = Color(0x44FFFFFF);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Dark Theme Colors (Current default)
  static const Color darkBackground = Color(0xFF090909);
  static const Color darkCardBackground = Color(0xFF1A1A1A);
  static const Color darkSurfaceBackground = Color(0xFF1C1C1C);
  static const Color darkBorderColor = Color(0xFF333333);
  static const Color darkBorderFocused = Color(0xFF555555);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkTextTertiary = Color(0xFF808080);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightCardBackground = Color(0xFFF8F9FA);
  static const Color lightSurfaceBackground = Color(0xFFFAFAFA);
  static const Color lightBorderColor = Color(0xFFE0E0E0);
  static const Color lightBorderFocused = Color(0xFFBDBDBD);
  static const Color lightTextPrimary = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF616161);
  static const Color lightTextTertiary = Color(0xFF9E9E9E);

  // Backward compatibility (default to dark theme)
  static const Color background = darkBackground;
  static const Color cardBackground = darkCardBackground;
  static const Color surfaceBackground = darkSurfaceBackground;
  static const Color borderColor = darkBorderColor;
  static const Color borderFocused = darkBorderFocused;
  static const Color textPrimary = darkTextPrimary;
  static const Color textSecondary = darkTextSecondary;
  static const Color textTertiary = darkTextTertiary;
}
