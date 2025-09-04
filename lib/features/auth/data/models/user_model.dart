// features/auth/data/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
// ✅ FIXED: Import the entity with alias to avoid conflicts
import '../../domain/entities/user.dart' as entity;

class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String role;
  final bool emailVerified;
  final String? firstName;
  final String? lastName;
  final DateTime? dateOfBirth;
  final String? handicap;
  final String? coachName;
  final String? golfClubOrFacility;
  final int? experience;
  final bool profileCompleted;
  final Map<String, dynamic> preferences;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.role = 'pupil',
    this.emailVerified = false,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.handicap,
    this.coachName,
    this.golfClubOrFacility,
    this.experience,
    this.profileCompleted = false,
    required this.preferences,
    required this.createdAt,
    required this.updatedAt,
  });

  // ✅ FIXED: Convert to entity.User (not fb.User)
  entity.User toEntity() => entity.User(
    uid: uid,
    email: email,
    displayName: displayName,
    photoUrl: photoUrl,
    role: role,
    emailVerified: emailVerified,
    firstName: firstName,
    lastName: lastName,
    dateOfBirth: dateOfBirth,
    handicap: handicap,
    coachName: coachName,
    golfClubOrFacility: golfClubOrFacility,
    experience: experience,
    profileCompleted: profileCompleted,
    preferences: preferences,
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
      photoUrl: firebaseUser.photoURL ?? userDoc?['photoURL'],
      role: userDoc?['role'] ?? 'pupil',
      emailVerified: firebaseUser.emailVerified,
      firstName: userDoc?['firstName'],
      lastName: userDoc?['lastName'],
      dateOfBirth: userDoc?['dateOfBirth']?.toDate(),
      handicap: userDoc?['handicap'],
      coachName: userDoc?['coachName'],
      golfClubOrFacility: userDoc?['golfClubOrFacility'],
      experience: userDoc?['experience'],
      profileCompleted: userDoc?['profileCompleted'] ?? false,
      preferences: Map<String, dynamic>.from(userDoc?['preferences'] ?? {}),
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
      photoUrl: user.photoUrl,
      role: user.role,
      emailVerified: user.emailVerified,
      firstName: user.firstName,
      lastName: user.lastName,
      dateOfBirth: user.dateOfBirth,
      handicap: user.handicap,
      coachName: user.coachName,
      golfClubOrFacility: user.golfClubOrFacility,
      experience: user.experience,
      profileCompleted: user.profileCompleted,
      preferences: user.preferences,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'role': role,
    'emailVerified': emailVerified,
    'firstName': firstName,
    'lastName': lastName,
    'dateOfBirth': dateOfBirth,
    'handicap': handicap,
    'coachName': coachName,
    'golfClubOrFacility': golfClubOrFacility,
    'experience': experience,
    'profileCompleted': profileCompleted,
    'preferences': preferences,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json['uid'],
    email: json['email'],
    displayName: json['displayName'],
    photoUrl: json['photoURL'],
    role: (json['role'] as String?) ?? 'pupil',
    emailVerified: json['emailVerified'] == true,
    preferences: json['preferences'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );
}
