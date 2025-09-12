import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repo.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repo;
  AuthBloc({required AuthRepository repo})
    : _repo = repo,
      super(AuthInitial()) {
    on<AuthAppStarted>(_onAppStarted);
    on<AuthSignUpRequested>(_onSignUp);
    on<AuthSignInRequested>(_onSignIn);
    on<AuthGuestSignInRequested>(_onSignInAsGuest);
    on<AuthSignOutRequested>(_onSignOut);
    on<AuthResetPasswordRequested>(_onResetPassword);
    on<AuthEmailVerificationRequested>(_onEmailVerificationRequested);
    on<AuthCompletePupilProfileRequested>(_onCompletePupilProfile);
    on<AuthCompleteCoachProfileRequested>(_onCompleteCoachProfile);
  }

  /* ---------- helpers ---------- */
  UserModel _userFromRepo(UserModel model) =>
      model; // identity – no mapping needed

  /* ---------- handlers ---------- */
  Future<void> _onAppStarted(
    AuthAppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      final user = await _repo.getCurrentUser();
      if (user == null) return emit(const AuthUnauthenticated());
      emit(
        user.profileCompleted
            ? AuthAuthenticated(user)
            : AuthProfileCompletionRequired(user),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUp(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _repo.signUp(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        role: event.role,
      );
      emit(AuthProfileCompletionRequired(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignIn(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _repo.signIn(
        email: event.email,
        password: event.password,
      );
      emit(
        user.profileCompleted
            ? AuthAuthenticated(user)
            : AuthProfileCompletionRequired(user),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInAsGuest(
    AuthGuestSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _repo.signInAsGuest();
      emit(AuthGuestSignedIn(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOut(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _repo.signOut();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onResetPassword(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _repo.resetPassword(email: event.email);
      emit(AuthPasswordResetSent(event.email));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onEmailVerificationRequested(
    AuthEmailVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _repo.sendEmailVerification();
      emit(const AuthEmailVerificationSent());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCompletePupilProfile(
    AuthCompletePupilProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _repo.completeProfile(
        userId: event.userId,
        profileData: {
          'pupilId': event.pupilId,
          'name': event.name,
          'dateOfBirth': event.dateOfBirth?.toIso8601String(),
          'handicap': event.handicap,
          'selectedCoachId': event.selectedCoachId,
          'selectedCoachName': event.selectedCoachName,
          'selectedClubId': event.selectedClubId,
          'selectedClubName': event.selectedClubName,
          'avatar': event.avatar,
        },
      );
      add(AuthAppStarted()); // refresh user
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCompleteCoachProfile(
    AuthCompleteCoachProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _repo.completeProfile(
        userId: event.userId,
        profileData: {
          'coachId': event.coachId,
          'name': event.name,
          'bio': event.bio,
          'experience': event.experience,
          'qualifications': event.qualifications,
          'specialties': event.specialties,
          'selectedClubId': event.selectedClubId,
          'selectedClubName': event.selectedClubName,
          'avatar': event.avatar,
        },
      );
      add(AuthAppStarted()); // refresh user
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
