import 'package:bitesize_golf/Models/user%20model/user_model.dart';

import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserModel user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthGuestSignedIn extends AuthState {
  final UserModel user;

  const AuthGuestSignedIn(this.user);

  @override
  List<Object> get props => [user];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class AuthPasswordResetSent extends AuthState {
  final String email;

  const AuthPasswordResetSent(this.email);

  @override
  List<Object> get props => [email];
}

class AuthCoachPendingVerification extends AuthState {
  final UserModel user;
  const AuthCoachPendingVerification(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthEmailVerificationSent extends AuthState {
  const AuthEmailVerificationSent();
}

// New states for profile completion
class AuthProfileCompleted extends AuthState {
  const AuthProfileCompleted();
}

class AuthProfileCompletionRequired extends AuthState {
  final UserModel user;

  const AuthProfileCompletionRequired(this.user);

  @override
  List<Object> get props => [user];
}
