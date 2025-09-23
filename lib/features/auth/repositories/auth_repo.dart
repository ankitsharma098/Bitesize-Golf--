import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/storage/shared_preference_utils.dart';
import '../../../Models/club model/golf_club_model.dart';
import '../../../Models/coaches model/coach_model.dart';
import '../../../Models/joining request models/coach_to_club_request.dart';
import '../../../Models/joining request models/coach_verification_request.dart';
import '../../../Models/joining request models/pupil_to_coach_request.dart';
import '../../../Models/pupil model/level_progress.dart';
import '../../../Models/pupil model/pupil_model.dart';
import '../../../Models/user model/user_model.dart';
import '../../../core/constants/firebase_collections_names.dart';

class AuthRepository {
  final fb.FirebaseAuth _firebaseAuth = fb.FirebaseAuth.instance;

  /// Get current signed-in user
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return null;

      final userDoc = await FirestoreCollections.usersCol
          .doc(firebaseUser.uid)
          .get();
      if (!userDoc.exists) return null;

      return UserModel.fromFirestore(userDoc.data()!, id: userDoc.id);
    } catch (e) {
      print('❌ Error getting current user: $e');
      return null;
    }
  }

  /// Sign up new user
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = credential.user!;

      final userModel = UserModel(
        uid: firebaseUser.uid,
        email: email,
        role: role,
        firstName: firstName,
        lastName: lastName,
        profileCompleted: false,
        emailVerified: firebaseUser.emailVerified,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final batch = FirebaseFirestore.instance.batch();

      // Save user
      batch.set(
        FirestoreCollections.usersCol.doc(userModel.uid),
        userModel.toFirestore(),
      );

      // Save role-specific document
      if (role == 'pupil') {
        final pupil = PupilModel(
          id: userModel.uid,
          name: '$firstName $lastName',
          lastActivityDate: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        batch.set(
          FirestoreCollections.pupilsCol.doc(userModel.uid),
          pupil.toFirestore(),
        );
      } else if (role == 'coach') {
        final coach = CoachModel(
          id: userModel.uid,
          name: '$firstName $lastName',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        batch.set(
          FirestoreCollections.coachesCol.doc(userModel.uid),
          coach.toFirestore(),
        );
      }

      await batch.commit();
      await SharedPrefsService.storeUserId(userModel.uid);

      return userModel;
    } catch (e) {
      throw Exception(_handleFirebaseError(e));
    }
  }

  /// Sign in existing user
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = await getCurrentUser();
      if (user == null) throw Exception('User book bloc not found');

      await SharedPrefsService.storeUserId(user.uid);
      return user;
    } catch (e) {
      throw Exception(_handleFirebaseError(e));
    }
  }

  /// Guest login
  Future<UserModel> signInAsGuest() async {
    try {
      final credential = await _firebaseAuth.signInAnonymously();
      final firebaseUser = credential.user!;

      final userModel = UserModel(
        uid: firebaseUser.uid,
        email: 'guest_${DateTime.now().millisecondsSinceEpoch}@guest.com',
        role: 'guest',
        profileCompleted: true,
        emailVerified: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await FirestoreCollections.usersCol
          .doc(userModel.uid)
          .set(userModel.toFirestore());

      await SharedPrefsService.storeUserId(userModel.uid);
      return userModel;
    } catch (e) {
      throw Exception(_handleFirebaseError(e));
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
  }

  /// Complete profile + create join requests
  Future<void> completeProfile({
    required String userId,
    required Map<String, dynamic> profileData,
  }) async {
    final userDoc = await FirestoreCollections.usersCol.doc(userId).get();
    if (!userDoc.exists) throw Exception('User not found');

    final user = UserModel.fromFirestore(userDoc.data()!, id: userId);
    final role = user.role;

    // Step 1: update user + role document
    await FirebaseFirestore.instance.runTransaction((tx) async {
      tx.update(FirestoreCollections.usersCol.doc(userId), {
        'profileCompleted': true,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
        ...profileData,
      });

      if (role == 'pupil') {
        final defaultLevel = {'1': LevelProgress.initial().toJson()};
        tx.update(FirestoreCollections.pupilsCol.doc(userId), {
          ...profileData,
          'levelProgress': FieldValue.arrayUnion(
            [],
          ), // prevent null merge issues
          'levelProgress': defaultLevel,
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        });
      } else if (role == 'coach') {
        tx.update(FirestoreCollections.coachesCol.doc(userId), {
          ...profileData,
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        });
      }
    });

    // Step 2: create requests
    // --- Pupil -> Coach request ---
    if (role == 'pupil') {
      final coachId = profileData['selectedCoachId'];
      final coachName = profileData['selectedCoachName'];

      if (coachId != null && coachName != null) {
        // Check if request already exists
        final existingReq = await FirestoreCollections.pupilCoachReqCol
            .where('pupilId', isEqualTo: userId)
            .where('coachId', isEqualTo: coachId)
            .where(
              'status',
              whereIn: ['pending', 'approved'],
            ) // avoid duplicates
            .limit(1)
            .get();

        if (existingReq.docs.isNotEmpty) {
          throw Exception("You already have a request with this coach.");
        }

        // Create new request
        final req = PupilToCoachRequest.create(
          id: FirestoreCollections.pupilCoachReqCol.doc().id,
          pupilId: userId,
          pupilName: profileData['name'] ?? '',
          coachId: coachId,
          coachName: coachName,
          clubId: profileData['selectedClubId'],
          clubName: profileData['selectedClubName'],
        );
        await FirestoreCollections.pupilCoachReqCol
            .doc(req.id)
            .set(req.toFirestore());
      }
    }
    // --- Coach -> Club request ---
    else if (role == 'coach') {
      final clubId = profileData['selectedClubId'];
      final clubName = profileData['selectedClubName'];

      if (clubId != null && clubName != null) {
        // Check if request already exists
        final existingReq = await FirestoreCollections.coachClubReqCol
            .where('coachId', isEqualTo: userId)
            .where('clubId', isEqualTo: clubId)
            .where('status', whereIn: ['pending', 'approved'])
            .limit(1)
            .get();

        if (existingReq.docs.isNotEmpty) {
          throw Exception(
            "You are already in this club or have a pending request.",
          );
        }

        // Create new request
        final req = CoachToClubRequest.create(
          id: FirestoreCollections.coachClubReqCol.doc().id,
          coachId: userId,
          coachName: profileData['name'] ?? '',
          clubId: clubId,
          clubName: clubName,
        );
        await FirestoreCollections.coachClubReqCol
            .doc(req.id)
            .set(req.toFirestore());
      }

      // Coach Verification request (always)
      final verReq = CoachVerificationRequest.create(
        id: FirestoreCollections.coachVerifReqCol.doc().id,
        coachId: userId,
        coachName: profileData['name'] ?? '',
      );
      await FirestoreCollections.coachVerifReqCol
          .doc(verReq.id)
          .set(verReq.toFirestore());
    }
  }

  Future<List<ClubModel>> getAllClubs() async {
    try {
      final snapshot = await FirestoreCollections.clubsCol
          .where('isActive', isEqualTo: true) // ✅ only active clubs
          .get();

      return snapshot.docs
          .map((doc) => ClubModel.fromFirestore(doc.data(), id: doc.id))
          .toList();
    } catch (e) {
      throw Exception(_handleFirebaseError(e));
    }
  }

  Future<List<CoachModel>> getAllCoachesByClubId(String clubId) async {
    try {
      final snapshot = await FirestoreCollections.coachesCol
          .where(
            'assignedClubId',
            isEqualTo: clubId,
          ) // ✅ only coaches for that club
          .where(
            'verificationStatus',
            isEqualTo: 'verified',
          ) // ✅ only approved coaches
          .get();

      return snapshot.docs
          .map((doc) => CoachModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw Exception(_handleFirebaseError(e));
    }
  }

  /// Firebase error handler
  String _handleFirebaseError(dynamic error) {
    if (error is fb.FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'Invalid email address';
        case 'user-disabled':
          return 'This account has been disabled';
        case 'user-not-found':
          return 'No user found with this email';
        case 'wrong-password':
          return 'Incorrect password';
        case 'email-already-in-use':
          return 'An account already exists with this email';
        case 'weak-password':
          return 'Password must be at least 6 characters';
        case 'network-request-failed':
          return 'Network error. Check your connection';
        case 'too-many-requests':
          return 'Too many attempts. Try again later';
        default:
          return error.message ?? 'Authentication error occurred';
      }
    }
    return error.toString();
  }
}
