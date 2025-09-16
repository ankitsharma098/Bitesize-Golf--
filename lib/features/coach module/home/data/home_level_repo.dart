import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../level/entity/level_entity.dart';

@LazySingleton()
class LevelRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  CollectionReference get _levels => _firestore.collection('levels');

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
}
