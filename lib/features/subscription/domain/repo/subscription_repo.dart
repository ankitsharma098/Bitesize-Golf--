// features/subscription/domain/repositories/subscription_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../failure.dart';
import '../../data/model/subscription.dart';
import '../../presentation/subscription_bloc/subscription_state.dart';

abstract class SubscriptionRepository {
  /// Get available subscription plans
  Future<Either<Failure, List<SubscriptionPlan>>> getAvailablePlans();

  /// Get current subscription for a pupil
  Future<Either<Failure, Subscription?>> getCurrentSubscription(String pupilId);

  /// Update subscription for a pupil
  Future<Either<Failure, Subscription>> updateSubscription({
    required String pupilId,
    required Subscription newSubscription,
  });

  /// Check if pupil can access a specific level
  Future<Either<Failure, bool>> canAccessLevel({
    required String pupilId,
    required int level,
  });

  /// Check if pupil can perform an action (take lesson, quiz, etc.)
  // Future<Either<Failure, bool>> canPerformAction({
  //   required String pupilId,
  //   required String actionType,
  //   required int currentUsageCount,
  // });

  /// Get subscription usage stats for a pupil
  //Future<Either<Failure, SubscriptionUsage>> getSubscriptionUsage(String pupilId);

  /// Cancel subscription
  Future<Either<Failure, void>> cancelSubscription(String pupilId);

  /// Reactivate subscription
  Future<Either<Failure, Subscription>> reactivateSubscription({
    required String pupilId,
    required SubscriptionPlan plan,
  });
}
