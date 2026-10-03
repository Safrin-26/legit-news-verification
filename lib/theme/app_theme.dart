import 'package:flutter/material.dart';

/// Pastel color palette for shadcn-like UI
class AppColors {
  // Primary pastel colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E5E5);
  static const Color borderHover = Color(0xFFD4D4D4);
  
  // Text colors
  static const Color textPrimary = Color(0xFF171717);
  static const Color textSecondary = Color(0xFF737373);
  static const Color textMuted = Color(0xFFA3A3A3);
  
  // Pastel accent colors
  static const Color pastelGreen = Color(0xFFD1FAE5);
  static const Color pastelGreenDark = Color(0xFF10B981);
  static const Color pastelRed = Color(0xFFFEE2E2);
  static const Color pastelRedDark = Color(0xFFEF4444);
  static const Color pastelBlue = Color(0xFFDBEAFE);
  static const Color pastelBlueDark = Color(0xFF3B82F6);
  static const Color pastelYellow = Color(0xFFFEF3C7);
  static const Color pastelYellowDark = Color(0xFFF59E0B);
  static const Color pastelPurple = Color(0xFFEDE9FE);
  static const Color pastelPurpleDark = Color(0xFF8B5CF6);
  
  // Status colors
  static const Color genuine = pastelGreen;
  static const Color genuineText = Color(0xFF065F46);
  static const Color fake = pastelRed;
  static const Color fakeText = Color(0xFF991B1B);
  static const Color uncertain = pastelYellow;
  static const Color uncertainText = Color(0xFF92400E);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        surface: AppColors.surface,
        primary: AppColors.textPrimary,
        secondary: AppColors.textSecondary,
        outline: AppColors.border,
      ),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.textPrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.pastelRedDark),
        ),
        hintStyle: const TextStyle(color: AppColors.textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.textPrimary,
          foregroundColor: AppColors.surface,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
