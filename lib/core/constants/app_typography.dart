import 'package:flutter/foundation.dart';

class AppTypography {
  AppTypography._();

  /// Let each platform pick its native default typeface so scripts like Korean,
  /// Japanese, Arabic, and Cyrillic render with the system font stack.
  static String? get primaryFamily {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.android:
      default:
        return null;
    }
  }

  static List<String>? get fallbackFamilies => null;
}
