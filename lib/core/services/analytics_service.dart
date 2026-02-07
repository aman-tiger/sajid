import 'firebase_service.dart';
import 'amplitude_service.dart';

/// Unified analytics service that wraps Firebase Analytics and Amplitude
/// Provides a single interface for tracking events across multiple platforms
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final _firebase = FirebaseService();
  final _amplitude = AmplitudeService();

  /// Log event to both Firebase and Amplitude
  Future<void> logEvent(String eventName, {Map<String, dynamic>? parameters}) async {
    await Future.wait([
      _firebase.logEvent(eventName, parameters: parameters),
      _amplitude.logEvent(eventName, properties: parameters),
    ]);
  }

  /// Log screen view
  Future<void> logScreenView(String screenName) async {
    await Future.wait([
      _firebase.logScreenView(screenName),
      _amplitude.logScreenView(screenName),
    ]);
  }

  /// Set user ID
  Future<void> setUserId(String? userId) async {
    await Future.wait([
      _firebase.setUserId(userId),
      _amplitude.setUserId(userId),
    ]);
  }

  /// Set user property (Firebase only, Amplitude uses different method)
  Future<void> setUserProperty(String name, String? value) async {
    await _firebase.setUserProperty(name, value);
  }

  /// Set user properties (Amplitude only)
  Future<void> setUserProperties(Map<String, dynamic> properties) async {
    await _amplitude.setUserProperties(properties);
  }

  // Common app events

  Future<void> logAppOpened() async {
    await _amplitude.logAppOpened();
  }

  Future<void> logOnboardingCompleted() async {
    await logEvent('onboarding_completed');
  }

  Future<void> logCategorySelected(String categoryId, bool isPremium) async {
    await logEvent('category_selected', parameters: {
      'category_id': categoryId,
      'is_premium': isPremium,
    });
    await _amplitude.logCategorySelected(categoryId, isPremium);
  }

  Future<void> logQuestionViewed(String categoryId, int questionIndex) async {
    await logEvent('question_viewed', parameters: {
      'category_id': categoryId,
      'question_index': questionIndex,
    });
    await _amplitude.logQuestionViewed(categoryId, questionIndex);
  }

  // Monetization events

  Future<void> logPaywallViewed(String source) async {
    await logEvent('paywall_viewed', parameters: {'source': source});
    await _amplitude.logPaywallViewed(source);
  }

  Future<void> logSubscriptionStarted(String productId, double price) async {
    await logEvent('subscription_started', parameters: {
      'product_id': productId,
      'price': price,
      'currency': 'USD',
    });
    await _amplitude.logSubscriptionStarted(productId, price);
  }

  Future<void> logSubscriptionCancelled(String productId) async {
    await logEvent('subscription_cancelled', parameters: {
      'product_id': productId,
    });
    await _amplitude.logSubscriptionCancelled(productId);
  }

  Future<void> logTrialStarted(String productId) async {
    await logEvent('trial_started', parameters: {
      'product_id': productId,
    });
    await _amplitude.logTrialStarted(productId);
  }

  Future<void> logPurchaseRestored() async {
    await logEvent('purchase_restored');
  }

  // User engagement events

  Future<void> logLanguageChanged(String oldLanguage, String newLanguage) async {
    await logEvent('language_changed', parameters: {
      'old_language': oldLanguage,
      'new_language': newLanguage,
    });
    await _amplitude.logLanguageChanged(oldLanguage, newLanguage);
  }

  Future<void> logShareAction(String contentType) async {
    await logEvent('share_action', parameters: {
      'content_type': contentType,
    });
    await _amplitude.logShareAction(contentType);
  }

  Future<void> logReviewRequested(String source) async {
    await logEvent('review_requested', parameters: {
      'source': source,
    });
    await _amplitude.logReviewRequested(source);
  }

  Future<void> logSettingsOpened() async {
    await logEvent('settings_opened');
  }

  Future<void> logHowToPlayViewed() async {
    await logEvent('how_to_play_viewed');
  }

  // Game flow events

  Future<void> logGameStarted(String categoryId) async {
    await logEvent('game_started', parameters: {
      'category_id': categoryId,
    });
  }

  Future<void> logGameEnded(String categoryId, int questionsViewed) async {
    await logEvent('game_ended', parameters: {
      'category_id': categoryId,
      'questions_viewed': questionsViewed,
    });
  }

  Future<void> logQuestionShuffled(String categoryId) async {
    await logEvent('questions_shuffled', parameters: {
      'category_id': categoryId,
    });
  }

  Future<void> logQuestionShared(String categoryId, int questionIndex) async {
    await logEvent('question_shared', parameters: {
      'category_id': categoryId,
      'question_index': questionIndex,
    });
  }
}
