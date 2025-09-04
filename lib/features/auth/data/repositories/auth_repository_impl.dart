// features/auth/data/repositories/auth_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/user.dart' as entity;
import '../../domain/failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_firebase_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseDataSource firebaseDataSource;
  final AuthLocalDataSource localDataSource;
  final FirebaseFirestore firestore;
  final fb.FirebaseAuth firebaseAuth;

  AuthRepositoryImpl({
    required this.firebaseDataSource,
    required this.localDataSource,
    required this.firestore,
    required this.firebaseAuth,
  });

  CollectionReference<Map<String, dynamic>> get _users =>
      firestore.collection('users');
  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserDoc(String uid) async {
    return await _users.doc(uid).get();
  }

  @override
  Future<Either<Failure, entity.User>> signIn(
    String email,
    String password,
  ) async {
    try {
      // ✅ FIXED: Convert model to entity
      final userModel = await firebaseDataSource.signIn(email, password);
      await localDataSource.cacheUser(userModel);
      return Right(userModel.toEntity()); // Convert to entity
    } on fb.FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: _getAuthErrorMessage(e.code)));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

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

      final userDoc = {
        'uid': authUser.uid,
        'email': authUser.email,
        'displayName': '$firstName $lastName',
        'photoURL': authUser.photoURL ?? '',
        'role': role,
        'emailVerified': authUser.emailVerified,
        'firstName': firstName,
        'lastName': lastName,
        'profileCompleted': false,
        'preferences': _getDefaultPreferences(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _users.doc(authUser.uid).set(userDoc);

      // ✅ FIXED: Create model and convert to entity
      final userModel = UserModel.fromFirebase(
        firebaseUser: authUser,
        userDoc: userDoc,
      );

      await localDataSource.cacheUser(userModel);
      return Right(userModel.toEntity());
    } on fb.FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: _getAuthErrorMessage(e.code)));
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
        'preferences': _getDefaultPreferences(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _users.doc(authUser.uid).set(guestDoc);

      // ✅ FIXED: Convert to entity
      final userModel = UserModel.fromFirebase(
        firebaseUser: authUser,
        userDoc: guestDoc,
      );

      await localDataSource.cacheUser(userModel);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entity.User?>> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getUser();
      if (cachedUser != null) return Right(cachedUser.toEntity());

      final authUser = firebaseAuth.currentUser;
      if (authUser == null) return const Right(null);

      final userDoc = await _getUserDoc(authUser.uid);
      if (!userDoc.exists) return const Right(null);

      final userModel = UserModel.fromFirebase(
        firebaseUser: authUser,
        userDoc: userDoc.data(),
      );

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

      final userDoc = await _getUserDoc(authUser.uid);
      final userModel = UserModel.fromFirebase(
        firebaseUser: authUser,
        userDoc: userDoc.data(),
      );

      await localDataSource.cacheUser(userModel);
      yield userModel.toEntity();
    }
  }

  @override
  Future<Either<Failure, entity.User>> updateProfile(
    String uid,
    Map<String, dynamic> profileData,
  ) async {
    try {
      await _users.doc(uid).update({
        ...profileData,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final authUser = firebaseAuth.currentUser!;
      final userDoc = await _getUserDoc(uid);
      final userModel = UserModel.fromFirebase(
        firebaseUser: authUser,
        userDoc: userDoc.data(),
      );

      await localDataSource.cacheUser(userModel);

      if (profileData.containsKey('firstName') ||
          profileData.containsKey('lastName')) {
        final displayName =
            '${profileData['firstName'] ?? ''} ${profileData['lastName'] ?? ''}'
                .trim();
        await authUser.updateDisplayName(displayName);
      }

      return Right(userModel.toEntity());
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await firebaseDataSource.signOut();
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

  @override
  Future<Either<Failure, void>> updateEmail(String newEmail) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return Left(AuthFailure(message: 'No user logged in'));
      }

      await user.verifyBeforeUpdateEmail(newEmail);
      return const Right(null);
    } on fb.FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: _getAuthErrorMessage(e.code)));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword(String newPassword) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return Left(AuthFailure(message: 'No user logged in'));
      }

      await user.updatePassword(newPassword);
      return const Right(null);
    } on fb.FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: _getAuthErrorMessage(e.code)));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  // Helper methods
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
}
