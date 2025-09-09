import 'package:equatable/equatable.dart';

import '../../data/model/subscription.dart';

enum SubscriptionPlanType { monthly, annual }

class SubscriptionPlan extends Equatable {
  final SubscriptionPlanType type;
  final String title;
  final String price;
  final String description;
  final int unlockedLevels;
  final String saveText;
  final bool isRecommended;

  const SubscriptionPlan({
    required this.type,
    required this.title,
    required this.price,
    required this.description,
    required this.unlockedLevels,
    this.saveText = '',
    this.isRecommended = false,
  });

  @override
  List<Object?> get props => [
    type,
    title,
    price,
    description,
    unlockedLevels,
    saveText,
    isRecommended,
  ];

  // Static plan definitions
  static const monthly = SubscriptionPlan(
    type: SubscriptionPlanType.monthly,
    title: 'Monthly',
    price: '£15.00',
    description: 'Monthly subscription',
    unlockedLevels: 5,
  );

  static const annual = SubscriptionPlan(
    type: SubscriptionPlanType.annual,
    title: 'Annual',
    price: '£144.00',
    description: 'Annual subscription',
    unlockedLevels: 10,
    saveText: 'Save 20%',
    isRecommended: true,
  );

  static List<SubscriptionPlan> get allPlans => [monthly, annual];
}

abstract class SubscriptionState {}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionError extends SubscriptionState {
  final String message;

  SubscriptionError(this.message);
}

class SubscriptionPlansLoaded extends SubscriptionState {
  final List<SubscriptionPlan> plans;
  final SubscriptionPlan? selectedPlan;

  SubscriptionPlansLoaded({required this.plans, this.selectedPlan});

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
}

class SubscriptionPurchaseSuccess extends SubscriptionState {
  final Subscription newSubscription;

  SubscriptionPurchaseSuccess(this.newSubscription);
}

class SubscriptionPurchaseFailure extends SubscriptionState {
  final String message;

  SubscriptionPurchaseFailure(this.message);
}
