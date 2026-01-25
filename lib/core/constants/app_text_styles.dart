import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// App text styles using Outfit font
/// Modern, geometric font - different from competitor's chunky display fonts
class AppTextStyles {
  AppTextStyles._();

  // Heading Styles
  static TextStyle h1({Color? color}) => GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w800, // Extra bold
        color: color ?? AppColors.textDark,
        height: 1.2,
      );

  static TextStyle h2({Color? color}) => GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w700, // Bold
        color: color ?? AppColors.textDark,
        height: 1.3,
      );

  static TextStyle h3({Color? color}) => GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textDark,
        height: 1.3,
      );

  static TextStyle h4({Color? color}) => GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600, // Semi-bold
        color: color ?? AppColors.textDark,
        height: 1.4,
      );

  static TextStyle h5({Color? color}) => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textDark,
        height: 1.4,
      );

  // Body Styles
  static TextStyle bodyLarge({Color? color}) => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w400, // Regular
        color: color ?? AppColors.textDark,
        height: 1.5,
      );

  static TextStyle bodyMedium({Color? color}) => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textDark,
        height: 1.5,
      );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textDark,
        height: 1.5,
      );

  // Button Styles
  static TextStyle button({Color? color}) => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textLight,
        height: 1.2,
        letterSpacing: 0.5,
      );

  static TextStyle buttonLarge({Color? color}) => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textLight,
        height: 1.2,
        letterSpacing: 0.5,
      );

  static TextStyle buttonSmall({Color? color}) => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textLight,
        height: 1.2,
        letterSpacing: 0.5,
      );

  // Caption/Label Styles
  static TextStyle caption({Color? color}) => GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textGrey,
        height: 1.4,
      );

  static TextStyle label({Color? color}) => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w500, // Medium
        color: color ?? AppColors.textDark,
        height: 1.4,
      );

  // Special Styles
  static TextStyle cardTitle({Color? color}) => GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textDark,
        height: 1.3,
      );

  static TextStyle cardDescription({Color? color}) => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textGrey,
        height: 1.5,
      );

  static TextStyle questionText({Color? color}) => GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textDark,
        height: 1.4,
      );
}
