import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class UserModel {
  final String uid;
  final String? email;
  final String role;
  final bool emailVerified;
  final String accountStatus;
  final bool profileCompleted;
  final String? profilePic;
  final String? firstName; // ✅ new
  final String? lastName; // ✅ new
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.uid,
    this.email,
    this.role = 'pupil',
    this.emailVerified = false,
    this.accountStatus = 'active',
    this.profileCompleted = false,
    this.profilePic,
    this.firstName, // ✅
    this.lastName, // ✅
    required this.createdAt,
    required this.updatedAt,
  });
  bool get isActive => accountStatus == 'active';
  bool get isProfileComplete => profileCompleted;

  /// Role helpers
  bool get isPupil => role.toLowerCase() == 'pupil';
  bool get isCoach => role.toLowerCase() == 'coach';
  bool get isGuest => role.toLowerCase() == 'guest';
  UserModel copyWith({
    String? uid,
    String? email,
    String? role,
    bool? emailVerified,
    String? accountStatus,
    bool? profileCompleted,
    String? profilePic,
    String? firstName, // ✅
    String? lastName, // ✅
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      role: role ?? this.role,
      emailVerified: emailVerified ?? this.emailVerified,
      accountStatus: accountStatus ?? this.accountStatus,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      profilePic: profilePic ?? this.profilePic,
      firstName: firstName ?? this.firstName, // ✅
      lastName: lastName ?? this.lastName, // ✅
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'uid': uid,
    'email': email,
    'role': role,
    'emailVerified': emailVerified,
    'accountStatus': accountStatus,
    'profileCompleted': profileCompleted,
    'profilePic': profilePic,
    'firstName': firstName, // ✅
    'lastName': lastName, // ✅
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };

  factory UserModel.fromFirestore(
    Map<String, dynamic> data, {
    required String id,
  }) => UserModel(
    uid: id,
    email: data['email'],
    role: data['role'] ?? 'pupil',
    emailVerified: data['emailVerified'] ?? false,
    accountStatus: data['accountStatus'] ?? 'active',
    profileCompleted: data['profileCompleted'] ?? false,
    profilePic: data['profilePic'],
    firstName: data['firstName'], // ✅
    lastName: data['lastName'], // ✅
    createdAt: (data['createdAt'] as Timestamp).toDate(),
    updatedAt: (data['updatedAt'] as Timestamp).toDate(),
  );

  factory UserModel.fromFirebase(fb.User firebaseUser) => UserModel(
    uid: firebaseUser.uid,
    email: firebaseUser.email,
    emailVerified: firebaseUser.emailVerified,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}
