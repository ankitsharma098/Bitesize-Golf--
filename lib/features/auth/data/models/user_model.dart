// features/auth/data/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/entities/user.dart' as entity;

class UserModel extends entity.User {
  const UserModel({
    required super.uid,
    super.email,
    super.displayName,
    super.photoUrl,
    super.role = 'pupil',
    super.emailVerified = false,
  });

  /// Build from FirebaseAuth user + optional Firestore /users/{uid} doc
  factory UserModel.fromFirebase({
    required fb.User authUser,
    Map<String, dynamic>? userDoc,
  }) {
    return UserModel(
      uid: authUser.uid,
      email: authUser.email ?? userDoc?['email'],
      displayName: authUser.displayName ?? userDoc?['displayName'],
      photoUrl: authUser.photoURL ?? userDoc?['photoURL'],
      role: (userDoc?['role'] as String?) ?? 'pupil',
      emailVerified:
          authUser.emailVerified || (userDoc?['emailVerified'] == true),
    );
  }

  /// Build from Firestore only (e.g., cached reload)
  factory UserModel.fromFirestoreDoc(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      email: data['email'],
      displayName: data['displayName'],
      photoUrl: data['photoURL'],
      role: (data['role'] as String?) ?? 'pupil',
      emailVerified: data['emailVerified'] == true,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json['uid'],
    email: json['email'],
    displayName: json['displayName'],
    photoUrl: json['photoURL'],
    role: (json['role'] as String?) ?? 'pupil',
    emailVerified: json['emailVerified'] == true,
  );

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'photoURL': photoUrl,
    'role': role,
    'emailVerified': emailVerified,
  };

  /// Minimal Firestore update map
  Map<String, dynamic> toFirestoreUpdate() => {
    'uid': uid,
    if (email != null) 'email': email,
    'displayName': displayName ?? '',
    'photoURL': photoUrl ?? '',
    'role': role,
    'emailVerified': emailVerified,
    'updatedAt': FieldValue.serverTimestamp(),
  };
}
