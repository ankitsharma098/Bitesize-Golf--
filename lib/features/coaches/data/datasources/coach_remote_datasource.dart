import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../models/coach_model.dart';

abstract class CoachRemoteDataSource {
  Future<CoachModel?> getCoach(String coachId);
  Stream<CoachModel?> watchCoach(String coachId);
  Future<void> updateCoach(CoachModel coach);
  Future<List<CoachModel>> getCoachesByClub(String clubId);
  Future<List<CoachModel>> getAllCoaches();
}

@LazySingleton(as: CoachRemoteDataSource)
class CoachRemoteDataSourceImpl implements CoachRemoteDataSource {
  final FirebaseFirestore firestore;

  CoachRemoteDataSourceImpl(this.firestore);

  @override
  Future<CoachModel?> getCoach(String coachId) async {
    try {
      final doc = await firestore.collection('coaches').doc(coachId).get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return CoachModel.fromFirestore(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get coach: $e');
    }
  }

  @override
  Stream<CoachModel?> watchCoach(String coachId) {
    return firestore.collection('coaches').doc(coachId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return CoachModel.fromFirestore(doc.data()!);
    });
  }

  @override
  Future<void> updateCoach(CoachModel coach) async {
    try {
      final updatedCoach = coach.copyWith(updatedAt: DateTime.now());
      await firestore
          .collection('coaches')
          .doc(coach.id)
          .update(updatedCoach.toJson());
    } catch (e) {
      throw Exception('Failed to update coach: $e');
    }
  }

  @override
  Future<List<CoachModel>> getCoachesByClub(String clubId) async {
    try {
      final querySnapshot = await firestore
          .collection('coaches')
          .where('assignedClubId', isEqualTo: clubId)
          .get();

      return querySnapshot.docs
          .map((doc) => CoachModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get coaches by club: $e');
    }
  }

  @override
  Future<List<CoachModel>> getAllCoaches() async {
    try {
      final querySnapshot = await firestore
          .collection('coaches')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => CoachModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all coaches: $e');
    }
  }
}
