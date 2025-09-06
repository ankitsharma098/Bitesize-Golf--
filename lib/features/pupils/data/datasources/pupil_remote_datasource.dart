// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:injectable/injectable.dart';
// import '../models/pupil_model.dart';
//
// abstract class PupilRemoteDataSource {
//   Future<void> createPupil(PupilModel pupil);
//   Future<PupilModel?> getPupil(String pupilId);
//   Stream<PupilModel?> watchPupil(String pupilId);
//   Future<void> updatePupil(PupilModel pupil);
//   Future<List<PupilModel>> getPupilsByParent(String parentId);
// }
//
// @LazySingleton(as: PupilRemoteDataSource)
// class PupilRemoteDataSourceImpl implements PupilRemoteDataSource {
//   final FirebaseFirestore firestore;
//
//   PupilRemoteDataSourceImpl(this.firestore);
//
//   CollectionReference get _pupils => firestore.collection('pupils');
//
//   @override
//   Future<void> createPupil(PupilModel pupil) async {
//     await _pupils.doc(pupil.id).set(pupil.toJson());
//   }
//
//   @override
//   Future<PupilModel?> getPupil(String pupilId) async {
//     final doc = await _pupils.doc(pupilId).get();
//     if (!doc.exists) return null;
//     return PupilModel.fromFirestore(doc);
//   }
//
//   @override
//   Stream<PupilModel?> watchPupil(String pupilId) {
//     return _pupils.doc(pupilId).snapshots().map((doc) {
//       if (!doc.exists) return null;
//       return PupilModel.fromFirestore(doc);
//     });
//   }
//
//   @override
//   Future<void> updatePupil(PupilModel pupil) async {
//     await _pupils.doc(pupil.id).update(pupil.toJson());
//   }
//
//   @override
//   Future<List<PupilModel>> getPupilsByParent(String parentId) async {
//     final snapshot = await _pupils.where('parentId', isEqualTo: parentId).get();
//     return snapshot.docs.map((doc) => PupilModel.fromFirestore(doc)).toList();
//   }
// }
