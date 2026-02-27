import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service for managing environment variables and configuration
/// Loads sensitive data from .env file to keep it out of source code
class EnvConfig {
  static final EnvConfig _instance = EnvConfig._internal();
  factory EnvConfig() => _instance;
  EnvConfig._internal();

  /// Initialize environment configuration
  /// Must be called before app starts
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
  }

  // Firebase Configuration
  static String get firebaseAndroidApiKey => 
      dotenv.env['FIREBASE_ANDROID_API_KEY'] ?? '';
  
  static String get firebaseIosApiKey => 
      dotenv.env['FIREBASE_IOS_API_KEY'] ?? '';

  // Amplitude Analytics
  static String get amplitudeApiKey => 
      dotenv.env['AMPLITUDE_API_KEY'] ?? '';

  // Sentry Error Tracking
  static String get sentryDsn => 
      dotenv.env['SENTRY_DSN'] ?? '';

  // Qonversion Subscriptions
  static String get qonversionProjectKey => 
      dotenv.env['QONVERSION_PROJECT_KEY'] ?? '';

  /// Validate that all required environment variables are set
  static bool validateConfig() {
    final missingKeys = <String>[];
    
    if (firebaseAndroidApiKey.isEmpty) missingKeys.add('FIREBASE_ANDROID_API_KEY');
    if (firebaseIosApiKey.isEmpty) missingKeys.add('FIREBASE_IOS_API_KEY');
    if (amplitudeApiKey.isEmpty) missingKeys.add('AMPLITUDE_API_KEY');
    if (sentryDsn.isEmpty) missingKeys.add('SENTRY_DSN');
    if (qonversionProjectKey.isEmpty) missingKeys.add('QONVERSION_PROJECT_KEY');
    
    if (missingKeys.isNotEmpty) {
      throw Exception(
        'Missing required environment variables: ${missingKeys.join(', ')}\n'
        'Please check your .env file and ensure all keys are set.'
      );
    }
    
    return true;
  }
}
