import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme() {
    final textTheme = ThemeData.light().textTheme.apply(
          fontFamily: AppTypography.primaryFamily,
        );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textLight,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textLight,
        tertiary: AppColors.accent,
        onTertiary: AppColors.textLight,
        error: AppColors.error,
        onError: AppColors.textLight,
        surface: AppColors.surface,
        onSurface: AppColors.textDark,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.surface,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: AppDimensions.appBarElevation,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textDark,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontFamily: AppTypography.primaryFamily,
          fontFamilyFallback: AppTypography.fallbackFamilies,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),

      // Text Theme
      textTheme: textTheme.copyWith(
        bodyLarge: textTheme.bodyLarge?.copyWith(
          fontFamilyFallback: AppTypography.fallbackFamilies,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          fontFamilyFallback: AppTypography.fallbackFamilies,
        ),
        bodySmall: textTheme.bodySmall?.copyWith(
          fontFamilyFallback: AppTypography.fallbackFamilies,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.buttonPaddingHorizontal,
            vertical: AppDimensions.paddingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
          ),
          minimumSize: const Size(
            double.infinity,
            AppDimensions.buttonHeightLarge,
          ),
          textStyle: TextStyle(
            fontFamily: AppTypography.primaryFamily,
            fontFamilyFallback: AppTypography.fallbackFamilies,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 2),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.buttonPaddingHorizontal,
            vertical: AppDimensions.paddingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
          ),
          minimumSize: const Size(
            double.infinity,
            AppDimensions.buttonHeightLarge,
          ),
          textStyle: TextStyle(
            fontFamily: AppTypography.primaryFamily,
            fontFamilyFallback: AppTypography.fallbackFamilies,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: TextStyle(
            fontFamily: AppTypography.primaryFamily,
            fontFamilyFallback: AppTypography.fallbackFamilies,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: AppDimensions.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        ),
        color: AppColors.surfaceLight,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
          vertical: AppDimensions.paddingMd,
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        thickness: AppDimensions.dividerThickness,
        color: AppColors.textGreyLight,
        space: AppDimensions.spaceMd,
      ),
    );
  }

  static ThemeData darkTheme() {
    final textTheme = ThemeData.dark().textTheme.apply(
          fontFamily: AppTypography.primaryFamily,
        );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        onPrimary: AppColors.textDark,
        secondary: AppColors.secondaryLight,
        onSecondary: AppColors.textDark,
        tertiary: AppColors.accentLight,
        onTertiary: AppColors.textDark,
        error: AppColors.error,
        onError: AppColors.textLight,
        surface: AppColors.backgroundDark,
        onSurface: AppColors.textLight,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.background,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: AppDimensions.appBarElevation,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textLight,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          fontFamily: AppTypography.primaryFamily,
          fontFamilyFallback: AppTypography.fallbackFamilies,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textLight,
        ),
      ),

      // Text Theme
      textTheme: textTheme.copyWith(
        bodyLarge: textTheme.bodyLarge?.copyWith(
          fontFamilyFallback: AppTypography.fallbackFamilies,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          fontFamilyFallback: AppTypography.fallbackFamilies,
        ),
        bodySmall: textTheme.bodySmall?.copyWith(
          fontFamilyFallback: AppTypography.fallbackFamilies,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.textDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.buttonPaddingHorizontal,
            vertical: AppDimensions.paddingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
          ),
          minimumSize: const Size(
            double.infinity,
            AppDimensions.buttonHeightLarge,
          ),
          textStyle: TextStyle(
            fontFamily: AppTypography.primaryFamily,
            fontFamilyFallback: AppTypography.fallbackFamilies,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: AppDimensions.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        ),
        color: AppColors.backgroundDark,
      ),
    );
  }
}
