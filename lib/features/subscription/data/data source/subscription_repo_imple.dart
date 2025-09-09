// features/subscription/data/repositories/subscription_repository_impl.dart
import 'package:bitesize_golf/features/subscription/data/data%20source/subscription_firestore_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../auth/domain/entities/user_enums.dart';
import '../../../../failure.dart';
import '../../domain/repo/subscription_repo.dart';
import '../../presentation/subscription_bloc/subscription_state.dart';
import '../model/subscription.dart';

@LazySingleton(as: SubscriptionRepository)
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final FirebaseFirestore firestore;
  final SubscriptionFirebaseDataSource dataSource;

  SubscriptionRepositoryImpl({
    required this.firestore,
    required this.dataSource,
  });

  CollectionReference<Map<String, dynamic>> get _pupils =>
      firestore.collection('pupils');

  @override
  Future<Either<Failure, List<SubscriptionPlan>>> getAvailablePlans() async {
    try {
      // In a real app, you might fetch these from Firestore or a remote API
      // For now, return static plans
      await Future.delayed(
        const Duration(milliseconds: 300),
      ); // Simulate network delay

      return Right(SubscriptionPlan.allPlans);
    } catch (e) {
      return Left(SubscriptionFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Subscription?>> getCurrentSubscription(
    String pupilId,
  ) async {
    try {
      final pupilDoc = await _pupils.doc(pupilId).get();

      if (!pupilDoc.exists) {
        return Left(SubscriptionFailure(message: 'Pupil not found'));
      }

      final pupilData = pupilDoc.data()!;
      final subscriptionData =
          pupilData['subscription'] as Map<String, dynamic>?;

      if (subscriptionData == null) {
        return const Right(null);
      }

      final subscription = Subscription.fromJson(subscriptionData);
      return Right(subscription);
    } catch (e) {
      return Left(SubscriptionFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Subscription>> updateSubscription({
    required String pupilId,
    required Subscription newSubscription,
  }) async {
    try {
      final batch = firestore.batch();

      // Update pupil document with new subscription
      batch.update(_pupils.doc(pupilId), {
        'subscription': newSubscription.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      return Right(newSubscription);
    } catch (e) {
      return Left(SubscriptionFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> canAccessLevel({
    required String pupilId,
    required int level,
  }) async {
    try {
      final subscriptionResult = await getCurrentSubscription(pupilId);

      return subscriptionResult.fold((failure) => Left(failure), (
        subscription,
      ) {
        final activeSubscription = subscription ?? Subscription.free();

        // Check if subscription is expired
        if (activeSubscription.isExpired) {
          return const Right(false);
        }

        return Right(activeSubscription.canAccessLevel(level));
      });
    } catch (e) {
      return Left(SubscriptionFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelSubscription(String pupilId) async {
    try {
      // Get current subscription
      final currentResult = await getCurrentSubscription(pupilId);

      return currentResult.fold((failure) => Left(failure), (
        currentSubscription,
      ) async {
        if (currentSubscription == null || currentSubscription.isFree) {
          return Left(
            SubscriptionFailure(message: 'No active subscription to cancel'),
          );
        }

        // Update to cancelled subscription but preserve end date
        final cancelledSubscription = currentSubscription.copyWith(
          status: SubscriptionStatus.cancelled,
          autoRenew: false,
        );

        final updateResult = await updateSubscription(
          pupilId: pupilId,
          newSubscription: cancelledSubscription,
        );

        return updateResult.fold(
          (failure) => Left(failure),
          (_) => const Right(null),
        );
      });
    } catch (e) {
      return Left(SubscriptionFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Subscription>> reactivateSubscription({
    required String pupilId,
    required SubscriptionPlan plan,
  }) async {
    try {
      final now = DateTime.now();
      final endDate = plan.type == SubscriptionPlanType.monthly
          ? DateTime(now.year, now.month + 1, now.day)
          : DateTime(now.year + 1, now.month, now.day);

      final newSubscription = _createSubscriptionFromPlan(plan, now, endDate);

      return await updateSubscription(
        pupilId: pupilId,
        newSubscription: newSubscription,
      );
    } catch (e) {
      return Left(SubscriptionFailure(message: e.toString()));
    }
  }

  Subscription _createSubscriptionFromPlan(
    SubscriptionPlan plan,
    DateTime startDate,
    DateTime endDate,
  ) {
    if (plan.type == SubscriptionPlanType.monthly) {
      return Subscription(
        status: SubscriptionStatus.active,
        tier: SubscriptionTier.premium,
        startDate: startDate,
        endDate: endDate,
        autoRenew: true,
        maxUnlockedLevels: plan.unlockedLevels,
      );
    } else {
      return Subscription.premium(
        startDate: startDate,
        endDate: endDate,
        autoRenew: true,
      );
    }
  }

  Future<void> _logSubscriptionChange(
    String pupilId,
    Subscription subscription,
  ) async {
    try {
      await firestore.collection('subscriptionLogs').add({
        'pupilId': pupilId,
        'subscriptionTier': subscription.tier.name,
        'subscriptionStatus': subscription.status.name,
        'maxUnlockedLevels': subscription.maxUnlockedLevels,
        'startDate': subscription.startDate != null
            ? Timestamp.fromDate(subscription.startDate!)
            : null,
        'endDate': subscription.endDate != null
            ? Timestamp.fromDate(subscription.endDate!)
            : null,
        'autoRenew': subscription.autoRenew,
        'timestamp': FieldValue.serverTimestamp(),
        'action': 'subscription_updated',
      });
    } catch (e) {
      // Log error but don't fail the main operation
      print('Failed to log subscription change: $e');
    }
  }
}
