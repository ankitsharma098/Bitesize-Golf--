import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../entities/user.dart';
import '../models/user_model.dart';

@LazySingleton()
class AuthRepository {
  final fb.FirebaseAuth _firebaseAuth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

      return UserModel.fromFirestore(
        userDoc.data() as Map<String, dynamic>,
      ).toEntity(); // This now returns User entity
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

      // Create role-specific document
      if (role == 'pupil') {
        batch.set(_pupils.doc(firebaseUser.uid), {
          'userId': firebaseUser.uid,
          'name': '$firstName $lastName',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else if (role == 'coach') {
        batch.set(_coaches.doc(firebaseUser.uid), {
          'userId': firebaseUser.uid,
          'name': '$firstName $lastName',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

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

  // Complete profile
  Future<void> completeProfile({
    required String userId,
    required Map<String, dynamic> profileData,
  }) async {
    try {
      final batch = _firestore.batch();

      // Update user document
      batch.update(_users.doc(userId), {
        'profileCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
        ...profileData,
      });

      // Update role-specific document
      final userDoc = await _users.doc(userId).get();
      final userData = userDoc.data() as Map<String, dynamic>;
      final role = userData['role'];

      if (role == 'pupil') {
        batch.update(_pupils.doc(userId), {
          ...profileData,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else if (role == 'coach') {
        batch.update(_coaches.doc(userId), {
          ...profileData,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to complete profile: $e');
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
