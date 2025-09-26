import 'package:bitesize_golf/Models/coaches%20model/coach_model.dart';
import 'package:bitesize_golf/core/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../route/routes_names.dart';
import '../../components/custom_scaffold.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<AuthBloc>().add(AuthAppStarted());
    // });
  }

  void _navigateIfNotAlready(String route) {
    if (!_hasNavigated && mounted) {
      _hasNavigated = true;
      context.go(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (_hasNavigated) return;

        if (state is AuthAuthenticated) {
          if (state.user.isCoach) {
            _navigateIfNotAlready(RouteNames.coachHome);
          } else {
            _navigateIfNotAlready(RouteNames.pupilHome);
          }
        } else if (state is AuthCoachPendingVerification) {
          _navigateIfNotAlready(RouteNames.pendingVerification);
        } else if (state is AuthProfileCompletionRequired) {
          _navigateIfNotAlready(
            state.user.isCoach
                ? RouteNames.completeProfileCoach
                : RouteNames.completeProfilePupil,
          );
        } else if (state is AuthUnauthenticated) {
          _navigateIfNotAlready(RouteNames.welcome);
        } else if (state is AuthGuestSignedIn) {
          _navigateIfNotAlready(RouteNames.guestHome);
        } else if (state is AuthError) {
          _navigateIfNotAlready(RouteNames.welcome);
        }
      },

      child: AppScaffold.splash(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/logo/logo.png", width: 100, height: 100),
              const SizedBox(height: 40),
              const LinearProgressIndicator(
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
