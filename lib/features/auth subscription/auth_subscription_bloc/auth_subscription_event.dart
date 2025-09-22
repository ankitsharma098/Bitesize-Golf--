import 'package:equatable/equatable.dart';
import '../../../Models/subscription model/subscription.dart';

abstract class SubscriptionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSubscriptionPlansEvent extends SubscriptionEvent {}

class SelectSubscriptionPlan extends SubscriptionEvent {
  final SubscriptionPlan plan;

  SelectSubscriptionPlan(this.plan);

  @override
  List<Object?> get props => [plan];
}

class PurchaseSubscriptionEvent extends SubscriptionEvent {
  final String pupilId;

  PurchaseSubscriptionEvent(this.pupilId);

  @override
  List<Object?> get props => [pupilId];
}

class CancelSubscriptionEvent extends SubscriptionEvent {
  final String pupilId;

  CancelSubscriptionEvent(this.pupilId);

  @override
  List<Object?> get props => [pupilId];
}
