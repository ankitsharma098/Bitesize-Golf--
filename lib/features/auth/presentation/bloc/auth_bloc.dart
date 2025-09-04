// features/auth/presentation/bloc/auth_bloc.dart
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/sign_in_guest_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final SignInAsGuestUseCase signInAsGuestUseCase;
  final fb.FirebaseAuth firebaseAuth; // ✅ INJECTED

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.checkAuthStatusUseCase,
    required this.updateProfileUseCase,
    required this.resetPasswordUseCase,
    required this.signInAsGuestUseCase,
    required this.firebaseAuth,
  }) : super(AuthInitial()) {
    on<AuthAppStarted>(_onAppStarted);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthGuestSignInRequested>(_onGuestSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthUpdateProfile>(_onUpdateProfile);
    on<AuthResetPasswordRequested>(_onResetPasswordRequested);
    on<AuthEmailVerificationRequested>(_onEmailVerificationRequested);
  }

  // In your AuthBloc - update _onAppStarted
  Future<void> _onAppStarted(
    AuthAppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      // Give Firebase Auth time to initialize
      await Future.delayed(const Duration(milliseconds: 500));

      final user = await checkAuthStatusUseCase();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signInUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signUpUseCase(
      email: event.email,
      password: event.password,
      role: event.role,
      firstName: event.firstName,
      lastName: event.lastName,
    );

    print("result--------------------------------> ${result}");

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onGuestSignInRequested(
    AuthGuestSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signInAsGuestUseCase();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthGuestSignedIn(user)),
    );
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signOutUseCase();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => const AuthUnauthenticated(),
    );
  }

  Future<void> _onUpdateProfile(
    AuthUpdateProfile event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    if (state is AuthAuthenticated) {
      final currentUser = (state as AuthAuthenticated).user;

      final result = await updateProfileUseCase(
        uid: currentUser.uid,
        profileData: event.profileData,
      );

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (updatedUser) => emit(AuthProfileUpdated(updatedUser)),
      );
    }
  }

  Future<void> _onResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await resetPasswordUseCase(email: event.email);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthPasswordResetSent(event.email)),
    );
  }

  Future<void> _onEmailVerificationRequested(
    AuthEmailVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = firebaseAuth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        emit(const AuthEmailVerificationSent());
      } else {
        emit(const AuthError('No user logged in'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
