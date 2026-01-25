import 'package:flutter/material.dart';

/// App color palette - "Night Party" theme
/// Designed to be 70%+ different from competitor's bright yellow/pink/green scheme
class AppColors {
  AppColors._();

  // Primary Colors - Deep Purple (Main brand color)
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFF8B5CF6);
  static const Color primaryDark = Color(0xFF6D28D9);

  // Secondary Colors - Coral (Warm, inviting - for CTAs)
  static const Color secondary = Color(0xFFFF6B6B);
  static const Color secondaryLight = Color(0xFFFF8787);
  static const Color secondaryDark = Color(0xFFFF5252);

  // Accent Colors - Teal (Fresh, energetic)
  static const Color accent = Color(0xFF14B8A6);
  static const Color accentLight = Color(0xFF2DD4BF);
  static const Color accentDark = Color(0xFF0D9488);

  // Background Colors
  static const Color backgroundDark = Color(0xFF1E1B4B); // Deep navy
  static const Color background = Color(0xFF0F172A); // Darker navy
  static const Color backgroundLight = Color(0xFF1E293B);

  // Surface Colors - For cards and elevated surfaces
  static const Color surface = Color(0xFFFFF7ED); // Cream
  static const Color surfaceLight = Color(0xFFFFFBEB); // Light cream
  static const Color surfaceDark = Color(0xFFFED7AA);

  // Text Colors
  static const Color textDark = Color(0xFF0F172A);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF64748B);
  static const Color textGreyLight = Color(0xFF94A3B8);

  // Functional Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Category-specific colors (for the 6 packs)
  static const Color categoryClassic = Color(0xFFFF6B6B); // Coral
  static const Color categoryParty = Color(0xFFF59E0B); // Amber
  static const Color categoryGirls = Color(0xFFEC4899); // Pink
  static const Color categoryCouples = Color(0xFF8B5CF6); // Purple
  static const Color categoryHot = Color(0xFFEF4444); // Red
  static const Color categoryGuys = Color(0xFF3B82F6); // Blue

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Lock/Unlock indicators
  static const Color locked = Color(0xFF64748B);
  static const Color unlocked = Color(0xFF10B981);
}
