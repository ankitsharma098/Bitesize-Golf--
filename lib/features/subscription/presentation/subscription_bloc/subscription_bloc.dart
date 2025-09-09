// features/subscription/presentation/subscription_bloc/subscription_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';
import '../../domain/usecases/load_subscription_plans.dart';
import '../../domain/usecases/purchase_subscription.dart';
import '../../data/model/subscription.dart';

@injectable
class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final LoadSubscriptionPlans _loadSubscriptionPlans;
  final PurchaseSubscription _purchaseSubscription;

  SubscriptionBloc(this._loadSubscriptionPlans, this._purchaseSubscription)
    : super(SubscriptionInitial()) {
    on<LoadSubscriptionPlansEvent>(_onLoadSubscriptionPlans);
    on<SelectSubscriptionPlan>(_onSelectSubscriptionPlan);
    on<PurchaseSubscriptionEvent>(_onPurchaseSubscription);
  }

  void _onLoadSubscriptionPlans(
    LoadSubscriptionPlansEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());

    final result = await _loadSubscriptionPlans();

    result.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (plans) => emit(
        SubscriptionPlansLoaded(
          plans: plans,
          selectedPlan: plans.isNotEmpty
              ? plans.first
              : null, // Default to first plan
        ),
      ),
    );
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

  void _onPurchaseSubscription(
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

    final params = PurchaseSubscriptionParams(
      pupilId: event.pupilId,
      selectedPlan: currentState.selectedPlan!,
    );

    final result = await _purchaseSubscription(params);

    result.fold(
      (failure) => emit(SubscriptionPurchaseFailure(failure.message)),
      (subscription) => emit(SubscriptionPurchaseSuccess(subscription)),
    );
  }
}
