// features/subscription/presentation/subscription_bloc/subscription_event.dart
import 'package:bitesize_golf/features/subscription/presentation/subscription_bloc/subscription_state.dart';

import '../../data/model/subscription.dart';

abstract class SubscriptionEvent {}

class LoadSubscriptionPlansEvent extends SubscriptionEvent {}

class SelectSubscriptionPlan extends SubscriptionEvent {
  final SubscriptionPlan plan;

  SelectSubscriptionPlan(this.plan);
}

class PurchaseSubscriptionEvent extends SubscriptionEvent {
  final String pupilId;

  PurchaseSubscriptionEvent(this.pupilId);
}
