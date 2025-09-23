import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../Models/coaches model/coach_model.dart';
import '../../../../core/constants/firebase_collections_names.dart';

class CoachProfilePageRepo {
  // Listen to coach book bloc changes
  Stream<CoachModel?> getCoachesDataStream(String userId) {
    return FirestoreCollections.coachesCol.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return CoachModel.fromJson(doc.data()!);
    });
  }

  // Update coach progress
  Future<void> updateCoachesProgress(
    String userId,
    CoachModel updatedCoach,
  ) async {
    try {
      await FirestoreCollections.coachesCol
          .doc(userId)
          .update(updatedCoach.toFirestore());
    } catch (e) {
      print('Error updating Coach progress: $e');
      throw Exception('Failed to update coach progress: $e');
    }
  }
}
