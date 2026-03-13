import 'package:flutter/widgets.dart';

class AppLinks {
  AppLinks._();

  static const String androidPackageId = 'com.hidavo.neverever';
  static const String appStoreUrl = 'https://apps.apple.com/app/id6758348414';
  static const String iosAppStoreId = '6758348414';
  static const String privacyPolicyUrl =
      'https://sites.google.com/view/neverhaveieveradult/privacy';
  static const String termsOfUseUrl =
      'https://sites.google.com/view/neverhaveieveradult/terms';

  static String privacyPolicyUrlForLocale(Locale locale) {
    final code = locale.countryCode == null
        ? locale.languageCode
        : '${locale.languageCode}_${locale.countryCode}';
    return '$privacyPolicyUrl?hl=$code';
  }

  static String get androidStoreUrl =>
      'https://play.google.com/store/apps/details?id=$androidPackageId';

  static String get iosStoreUrl =>
      appStoreUrl;
}
