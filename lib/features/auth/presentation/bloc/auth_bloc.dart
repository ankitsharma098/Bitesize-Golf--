import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/sign_in_guest_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/update_coach_profile_usecase.dart';
import '../../domain/usecases/update_pupil_profile_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final UpdateCoachProfileUseCase updateCoachProfileUseCase;
  final UpdatePupilProfileUseCase updatePupilProfileUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final SignInAsGuestUseCase signInAsGuestUseCase;
  final fb.FirebaseAuth firebaseAuth;

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.checkAuthStatusUseCase,
    required this.updateCoachProfileUseCase,
    required this.updatePupilProfileUseCase,
    required this.resetPasswordUseCase,
    required this.signInAsGuestUseCase,
    required this.firebaseAuth,
  }) : super(AuthInitial()) {
    on<AuthAppStarted>(_onAppStarted);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthGuestSignInRequested>(_onGuestSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthResetPasswordRequested>(_onResetPasswordRequested);
    on<AuthEmailVerificationRequested>(_onEmailVerificationRequested);
    on<AuthCompletePupilProfileRequested>(_onCompletePupilProfile);
    on<AuthCompleteCoachProfileRequested>(_onCompleteCoachProfile);
  }
  Future<void> _onAppStarted(
    AuthAppStarted event,
    Emitter<AuthState> emit,
  ) async {
    print("AuthBloc: App started event received");
    emit(AuthLoading());

    try {
      // Give Firebase Auth more time to initialize properly
      await Future.delayed(const Duration(milliseconds: 800));

      final result = await checkAuthStatusUseCase();

      result.fold(
        (failure) {
          print("AuthBloc: Auth check failed - ${failure.message}");
          emit(AuthError(failure.message));
        },
        (user) {
          if (user != null) {
            print("AuthBloc: User found - ${user.uid}");
            print("AuthBloc: Profile completed - ${user.profileCompleted}");
            print(
              "AuthBloc: Needs profile completion - ${user.needsProfileCompletion}",
            );

            // Use the entity's needsProfileCompletion property
            if (user.needsProfileCompletion) {
              print("AuthBloc: Emitting AuthProfileCompletionRequired");
              emit(AuthProfileCompletionRequired(user));
            } else {
              print("AuthBloc: Emitting AuthAuthenticated");
              emit(AuthAuthenticated(user));
            }
          } else {
            print("AuthBloc: No user found, emitting AuthUnauthenticated");
            emit(const AuthUnauthenticated());
          }
        },
      );
    } catch (e) {
      print("AuthBloc: Exception in _onAppStarted - $e");
      emit(AuthError(e.toString()));
    }
  }

  // Future<void> _onAppStarted(
  //   AuthAppStarted event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(AuthLoading());
  //
  //   try {
  //     // Give Firebase Auth time to initialize
  //     await Future.delayed(const Duration(milliseconds: 500));
  //
  //     final user = await checkAuthStatusUseCase();
  //     if (user != null) {
  //       // Check if profile completion is needed
  //       print("User not null $user");
  //       if (user.needsProfileCompletion) {
  //         print("User profile not complete");
  //         emit(AuthProfileCompletionRequired(user));
  //       } else {
  //         print("User is authenicated");
  //         emit(AuthAuthenticated(user));
  //       }
  //     } else {
  //       emit(const AuthUnauthenticated());
  //     }
  //   } catch (e) {
  //     emit(AuthError(e.toString()));
  //   }
  // }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signInUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold((failure) => emit(AuthError(failure.message)), (user) {
      if (user.needsProfileCompletion) {
        emit(AuthProfileCompletionRequired(user));
      } else {
        emit(AuthAuthenticated(user));
      }
    });
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

    result.fold((failure) => emit(AuthError(failure.message)), (user) {
      // After successful signup, user needs to complete profile
      if (user.role == 'pupil') {
        emit(AuthProfileCompletionRequired(user));
      } else if (user.role == 'coach') {
        // Coach profile is created automatically but needs verification
        emit(AuthProfileCompletionRequired(user));
      } else {
        emit(AuthAuthenticated(user));
      }
    });
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
      (_) => emit(const AuthUnauthenticated()),
    );
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

  Future<void> _onCompletePupilProfile(
    AuthCompletePupilProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await updatePupilProfileUseCase(
      pupilId: event.pupilId,
      userId: event.userId, // Now correctly using userId
      name: event.name,
      dateOfBirth: event.dateOfBirth,
      handicap: event.handicap,
      selectedCoachId: event.selectedClubId,
      selectedCoachName: event.selectedCoachName,
      selectedClubId: event.selectedClubId,
      selectedClubName: event.selectedClubName, // Added
      avatar: event.avatar,
    );

    result.fold((failure) => emit(AuthError(failure.message)), (_) {
      // After profile completion, check auth status to get updated user
      add(AuthAppStarted());
    });
  }

  Future<void> _onCompleteCoachProfile(
    AuthCompleteCoachProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await updateCoachProfileUseCase(
      coachId: event.coachId,
      userId: event.userId,
      name: event.name,
      bio: event.bio,
      experience: event.experience,
      qualifications: event.qualifications,
      specialties: event.specialties,
      selectedClubId: event.selectedClubId, // Changed from clubId
      selectedClubName: event.selectedClubName, // Added
      avatar: event.avatar,
    );

    result.fold((failure) => emit(AuthError(failure.message)), (_) {
      // After profile completion, check auth status to get updated user
      add(AuthAppStarted());
    });
  }
}
