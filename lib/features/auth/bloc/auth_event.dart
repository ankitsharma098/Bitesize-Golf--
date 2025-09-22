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

/// Profile completion (Pupil)
class AuthCompletePupilProfileRequested extends AuthEvent {
  final String pupilId;
  final String userId;
  final String name;
  final DateTime? dateOfBirth;
  final String? handicap;

  /// user-selected values (pending approval)
  final String? selectedCoachId;
  final String? selectedCoachName;
  final String? selectedClubId;
  final String? selectedClubName;

  final String? profilePic;

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
    this.profilePic,
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
    profilePic,
  ];
}

/// Profile completion (Coach)
class AuthCompleteCoachProfileRequested extends AuthEvent {
  final String coachId;
  final String userId;
  final String name;
  final int? experience;

  /// user-selected values (pending approval)
  final String? selectedClubId;
  final String? selectedClubName;

  final String? profilePic;

  const AuthCompleteCoachProfileRequested({
    required this.coachId,
    required this.userId,
    required this.name,
    this.experience,
    this.selectedClubId,
    this.selectedClubName,
    this.profilePic,
  });

  @override
  List<Object?> get props => [
    coachId,
    userId,
    name,
    experience,
    selectedClubId,
    selectedClubName,
    profilePic,
  ];
}
