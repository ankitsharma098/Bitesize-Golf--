// features/subscription/data/datasources/subscription_firebase_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

abstract class SubscriptionFirebaseDataSource {
  Future<Map<String, dynamic>?> getPupilSubscription(String pupilId);
  Future<void> updatePupilSubscription(
    String pupilId,
    Map<String, dynamic> subscriptionData,
  );
  // Future<void> logSubscriptionEvent(Map<String, dynamic> eventData);
}

@LazySingleton(as: SubscriptionFirebaseDataSource)
class SubscriptionFirebaseDataSourceImpl
    implements SubscriptionFirebaseDataSource {
  final FirebaseFirestore firestore;

  SubscriptionFirebaseDataSourceImpl(this.firestore);

  @override
  Future<Map<String, dynamic>?> getPupilSubscription(String pupilId) async {
    try {
      final pupilDoc = await firestore.collection('pupils').doc(pupilId).get();

      if (!pupilDoc.exists) {
        return null;
      }

      final pupilData = pupilDoc.data()!;
      return pupilData['subscription'] as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Failed to get pupil subscription: $e');
    }
  }

  @override
  Future<void> updatePupilSubscription(
    String pupilId,
    Map<String, dynamic> subscriptionData,
  ) async {
    try {
      await firestore.collection('pupils').doc(pupilId).update({
        'subscription': subscriptionData,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update pupil subscription: $e');
    }
  }

  /*  @override
  Future<Map<String, dynamic>?> getSubscriptionUsage(String pupilId, String date) async {
    try {
      final usageDoc = await firestore
          .collection('subscriptionUsage')
          .doc('${pupilId}_$date')
          .get();

      return usageDoc.exists ? usageDoc.data() : null;
    } catch (e) {
      throw Exception('Failed to get subscription usage: $e');
    }
  }

  @override
  Future<void> updateSubscriptionUsage(String pupilId, String date, Map<String, dynamic> usageData) async {
    try {
      await firestore
          .collection('subscriptionUsage')
          .doc('${pupilId}_$date')
          .set(usageData, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to update subscription usage: $e');
    }
  }

  @override
  Future<void> logSubscriptionEvent(Map<String, dynamic> eventData) async {
    try {
      await firestore.collection('subscriptionLogs').add({
        ...eventData,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to log subscription event: $e');
    }
  }*/
}
