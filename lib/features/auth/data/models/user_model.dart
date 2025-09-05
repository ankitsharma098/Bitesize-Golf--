// features/auth/data/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
// ✅ FIXED: Import the entity with alias to avoid conflicts
import '../../domain/entities/user.dart' as entity;

class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final String role;
  final bool emailVerified;
  final String accountStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.accountStatus = 'active',
    this.photoURL,
    this.role = 'pupil',
    this.emailVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // ✅ FIXED: Convert to entity.User (not fb.User)
  entity.User toEntity() => entity.User(
    uid: uid,
    email: email,
    displayName: displayName,
    photoURL: photoURL,
    role: role,
    emailVerified: emailVerified,
    accountStatus: accountStatus,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  // ✅ FIXED: Rename method to avoid confusion
  factory UserModel.fromFirebase({
    required fb.User firebaseUser,
    Map<String, dynamic>? userDoc,
  }) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName ?? userDoc?['displayName'] ?? '',
      photoURL: firebaseUser.photoURL ?? userDoc?['photoURL'],
      role: userDoc?['role'] ?? 'pupil',
      emailVerified: firebaseUser.emailVerified,
      accountStatus: userDoc?['accountStatus'],
      createdAt: userDoc?['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: userDoc?['updatedAt']?.toDate() ?? DateTime.now(),
    );
  }

  // ✅ FIXED: Correct import and conversion
  factory UserModel.fromEntity(entity.User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL,
      role: user.role,
      emailVerified: user.emailVerified,
      accountStatus: user.accountStatus,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'photoURL': photoURL,
    'role': role,
    'emailVerified': emailVerified,
    'accountStatus': accountStatus,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json['uid'],
    email: json['email'],
    displayName: json['displayName'],
    photoURL: json['photoURL'],
    role: (json['role'] as String?) ?? 'pupil',
    emailVerified: json['emailVerified'] == true,
    accountStatus: json['accountStatus'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );
}
