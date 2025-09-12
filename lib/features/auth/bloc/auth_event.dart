import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthAppStarted extends AuthEvent {}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String role;
  final String firstName;
  final String lastName;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.role,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object> get props => [email, password, role, firstName, lastName];
}

class AuthGuestSignInRequested extends AuthEvent {}

class AuthSignOutRequested extends AuthEvent {}

class AuthResetPasswordRequested extends AuthEvent {
  final String email;

  const AuthResetPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthEmailVerificationRequested extends AuthEvent {}

// New events for profile completion
class AuthCompletePupilProfileRequested extends AuthEvent {
  final String pupilId;
  final String userId; // Changed from parentId to userId for consistency
  final String name;
  final DateTime? dateOfBirth;
  final String? handicap;
  final String? selectedCoachId; // Added - this is the key field
  final String? selectedCoachName;
  final String? selectedClubId;
  final String? selectedClubName; // Added for consistency
  final String? avatar;

  const AuthCompletePupilProfileRequested({
    required this.pupilId,
    required this.userId,
    required this.name,
    this.dateOfBirth,
    this.handicap,
    this.selectedCoachId,
    this.selectedCoachName,
    this.selectedClubId,
    this.selectedClubName,
    this.avatar,
  });

  @override
  List<Object?> get props => [
    pupilId,
    userId,
    name,
    dateOfBirth,
    handicap,
    selectedCoachId,
    selectedCoachName,
    selectedClubId,
    selectedClubName,
    avatar,
  ];
}

class AuthCompleteCoachProfileRequested extends AuthEvent {
  final String coachId;
  final String userId;
  final String name;
  final String? bio;
  final int? experience;
  final List<String>? qualifications;
  final List<String>? specialties;
  final String? selectedClubId; // Changed from clubId
  final String? selectedClubName; // Added
  final String? avatar;

  const AuthCompleteCoachProfileRequested({
    required this.coachId,
    required this.userId,
    required this.name,
    this.bio,
    this.experience,
    this.qualifications,
    this.specialties,
    this.selectedClubId,
    this.selectedClubName,
    this.avatar,
  });

  @override
  List<Object?> get props => [
    coachId,
    userId,
    name,
    bio,
    experience,
    qualifications,
    specialties,
    selectedClubId,
    selectedClubName,
    avatar,
  ];
}
