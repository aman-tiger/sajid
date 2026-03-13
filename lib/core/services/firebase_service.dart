import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'analytics_service.dart';

/// Service class for managing Firebase integrations
/// Handles Analytics, Crashlytics, and Cloud Messaging
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  late final FirebaseAnalytics _analytics;
  late final FirebaseCrashlytics _crashlytics;
  late final FirebaseMessaging _messaging;
  late final FirebaseFirestore _firestore;
  static const String _pushStateIdKey = 'push_state_id';

  /// Initialize Firebase services
  Future<void> initialize() async {
    try {
      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;
      _messaging = FirebaseMessaging.instance;
      _firestore = FirebaseFirestore.instance;

      // Configure Crashlytics
      // Pass all uncaught errors to Crashlytics
      FlutterError.onError = _crashlytics.recordFlutterFatalError;

      // Pass all uncaught asynchronous errors to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics.recordError(error, stack, fatal: true);
        return true;
      };

      // Setup FCM message handlers
      _setupMessageHandlers();

      debugPrint('✅ Firebase initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Firebase initialization error: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Setup FCM message handlers
  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message received: ${message.notification?.title}');
      AnalyticsService().logNotificationReceived(
        title: message.notification?.title,
      );
    });

    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Background message opened: ${message.notification?.title}');
      AnalyticsService().logNotificationTapped(
        title: message.notification?.title,
      );
    });

    _messaging.getInitialMessage().then((message) {
      if (message == null) {
        return;
      }
      AnalyticsService().logNotificationTapped(
        title: message.notification?.title,
      );
    });

    _messaging.getToken().then((token) {
      debugPrint('FCM Token: $token');
      _upsertPushState({'fcmToken': token});
    });
  }

  /// Log analytics event
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters?.cast<String, Object>(),
      );
      debugPrint('📊 Analytics event logged: $name');
    } catch (e) {
      debugPrint('Error logging analytics event: $e');
    }
  }

  /// Log screen view
  Future<void> logScreenView(String screenName) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
      );
      debugPrint('📱 Screen view logged: $screenName');
    } catch (e) {
      debugPrint('Error logging screen view: $e');
    }
  }

  /// Set user ID for analytics
  Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
      debugPrint('👤 User ID set: $userId');
    } catch (e) {
      debugPrint('Error setting user ID: $e');
    }
  }

  /// Set user property
  Future<void> setUserProperty(String name, String? value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      debugPrint('🏷️ User property set: $name = $value');
    } catch (e) {
      debugPrint('Error setting user property: $e');
    }
  }

  Future<void> setPushAudienceSegment(String segment) async {
    try {
      await _analytics.setUserProperty(name: 'subscription_segment', value: segment);
      await _analytics.logEvent(
        name: 'push_segment_updated',
        parameters: {'segment': segment},
      );
      await _upsertPushState({
        'subscriptionSegment': segment,
      });
    } catch (e) {
      debugPrint('Error setting push audience segment: $e');
    }
  }

  Future<void> markOnboardingCompleted() async {
    try {
      await _upsertPushState({
        'onboardingCompletedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error marking onboarding completion for push state: $e');
    }
  }

  Future<void> markPurchaseActivated() async {
    try {
      await _upsertPushState({
        'subscriptionPurchasedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error marking purchase activation for push state: $e');
    }
  }

  Future<void> markSubscriptionExpired() async {
    try {
      await _upsertPushState({
        'subscriptionExpiredAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error marking subscription expiration for push state: $e');
    }
  }

  /// Log error to Crashlytics
  Future<void> logError(dynamic error, StackTrace? stackTrace, {String? reason}) async {
    try {
      await _crashlytics.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: false,
      );
      debugPrint('🐛 Error logged to Crashlytics: $error');
    } catch (e) {
      debugPrint('Error logging to Crashlytics: $e');
    }
  }

  /// Set custom key for Crashlytics
  Future<void> setCrashlyticsKey(String key, dynamic value) async {
    try {
      await _crashlytics.setCustomKey(key, value);
    } catch (e) {
      debugPrint('Error setting Crashlytics key: $e');
    }
  }

  /// Get FCM token
  Future<String?> getFCMToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  /// Subscribe to FCM topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('📢 Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from FCM topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('🔕 Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic: $e');
    }
  }

  Future<void> updateActivityPing() async {
    try {
      final now = DateTime.now();
      await _upsertPushState({
        'lastActiveAt': FieldValue.serverTimestamp(),
        'localHour': now.hour,
        'localWeekday': now.weekday,
      });
    } catch (e) {
      debugPrint('Error updating push activity ping: $e');
    }
  }

  Future<String> _getPushStateId() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_pushStateIdKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final generated =
        'u_${DateTime.now().millisecondsSinceEpoch}_${UniqueKey().hashCode}';
    await prefs.setString(_pushStateIdKey, generated);
    return generated;
  }

  Future<void> _upsertPushState(Map<String, dynamic> data) async {
    final userId = await _getPushStateId();
    await _firestore.collection('user_push_state').doc(userId).set(
      data,
      SetOptions(merge: true),
    );
  }
}
