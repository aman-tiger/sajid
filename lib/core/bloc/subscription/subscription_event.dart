import 'package:equatable/equatable.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object?> get props => [];
}

class CheckSubscriptionStatusEvent extends SubscriptionEvent {
  const CheckSubscriptionStatusEvent();
}

class PurchaseSubscriptionEvent extends SubscriptionEvent {
  final QProduct product;

  const PurchaseSubscriptionEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class RestorePurchaseEvent extends SubscriptionEvent {
  const RestorePurchaseEvent();
}

class UpdateSubscriptionStatusEvent extends SubscriptionEvent {
  final bool isActive;

  const UpdateSubscriptionStatusEvent(this.isActive);

  @override
  List<Object?> get props => [isActive];
}
