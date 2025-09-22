import 'package:bitesize_golf/features/coach%20module/session/presentation/start_new_session.dart';
import 'package:bitesize_golf/route/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/utils/pending_approval_screen.dart';
import '../features/auth subscription/presentation/auth_subscription_screen.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../features/auth/bloc/auth_state.dart';
import '../features/auth/presentation/LetsStart_page.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/register_page.dart';
import '../features/auth/presentation/splash_page.dart';
import '../features/auth/presentation/update_coach_profile.dart';
import '../features/auth/presentation/update_pupil_profile_page.dart';
import '../features/auth/presentation/forgot_password.dart';
import '../features/auth/presentation/welcome_page.dart';
import '../features/coach module/home/presentation/main_wrapper.dart';
import '../features/coach module/statistics/presentation/pupil_stats_screen.dart';
import '../features/coach module/statistics/presentation/search_stats_screen.dart';
import '../features/guest module/home/presentation/main_wrapper.dart';
import '../features/pupils modules/home/presentation/main_wrapper.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.pendingVerification,
        name: 'pendingVerification',
        builder: (context, state) => const PendingApprovalScreen(),
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
        path: '/subscription',
        name: 'subscription',
        builder: (context, state) {
          // read the query parameter ?pupilId=xyz
          final pupilId = state.uri.queryParameters['pupilId'];
          return SubscriptionScreen();
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
        builder: (context, state) => const CoachMainWrapperScreen(),
      ),
      GoRoute(
        path: RouteNames.createSession,
        name: 'create-session',
        builder: (context, state) => const CreateSessionScreen(),
      ),

      GoRoute(
        path: RouteNames.pupilHome,
        name: '/pupil/home',
        builder: (context, state) => const PupilMainWrapperScreen(),
      ),

      GoRoute(
        path: RouteNames.guestHome,
        name: 'guestHome',
        builder: (context, state) => const MainGuestWrapperScreen(),
      ),
      GoRoute(
        path: RouteNames.pupilstats,
        name: 'Statistics',
        builder: (context, state) => PupilStatsScreen(),
      ),
      GoRoute(
        path: RouteNames.searchStats,
        name: 'searchStats',
        builder: (context, state) => SearchStatsScreen(),
      ),
    ],
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
      final authBloc = context.read<AuthBloc>();
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
