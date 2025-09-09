// features/subscription/domain/usecases/purchase_subscription.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../failure.dart';
import '../../../auth/domain/entities/user_enums.dart';
import '../../data/model/subscription.dart';
import '../../presentation/subscription_bloc/subscription_state.dart';
import '../repo/subscription_repo.dart';

class PurchaseSubscriptionParams {
  final String pupilId;
  final SubscriptionPlan selectedPlan;

  PurchaseSubscriptionParams({
    required this.pupilId,
    required this.selectedPlan,
  });
}

@injectable
class PurchaseSubscription {
  final SubscriptionRepository repository;

  PurchaseSubscription(this.repository);

  Future<Either<Failure, Subscription>> call(
    PurchaseSubscriptionParams params,
  ) async {
    try {
      // Create subscription based on selected plan
      final selectedPlan = params.selectedPlan;
      final now = DateTime.now();
      final endDate = selectedPlan.type == SubscriptionPlanType.monthly
          ? DateTime(now.year, now.month + 1, now.day)
          : DateTime(now.year + 1, now.month, now.day);

      Subscription newSubscription;

      if (selectedPlan.type == SubscriptionPlanType.monthly) {
        // Monthly plan with 5 levels
        newSubscription = Subscription(
          status: SubscriptionStatus.active,
          tier: SubscriptionTier.premium,
          startDate: now,
          endDate: endDate,
          autoRenew: true,
          maxUnlockedLevels: 5,
        );
      } else {
        // Annual plan with 10 levels (full premium)
        newSubscription = Subscription.premium(
          startDate: now,
          endDate: endDate,
          autoRenew: true,
        );
      }

      // Update subscription in repository
      return await repository.updateSubscription(
        pupilId: params.pupilId,
        newSubscription: newSubscription,
      );
    } catch (e) {
      return Left(SubscriptionFailure(message: e.toString()));
    }
  }
}
