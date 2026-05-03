class AppSecrets {
  AppSecrets._();

  static const String amplitudeApiKey = String.fromEnvironment(
    'AMPLITUDE_API_KEY',
    defaultValue: '3ab27ae7cdd809a01ed47aa66b86b64',
  );

  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: 'https://5909324f6ca05e7f7aa1ea6e153985a8@o4510181406867456.ingest.de.sentry.io/4510790965592144',
  );

  static const String qonversionProjectKey = String.fromEnvironment(
    'QONVERSION_PROJECT_KEY',
    defaultValue: 'snoMes6puPWAIqD73d05Ki1V4D8HUKVk',
  );

  static const String appsflyerDevKey = String.fromEnvironment(
    'APPSFLYER_DEV_KEY',
    defaultValue: 'pZL9Winh8GuPMpEVjxdkZH',
  );

  static const String appsflyerAppId = String.fromEnvironment(
    'APPSFLYER_APP_ID',
    defaultValue: '6758348414',
  );
}
