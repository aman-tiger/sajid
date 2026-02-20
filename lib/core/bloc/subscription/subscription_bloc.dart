import 'package:flutter_bloc/flutter_bloc.dart';
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
          emit(const SubscriptionPurchaseSuccess());
          emit(const SubscriptionActive(productId: 'premium'));
          break;
        case PurchaseOutcomeType.cancelled:
          emit(const SubscriptionPurchaseCancelled());
          emit(const SubscriptionInactive());
          break;
        case PurchaseOutcomeType.pending:
          emit(const SubscriptionPurchasePending());
          emit(const SubscriptionInactive());
          break;
        case PurchaseOutcomeType.error:
          emit(
            SubscriptionError(
              outcome.message ?? 'Purchase failed. Please try again.',
            ),
          );
          emit(const SubscriptionInactive());
          break;
      }
    } catch (_) {
      emit(const SubscriptionError('Purchase failed. Please try again.'));
      emit(const SubscriptionInactive());
    } 
  }

  Future<void> _onRestorePurchase(
    RestorePurchaseEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    try {
      emit(const SubscriptionLoading());

      final hasActive = await subscriptionService.restorePurchases();

      emit(SubscriptionRestoreSuccess(hadPurchases: hasActive));

      if (hasActive) {
        emit(const SubscriptionActive(productId: 'premium'));
      } else {
        emit(const SubscriptionInactive());
      }
    } catch (e) {
      emit(SubscriptionError('Restore failed: ${e.toString()}'));
      emit(const SubscriptionInactive());
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
