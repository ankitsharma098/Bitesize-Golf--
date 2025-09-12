// features/auth/presentation/pages/splash_page.dart
import 'package:bitesize_golf/features/components/utils/size_config.dart';
import 'package:bitesize_golf/route/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

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
    // Trigger auth check on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(AuthAppStarted());
    });
  }

  String _getRoleBasedHome(String role) {
    switch (role) {
      case 'coach':
        return RouteNames.coachHome;
      case 'pupil':
        return RouteNames.pupilHome;
      case 'guest':
        return RouteNames.guestHome;
      default:
        return '';
    }
  }

  void _navigateIfNotAlready(String route) {
    if (!_hasNavigated && mounted) {
      _hasNavigated = true;
      // Use pushReplacement to prevent back navigation to splash
      context.pushReplacement(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          print("SplashScreen - AuthState: $state");

          // Prevent multiple navigations
          if (_hasNavigated) return;

          if (state is AuthAuthenticated) {
            print("User authenticated, checking profile completion...");
            print("profileCompleted: ${state.user.profileCompleted}");
            print("needsProfileCompletion: ${state.user.profileCompleted}");
            print("role: ${state.user.role}");

            if (state.user.profileCompleted) {
              // Profile incomplete - go to completion page
              _navigateIfNotAlready(
                state.user.isCoach
                    ? RouteNames.completeProfileCoach
                    : RouteNames.completeProfilePupil,
              );
            } else {
              // Profile complete - go to home
              _navigateIfNotAlready(_getRoleBasedHome(state.user.role));
            }
          } else if (state is AuthUnauthenticated) {
            // Not authenticated - go to welcome
            print("User unauthenticated, navigating to welcome");
            _navigateIfNotAlready(RouteNames.welcome);
          } else if (state is AuthProfileCompletionRequired) {
            // Explicitly told profile needs completion
            print("Profile completion required");
            _navigateIfNotAlready(
              state.user.isCoach
                  ? RouteNames.completeProfileCoach
                  : RouteNames.completeProfilePupil,
            );
          } else if (state is AuthGuestSignedIn) {
            print("Guest signed in, navigating to guest home");
            _navigateIfNotAlready(RouteNames.guestHome);
          } else if (state is AuthError) {
            print("Auth error: ${state.message}");
            // On error, go to welcome page
            _navigateIfNotAlready(RouteNames.welcome);
          }
          // For AuthLoading and AuthInitial states, stay on splash screen
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF2E7D32), // Golf green
                Color(0xFF4CAF50), // Lighter green
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FlutterLogo(size: 120),
                const SizedBox(height: 32),
                const Text(
                  'Bitesize Golf',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                const Text('Loading your golf experience...'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
