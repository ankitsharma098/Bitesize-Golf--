import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../model/golf_club_model.dart';

abstract class ClubRemoteDataSource {
  Stream<List<GolfClubModel>> watchActiveClubs();
  Future<List<GolfClubModel>> getActiveClubs();
}

@LazySingleton(as: ClubRemoteDataSource)
class ClubRemoteDataSourceImpl implements ClubRemoteDataSource {
  final FirebaseFirestore firestore;

  ClubRemoteDataSourceImpl(this.firestore);

  CollectionReference get _clubs => firestore.collection('golfClubs');

  @override
  Stream<List<GolfClubModel>> watchActiveClubs() {
    return _clubs
        .where('isActive', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => GolfClubModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<List<GolfClubModel>> getActiveClubs() async {
    final snapshot = await _clubs
        .where('isActive', isEqualTo: true)
        .orderBy('name')
        .get();
    return snapshot.docs
        .map((doc) => GolfClubModel.fromFirestore(doc))
        .toList();
  }
}
