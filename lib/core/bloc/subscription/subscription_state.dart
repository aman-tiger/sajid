import 'package:equatable/equatable.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial();
}

class SubscriptionLoading extends SubscriptionState {
  const SubscriptionLoading();
}

class SubscriptionActive extends SubscriptionState {
  final String productId;
  final DateTime? expiryDate;

  const SubscriptionActive({
    required this.productId,
    this.expiryDate,
  });

  @override
  List<Object?> get props => [productId, expiryDate];
}

class SubscriptionInactive extends SubscriptionState {
  const SubscriptionInactive();
}

class SubscriptionPurchasing extends SubscriptionState {
  const SubscriptionPurchasing();
}

class SubscriptionPurchaseSuccess extends SubscriptionState {
  const SubscriptionPurchaseSuccess();
}

class SubscriptionPurchaseCancelled extends SubscriptionState {
  const SubscriptionPurchaseCancelled();
}

class SubscriptionRestoreSuccess extends SubscriptionState {
  final bool hadPurchases;

  const SubscriptionRestoreSuccess({required this.hadPurchases});

  @override
  List<Object?> get props => [hadPurchases];
}

class SubscriptionError extends SubscriptionState {
  final String message;

  const SubscriptionError(this.message);

  @override
  List<Object?> get props => [message];
}
