import 'package:flutter/foundation.dart';

class AppTypography {
  AppTypography._();

  static String get primaryFamily {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return '.SF Pro Text';
      case TargetPlatform.android:
        return 'Noto Sans';
      default:
        return 'Noto Sans';
    }
  }

  static List<String> get fallbackFamilies => const <String>[
        'Noto Sans',
        'Noto Sans CJK KR',
        'Noto Sans CJK JP',
        'Noto Sans Arabic',
        'Noto Sans Thai',
        'Noto Sans Hebrew',
        'sans-serif',
      ];
}
