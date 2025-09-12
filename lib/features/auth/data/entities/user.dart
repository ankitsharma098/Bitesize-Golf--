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

  bool get isCoach => role == 'coach';
  bool get isPupil => role == 'pupil';
  bool get isGuest => role == 'guest';
}
