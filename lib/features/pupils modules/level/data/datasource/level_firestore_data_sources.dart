import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../model/level_model.dart';

abstract class LevelFirebaseDataSource {
  Future<List<LevelModel>> getAllLevels();
  Future<LevelModel?> getLevelById(String id);
  Future<List<LevelModel>> getLevelsByPlan(String planType);
}

@LazySingleton(as: LevelFirebaseDataSource)
class LevelFirebaseDataSourceImpl implements LevelFirebaseDataSource {
  final FirebaseFirestore firestore;

  LevelFirebaseDataSourceImpl({required this.firestore});

  @override
  Future<List<LevelModel>> getAllLevels() async {
    final qs = await firestore
        .collection('levels')
        .where('isActive', isEqualTo: true)
        .orderBy('sortOrder')
        .get();
    return qs.docs.map((doc) => LevelModel.fromFirestore(doc.data())).toList();
  }

  @override
  Future<LevelModel?> getLevelById(String id) async {
    final doc = await firestore.collection('levels').doc(id).get();
    return doc.exists ? LevelModel.fromFirestore(doc.data()!) : null;
  }

  @override
  Future<List<LevelModel>> getLevelsByPlan(String planType) async {
    final qs = await firestore
        .collection('levels')
        .where('isActive', isEqualTo: true)
        .where('requiredPlan', isEqualTo: planType)
        .orderBy('sortOrder')
        .get();
    return qs.docs.map((doc) => LevelModel.fromFirestore(doc.data())).toList();
  }
}
