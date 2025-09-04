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

class AuthEmailVerificationRequested extends AuthEvent {}
