import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../entities/user.dart' as entity;
import '../entities/user.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final String role;
  final bool emailVerified;
  final String? firstName;
  final String? lastName;
  final String accountStatus;
  final bool profileCompleted;
  final Map<String, dynamic>? preferences;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.role = 'pupil',
    this.emailVerified = false,
    this.firstName,
    this.lastName,
    this.accountStatus = 'active',
    this.profileCompleted = false,
    this.preferences,
    required this.createdAt,
    required this.updatedAt,
  });

  /* ---------- to / from entity ---------- */

  User toEntity() => User(
    uid: uid,
    email: email,
    displayName: displayName,
    photoURL: photoURL,
    role: role,
    emailVerified: emailVerified,
    firstName: firstName,
    lastName: lastName,
    accountStatus: accountStatus,
    profileCompleted: profileCompleted,
    preferences: preferences,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  /* ---------- to / from JSON ---------- */

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'photoURL': photoURL,
    'role': role,
    'emailVerified': emailVerified,
    'firstName': firstName,
    'lastName': lastName,
    'accountStatus': accountStatus,
    'profileCompleted': profileCompleted,
    'preferences': preferences,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json['uid'] as String,
    email: json['email'] as String?,
    displayName: json['displayName'] as String?,
    photoURL: json['photoURL'] as String?,
    role: json['role'] as String? ?? 'pupil',
    emailVerified: json['emailVerified'] as bool? ?? false,
    firstName: json['firstName'] as String?,
    lastName: json['lastName'] as String?,
    accountStatus: json['accountStatus'] as String? ?? 'active',
    profileCompleted: json['profileCompleted'] as bool? ?? false,
    preferences: json['preferences'] as Map<String, dynamic>?,
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  /* ---------- from Firebase Auth only ---------- */

  factory UserModel.fromFirebase(fb.User firebaseUser) => UserModel(
    uid: firebaseUser.uid,
    email: firebaseUser.email,
    displayName: firebaseUser.displayName,
    photoURL: firebaseUser.photoURL,
    emailVerified: firebaseUser.emailVerified,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  factory UserModel.fromFirestore(Map<String, dynamic> data) => UserModel(
    uid: data['uid'] as String,
    email: data['email'] as String?,
    displayName: data['displayName'] as String?,
    photoURL: data['photoURL'] as String?,
    role: data['role'] as String? ?? 'pupil',
    emailVerified: data['emailVerified'] as bool? ?? false,
    firstName: data['firstName'] as String?,
    lastName: data['lastName'] as String?,
    accountStatus: data['accountStatus'] as String? ?? 'active',
    profileCompleted: data['profileCompleted'] as bool? ?? false,
    preferences: data['preferences'] as Map<String, dynamic>?,
    createdAt: (data['createdAt'] as Timestamp).toDate(),
    updatedAt: (data['updatedAt'] as Timestamp).toDate(),
  );
}
