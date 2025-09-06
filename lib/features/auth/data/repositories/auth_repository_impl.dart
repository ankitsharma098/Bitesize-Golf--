import 'package:bitesize_golf/features/auth/domain/entities/subscription.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../models/join_request_models.dart';
import '../../../coaches/data/models/coach_model.dart';
import '../../../pupils/data/models/pupil_model.dart';
import '../../domain/entities/user.dart' as entity;
import '../../domain/entities/user_enums.dart';
import '../../domain/failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_firebase_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  //  final AuthFirebaseDataSource firebaseDataSource;
  final AuthLocalDataSource localDataSource;
  final FirebaseFirestore firestore;
  final fb.FirebaseAuth firebaseAuth;

  AuthRepositoryImpl({
    // required this.firebaseDataSource,
    required this.localDataSource,
    required this.firestore,
    required this.firebaseAuth,
  });

  CollectionReference<Map<String, dynamic>> get _users =>
      firestore.collection('users');
  CollectionReference<Map<String, dynamic>> get _pupils =>
      firestore.collection('pupils');
  CollectionReference<Map<String, dynamic>> get _coaches =>
      firestore.collection('coaches');
  CollectionReference<Map<String, dynamic>> get _joinRequests =>
      firestore.collection('joinRequests');

  @override
  Future<Either<Failure, entity.User>> signUp({
    required String email,
    required String password,
    required String role,
    required String firstName,
    required String lastName,
  }) async {
    try {
      // Create Firebase Auth user
      final cred = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final authUser = cred.user!;
      final now = DateTime.now();

      // Create user document
      final userModel = UserModel(
        uid: authUser.uid,
        accountStatus: 'active',
        displayName: '$firstName $lastName',
        emailVerified: authUser.emailVerified,
        firstName: firstName,
        lastName: lastName,
        profileCompleted: false,
        email: authUser.email,
        photoURL: authUser.photoURL ?? '',
        role: role,
        subscription: _getDefaultSubscription(),
        preferences: _getDefaultPreferences(),

        createdAt: now,
        updatedAt: now,
      );

      final batch = firestore.batch();

      // Add user document
      batch.set(_users.doc(authUser.uid), userModel.toJson());

      // Create role-specific profile
      if (role == 'pupil') {
        final pupilModel = PupilModel(
          id: authUser.uid,
          parentId: authUser.uid,
          name: '$firstName $lastName',
          assignedCoach: null,
          avatar: authUser.photoURL ?? '',
          createdAt: now,
          updatedAt: now,
        );
        batch.set(_pupils.doc(authUser.uid), pupilModel.toJson());

        //final pupilModel = PupilModel();
      } else if (role == 'coach') {
        // Create coach profile
        final coachModel = CoachModel(
          id: authUser.uid,
          userId: authUser.uid,
          displayName: '$firstName $lastName',
          bio: '',
          experience: 0,
          verificationStatus: 'pending',
          createdAt: now,
          updatedAt: now,
        );
        batch.set(_coaches.doc(authUser.uid), coachModel.toJson());

        // Create coach verification request
        final verificationRequest = JoinRequestModel(
          id: firestore.collection('joinRequests').doc().id,
          coachId: authUser.uid,
          requestType: 'coach_verification',
          requestedAt: now,
          createdAt: now,
          updatedAt: now,
        );
        batch.set(
          _joinRequests.doc(verificationRequest.id),
          verificationRequest.toJson(),
        );
      }

      // Commit all operations
      await batch.commit();

      // Re-read the user document to get server timestamps
      final freshSnap = await _users.doc(authUser.uid).get();

      final userMap = freshSnap.data();

      if (userMap == null) {
        return Left(AuthFailure(message: 'User data not found'));
      }

      final model = UserModel.fromFirestore(userMap);
      return Right(model.toEntity());
    } on fb.FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: _getAuthErrorMessage(e.code)));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createPupilProfile({
    required String pupilId,
    required String parentId,
    required String name,
    DateTime? dateOfBirth,
    String? handicap,
    String? selectedCoachName,
    String? selectedClubId,
    String? avatar,
  }) async {
    try {
      final now = DateTime.now();
      final pupil = PupilModel(
        id: pupilId,
        parentId: parentId,
        name: name,
        dateOfBirth: dateOfBirth,
        handicap: handicap,
        selectedCoachName: selectedCoachName,
        selectedClubId: selectedClubId,
        avatar: avatar,
        createdAt: now,
        updatedAt: now,
      );

      final batch = firestore.batch();

      // Create pupil profile
      batch.set(_pupils.doc(pupilId), pupil.toJson());

      // If a coach was selected, create a join request
      if (selectedCoachName != null && selectedCoachName.isNotEmpty) {
        // Note: In a real implementation, you'd need to find the coach by name
        // For now, we'll create a request without a specific coach ID
        final joinRequest = JoinRequestModel(
          id: firestore.collection('joinRequests').doc().id,
          pupilId: pupilId,
          parentId: parentId,
          requestType: 'pupil_to_coach',
          requestedAt: now,
          parentMessage: 'Request to join coach: $selectedCoachName',
          createdAt: now,
          updatedAt: now,
        );
        batch.set(_joinRequests.doc(joinRequest.id), joinRequest.toJson());
      }

      // Update parent's profile completion status
      batch.update(_users.doc(parentId), {
        'profileCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  // Keep existing methods...
  // @override
  // Future<Either<Failure, entity.User>> signIn(
  //   String email,
  //   String password,
  // ) async {
  //   try {
  //     final userModel = await firebaseDataSource.signIn(email, password);
  //     await localDataSource.cacheUser(userModel);
  //     return Right(userModel.toEntity());
  //   } on fb.FirebaseAuthException catch (e) {
  //     return Left(AuthFailure(message: _getAuthErrorMessage(e.code)));
  //   } catch (e) {
  //     return Left(AuthFailure(message: e.toString()));
  //   }
  // }

  @override
  Future<Either<Failure, entity.User>> signInAsGuest() async {
    try {
      final cred = await firebaseAuth.signInAnonymously();
      final authUser = cred.user!;

      final guestDoc = {
        'uid': authUser.uid,
        'email':
            'guest_${DateTime.now().millisecondsSinceEpoch}@bitesizegolf.com',
        'displayName': 'Guest User',
        'role': 'guest',
        'emailVerified': true,
        'profileCompleted': true,
        'subscription': _getDefaultSubscription(),
        'preferences': _getDefaultPreferences(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _users.doc(authUser.uid).set(guestDoc);

      final userModel = UserModel.fromFirebase(authUser);

      await localDataSource.cacheUser(userModel);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entity.User?>> getCurrentUser() async {
    try {
      final cached = await localDataSource.getUser();
      if (cached != null) {
        return Right(cached.toEntity());
      }

      final authUser = firebaseAuth.currentUser;
      if (authUser == null) {
        return const Right(null);
      }

      final userDoc = await _users.doc(authUser.uid).get();
      if (!userDoc.exists) {
        return const Right(null);
      }

      final userModel = UserModel.fromFirebase(authUser);

      await localDataSource.cacheUser(userModel);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Stream<entity.User?> authState$() async* {
    await for (final authUser in firebaseAuth.authStateChanges()) {
      if (authUser == null) {
        await localDataSource.clear();
        yield null;
        continue;
      }

      final userDoc = await _users.doc(authUser.uid).get();
      if (!userDoc.exists) {
        yield null;
        continue;
      }

      final userModel = UserModel.fromFirebase(authUser);

      await localDataSource.cacheUser(userModel);
      yield userModel.toEntity();
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      //  await firebaseDataSource.signOut();
      await localDataSource.clear();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on fb.FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: _getAuthErrorMessage(e.code)));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  // Helper methods
  Subscription? _getDefaultSubscription() => Subscription(
    autoRenew: false,
    endDate: calculateEndDate(DateTime.now()),
    startDate: DateTime.now(),
    status: SubscriptionStatus.free,
    tier: SubscriptionTier.free,
  );

  DateTime calculateEndDate(DateTime startDate) {
    // Add two months to the start date.
    // This handles month length variations correctly.
    DateTime endDate = DateTime(
      startDate.year,
      startDate.month + 2,
      startDate.day,
      startDate.hour,
      startDate.minute,
      startDate.second,
      startDate.millisecond,
      startDate.microsecond,
    );
    return endDate;
  }

  Map<String, dynamic> _getDefaultPreferences() => {
    'notifications': {
      'push': true,
      'email': true,
      'sms': false,
      'reminders': true,
      'streakWarnings': true,
      'coachFeedback': true,
    },
    'units': 'metric',
    'language': 'en',
    'timezone': 'UTC',
    'theme': 'auto',
    'playbackSpeed': 1.0,
    'captionsEnabled': false,
    'autoplay': true,
  };

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Invalid password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password must be 6 characters or more.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'too-many-requests':
        return 'Too many unsuccessful login attempts. Please try again later.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  @override
  Future<Either<Failure, void>> createCoachProfile({
    required String coachId,
    required String userId,
    required String name,
    String? bio,
    int? experience,
    String? clubId,
  }) {
    // TODO: implement createCoachProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateEmail(String newEmail) {
    // TODO: implement updateEmail
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updatePassword(String newPassword) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, entity.User>> updateProfile(
    String uid,
    Map<String, dynamic> profileData,
  ) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, entity.User>> signIn(String email, String password) {
    // TODO: implement signIn
    throw UnimplementedError();
  }
}
