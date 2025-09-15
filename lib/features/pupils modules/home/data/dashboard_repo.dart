import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../level/entity/level_entity.dart';
import '../../pupil/data/models/pupil_model.dart';

@LazySingleton()
class DashboardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  CollectionReference get _pupils => _firestore.collection('pupils');
  CollectionReference get _levels => _firestore.collection('levels');

  // Get current pupil data
  Future<PupilModel?> getPupilData(String userId) async {
    try {
      final pupilDoc = await _pupils.doc(userId).get();

      if (!pupilDoc.exists) return null;

      return PupilModel.fromJson(pupilDoc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error getting pupil data: $e');
      throw Exception('Failed to get pupil data: $e');
    }
  }

  // Listen to pupil data changes
  Stream<PupilModel?> getPupilDataStream(String userId) {
    return _pupils.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return PupilModel.fromJson(doc.data() as Map<String, dynamic>);
    });
  }

  // Get all levels
  Future<List<Level>> getAllLevels() async {
    try {
      final levelsQuery = await _levels
          .where('isActive', isEqualTo: true)
          .where('isPublished', isEqualTo: true)
          .orderBy('levelNumber')
          .get();

      return levelsQuery.docs
          .map((doc) => Level.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting levels: $e');
      throw Exception('Failed to get levels: $e');
    }
  }

  // Listen to levels changes
  Stream<List<Level>> getLevelsStream() {
    return _levels
        .where('isActive', isEqualTo: true)
        .where('isPublished', isEqualTo: true)
        .orderBy('levelNumber')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Level.fromJson(doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  // Update pupil progress
  Future<void> updatePupilProgress(
    String userId,
    PupilModel updatedPupil,
  ) async {
    try {
      await _pupils.doc(userId).update(updatedPupil.toJson());
    } catch (e) {
      print('Error updating pupil progress: $e');
      throw Exception('Failed to update pupil progress: $e');
    }
  }

  // Update specific level progress
  Future<void> updateLevelProgress(
    String userId,
    int levelNumber,
    Map<String, dynamic> progressData,
  ) async {
    try {
      await _pupils.doc(userId).update({
        'levelProgress.$levelNumber': progressData,
        'lastActivityDate': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating level progress: $e');
      throw Exception('Failed to update level progress: $e');
    }
  }

  // Unlock next level
  Future<void> unlockLevel(String userId, int levelNumber) async {
    try {
      await _pupils.doc(userId).update({
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
