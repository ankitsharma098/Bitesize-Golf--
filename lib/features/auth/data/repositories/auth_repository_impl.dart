import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../models/join_request_models.dart';
import '../../../coaches/data/models/coach_model.dart';
import '../../../pupils modules/pupil/data/models/pupil_model.dart';
import '../../../subscription/data/model/subscription.dart';
import '../../domain/entities/user.dart' as entity;
import '../../domain/entities/user_enums.dart';
import '../../../../failure.dart';
import '../../domain/repositories/auth_repository.dart';
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
        preferences: _getDefaultPreferences(),
        createdAt: now,
        updatedAt: now,
      );

      final batch = firestore.batch();

      // User document
      batch.set(_users.doc(authUser.uid), userModel.toJson());

      // Role-specific document using SAME ID as user
      if (role == 'pupil') {
        final pupilModel = PupilModel.create(
          id: authUser.uid,
          userId: authUser.uid,
          name: '$firstName $lastName',
          avatar: authUser.photoURL,
        ).copyWith(subscription: _getDefaultSubscription());
        batch.set(_pupils.doc(authUser.uid), pupilModel.toJson());
      } else if (role == 'coach') {
        final coachModel = CoachModel.create(
          id: authUser.uid, // Use user ID as document ID
          userId: authUser.uid,
          name: '$firstName $lastName',
        );
        batch.set(_coaches.doc(authUser.uid), coachModel.toJson());
      }

      await batch.commit();

      final freshSnap = await _users.doc(authUser.uid).get();
      final userMap = freshSnap.data();

      if (userMap == null) {
        return Left(AuthFailure(message: 'User data not found'));
      }

      final model = UserModel.fromFirestore(userMap);
      await localDataSource.cacheUser(userModel);
      return Right(model.toEntity());
    } on fb.FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: _getAuthErrorMessage(e.code)));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCoachProfile({
    required String coachId, // This becomes userId
    required String userId,
    required String name,
    String? bio,
    int? experience,
    List<String>? qualifications,
    List<String>? specialties,
    String? selectedClubName,
    String? selectedClubId,
    String? avatar,
  }) async {
    try {
      final now = DateTime.now();

      // Get existing coach data first
      final existingDoc = await _coaches.doc(userId).get();
      final existingData = existingDoc.data() ?? {};

      // Create updated coach model
      final updatedCoach = CoachModel(
        id: userId, // Always use userId
        userId: userId,
        name: name,
        bio: bio ?? '',
        experience: experience ?? 0,
        qualifications: qualifications ?? [],
        specialties: specialties ?? [],
        selectedClubId: selectedClubId,
        selectedClubName: selectedClubName,
        clubAssignmentStatus: selectedClubId != null ? 'pending' : 'none',
        // Preserve existing fields
        assignedClubId: existingData['assignedClubId'],
        assignedClubName: existingData['assignedClubName'],
        clubAssignedAt: existingData['clubAssignedAt']?.toDate(),
        verificationStatus: existingData['verificationStatus'] ?? 'pending',
        verifiedBy: existingData['verifiedBy'],
        verifiedAt: existingData['verifiedAt']?.toDate(),
        verificationNote: existingData['verificationNote'],
        maxPupils: existingData['maxPupils'] ?? 20,
        currentPupils: existingData['currentPupils'] ?? 0,
        acceptingNewPupils: existingData['acceptingNewPupils'] ?? true,
        stats: existingData['stats'] ?? CoachModel.getDefaultStats(),
        createdAt: existingData['createdAt']?.toDate() ?? now,
        updatedAt: now,
      );

      final batch = firestore.batch();

      // 1. ALWAYS update coach profile (using userId as document ID)
      batch.set(_coaches.doc(userId), updatedCoach.toJson());

      // 2. ALWAYS update user profile completion
      batch.update(_users.doc(userId), {
        'profileCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 3. Handle join request logic SEPARATELY
      String? joinRequestResult;

      if (selectedClubId != null &&
          selectedClubId!.isNotEmpty &&
          selectedClubName != null &&
          selectedClubName!.isNotEmpty) {
        // Check for existing pending join request
        final existingRequests = await _joinRequests
            .where('requesterId', isEqualTo: userId)
            .where('requestType', isEqualTo: 'coach_to_club')
            .where('targetClubId', isEqualTo: selectedClubId)
            .where('status', isEqualTo: 'pending')
            .get();

        if (existingRequests.docs.isNotEmpty) {
          // UPDATE existing request with new information
          final existingRequest = existingRequests.docs.first;
          final updatedRequestData = {
            'requesterName': name, // Update with new name
            'targetClubName': selectedClubName, // Update club name if changed
            'message': "I would like to join your club as a coach",
            'updatedAt': FieldValue.serverTimestamp(),
          };

          batch.update(
            _joinRequests.doc(existingRequest.id),
            updatedRequestData,
          );
          joinRequestResult = "existing_updated";
        } else {
          // CREATE new join request
          final joinRequest = JoinRequestModel.coachToClub(
            id: '${userId}_${selectedClubId}_${now.millisecondsSinceEpoch}',
            coachUserId: userId,
            coachName: name,
            clubId: selectedClubId!,
            clubName: selectedClubName!,
            message: "I would like to join your club as a coach",
          );

          batch.set(_joinRequests.doc(joinRequest.id), joinRequest.toJson());
          joinRequestResult = "new_created";
        }
      }

      // Commit all changes
      await batch.commit();

      // Log success for debugging
      print('✅ Profile updated successfully. Join request: $joinRequestResult');

      return const Right(null);
    } catch (e) {
      print('❌ Error updating coach profile: $e');
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePupilProfile({
    required String pupilId, // This becomes userId
    required String userId,
    required String name,
    DateTime? dateOfBirth,
    String? handicap,
    String? selectedCoachName,
    String? selectedCoachId,
    String? selectedClubName,
    String? selectedClubId,
    String? avatar,
  }) async {
    try {
      final now = DateTime.now();

      // 🐛 DEBUG: Print all incoming parameters
      print('🔍 DEBUG - Pupil Profile Update:');
      print('   userId: $userId');
      print('   name: $name');
      print('   selectedCoachId: $selectedCoachId');
      print('   selectedCoachName: $selectedCoachName');

      // Get existing pupil data first
      final existingDoc = await _pupils.doc(userId).get();
      final existingData = existingDoc.data() ?? {};

      // Parse existing pupil model to preserve all fields
      final existingPupil = PupilModel.fromJson(existingData);

      // Create updated pupil model using copyWith to preserve existing data
      final updatedPupil = existingPupil.copyWith(
        name: name,
        dateOfBirth: dateOfBirth,
        handicap: handicap,
        selectedCoachId: selectedCoachId,
        selectedCoachName: selectedCoachName,
        selectedClubId: selectedClubId,
        selectedClubName: selectedClubName,
        avatar: avatar,
        assignmentStatus: selectedCoachId != null ? 'pending' : 'none',
        updatedAt: now,
        lastActivityDate: now, // Profile update counts as activity
      );

      final batch = firestore.batch();

      // 1. ALWAYS update pupil profile
      batch.set(_pupils.doc(userId), updatedPupil.toJson());
      print('✅ Added pupil profile update to batch');

      // 2. ALWAYS update user profile completion
      batch.update(_users.doc(userId), {
        'profileCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('✅ Added user profile completion to batch');

      // 3. Handle join request logic SEPARATELY
      String? joinRequestResult = "none_needed";

      // 🐛 DEBUG: Check conditions step by step
      print('🔍 Checking join request conditions:');
      print('   selectedCoachId != null: ${selectedCoachId != null}');
      print('   selectedCoachId!.isNotEmpty: ${selectedCoachId?.isNotEmpty}');
      print('   selectedCoachName != null: ${selectedCoachName != null}');
      print(
        '   selectedCoachName!.isNotEmpty: ${selectedCoachName?.isNotEmpty}',
      );

      if (selectedCoachId != null &&
          selectedCoachId!.isNotEmpty &&
          selectedCoachName != null &&
          selectedCoachName!.isNotEmpty) {
        print(
          '🔍 Join request conditions met, checking for existing requests...',
        );

        // Check for existing pending join request
        final existingRequests = await _joinRequests
            .where('requesterId', isEqualTo: userId)
            .where('requestType', isEqualTo: 'pupil_to_coach')
            .where('targetCoachId', isEqualTo: selectedCoachId)
            .where('status', isEqualTo: 'pending')
            .get();

        print('🔍 Found ${existingRequests.docs.length} existing requests');

        if (existingRequests.docs.isNotEmpty) {
          // UPDATE existing request with new information
          final existingRequest = existingRequests.docs.first;
          final updatedRequestData = {
            'requesterName': name, // Update with new name
            'targetCoachName':
                selectedCoachName, // Update coach name if changed
            'message': "Please accept me as your student",
            'updatedAt': FieldValue.serverTimestamp(),
          };

          batch.update(
            _joinRequests.doc(existingRequest.id),
            updatedRequestData,
          );
          joinRequestResult = "existing_updated";
          print('✅ Updated existing join request: ${existingRequest.id}');
        } else {
          // CREATE new join request
          final joinRequestId =
              '${userId}_${selectedCoachId}_${now.millisecondsSinceEpoch}';

          final joinRequest = JoinRequestModel.pupilToCoach(
            id: joinRequestId,
            pupilUserId: userId,
            pupilName: name,
            coachId: selectedCoachId!,
            coachName: selectedCoachName!,
            message: "Please accept me as your student",
          );

          print('🔍 Creating new join request:');
          print('   Request ID: $joinRequestId');
          print('   Pupil User ID: $userId');
          print('   Pupil Name: $name');
          print('   Coach ID: ${selectedCoachId!}');
          print('   Coach Name: ${selectedCoachName!}');

          batch.set(_joinRequests.doc(joinRequest.id), joinRequest.toJson());
          joinRequestResult = "new_created";
          print('✅ Added new join request to batch: $joinRequestId');
        }
      } else {
        print(
          '❌ Join request conditions NOT met - no coach selected or incomplete data',
        );
      }

      // Commit all changes
      print(
        '🔍 Committing batch with ${joinRequestResult} join request result...',
      );
      await batch.commit();

      // Final success log
      print(
        '✅ Pupil profile updated successfully. Join request: $joinRequestResult',
      );

      return const Right(null);
    } catch (e) {
      print('❌ Error updating pupil profile: $e');
      print('❌ Stack trace: ${StackTrace.current}');
      return Left(AuthFailure(message: e.toString()));
    }
  }

  Future<bool> _hasExistingJoinRequest({
    required String requesterId,
    required String requestType,
    String? targetCoachId,
    String? targetClubId,
  }) async {
    Query query = _joinRequests
        .where('requesterId', isEqualTo: requesterId)
        .where('requestType', isEqualTo: requestType)
        .where('status', isEqualTo: 'pending');

    if (targetCoachId != null) {
      query = query.where('targetCoachId', isEqualTo: targetCoachId);
    }
    if (targetClubId != null) {
      query = query.where('targetClubId', isEqualTo: targetClubId);
    }

    final snap = await query.get();
    print('🔍 Guard query: ${snap.docs.length} docs found'); // ⬅️ debug
    return snap.docs.isNotEmpty;
  }

  @override
  Future<Either<Failure, void>> updateCoachProfileWithDupeCheck({
    required String coachId,
    required String userId,
    required String name,
    String? bio,
    int? experience,
    List<String>? qualifications,
    List<String>? specialties,
    String? selectedClubName,
    String? selectedClubId,
    String? avatar,
  }) async {
    try {
      final now = DateTime.now();

      // Check for existing join request if club is selected
      if (selectedClubId != null && selectedClubId!.isNotEmpty) {
        final hasExisting = await _hasExistingJoinRequest(
          requesterId: userId,
          requestType: 'coach_to_club',
          targetClubId: selectedClubId,
        );

        if (hasExisting) {
          return Left(
            AuthFailure(
              message: 'You already have a pending request to this club',
            ),
          );
        }
      }

      // Rest of the function remains the same as updateCoachProfile
      final existingDoc = await _coaches.doc(coachId).get();
      final existingData = existingDoc.data() ?? {};

      final updatedCoach = CoachModel(
        id: coachId,
        userId: userId,
        name: name,
        bio: bio ?? '',
        experience: experience ?? 0,
        qualifications: qualifications ?? [],
        specialties: specialties ?? [],
        selectedClubId: selectedClubId,
        selectedClubName: selectedClubName,
        clubAssignmentStatus: selectedClubId != null ? 'pending' : 'none',
        assignedClubId: existingData['assignedClubId'],
        assignedClubName: existingData['assignedClubName'],
        clubAssignedAt: existingData['clubAssignedAt']?.toDate(),
        verificationStatus: existingData['verificationStatus'] ?? 'pending',
        verifiedBy: existingData['verifiedBy'],
        verifiedAt: existingData['verifiedAt']?.toDate(),
        verificationNote: existingData['verificationNote'],
        maxPupils: existingData['maxPupils'] ?? 20,
        currentPupils: existingData['currentPupils'] ?? 0,
        acceptingNewPupils: existingData['acceptingNewPupils'] ?? true,
        stats: existingData['stats'] ?? CoachModel.getDefaultStats(),
        createdAt: existingData['createdAt']?.toDate() ?? now,
        updatedAt: now,
      );

      final batch = firestore.batch();
      batch.set(_coaches.doc(coachId), updatedCoach.toJson());

      if (selectedClubId != null &&
          selectedClubId!.isNotEmpty &&
          selectedClubName != null &&
          selectedClubName!.isNotEmpty) {
        final requestDocRef = _joinRequests.doc();
        final joinRequest = JoinRequestModel.coachToClub(
          id: requestDocRef.id,
          coachUserId: userId,
          coachName: name,
          clubId: selectedClubId!,
          clubName: selectedClubName!,
          message: "I would like to join your club as a coach",
        );

        batch.set(requestDocRef, joinRequest.toJson());
      }

      batch.update(_users.doc(userId), {
        'profileCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

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
      // final cached = await localDataSource.getUser();
      // if (cached != null) {
      //   print("Cached User Found");
      //   return Right(cached.toEntity());
      // }

      // await localDataSource.clear();

      final authUser = firebaseAuth.currentUser;
      if (authUser == null) {
        print("No user found in the auth");
        return const Right(null);
      }

      final userDoc = await _users.doc(authUser.uid).get();
      if (!userDoc.exists) {
        print("No user found in the user collection");
        return const Right(null);
      }

      // ✅ USE FIRESTORE DATA instead of Firebase Auth data
      final userModel = UserModel.fromFirestore(userDoc.data()!);

      print("User role from Firestore: ${userModel.role}");
      print("Profile completed: ${userModel.profileCompleted}");

      await localDataSource.cacheUser(userModel);
      return Right(userModel.toEntity());
    } catch (e) {
      print("Error getting current user: $e");
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

      // ✅ USE FIRESTORE DATA instead of Firebase Auth data
      final userModel = UserModel.fromFirestore(userDoc.data()!);

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
  Future<Either<Failure, entity.User>> signIn(String email, String password) {
    // TODO: implement signIn
    throw UnimplementedError();
  }
}
