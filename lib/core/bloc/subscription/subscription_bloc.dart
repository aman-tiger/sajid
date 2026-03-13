import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:never_have_ever/main.dart';
import '../../services/analytics_service.dart';
import '../../services/subscription_service.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionService subscriptionService;

  SubscriptionBloc({required this.subscriptionService})
      : super(const SubscriptionInitial()) {
    on<CheckSubscriptionStatusEvent>(_onCheckSubscriptionStatus);
    on<PurchaseSubscriptionEvent>(_onPurchaseSubscription);
    on<RestorePurchaseEvent>(_onRestorePurchase);
    on<UpdateSubscriptionStatusEvent>(_onUpdateSubscriptionStatus);
  }

  Future<void> _onCheckSubscriptionStatus(
    CheckSubscriptionStatusEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    try {
      emit(const SubscriptionLoading());

      final isActive = await subscriptionService.hasActiveSubscription();

      if (isActive) {
        emit(const SubscriptionActive(productId: 'premium'));
      } else {
        emit(const SubscriptionInactive());
      }
    } catch (e) {
      emit(SubscriptionError('Failed to check subscription: ${e.toString()}'));
    }
  }

  Future<void> _onPurchaseSubscription(
    PurchaseSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    try {
      emit(const SubscriptionPurchasing());

      final outcome = await subscriptionService.purchaseProduct(event.product);

      switch (outcome.type) {
        case PurchaseOutcomeType.success:
          final hasTrial = event.product.trialPeriod != null;
          final price = event.product.price?.toDouble() ?? 0.0;
          final currency = event.product.currencyCode ?? 'USD';
          final productId = event.product.qonversionId;

          await AnalyticsService().logEvent(
            'Purchase_Success',
            parameters: {
              'product_id': productId,
              'price': price,
              'currency': currency,
              'has_trial': hasTrial,
            },
          );

          if (hasTrial) {
            await AnalyticsService().logTrialStarted(productId);
          } else {
            await AnalyticsService().logSubscriptionStarted(productId, price);
          }
          await AnalyticsService().setPushAudienceSegment('active_subscription');
          await AnalyticsService().markSubscriptionActivatedForPush();

          appsflyerSdk?.logEvent(
            hasTrial ? 'af_start_trial' : 'af_subscribe',
            {
              'af_currency': currency,
              'af_revenue': hasTrial ? 0 : price,
              'af_quantity': 1,
              'af_order_id': productId,
            },
          );

          emit(const SubscriptionPurchaseSuccess());
          break;
        case PurchaseOutcomeType.cancelled:
          emit(const SubscriptionPurchaseCancelled());
          break;
        case PurchaseOutcomeType.pending:
          emit(const SubscriptionPurchasePending());
          break;
        case PurchaseOutcomeType.error:
          await AnalyticsService().logEvent(
            'Purchase_Failed',
            parameters: {
              'product_id': event.product.qonversionId,
              'error': outcome.message ?? 'unknown_error',
            },
          );

          appsflyerSdk?.logEvent(
            'Purchase_Failed',
            {
              'af_error': outcome.message ?? 'unknown error',
            },
          );

          emit(
            SubscriptionError(
              outcome.message ?? 'Purchase failed. Please try again.',
            ),
          );
          break;
      }
    } catch (_) {
      await AnalyticsService().logEvent(
        'Purchase_Failed',
        parameters: const {'error': 'exception'},
      );
      emit(const SubscriptionError('Purchase failed. Please try again.'));
    } 
  }

  Future<void> _onRestorePurchase(
    RestorePurchaseEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    try {
      emit(const SubscriptionLoading());

      final hasActive = await subscriptionService.restorePurchases();

      if (hasActive) {
        appsflyerSdk?.logEvent(
          'af_restore',
          const {'af_success': true},
        );
        await AnalyticsService().logPurchaseRestored();
        await AnalyticsService().setPushAudienceSegment('active_subscription');
        emit(const SubscriptionRestoreSuccess(hadPurchases: true));
      } else {
        final segment = await subscriptionService.resolvePushSegment();
        await AnalyticsService().setPushAudienceSegment(segment);
        if (segment == 'churned') {
          await AnalyticsService().markSubscriptionExpiredForPush();
        }
        emit(const SubscriptionRestoreSuccess(hadPurchases: false));
      }
    } catch (e) {
      emit(SubscriptionError('Restore failed: ${e.toString()}'));
    }
  }

  void _onUpdateSubscriptionStatus(
    UpdateSubscriptionStatusEvent event,
    Emitter<SubscriptionState> emit,
  ) {
    if (event.isActive) {
      emit(const SubscriptionActive(productId: 'premium'));
    } else {
      emit(const SubscriptionInactive());
    }
  }

  /// Helper method to check if currently subscribed
  bool get isSubscribed {
    return state is SubscriptionActive;
  }
}
