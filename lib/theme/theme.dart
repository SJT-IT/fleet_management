import 'package:flutter/material.dart';

class AppColors {
  // Common
  static const green = Color(0xFF22C55E);

  // Dark Mode
  static const darkBackground = Color(0xFF0B0F14);
  static const darkCard = Color(0xFF111827);
  static const darkInput = Color(0xFF1F2937);
  static const darkText = Color(0xFFF9FAFB);
  static const darkTextSecondary = Colors.white60;

  // Light Mode
  static const lightBackground = Color(0xFFF9FAFB);
  static const lightCard = Colors.white;
  static const lightInput = Color(0xFFF3F4F6);
  static const lightText = Color(0xFF111827);
  static const lightTextSecondary = Color(0xFF6B7280);
}

class AppTheme {
  // DARK THEME
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.green,
    cardColor: AppColors.darkCard,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkInput,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.white.withAlpha(13)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.green),
      ),
      labelStyle: const TextStyle(color: AppColors.darkTextSecondary),
      prefixStyle: const TextStyle(color: AppColors.darkTextSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.green,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.darkText),
      bodyLarge: TextStyle(color: AppColors.darkText),
    ),
  );

  // LIGHT THEME
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.green,
    cardColor: AppColors.lightCard,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightInput,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.green),
      ),
      labelStyle: const TextStyle(color: AppColors.lightTextSecondary),
      prefixStyle: const TextStyle(color: AppColors.lightTextSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.green,
        foregroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.lightText),
      bodyLarge: TextStyle(color: AppColors.lightText),
    ),
  );
}
