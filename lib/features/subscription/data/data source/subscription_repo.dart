import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../auth/data/entities/user_enums.dart';
import '../model/subscription.dart';

@LazySingleton()
class SubscriptionRepository {
  final FirebaseFirestore firestore;

  SubscriptionRepository(this.firestore);

  CollectionReference<Map<String, dynamic>> get _pupils =>
      firestore.collection('pupils');

  // Get available subscription plans
  Future<List<SubscriptionPlan>> getAvailablePlans() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      return SubscriptionPlan.allPlans;
    } catch (e) {
      throw Exception('Failed to load subscription plans: $e');
    }
  }

  // Get current subscription for a pupil
  Future<Subscription?> getCurrentSubscription(String pupilId) async {
    try {
      final pupilDoc = await _pupils.doc(pupilId).get();

      if (!pupilDoc.exists) {
        throw Exception('Pupil not found');
      }

      final pupilData = pupilDoc.data()!;
      final subscriptionData =
          pupilData['subscription'] as Map<String, dynamic>?;

      if (subscriptionData == null) {
        return null;
      }

      return Subscription.fromJson(subscriptionData);
    } catch (e) {
      throw Exception('Failed to get current subscription: $e');
    }
  }

  // Update subscription for a pupil
  Future<Subscription> updateSubscription({
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

      // Log subscription change
      await _logSubscriptionChange(pupilId, newSubscription);

      return newSubscription;
    } catch (e) {
      throw Exception('Failed to update subscription: $e');
    }
  }

  // Check if user can access a specific level
  Future<bool> canAccessLevel({
    required String pupilId,
    required int level,
  }) async {
    try {
      final subscription = await getCurrentSubscription(pupilId);
      final activeSubscription = subscription ?? Subscription.free();

      // Check if subscription is expired
      if (activeSubscription.isExpired) {
        return false;
      }

      return activeSubscription.canAccessLevel(level);
    } catch (e) {
      throw Exception('Failed to check level access: $e');
    }
  }

  // Cancel subscription
  Future<void> cancelSubscription(String pupilId) async {
    try {
      final currentSubscription = await getCurrentSubscription(pupilId);

      if (currentSubscription == null || currentSubscription.isFree) {
        throw Exception('No active subscription to cancel');
      }

      // Update to cancelled subscription but preserve end date
      final cancelledSubscription = currentSubscription.copyWith(
        status: SubscriptionStatus.cancelled,
        autoRenew: false,
      );

      await updateSubscription(
        pupilId: pupilId,
        newSubscription: cancelledSubscription,
      );
    } catch (e) {
      throw Exception('Failed to cancel subscription: $e');
    }
  }

  // Purchase/Reactivate subscription
  Future<Subscription> purchaseSubscription({
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
      throw Exception('Failed to purchase subscription: $e');
    }
  }

  // Private helper to create subscription from plan
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

  // Private helper to log subscription changes
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
