import 'package:bitesize_golf/route/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/bloc/auth_bloc.dart';
import '../features/auth/bloc/auth_state.dart';
import '../features/auth/presentation/pages/LetsStart_page.dart';
import '../features/auth/presentation/pages/update_coach_profile.dart';
import '../features/auth/presentation/pages/update_pupil_profile_page.dart';
import '../features/auth/presentation/pages/forgot_password.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/welcome_page.dart';
import '../features/pupils modules/home/presentation/main_wrapper.dart';
import '../features/subscription/presentation/pages/subscription_page.dart';
import '../injection.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true, // Enable for debugging
    routes: [
      // Auth routes - always accessible
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: RouteNames.welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: RouteNames.letsStart,
        name: 'letsStart',
        builder: (context, state) {
          final isPupilParam = state.uri.queryParameters['isPupil'];
          final isPupil = isPupilParam == 'true' || isPupilParam == null;
          return LetsStart(isPupil: isPupil);
        },
      ),
      GoRoute(
        path: '/subscription', // keep the same path
        name: 'subscription',
        builder: (context, state) {
          // read the query parameter ?pupilId=xyz
          final pupilId = state.uri.queryParameters['pupilId'];
          return SubscriptionScreen(pupilId: pupilId);
        },
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: RouteNames.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),

      GoRoute(
        path: RouteNames.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // Profile completion routes
      GoRoute(
        path: RouteNames.completeProfileCoach,
        name: 'completeProfileCoach',
        builder: (context, state) => const UpdateProfileCoachPage(),
      ),

      GoRoute(
        path: RouteNames.completeProfilePupil,
        name: 'completeProfilePupil',
        builder: (context, state) => const UpdatePupilProfilePage(),
      ),

      // Protected routes - only after auth
      GoRoute(
        path: RouteNames.coachHome,
        name: 'coachHome',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Coach Home - Coming Soon')),
        ),
      ),

      GoRoute(
        path: RouteNames.pupilHome,
        name: 'pupilHome',
        builder: (context, state) => const MainWrapperScreen(),
      ),

      GoRoute(
        path: RouteNames.guestHome,
        name: 'guestHome',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Guest Home - Coming Soon')),
        ),
      ),
    ],
    // Simplified redirect - let the splash screen handle most navigation logic
    redirect: _handleRedirect,
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Route not found: ${state.uri}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.splash),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );

  static String? _handleRedirect(BuildContext context, GoRouterState state) {
    final currentPath = state.uri.toString();

    print("DEBUG: Redirect - Path: $currentPath");

    // Define routes that are always accessible
    final publicRoutes = [
      RouteNames.splash,
      RouteNames.welcome,
      RouteNames.login,
      RouteNames.register,
      RouteNames.forgotPassword,
    ];

    // Allow public routes without any checks
    if (publicRoutes.contains(currentPath)) {
      return null;
    }

    // For all other routes, let the splash screen and BlocListener handle navigation
    // This prevents redirect loops

    try {
      final authBloc = getIt<AuthBloc>();
      final authState = authBloc.state;

      // Only redirect if we have a clear auth state
      if (authState is AuthUnauthenticated) {
        // User is definitely not authenticated
        if (!publicRoutes.contains(currentPath)) {
          return RouteNames.welcome;
        }
      }

      // For AuthLoading, AuthInitial, or other states, don't redirect
      // Let the splash screen handle the navigation
    } catch (e) {
      print("Error in redirect: $e");
      // If there's an error accessing the auth bloc, go to start
      return RouteNames.splash;
    }

    return null;
  }

  static String getRoleBasedHome(String role) {
    switch (role) {
      case 'coach':
        return RouteNames.coachHome;
      case 'pupil':
      case 'parent':
        return RouteNames.pupilHome;
      case 'guest':
        return RouteNames.guestHome;
      default:
        return RouteNames.pupilHome;
    }
  }
}
