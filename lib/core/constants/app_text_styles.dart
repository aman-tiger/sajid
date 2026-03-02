import 'package:flutter/material.dart';
import 'app_colors.dart';

/// App text styles using Outfit font
/// Modern, geometric font - different from competitor's chunky display fonts
class AppTextStyles {
  AppTextStyles._();
  static const String _fontFamily = 'Outfit';

  static TextStyle _style({
    required double size,
    required FontWeight weight,
    required Color color,
    required double height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // Heading Styles
  static TextStyle h1({Color? color}) => _style(
        size: 32,
        weight: FontWeight.w800,
        color: color ?? AppColors.textDark,
        height: 1.2,
      );

  static TextStyle h2({Color? color}) => _style(
        size: 28,
        weight: FontWeight.w700,
        color: color ?? AppColors.textDark,
        height: 1.3,
      );

  static TextStyle h3({Color? color}) => _style(
        size: 24,
        weight: FontWeight.w700,
        color: color ?? AppColors.textDark,
        height: 1.3,
      );

  static TextStyle h4({Color? color}) => _style(
        size: 20,
        weight: FontWeight.w600,
        color: color ?? AppColors.textDark,
        height: 1.4,
      );

  static TextStyle h5({Color? color}) => _style(
        size: 18,
        weight: FontWeight.w600,
        color: color ?? AppColors.textDark,
        height: 1.4,
      );

  // Body Styles
  static TextStyle bodyLarge({Color? color}) => _style(
        size: 16,
        weight: FontWeight.w400,
        color: color ?? AppColors.textDark,
        height: 1.5,
      );

  static TextStyle bodyMedium({Color? color}) => _style(
        size: 14,
        weight: FontWeight.w400,
        color: color ?? AppColors.textDark,
        height: 1.5,
      );

  static TextStyle bodySmall({Color? color}) => _style(
        size: 12,
        weight: FontWeight.w400,
        color: color ?? AppColors.textDark,
        height: 1.5,
      );

  // Button Styles
  static TextStyle button({Color? color}) => _style(
        size: 16,
        weight: FontWeight.w600,
        color: color ?? AppColors.textLight,
        height: 1.2,
        letterSpacing: 0.5,
      );

  static TextStyle buttonLarge({Color? color}) => _style(
        size: 18,
        weight: FontWeight.w700,
        color: color ?? AppColors.textLight,
        height: 1.2,
        letterSpacing: 0.5,
      );

  static TextStyle buttonSmall({Color? color}) => _style(
        size: 14,
        weight: FontWeight.w600,
        color: color ?? AppColors.textLight,
        height: 1.2,
        letterSpacing: 0.5,
      );

  // Caption/Label Styles
  static TextStyle caption({Color? color}) => _style(
        size: 12,
        weight: FontWeight.w400,
        color: color ?? AppColors.textGrey,
        height: 1.4,
      );

  static TextStyle label({Color? color}) => _style(
        size: 14,
        weight: FontWeight.w500,
        color: color ?? AppColors.textDark,
        height: 1.4,
      );

  // Special Styles
  static TextStyle cardTitle({Color? color}) => _style(
        size: 20,
        weight: FontWeight.w700,
        color: color ?? AppColors.textDark,
        height: 1.3,
      );

  static TextStyle cardDescription({Color? color}) => _style(
        size: 14,
        weight: FontWeight.w400,
        color: color ?? AppColors.textGrey,
        height: 1.5,
      );

  static TextStyle questionText({Color? color}) => _style(
        size: 22,
        weight: FontWeight.w600,
        color: color ?? AppColors.textDark,
        height: 1.4,
      );
}
