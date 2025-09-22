import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../../../Models/subscription model/subscription.dart';
import '../../../../core/constants/firebase_collections_names.dart';

class SubscriptionRepository {
  const SubscriptionRepository();

  // Get available subscription plans
  Future<List<SubscriptionPlan>> getAvailablePlans() async {
    try {
      // Simulate small delay for smoother UX
      await Future.delayed(const Duration(milliseconds: 300));
      return SubscriptionPlan.allPlans;
    } catch (e) {
      throw Exception('Failed to load subscription plans: $e');
    }
  }

  // Get current subscription for a pupil
  Future<Subscription?> getCurrentSubscription(String pupilId) async {
    try {
      final pupilDoc = await FirestoreCollections.pupilsCol.doc(pupilId).get();

      if (!pupilDoc.exists) {
        throw Exception('Pupil not found');
      }

      final data = pupilDoc.data();
      final subscriptionData = data?['subscription'] as Map<String, dynamic>?;

      if (subscriptionData == null) return null;

      return Subscription.fromFirestore(subscriptionData);
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
      await FirestoreCollections.pupilsCol.doc(pupilId).update({
        'subscription': newSubscription.toFirestore(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Log subscription change separately
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

      // Subscription expired?
      if (activeSubscription.isExpired) return false;

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

      final cancelled = currentSubscription.copyWith(
        status: SubscriptionStatus.cancelled,
        autoRenew: false,
      );

      await updateSubscription(pupilId: pupilId, newSubscription: cancelled);
    } catch (e) {
      throw Exception('Failed to cancel subscription: $e');
    }
  }

  // Purchase or reactivate subscription
  Future<Subscription> purchaseSubscription({
    required String pupilId,
    required SubscriptionPlan plan,
  }) async {
    try {
      final now = DateTime.now();
      final endDate = plan.type == SubscriptionPlanType.monthly
          ? DateTime(now.year, now.month + 1, now.day)
          : DateTime(now.year + 1, now.month, now.day);

      final newSub = _createSubscriptionFromPlan(plan, now, endDate);

      return await updateSubscription(
        pupilId: pupilId,
        newSubscription: newSub,
      );
    } catch (e) {
      throw Exception('Failed to purchase subscription: $e');
    }
  }

  // ----------------- Helpers -----------------

  Subscription _createSubscriptionFromPlan(
    SubscriptionPlan plan,
    DateTime start,
    DateTime end,
  ) {
    if (plan.type == SubscriptionPlanType.monthly) {
      return Subscription(
        status: SubscriptionStatus.active,
        tier: SubscriptionTier.premium,
        startDate: start,
        endDate: end,
        autoRenew: true,
        maxUnlockedLevels: plan.unlockedLevels,
      );
    } else {
      return Subscription.premium(
        startDate: start,
        endDate: end,
        autoRenew: true,
      );
    }
  }

  Future<void> _logSubscriptionChange(
    String pupilId,
    Subscription subscription,
  ) async {
    try {
      await FirestoreCollections.subscriptionLogsCol.add({
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
      // Don’t crash main flow, just log failure
      debugPrint('Failed to log subscription change: $e');
    }
  }
}
