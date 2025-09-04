// features/auth/domain/entities/user.dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String role;
  final bool emailVerified;

  // Add these fields based on your schema
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

  const User({
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

  // Business logic getters
  bool get isGuest => role == 'guest';
  bool get isPupil => role == 'pupil';
  bool get isCoach => role == 'coach';
  bool get isAdmin => role == 'admin';

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    photoUrl,
    role,
    emailVerified,
    firstName,
    lastName,
    dateOfBirth,
    handicap,
    coachName,
    golfClubOrFacility,
    experience,
    profileCompleted,
    preferences,
    createdAt,
    updatedAt,
  ];

  // Copy with for immutability
  User copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? role,
    bool? emailVerified,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? handicap,
    String? coachName,
    String? golfClubOrFacility,
    int? experience,
    bool? profileCompleted,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => User(
    uid: uid ?? this.uid,
    email: email ?? this.email,
    displayName: displayName ?? this.displayName,
    photoUrl: photoUrl ?? this.photoUrl,
    role: role ?? this.role,
    emailVerified: emailVerified ?? this.emailVerified,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    handicap: handicap ?? this.handicap,
    coachName: coachName ?? this.coachName,
    golfClubOrFacility: golfClubOrFacility ?? this.golfClubOrFacility,
    experience: experience ?? this.experience,
    profileCompleted: profileCompleted ?? this.profileCompleted,
    preferences: preferences ?? this.preferences,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
