import 'package:bitesize_golf/features/auth/domain/entities/user_enums.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
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

  const User({
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

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    photoURL,
    role,
    emailVerified,
    firstName,
    lastName,
    accountStatus,
    profileCompleted,
    preferences,
    createdAt,
    updatedAt,
  ];

  User copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    String? role,
    bool? emailVerified,
    String? firstName,
    String? lastName,
    String? accountStatus,
    bool? profileCompleted,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
      emailVerified: emailVerified ?? this.emailVerified,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      accountStatus: accountStatus ?? this.accountStatus,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isCoach => role == 'coach';
  bool get isPupil => role == 'pupil';
  bool get isGuest => role == 'guest';
  bool get needsProfileCompletion => !profileCompleted && !isGuest;
}
