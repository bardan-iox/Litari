import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF1A1F2E);
  static const Color surface = Color(0xFF252B3B);
  static const Color surfaceVariant = Color(0xFF2C3347);
  static const Color inputBorder = Color(0xFF3D4560);
  static const Color primary = Color(0xFFB5673D);
  static const Color primaryDark = Color(0xFF8B4F2E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B8CC);
  static const Color textHint = Color(0xFF6B7494);
  static const Color accentBlue = Color(0xFF4A9EFF);
  static const Color facebookBlue = Color(0xFF1877F2);
  static const Color divider = Color(0xFF3D4560);
}

class AppTextStyles {
  static const TextStyle appName = TextStyle(
    color: AppColors.primary,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: 4,
  );

  static const TextStyle body = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
  );

  static const TextStyle bodySecondary = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
  );

  static const TextStyle link = TextStyle(
    color: AppColors.accentBlue,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
  );

  static const TextStyle buttonLabel = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle inputText = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}

ThemeData buildAppTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      surface: AppColors.surface,
    ),
  );
}
