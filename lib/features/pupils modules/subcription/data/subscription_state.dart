part of 'subscription_bloc.dart';

@immutable
sealed class SubscriptionState {}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final Subscription subscription;

  bool get isExpired => subscription.endDate!.isBefore(DateTime.now());
  bool get isExpiringSoon =>
      subscription.endDate!.isBefore(
        DateTime.now().add(const Duration(days: 30)),
      ) &&
      subscription.endDate!.isAfter(DateTime.now());

  SubscriptionLoaded(this.subscription);
}

class SubscriptionError extends SubscriptionState {
  final String message;
  SubscriptionError(this.message);
}

class SubscriptionRenewed extends SubscriptionState {}
