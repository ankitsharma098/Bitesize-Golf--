import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthGuestSignedIn extends AuthState {
  final User user;

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

class AuthEmailVerificationSent extends AuthState {
  const AuthEmailVerificationSent();
}

// New states for profile completion
class AuthProfileCompleted extends AuthState {
  const AuthProfileCompleted();
}

class AuthProfileCompletionRequired extends AuthState {
  final User user;

  const AuthProfileCompletionRequired(this.user);

  @override
  List<Object> get props => [user];
}
