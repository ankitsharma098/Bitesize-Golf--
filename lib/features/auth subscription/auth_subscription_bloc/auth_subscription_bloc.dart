import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Models/subscription model/subscription.dart';
import '../data/subscription_repo.dart';
import 'auth_subscription_event.dart';
import 'auth_subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository _repository = const SubscriptionRepository();

  SubscriptionBloc() : super(SubscriptionInitial()) {
    on<LoadSubscriptionPlansEvent>(_onLoadSubscriptionPlans);
    on<SelectSubscriptionPlan>(_onSelectSubscriptionPlan);
    on<PurchaseSubscriptionEvent>(_onPurchaseSubscription);
    on<CancelSubscriptionEvent>(_onCancelSubscription);
  }

  Future<void> _onLoadSubscriptionPlans(
    LoadSubscriptionPlansEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    try {
      final plans = await _repository.getAvailablePlans();
      emit(
        SubscriptionPlansLoaded(
          plans: plans,
          selectedPlan: plans.isNotEmpty ? plans.first : null,
        ),
      );
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }

  void _onSelectSubscriptionPlan(
    SelectSubscriptionPlan event,
    Emitter<SubscriptionState> emit,
  ) {
    final current = state;
    if (current is SubscriptionPlansLoaded) {
      emit(current.copyWith(selectedPlan: event.plan));
    }
  }

  Future<void> _onPurchaseSubscription(
    PurchaseSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    final current = state;
    if (current is! SubscriptionPlansLoaded || current.selectedPlan == null) {
      emit(SubscriptionPurchaseFailure('No plan selected'));
      return;
    }

    emit(SubscriptionPurchasing(current.selectedPlan!));

    try {
      final subscription = await _repository.purchaseSubscription(
        pupilId: event.pupilId,
        plan: current.selectedPlan!,
      );
      emit(SubscriptionPurchaseSuccess(subscription));
    } catch (e) {
      emit(SubscriptionPurchaseFailure(e.toString()));
    }
  }

  Future<void> _onCancelSubscription(
    CancelSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    try {
      await _repository.cancelSubscription(event.pupilId);
      add(LoadSubscriptionPlansEvent());
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }
}
