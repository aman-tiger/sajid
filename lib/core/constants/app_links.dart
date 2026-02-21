class AppLinks {
  AppLinks._();

  static const String androidPackageId = 'com.hidavo.neverever';
  static const String appStoreUrl = 'https://apps.apple.com/app/id6758348414';
  static const String iosAppStoreId = '6758348414';

  static String get androidStoreUrl =>
      'https://play.google.com/store/apps/details?id=$androidPackageId';

  static String get iosStoreUrl =>
      appStoreUrl;
}
