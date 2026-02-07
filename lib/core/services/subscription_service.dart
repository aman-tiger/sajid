import 'package:qonversion_flutter/qonversion_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionService {
  static const String _subscriptionKey = 'has_subscription';
  static const String _subscriptionCheckedAtKey = 'subscription_checked_at';
  static const String _premiumEntitlementId = 'premium';

  /// Check if user has an active subscription
  Future<bool> hasActiveSubscription() async {
    try {
      // Try to fetch from Qonversion
      final entitlements = await Qonversion.getSharedInstance().checkEntitlements();
      final isActive = entitlements[_premiumEntitlementId]?.isActive ?? false;

      // Cache the result
      await _cacheSubscriptionStatus(isActive);

      return isActive;
    } catch (e) {
      // Fallback to cached value if online check fails
      return await _getCachedSubscriptionStatus();
    }
  }

  /// Get cached subscription status
  Future<bool> _getCachedSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_subscriptionKey) ?? false;
  }

  /// Cache subscription status locally
  Future<void> _cacheSubscriptionStatus(bool isActive) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_subscriptionKey, isActive);
    await prefs.setInt(
      _subscriptionCheckedAtKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Purchase a subscription product
  Future<bool> purchaseProduct(QProduct product) async {
    try {
      final result = await Qonversion.getSharedInstance().purchaseProduct(product);

      // Check if purchase was successful
      final isActive = result[_premiumEntitlementId]?.isActive ?? false;

      if (isActive) {
        await _cacheSubscriptionStatus(true);
      }

      return isActive;
    } catch (e) {
      throw Exception('Purchase failed: $e');
    }
  }

  /// Restore previous purchases
  Future<bool> restorePurchases() async {
    try {
      final entitlements = await Qonversion.getSharedInstance().restore();
      final isActive = entitlements[_premiumEntitlementId]?.isActive ?? false;

      await _cacheSubscriptionStatus(isActive);

      return isActive;
    } catch (e) {
      throw Exception('Restore failed: $e');
    }
  }

  /// Get available products/offerings
  Future<QOfferings?> getOfferings() async {
    try {
      final offerings = await Qonversion.getSharedInstance().offerings();
      return offerings;
    } catch (e) {
      throw Exception('Failed to load offerings: $e');
    }
  }

  /// Check if cached subscription status is stale (older than 24 hours)
  Future<bool> isCacheStale() async {
    final prefs = await SharedPreferences.getInstance();
    final checkedAt = prefs.getInt(_subscriptionCheckedAtKey);

    if (checkedAt == null) return true;

    final lastCheck = DateTime.fromMillisecondsSinceEpoch(checkedAt);
    final now = DateTime.now();
    final difference = now.difference(lastCheck);

    return difference.inHours >= 24;
  }
}
