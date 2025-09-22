// subscription_event.dart
part of 'subscription_bloc.dart';

@immutable
sealed class SubscriptionEvent {}

class LoadSubscription extends SubscriptionEvent {
  final String userId;
  LoadSubscription(this.userId);
}

class RefreshSubscription extends SubscriptionEvent {
  final String userId;
  RefreshSubscription(this.userId);
}

class RenewSubscription extends SubscriptionEvent {
  final String userId;
  RenewSubscription(this.userId);
}
