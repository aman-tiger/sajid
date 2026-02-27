import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../config/app_secrets.dart';

/// Service class for managing Sentry error tracking
/// Captures errors, exceptions, and performance metrics
class SentryService {
  static final SentryService _instance = SentryService._internal();
  factory SentryService() => _instance;
  SentryService._internal();

  /// Initialize Sentry (call this from main.dart before runApp)
  static Future<void> initialize(Function() appRunner) async {
    if (AppSecrets.sentryDsn.isEmpty) {
      debugPrint('Sentry DSN missing. Set SENTRY_DSN.');
      appRunner();
      return;
    }

    await SentryFlutter.init(
      (options) {
        options.dsn = AppSecrets.sentryDsn;
        options.environment = kDebugMode ? 'development' : 'production';
        options.tracesSampleRate = 1.0; // Capture 100% of transactions
        options.debug = kDebugMode; // Print debug info in debug mode
        options.enableAutoSessionTracking = true;
        options.attachScreenshot = true;
        options.attachViewHierarchy = true;

        // Configure what to send
        options.beforeSend = (event, hint) {
          // Filter out events if needed
          return event;
        };
      },
      appRunner: appRunner,
    );

    debugPrint('✅ Sentry initialized successfully');
  }

  /// Capture exception manually
  Future<void> captureException(
    dynamic exception,
    StackTrace? stackTrace, {
    String? hint,
    Map<String, dynamic>? extras,
  }) async {
    try {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        hint: hint != null ? Hint.withMap({'hint': hint}) : null,
      );

      if (extras != null) {
        Sentry.configureScope((scope) {
          extras.forEach((key, value) {
            scope.setExtra(key, value);
          });
        });
      }

      debugPrint('🐛 Exception captured in Sentry: $exception');
    } catch (e) {
      debugPrint('Error capturing exception in Sentry: $e');
    }
  }

  /// Capture message
  Future<void> captureMessage(
    String message, {
    SentryLevel level = SentryLevel.info,
    Map<String, dynamic>? extras,
  }) async {
    try {
      await Sentry.captureMessage(
        message,
        level: level,
      );

      if (extras != null) {
        Sentry.configureScope((scope) {
          extras.forEach((key, value) {
            scope.setExtra(key, value);
          });
        });
      }

      debugPrint('📝 Message captured in Sentry: $message');
    } catch (e) {
      debugPrint('Error capturing message in Sentry: $e');
    }
  }

  /// Set user context
  Future<void> setUser(String? userId, {String? email, String? username}) async {
    try {
      await Sentry.configureScope((scope) {
        scope.setUser(
          SentryUser(
            id: userId,
            email: email,
            username: username,
          ),
        );
      });
      debugPrint('👤 Sentry user set: $userId');
    } catch (e) {
      debugPrint('Error setting Sentry user: $e');
    }
  }

  /// Clear user context
  Future<void> clearUser() async {
    try {
      await Sentry.configureScope((scope) {
        scope.setUser(null);
      });
      debugPrint('👤 Sentry user cleared');
    } catch (e) {
      debugPrint('Error clearing Sentry user: $e');
    }
  }

  /// Add breadcrumb
  void addBreadcrumb(
    String message, {
    String? category,
    SentryLevel level = SentryLevel.info,
    Map<String, dynamic>? data,
  }) {
    try {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: message,
          category: category,
          level: level,
          data: data,
        ),
      );
      debugPrint('🍞 Breadcrumb added: $message');
    } catch (e) {
      debugPrint('Error adding breadcrumb: $e');
    }
  }

  /// Set context
  void setContext(String key, Map<String, dynamic> context) {
    try {
      Sentry.configureScope((scope) {
        scope.setContexts(key, context);
      });
    } catch (e) {
      debugPrint('Error setting Sentry context: $e');
    }
  }

  /// Set tag
  void setTag(String key, String value) {
    try {
      Sentry.configureScope((scope) {
        scope.setTag(key, value);
      });
    } catch (e) {
      debugPrint('Error setting Sentry tag: $e');
    }
  }

  /// Start transaction (for performance monitoring)
  ISentrySpan startTransaction(String operation, String description) {
    final transaction = Sentry.startTransaction(
      operation,
      description,
    );
    debugPrint('⏱️ Transaction started: $operation');
    return transaction;
  }

  /// Common error tracking methods

  /// Track API error
  Future<void> trackApiError(String endpoint, int statusCode, String error) async {
    await captureMessage(
      'API Error: $endpoint',
      level: SentryLevel.error,
      extras: {
        'endpoint': endpoint,
        'status_code': statusCode,
        'error': error,
      },
    );
  }

  /// Track payment error
  Future<void> trackPaymentError(String productId, String error) async {
    await captureMessage(
      'Payment Error: $productId',
      level: SentryLevel.error,
      extras: {
        'product_id': productId,
        'error': error,
      },
    );
  }

  /// Track navigation error
  Future<void> trackNavigationError(String route, String error) async {
    await captureMessage(
      'Navigation Error: $route',
      level: SentryLevel.warning,
      extras: {
        'route': route,
        'error': error,
      },
    );
  }

  /// Track data loading error
  Future<void> trackDataLoadingError(String dataType, String error) async {
    await captureMessage(
      'Data Loading Error: $dataType',
      level: SentryLevel.error,
      extras: {
        'data_type': dataType,
        'error': error,
      },
    );
  }
}
