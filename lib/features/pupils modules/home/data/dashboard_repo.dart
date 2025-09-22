import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../Models/level model/level_model.dart';
import '../../../../Models/pupil model/pupil_model.dart';
import '../../../../core/constants/firebase_collections_names.dart';

class DashboardRepository {
  Stream<PupilModel?> getPupilDataStream(String userId) {
    return FirestoreCollections.pupilsCol.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      final data = doc.data()!;
      data['id'] = doc.id;
      return PupilModel.fromFirestore(data);
    });
  }

  Future<List<LevelModel>> getAllLevels() async {
    try {
      final levelsQuery = await FirestoreCollections.levelsCol
          .where('isActive', isEqualTo: true)
          .where('isPublished', isEqualTo: true)
          .orderBy('levelNumber')
          .get();

      return levelsQuery.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return LevelModel.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting levels: $e');
      throw Exception('Failed to get levels: $e');
    }
  }

  Stream<List<LevelModel>> getLevelsStream() {
    return FirestoreCollections.levelsCol
        .where('isActive', isEqualTo: true)
        .where('isPublished', isEqualTo: true)
        .orderBy('levelNumber')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return LevelModel.fromFirestore(data);
          }).toList(),
        );
  }

  Future<void> updatePupilProgress(
    String userId,
    PupilModel updatedPupil,
  ) async {
    try {
      await FirestoreCollections.pupilsCol
          .doc(userId)
          .update(updatedPupil.toFirestore());
    } catch (e) {
      print('Error updating pupil progress: $e');
      throw Exception('Failed to update pupil progress: $e');
    }
  }

  Future<void> updateLevelProgress(
    String userId,
    int levelNumber,
    Map<String, dynamic> progressData,
  ) async {
    try {
      await FirestoreCollections.pupilsCol.doc(userId).update({
        'levelProgress.$levelNumber': progressData,
        'lastActivityDate': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating level progress: $e');
      throw Exception('Failed to update level progress: $e');
    }
  }

  Future<void> unlockLevel(String userId, int levelNumber) async {
    try {
      await FirestoreCollections.pupilsCol.doc(userId).update({
        'unlockedLevels': FieldValue.arrayUnion([levelNumber]),
        'lastActivityDate': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error unlocking level: $e');
      throw Exception('Failed to unlock level: $e');
    }
  }
}
