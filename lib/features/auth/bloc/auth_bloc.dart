// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../repositories/auth_repo.dart';
// import 'auth_event.dart';
// import 'auth_state.dart';
//
// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final AuthRepository _repo = AuthRepository();
//
//   AuthBloc() : super(AuthInitial()) {
//     on<AuthAppStarted>(_onAppStarted);
//     on<AuthSignUpRequested>(_onSignUp);
//     on<AuthSignInRequested>(_onSignIn);
//     on<AuthGuestSignInRequested>(_onSignInAsGuest);
//     on<AuthSignOutRequested>(_onSignOut);
//     on<AuthResetPasswordRequested>(_onResetPassword);
//     on<AuthEmailVerificationRequested>(_onEmailVerificationRequested);
//     on<AuthCompletePupilProfileRequested>(_onCompletePupilProfile);
//     on<AuthCompleteCoachProfileRequested>(_onCompleteCoachProfile);
//   }
//
//   /* ---------- Handlers ---------- */
//
//   Future<void> _onAppStarted(
//     AuthAppStarted event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(AuthLoading());
//     try {
//       final user = await _repo.getCurrentUser();
//       if (user == null) {
//         emit(const AuthUnauthenticated());
//       } else {
//         emit(
//           user.profileCompleted
//               ? AuthAuthenticated(user)
//               : AuthProfileCompletionRequired(user),
//         );
//       }
//     } catch (e) {
//       emit(AuthError(e.toString()));
//     }
//   }
//
//   Future<void> _onSignUp(
//     AuthSignUpRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(AuthLoading());
//     try {
//       final user = await _repo.signUp(
//         email: event.email,
//         password: event.password,
//         role: event.role,
//         firstName: event.firstName,
//         lastName: event.lastName,
//       );
//       emit(AuthProfileCompletionRequired(user));
//     } catch (e) {
//       emit(AuthError(e.toString()));
//     }
//   }
//
//   Future<void> _onSignIn(
//     AuthSignInRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(AuthLoading());
//     try {
//       final user = await _repo.signIn(
//         email: event.email,
//         password: event.password,
//       );
//       emit(
//         user.profileCompleted
//             ? AuthAuthenticated(user)
//             : AuthProfileCompletionRequired(user),
//       );
//     } catch (e) {
//       emit(AuthError(e.toString()));
//     }
//   }
//
//   Future<void> _onSignInAsGuest(
//     AuthGuestSignInRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(AuthLoading());
//     try {
//       final user = await _repo.signInAsGuest();
//       emit(AuthGuestSignedIn(user));
//     } catch (e) {
//       emit(AuthError(e.toString()));
//     }
//   }
//
//   Future<void> _onSignOut(
//     AuthSignOutRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(AuthLoading());
//     try {
//       await _repo.signOut();
//       emit(const AuthUnauthenticated());
//     } catch (e) {
//       emit(AuthError(e.toString()));
//     }
//   }
//
//   Future<void> _onResetPassword(
//     AuthResetPasswordRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(AuthLoading());
//     try {
//       await _repo.resetPassword(event.email);
//       emit(AuthPasswordResetSent(event.email));
//     } catch (e) {
//       emit(AuthError(e.toString()));
//     }
//   }
//
//   Future<void> _onEmailVerificationRequested(
//     AuthEmailVerificationRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(AuthLoading());
//     try {
//       await _repo.sendEmailVerification();
//       emit(const AuthEmailVerificationSent());
//     } catch (e) {
//       emit(AuthError(e.toString()));
//     }
//   }
//
//   Future<void> _onCompletePupilProfile(
//     AuthCompletePupilProfileRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(AuthLoading());
//     try {
//       await _repo.completeProfile(
//         userId: event.userId,
//         profileData: {
//           'id': event.pupilId,
//           'name': event.name,
//           'dateOfBirth': event.dateOfBirth?.toIso8601String(),
//           'handicap': event.handicap,
//           'selectedCoachId': event.selectedCoachId,
//           'selectedCoachName': event.selectedCoachName,
//           'selectedClubId': event.selectedClubId,
//           'selectedClubName': event.selectedClubName,
//           'profilePic': event.profilePic,
//         },
//       );
//
//       add(AuthAppStarted()); // Refresh user after saving
//     } catch (e) {
//       emit(AuthError(e.toString()));
//     }
//   }
//
//   Future<void> _onCompleteCoachProfile(
//     AuthCompleteCoachProfileRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(AuthLoading());
//     try {
//       await _repo.completeProfile(
//         userId: event.userId,
//         profileData: {
//           'id': event.coachId,
//           'name': event.name,
//           'experience': event.experience,
//           'selectedClubId': event.selectedClubId,
//           'selectedClubName': event.selectedClubName,
//           'profilePic': event.profilePic,
//         },
//       );
//
//       add(AuthAppStarted()); // Refresh user after saving
//     } catch (e) {
//       emit(AuthError(e.toString()));
//     }
//   }
// }
import 'package:bitesize_golf/core/utils/user_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/auth_repo.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repo = AuthRepository();

  AuthBloc() : super(AuthInitial()) {
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

  /* ---------- Handlers ---------- */

  Future<void> _onAppStarted(
    AuthAppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _repo.getCurrentUser();
      if (user == null) {
        emit(const AuthUnauthenticated());
        return;
      }

      if (!user.profileCompleted) {
        emit(AuthProfileCompletionRequired(user));
        return;
      }

      // 🔥 Check coach verification
      if (user.isCoach) {
        final coach = await UserUtil().getCurrentCoach();
        if (coach == null) {
          emit(AuthError("Coach profile not found"));
        } else if (!coach.isVerified) {
          emit(AuthCoachPendingVerification(user)); // ⬅️ New state
        } else {
          emit(AuthAuthenticated(user));
        }
      } else {
        emit(AuthAuthenticated(user));
      }
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
        role: event.role,
        firstName: event.firstName,
        lastName: event.lastName,
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

      if (!user.profileCompleted) {
        emit(AuthProfileCompletionRequired(user));
        return;
      }

      // 🔥 Check coach verification
      if (user.isCoach) {
        final coach = await UserUtil().getCurrentCoach();
        if (coach == null) {
          emit(AuthError("Coach profile not found"));
        } else if (!coach.isVerified) {
          emit(AuthCoachPendingVerification(user));
        } else {
          emit(AuthAuthenticated(user));
        }
      } else {
        emit(AuthAuthenticated(user));
      }
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
      await _repo.resetPassword(event.email);
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
          'id': event.pupilId,
          'name': event.name,
          'dateOfBirth': event.dateOfBirth?.toIso8601String(),
          'handicap': event.handicap,
          'selectedCoachId': event.selectedCoachId,
          'selectedCoachName': event.selectedCoachName,
          'selectedClubId': event.selectedClubId,
          'selectedClubName': event.selectedClubName,
          'profilePic': event.profilePic,
        },
      );

      add(AuthAppStarted()); // Refresh user after saving
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
          'id': event.coachId,
          'name': event.name,

          'experience': event.experience,
          'selectedClubId': event.selectedClubId,
          'selectedClubName': event.selectedClubName,
          'profilePic': event.profilePic,
          'verificationStatus': 'pending', // 🔥 mark pending by default
        },
      );

      add(AuthAppStarted()); // Refresh user after saving
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
