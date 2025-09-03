// features/auth/presentation/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signIn;
  final SignUpUseCase signUp;
  final SignOutUseCase signOut;
  final CheckAuthStatusUseCase authStatus;

  AuthBloc({
    required this.signIn,
    required this.signUp,
    required this.signOut,
    required this.authStatus,
  }) : super(AuthInitial()) {
    on<AuthAppStarted>((event, emit) async {
      emit(AuthLoading());
      await emit.forEach(
        authStatus(),
        onData: (user) => user == null
            ? const AuthUnauthenticated()
            : AuthAuthenticated(user),
        onError: (e, st) => AuthError(e.toString()),
      );
    });

    on<AuthSignInRequested>((event, emit) async {
      emit(AuthLoading());
      final res = await signIn(email: event.email, password: event.password);
      res.fold(
        (l) => emit(AuthError(l.message)),
        (r) => emit(AuthAuthenticated(r)),
      );
    });

    on<AuthSignUpRequested>((event, emit) async {
      emit(AuthLoading());
      final res = await signUp(email: event.email, password: event.password);
      res.fold(
        (l) => emit(AuthError(l.message)),
        (r) => emit(AuthAuthenticated(r)),
      );
    });

    on<AuthSignOutRequested>((event, emit) async {
      final res = await signOut();
      res.fold(
        (l) => emit(AuthError(l.message)),
        (_) => const AuthUnauthenticated(),
      );
    });
  }
}
