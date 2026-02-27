class AppSecrets {
  AppSecrets._();

  static const String amplitudeApiKey = String.fromEnvironment(
    'AMPLITUDE_API_KEY',
    defaultValue: '',
  );

  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: '',
  );

  static const String qonversionProjectKey = String.fromEnvironment(
    'QONVERSION_PROJECT_KEY',
    defaultValue: '',
  );
}
