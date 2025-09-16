import 'package:bitesize_golf/features/coaches/data/models/coach_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class CoachProfilePageRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  CollectionReference get _coaches => _firestore.collection('coaches');

  // Get current coach data
  Future<CoachModel?> getCoachData(String userId) async {
    try {
      final coachDoc = await _coaches.doc(userId).get();

      if (!coachDoc.exists) return null;

      return CoachModel.fromJson(coachDoc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error getting Coach data: $e');
      throw Exception('Failed to get Coach data: $e');
    }
  }

  // Listen to coach data changes
  Stream<CoachModel?> getCoachesDataStream(String userId) {
    return _coaches.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return CoachModel.fromJson(doc.data() as Map<String, dynamic>);
    });
  }

  // Update coach progress
  Future<void> updateCoachesProgress(
    String userId,
    CoachModel updatedCoach,
  ) async {
    try {
      await _coaches.doc(userId).update(updatedCoach.toJson());
    } catch (e) {
      print('Error updating Coach progress: $e');
      throw Exception('$e');
    }
  }
}
