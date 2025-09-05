import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../models/coach_model.dart';

abstract class CoachRemoteDataSource {
  Future<void> createCoach(CoachModel coach);
  Future<CoachModel?> getCoach(String coachId);
  Stream<CoachModel?> watchCoach(String coachId);
  Future<void> updateCoach(CoachModel coach);
  Future<List<CoachModel>> getCoachesByClub(String? clubId);
}

@LazySingleton(as: CoachRemoteDataSource)
class CoachRemoteDataSourceImpl implements CoachRemoteDataSource {
  final FirebaseFirestore firestore;

  CoachRemoteDataSourceImpl(this.firestore);

  CollectionReference get _coaches => firestore.collection('coaches');

  @override
  Future<void> createCoach(CoachModel coach) async {
    await _coaches.doc(coach.id).set(coach.toJson());
  }

  @override
  Future<CoachModel?> getCoach(String coachId) async {
    final doc = await _coaches.doc(coachId).get();
    if (!doc.exists) return null;
    return CoachModel.fromFirestore(doc);
  }

  @override
  Stream<CoachModel?> watchCoach(String coachId) {
    return _coaches.doc(coachId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return CoachModel.fromFirestore(doc);
    });
  }

  @override
  Future<void> updateCoach(CoachModel coach) async {
    await _coaches.doc(coach.id).update(coach.toJson());
  }

  @override
  Future<List<CoachModel>> getCoachesByClub(String? clubId) async {
    Query query = _coaches;
    if (clubId != null) {
      query = query.where('clubId', isEqualTo: clubId);
    }
    final snapshot = await query
        .where('verificationStatus', isEqualTo: 'verified')
        .get();
    return snapshot.docs.map((doc) => CoachModel.fromFirestore(doc)).toList();
  }
}
