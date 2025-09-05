// features/auth/presentation/bloc/auth_event.dart
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthAppStarted extends AuthEvent {}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthSignInRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
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
  List<Object?> get props => [email, password, role, firstName, lastName];
}

class AuthGuestSignInRequested extends AuthEvent {}

class AuthSignOutRequested extends AuthEvent {}

class AuthUpdateProfile extends AuthEvent {
  final Map<String, dynamic> profileData;
  const AuthUpdateProfile(this.profileData);
  @override
  List<Object?> get props => [profileData];
}

class AuthResetPasswordRequested extends AuthEvent {
  final String email;
  const AuthResetPasswordRequested(this.email);
  @override
  List<Object?> get props => [email];
}
// Add these new events to the existing file

class AuthCompletePupilProfileRequested extends AuthEvent {
  final String pupilId;
  final String parentId;
  final String name;
  final DateTime? dateOfBirth;
  final String? handicap;
  final String? selectedCoachName;
  final String? selectedClubId;
  final String? avatar;

  const AuthCompletePupilProfileRequested({
    required this.pupilId,
    required this.parentId,
    required this.name,
    this.dateOfBirth,
    this.handicap,
    this.selectedCoachName,
    this.selectedClubId,
    this.avatar,
  });

  @override
  List<Object?> get props => [
    pupilId,
    parentId,
    name,
    dateOfBirth,
    handicap,
    selectedCoachName,
    selectedClubId,
    avatar,
  ];
}

class AuthCompleteCoachProfileRequested extends AuthEvent {
  final String coachId;
  final String userId;
  final String name;
  final String? bio;
  final List<String>? qualifications;
  final int? experience;
  final List<String>? specialties;
  final String? clubId;

  const AuthCompleteCoachProfileRequested({
    required this.coachId,
    required this.userId,
    required this.name,
    this.bio,
    this.qualifications,
    this.experience,
    this.specialties,
    this.clubId,
  });

  @override
  List<Object?> get props => [
    coachId,
    userId,
    name,
    bio,
    qualifications,
    experience,
    specialties,
    clubId,
  ];
}

class AuthEmailVerificationRequested extends AuthEvent {}
