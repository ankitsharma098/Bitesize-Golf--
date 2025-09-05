// features/auth/presentation/bloc/auth_state.dart
part of 'auth_bloc.dart';

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
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  final String? reason;
  const AuthUnauthenticated([this.reason]);
  @override
  List<Object?> get props => [reason];
}

class AuthError extends AuthState {
  final String message;
  final String? code;
  const AuthError(this.message, [this.code]);
  @override
  List<Object?> get props => [message, code];
}

class AuthPasswordResetSent extends AuthState {
  final String email;
  const AuthPasswordResetSent(this.email);
  @override
  List<Object?> get props => [email];
}

class AuthEmailVerificationSent extends AuthState {
  const AuthEmailVerificationSent();
  @override
  List<Object?> get props => [];
}

class AuthEmailUpdateSent extends AuthState {
  final String newEmail;
  const AuthEmailUpdateSent(this.newEmail);
  @override
  List<Object?> get props => [newEmail];
}

class AuthPasswordUpdated extends AuthState {
  const AuthPasswordUpdated();
  @override
  List<Object?> get props => [];
}

class AuthProfileUpdated extends AuthState {
  final User user;
  const AuthProfileUpdated(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthGuestSignedIn extends AuthState {
  final User guestUser;
  const AuthGuestSignedIn(this.guestUser);
  @override
  List<Object?> get props => [guestUser];
}

// Add this new state class
class AuthProfileCompleted extends AuthState {
  const AuthProfileCompleted();

  @override
  List<Object?> get props => [];
}
