import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// Typography System based strictly on Figma Tokens with Cairo Font
class AppTheme {
  static ThemeData get lightTheme {
    final baseTextTheme =
        ThemeData.light().textTheme.apply(fontFamily: 'Cairo');

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.deerBlood500,
      colorScheme: const ColorScheme.light(
        primary: AppColors.deerBlood500,
        secondary: AppColors.deerBlood700,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      fontFamily: 'Cairo',
      fontFamilyFallback: const [
        'Noto Color Emoji',
        'Segoe UI Emoji',
        'Apple Color Emoji'
      ],
      dividerTheme:
          const DividerThemeData(color: Color(0xFFEEE8E8), thickness: 1),
      textTheme: baseTextTheme.copyWith(
        // Display — 32px Bold
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          height: 1.25,
        ),
        // H1 — 28px SemiBold
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.3,
        ),
        // H2 — 24px SemiBold
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.3,
        ),
        // H3 — 20px SemiBold
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.35,
        ),
        // Section — 18px SemiBold
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          height: 1.4,
        ),
        // Body Large — 16px Regular
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        // Body Regular — 14px Regular
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        // Body Small — 12px Regular
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textMuted,
          height: 1.4,
        ),
        // Label Large (Buttons)
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
    );
  }

  // Custom Specific Typo Styles
  static TextStyle priceLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.deerBlood500,
    letterSpacing: -0.3,
  );

  static TextStyle badgeText = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.deerBlood500,
  );
}
