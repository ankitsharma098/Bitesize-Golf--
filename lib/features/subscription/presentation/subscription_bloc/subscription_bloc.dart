// features/subscription/presentation/subscription_bloc/subscription_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/data source/subscription_repo.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

@injectable
class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository repository;

  SubscriptionBloc(this.repository) : super(SubscriptionInitial()) {
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
      final plans = await repository.getAvailablePlans();
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
    final currentState = state;
    if (currentState is SubscriptionPlansLoaded) {
      emit(currentState.copyWith(selectedPlan: event.plan));
    }
  }

  Future<void> _onPurchaseSubscription(
    PurchaseSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SubscriptionPlansLoaded ||
        currentState.selectedPlan == null) {
      emit(SubscriptionPurchaseFailure('No plan selected'));
      return;
    }

    emit(SubscriptionPurchasing(currentState.selectedPlan!));

    try {
      final subscription = await repository.purchaseSubscription(
        pupilId: event.pupilId,
        plan: currentState.selectedPlan!,
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
      await repository.cancelSubscription(event.pupilId);
      // Reload plans after cancellation
      add(LoadSubscriptionPlansEvent());
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }
}
