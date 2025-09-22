import 'package:equatable/equatable.dart';
import '../../../Models/subscription model/subscription.dart';

abstract class SubscriptionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionError extends SubscriptionState {
  final String message;
  SubscriptionError(this.message);

  @override
  List<Object?> get props => [message];
}

class SubscriptionPlansLoaded extends SubscriptionState {
  final List<SubscriptionPlan> plans;
  final SubscriptionPlan? selectedPlan;

  SubscriptionPlansLoaded({required this.plans, this.selectedPlan});

  @override
  List<Object?> get props => [plans, selectedPlan];

  SubscriptionPlansLoaded copyWith({
    List<SubscriptionPlan>? plans,
    SubscriptionPlan? selectedPlan,
  }) {
    return SubscriptionPlansLoaded(
      plans: plans ?? this.plans,
      selectedPlan: selectedPlan ?? this.selectedPlan,
    );
  }
}

class SubscriptionPurchasing extends SubscriptionState {
  final SubscriptionPlan selectedPlan;
  SubscriptionPurchasing(this.selectedPlan);

  @override
  List<Object?> get props => [selectedPlan];
}

class SubscriptionPurchaseSuccess extends SubscriptionState {
  final Subscription newSubscription;
  SubscriptionPurchaseSuccess(this.newSubscription);

  @override
  List<Object?> get props => [newSubscription];
}

class SubscriptionPurchaseFailure extends SubscriptionState {
  final String message;
  SubscriptionPurchaseFailure(this.message);

  @override
  List<Object?> get props => [message];
}
