// features/auth/data/datasources/auth_firebase_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:injectable/injectable.dart';
import '../models/user_model.dart';

abstract class AuthFirebaseDataSource {
  Future<UserModel> signIn(String email, String password);
  // Future<UserModel> signUp(
  //   String email,
  //   String password,
  //   String role,
  //   String firstName,
  //   String lastName,
  // );
  Future<void> signOut();
  Future<UserModel?> currentUser();
  Stream<UserModel?> authState$();
  Future<UserModel> updateUserProfile(
    String uid,
    Map<String, dynamic> profileData,
  );
  Future<void> sendPasswordResetEmail(String email);
}

@LazySingleton(as: AuthFirebaseDataSource)
class AuthFirebaseDataSourceImpl implements AuthFirebaseDataSource {
  final fb.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthFirebaseDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  CollectionReference<Map<String, dynamic>> get _users =>
      firestore.collection('users');

  @override
  Future<UserModel> signIn(String email, String password) async {
    final cred = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final authUser = cred.user!;
    final userDoc = await _getUserDoc(authUser.uid);

    return UserModel.fromFirebase(authUser);
  }

  // @override
  // Future<UserModel> signUp(
  //   String email,
  //   String password,
  //   String role,
  //   String firstName,
  //   String lastName,
  // ) async {
  //   final cred = await firebaseAuth.createUserWithEmailAndPassword(
  //     email: email,
  //     password: password,
  //   );
  //
  //   final authUser = cred.user!;
  //
  //   // Create user document
  //   final userDoc = {
  //     'uid': authUser.uid,
  //     'email': authUser.email,
  //     'displayName': '$firstName $lastName',
  //     'photoURL': authUser.photoURL ?? '',
  //     'role': role,
  //     'emailVerified': authUser.emailVerified,
  //     'accountStatus': 'active',
  //     'createdAt': FieldValue.serverTimestamp(),
  //     'updatedAt': FieldValue.serverTimestamp(),
  //   };
  //
  //   await _users.doc(authUser.uid).set(userDoc);
  //
  //   return UserModel.fromFirebase(firebaseUser: authUser, userDoc: userDoc);
  // }

  @override
  Future<UserModel?> currentUser() async {
    final authUser = firebaseAuth.currentUser;
    if (authUser == null) return null;

    final freshSnap = await _users.doc(authUser.uid).get();

    final userMap = freshSnap.data();

    final model = UserModel.fromFirestore(userMap!);

    return model;
  }

  @override
  Stream<UserModel?> authState$() {
    return firebaseAuth.authStateChanges().asyncMap((authUser) async {
      if (authUser == null) return null;

      final freshSnap = await _users.doc(authUser.uid).get();

      final userMap = freshSnap.data();

      final model = UserModel.fromFirestore(userMap!);
      return model;
    });
  }

  // @override
  // Future<UserModel> updateUserProfile(
  //   String uid,
  //   Map<String, dynamic> profileData,
  // ) async {
  //   await _users.doc(uid).update({
  //     ...profileData,
  //     'updatedAt': FieldValue.serverTimestamp(),
  //   });
  //
  //   final authUser = firebaseAuth.currentUser!;
  //   final userDoc = await _getUserDoc(uid);
  //
  //   return UserModel.fromFirebase(firebaseUser: authUser, userDoc: userDoc);
  // }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<Map<String, dynamic>?> _getUserDoc(String uid) async {
    final doc = await _users.doc(uid).get();
    return doc.data();
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

  @override
  Future<UserModel> updateUserProfile(
    String uid,
    Map<String, dynamic> profileData,
  ) {
    // TODO: implement updateUserProfile
    throw UnimplementedError();
  }
}
