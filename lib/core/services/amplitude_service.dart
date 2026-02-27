import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/configuration.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:amplitude_flutter/events/identify.dart';
import 'package:amplitude_flutter/events/revenue.dart';
import 'package:flutter/foundation.dart';
import '../config/app_secrets.dart';

/// Service class for managing Amplitude Analytics
/// Tracks user events, properties, and behavioral data
class AmplitudeService {
  static final AmplitudeService _instance = AmplitudeService._internal();
  factory AmplitudeService() => _instance;
  AmplitudeService._internal();

  Amplitude? _amplitude;
  /// Initialize Amplitude
  Future<void> initialize() async {
    try {
      if (AppSecrets.amplitudeApiKey.isEmpty) {
        debugPrint('Amplitude key missing. Set AMPLITUDE_API_KEY.');
        return;
      }

      // Create Amplitude instance with configuration
      _amplitude = Amplitude(
        Configuration(
          apiKey: AppSecrets.amplitudeApiKey,
          flushQueueSize: 30,
          flushIntervalMillis: 30000,
        ),
      );

      debugPrint('✅ Amplitude initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Amplitude initialization error: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Log event
  Future<void> logEvent(String eventName, {Map<String, dynamic>? properties}) async {
    try {
      _amplitude?.track(BaseEvent(eventName, eventProperties: properties));
      debugPrint('📊 Amplitude event logged: $eventName');
    } catch (e) {
      debugPrint('Error logging Amplitude event: $e');
    }
  }

  /// Set user ID
  Future<void> setUserId(String? userId) async {
    try {
      _amplitude?.setUserId(userId);
      debugPrint('👤 Amplitude user ID set: $userId');
    } catch (e) {
      debugPrint('Error setting Amplitude user ID: $e');
    }
  }

  /// Set user properties
  Future<void> setUserProperties(Map<String, dynamic> properties) async {
    try {
      final identify = Identify();
      properties.forEach((key, value) {
        identify.set(key, value);
      });
      _amplitude?.identify(identify);
      debugPrint('🏷️ Amplitude user properties set');
    } catch (e) {
      debugPrint('Error setting Amplitude user properties: $e');
    }
  }

  /// Log revenue
  Future<void> logRevenue(String productId, int quantity, double price) async {
    try {
      final revenue = Revenue()
        ..productId = productId
        ..quantity = quantity
        ..price = price;
      _amplitude?.revenue(revenue);
      debugPrint('💰 Amplitude revenue logged: $productId - \$$price');
    } catch (e) {
      debugPrint('Error logging Amplitude revenue: $e');
    }
  }

  /// Identify user
  Future<void> identify(Map<String, dynamic> userProperties) async {
    try {
      // Add first_used timestamp
      final properties = {
        'first_used': DateTime.now().toIso8601String(),
        ...userProperties,
      };

      final identify = Identify();
      properties.forEach((key, value) {
        identify.setOnce(key, value);
      });
      _amplitude?.identify(identify);
      debugPrint('🆔 Amplitude user identified');
    } catch (e) {
      debugPrint('Error identifying Amplitude user: $e');
    }
  }

  /// Log app opened
  Future<void> logAppOpened() async {
    await logEvent('app_opened');
  }

  /// Log screen view
  Future<void> logScreenView(String screenName) async {
    await logEvent('screen_view', properties: {'screen_name': screenName});
  }

  /// Log subscription events
  Future<void> logSubscriptionStarted(String productId, double price) async {
    await logEvent('subscription_started', properties: {
      'product_id': productId,
      'price': price,
      'currency': 'USD',
    });
  }

  Future<void> logSubscriptionCancelled(String productId) async {
    await logEvent('subscription_cancelled', properties: {
      'product_id': productId,
    });
  }

  Future<void> logTrialStarted(String productId) async {
    await logEvent('trial_started', properties: {
      'product_id': productId,
    });
  }

  /// Log category selection
  Future<void> logCategorySelected(String categoryId, bool isPremium) async {
    await logEvent('category_selected', properties: {
      'category_id': categoryId,
      'is_premium': isPremium,
    });
  }

  /// Log question viewed
  Future<void> logQuestionViewed(String categoryId, int questionIndex) async {
    await logEvent('question_viewed', properties: {
      'category_id': categoryId,
      'question_index': questionIndex,
    });
  }

  /// Log paywall viewed
  Future<void> logPaywallViewed(String source) async {
    await logEvent('paywall_viewed', properties: {
      'source': source,
    });
  }

  /// Log settings action
  Future<void> logSettingsAction(String action) async {
    await logEvent('settings_action', properties: {
      'action': action,
    });
  }

  /// Log language changed
  Future<void> logLanguageChanged(String oldLanguage, String newLanguage) async {
    await logEvent('language_changed', properties: {
      'old_language': oldLanguage,
      'new_language': newLanguage,
    });
  }

  /// Log share action
  Future<void> logShareAction(String contentType) async {
    await logEvent('share_action', properties: {
      'content_type': contentType,
    });
  }

  /// Log review requested
  Future<void> logReviewRequested(String source) async {
    await logEvent('review_requested', properties: {
      'source': source,
    });
  }
}
