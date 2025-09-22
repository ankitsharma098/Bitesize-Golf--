import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Models/user model/user_model.dart';
import '../../Models/pupil model/pupil_model.dart';
import '../../Models/coaches model/coach_model.dart';
import '../../features/auth/repositories/auth_repo.dart';
import '../constants/firebase_collections_names.dart';

class UserUtil {
  final AuthRepository _authRepo = AuthRepository();

  /// Base user (from auth + Firestore `users` collection)
  Future<UserModel?> getCurrentUser() async {
    return await _authRepo.getCurrentUser();
  }

  /// Get current pupil profile if role == pupil
  Future<PupilModel?> getCurrentPupil() async {
    final user = await getCurrentUser();
    if (user == null || !user.isPupil) return null;

    final doc = await FirestoreCollections.pupilsCol.doc(user.uid).get();
    if (!doc.exists || doc.data() == null) return null;

    return PupilModel.fromFirestore(doc.data()!);
  }

  /// Get current coach profile if role == coach
  Future<CoachModel?> getCurrentCoach() async {
    final user = await getCurrentUser();
    if (user == null || !user.isCoach) return null;

    final doc = await FirestoreCollections.coachesCol.doc(user.uid).get();
    if (!doc.exists || doc.data() == null) return null;

    return CoachModel.fromFirestore(doc.data()!);
  }

  /// Return correct profile automatically
  Future<dynamic> getProfile() async {
    final user = await getCurrentUser();
    if (user == null) return null;

    if (user.isPupil) {
      return await getCurrentPupil();
    } else if (user.isCoach) {
      return await getCurrentCoach();
    } else {
      return user; // fallback: guest or base user
    }
  }
}
