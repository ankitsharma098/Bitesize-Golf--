import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../models/join_request_models.dart';
import '../../../coaches/data/models/coach_model.dart';
import '../../../joining request/repo/joining_request_repo.dart';
import '../../../pupils modules/pupil/data/models/pupil_model.dart';
import '../entities/user.dart';
import '../models/user_model.dart';

@LazySingleton()
class AuthRepository {
  final fb.FirebaseAuth _firebaseAuth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final JoinRequestRepository _joinRequestRepo; // Add this

  // Constructor injection
  AuthRepository(this._joinRequestRepo);

  // Collections
  CollectionReference get _users => _firestore.collection('users');
  CollectionReference get _pupils => _firestore.collection('pupils');
  CollectionReference get _coaches => _firestore.collection('coaches');

  // Check current auth status
  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return null;

      final userDoc = await _users.doc(firebaseUser.uid).get();

      print("User Doc ----${userDoc}");
      if (!userDoc.exists) return null;

      User user = UserModel.fromFirestore(
        userDoc.data() as Map<String, dynamic>,
      ).toEntity();

      print("Role ---> ${user.role}");
      return user;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Sign up new user
  Future<User> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    try {
      // Create Firebase Auth user
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user!;

      // Create user model
      final userModel = UserModel(
        uid: firebaseUser.uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        displayName: '$firstName $lastName',
        role: role,
        profileCompleted: false,
        emailVerified: firebaseUser.emailVerified,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to Firestore using batch
      final batch = _firestore.batch();

      // Create user document
      batch.set(_users.doc(firebaseUser.uid), userModel.toJson());

      if (role == 'pupil') {
        final pupilModel = PupilModel.create(
          id: userModel.uid, // Use userId as document ID
          userId: userModel.uid,
          name: '$firstName $lastName',
        );
        batch.set(_pupils.doc(userModel.uid), pupilModel.toJson());
      } else if (role == 'coach') {
        final coachModel = CoachModel.create(
          id: userModel.uid, // Use userId as document ID
          userId: userModel.uid,
          name: '$firstName $lastName',
        );
        batch.set(_coaches.doc(userModel.uid), coachModel.toJson());
      }

      // Create role-specific document
      // if (role == 'pupil') {
      //   batch.set(_pupils.doc(firebaseUser.uid), {
      //     'userId': firebaseUser.uid,
      //     'name': '$firstName $lastName',
      //     'createdAt': FieldValue.serverTimestamp(),
      //     'updatedAt': FieldValue.serverTimestamp(),
      //   });
      // } else if (role == 'coach') {
      //   batch.set(_coaches.doc(firebaseUser.uid), {
      //     'userId': firebaseUser.uid,
      //     'name': '$firstName $lastName',
      //     'createdAt': FieldValue.serverTimestamp(),
      //     'updatedAt': FieldValue.serverTimestamp(),
      //   });
      // }

      await batch.commit();
      return userModel.toEntity();
    } catch (e) {
      throw _handleFirebaseError(e);
    }
  }

  // Sign in user
  Future<User> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = await getCurrentUser();
      if (user == null) throw Exception('User data not found');

      return user;
    } catch (e) {
      throw _handleFirebaseError(e);
    }
  }

  // Sign in as guest
  Future<User> signInAsGuest() async {
    try {
      final credential = await _firebaseAuth.signInAnonymously();
      final firebaseUser = credential.user!;

      final userModel = UserModel(
        uid: firebaseUser.uid,
        email: 'guest_${DateTime.now().millisecondsSinceEpoch}@guest.com',
        displayName: 'Guest User',
        role: 'guest',
        profileCompleted: true, // Guests don't need profile completion
        emailVerified: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save guest user to Firestore
      await _users.doc(firebaseUser.uid).set(userModel.toJson());

      return userModel.toEntity();
    } catch (e) {
      throw _handleFirebaseError(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw _handleFirebaseError(e);
    }
  }

  // Reset password
  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleFirebaseError(e);
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
      } else {
        throw Exception('No user logged in');
      }
    } catch (e) {
      throw Exception('Failed to send email verification: $e');
    }
  }

  // Complete profile with join request creation
  // Improved version of the completeProfile method with better error handling

  // Improved and Simplified version of completeProfile method
  // This uses separate transactions for better error handling

  Future<void> completeProfile({
    required String userId,
    required Map<String, dynamic> profileData,
  }) async {
    try {
      // Step 1: Get current user data and validate
      final userDoc = await _users.doc(userId).get();
      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final role = userData['role'] as String;
      final userName =
          profileData['name'] as String? ?? userData['displayName'] as String;

      // Step 2: Check for duplicate requests BEFORE any updates
      await _checkForDuplicateRequests(
        userId: userId,
        role: role,
        profileData: profileData,
      );

      // Step 3: Update profile in a transaction (safer for profile data)
      await _firestore.runTransaction((transaction) async {
        // Update user document
        transaction.update(_users.doc(userId), {
          'profileCompleted': true,
          'updatedAt': FieldValue.serverTimestamp(),
          ...profileData,
        });

        // Update role-specific document
        DocumentReference roleRef;
        if (role == 'pupil') {
          roleRef = _pupils.doc(userId);
        } else if (role == 'coach') {
          roleRef = _coaches.doc(userId);
        } else {
          throw Exception('Invalid role: $role');
        }

        transaction.update(roleRef, {
          ...profileData,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });

      // Step 4: Create join requests using the existing repository method
      // This is done AFTER profile completion to ensure consistency
      try {
        await _createJoinRequestsAfterProfile(
          userId: userId,
          userName: userName,
          role: role,
          profileData: profileData,
        );
      } catch (joinRequestError) {
        // Log the error but don't fail the entire process
        // The user's profile is complete, but requests need to be created manually
        print(
          '⚠️  Profile completed but failed to create join requests: $joinRequestError',
        );
        print(
          '💡 User can manually create requests later or admin can create them',
        );

        // Optionally, you could set a flag in the user document indicating
        // that join requests need to be created
        await _users.doc(userId).update({
          'joinRequestsNeedCreation': true,
          'joinRequestError': joinRequestError.toString(),
        });
      }
    } catch (e) {
      throw Exception('Failed to complete profile: $e');
    }
  }

  /// Check for duplicate requests before creating new ones
  Future<void> _checkForDuplicateRequests({
    required String userId,
    required String role,
    required Map<String, dynamic> profileData,
  }) async {
    if (role == 'pupil') {
      final coachId = profileData['selectedCoachId'] as String?;
      if (coachId != null) {
        final exists = await _joinRequestRepo.requestExists(
          requesterId: userId,
          requestType: 'pupil_to_coach',
          targetCoachId: coachId,
        );
        if (exists) {
          throw Exception('A request to this coach already exists');
        }
      }
    } else if (role == 'coach') {
      final clubId = profileData['selectedClubId'] as String?;

      // Check club request
      if (clubId != null) {
        final clubRequestExists = await _joinRequestRepo.requestExists(
          requesterId: userId,
          requestType: 'coach_to_club',
          targetClubId: clubId,
        );
        if (clubRequestExists) {
          throw Exception('A request to this club already exists');
        }
      }

      // Check verification request
      final verificationExists = await _joinRequestRepo.requestExists(
        requesterId: userId,
        requestType: 'coach_verification',
      );
      if (verificationExists) {
        throw Exception('A verification request already exists');
      }
    }
  }

  /// Create join requests after successful profile completion
  /// Create join requests after successful profile completion
  Future<void> _createJoinRequestsAfterProfile({
    required String userId,
    required String userName,
    required String role,
    required Map<String, dynamic> profileData,
  }) async {
    // Determine what join requests to create
    bool createCoachRequest = false;
    bool createClubRequest = false;
    bool createVerificationRequest = false;

    String? targetCoachId;
    String? targetCoachName;
    String? targetClubId;
    String? targetClubName;

    if (role == 'pupil') {
      print("Pupil Profile Data ${profileData}");

      // Extract coach information
      targetCoachId = profileData['selectedCoachId'] as String?;
      targetCoachName = profileData['selectedCoachName'] as String?;

      // 🔧 FIX: Extract club information for pupil requests
      targetClubId = profileData['selectedClubId'] as String?;
      targetClubName = profileData['selectedClubName'] as String?;

      // Debug logging
      print('🏛️ AuthRepo: Extracted club data for pupil:');
      print('   targetClubId: $targetClubId');
      print('   targetClubName: $targetClubName');

      createCoachRequest = targetCoachId != null && targetCoachName != null;
    } else if (role == 'coach') {
      targetClubId = profileData['selectedClubId'] as String?;
      targetClubName = profileData['selectedClubName'] as String?;
      createClubRequest = targetClubId != null && targetClubName != null;
      createVerificationRequest = true; // All coaches need verification
    }

    // Use the existing repository method for creating requests
    if (createCoachRequest || createClubRequest || createVerificationRequest) {
      await _joinRequestRepo.createJoinRequestsBatch(
        userId: userId,
        userName: userName,
        userRole: role,
        targetCoachId: targetCoachId,
        targetCoachName: targetCoachName,
        targetClubId: targetClubId, // Now this will have the correct value
        targetClubName: targetClubName, // Now this will have the correct value
        createCoachRequest: createCoachRequest,
        createClubRequest: createClubRequest,
        createVerificationRequest: createVerificationRequest,
        message: 'Profile completion request',
      );

      print('✅ Join requests created for $role: $userName');
      if (createCoachRequest) print('  - Pupil → Coach request created');
      if (createClubRequest) print('  - Coach → Club request created');
      if (createVerificationRequest)
        print('  - Coach verification request created');

      // Clear the error flags if requests were created successfully
      await _users.doc(userId).update({
        'joinRequestsNeedCreation': FieldValue.delete(),
        'joinRequestError': FieldValue.delete(),
      });
    }
  }

  /// Helper method to retry creating join requests for users who had failures
  Future<void> retryJoinRequestCreation(String userId) async {
    try {
      final userDoc = await _users.doc(userId).get();
      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final needsCreation = userData['joinRequestsNeedCreation'] as bool?;

      if (needsCreation != true) {
        print('✅ User $userId does not need join request creation');
        return;
      }

      final role = userData['role'] as String;
      final userName = userData['displayName'] as String;

      // Extract profile data from user document
      final profileData = <String, dynamic>{
        if (userData.containsKey('selectedCoachId'))
          'selectedCoachId': userData['selectedCoachId'],
        if (userData.containsKey('selectedCoachName'))
          'selectedCoachName': userData['selectedCoachName'],
        if (userData.containsKey('selectedClubId'))
          'selectedClubId': userData['selectedClubId'],
        if (userData.containsKey('selectedClubName'))
          'selectedClubName': userData['selectedClubName'],
      };

      await _createJoinRequestsAfterProfile(
        userId: userId,
        userName: userName,
        role: role,
        profileData: profileData,
      );

      print('✅ Successfully created join requests for user $userId');
    } catch (e) {
      print('❌ Failed to retry join request creation for user $userId: $e');
      throw e;
    }
  }

  // Handle Firebase errors
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
