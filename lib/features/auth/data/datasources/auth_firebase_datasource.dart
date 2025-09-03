// features/auth/data/datasources/auth_firebase_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:injectable/injectable.dart';
import '../models/user_model.dart';

abstract class AuthFirebaseDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password);
  Future<void> signOut();
  Future<UserModel?> currentUser();
  Stream<UserModel?> authState$();
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

  Future<Map<String, dynamic>?> _getUserDoc(String uid) async {
    final doc = await _users.doc(uid).get();
    return doc.data();
  }

  Future<void> _ensureUserDocument(fb.User u) async {
    final ref = _users.doc(u.uid);
    final snap = await ref.get();
    if (!snap.exists) {
      await ref.set({
        'uid': u.uid,
        'email': u.email,
        'displayName': u.displayName ?? '',
        'photoURL': u.photoURL ?? '',
        'role': 'pupil', // default role
        'emailVerified': u.emailVerified,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      await ref.update({
        'emailVerified': u.emailVerified,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    final cred = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user!;
    await _ensureUserDocument(user);
    final userDoc = await _getUserDoc(user.uid);
    return UserModel.fromFirebase(authUser: user, userDoc: userDoc);
  }

  @override
  Future<UserModel> signUp(String email, String password) async {
    final cred = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user!;
    await _ensureUserDocument(user);
    final userDoc = await _getUserDoc(user.uid);
    return UserModel.fromFirebase(authUser: user, userDoc: userDoc);
  }

  @override
  Future<void> signOut() => firebaseAuth.signOut();

  @override
  Future<UserModel?> currentUser() async {
    final u = firebaseAuth.currentUser;
    if (u == null) return null;
    final userDoc = await _getUserDoc(u.uid);
    return UserModel.fromFirebase(authUser: u, userDoc: userDoc);
    // If userDoc is null on first login, defaults are applied.
  }

  @override
  Stream<UserModel?> authState$() {
    return firebaseAuth.authStateChanges().asyncMap((u) async {
      if (u == null) return null;
      final userDoc = await _getUserDoc(u.uid);
      return UserModel.fromFirebase(authUser: u, userDoc: userDoc);
    });
  }
}
