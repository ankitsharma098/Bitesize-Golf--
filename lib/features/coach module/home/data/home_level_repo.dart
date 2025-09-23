import 'package:bitesize_golf/Models/level%20model/level_model.dart';

import '../../../../core/constants/firebase_collections_names.dart';

class CoachHomeRepo {
  final _levels = FirestoreCollections.levelsCol;

  /// Get all published and active levels
  Future<List<LevelModel>> getAllLevels() async {
    try {
      final query = await _levels
          .where('isActive', isEqualTo: true)
          .where('isPublished', isEqualTo: true)
          .orderBy('levelNumber')
          .get();

      return query.docs.map((doc) => LevelModel.fromJson(doc.data())).toList();
    } catch (e) {
      print('🔥 Error getting levels: $e');
      throw Exception('Failed to fetch levels: $e');
    }
  }

  /// Listen to realtime level changes
  Stream<List<LevelModel>> getLevelsStream() {
    return _levels
        .where('isActive', isEqualTo: true)
        .where('isPublished', isEqualTo: true)
        .orderBy('levelNumber')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => LevelModel.fromJson(doc.data()))
              .toList(),
        );
  }
}
