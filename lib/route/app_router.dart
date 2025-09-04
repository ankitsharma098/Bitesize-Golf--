// lib/route/app_router.dart
import 'package:bitesize_golf/route/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../features/auth/presentation/bloc/auth_bloc.dart';

import '../features/auth/domain/entities/user.dart';

// Auth pages
import '../features/auth/presentation/pages/coach_profile.dart';
import '../features/auth/presentation/pages/complete_pupil_profile_page.dart';
import '../features/auth/presentation/pages/forgot_password.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/welcome_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.letStart,
    routes: [
      // ---------- Auth Routes ----------
      GoRoute(
        path: RouteNames.letStart,
        name: 'letStart',
        builder: (context, state) => BlocListener<AuthBloc, AuthState>(
          listener: (context, authState) {
            if (authState is AuthAuthenticated) {
              if (authState.user.profileCompleted) {
                context.go(_getRoleBasedHome(authState.user.role));
              } else {
                context.go(
                  authState.user.isCoach
                      ? RouteNames.completeProfileCoach
                      : RouteNames.completeProfilePupil,
                );
              }
            } else if (authState is AuthUnauthenticated) {
              context.go(RouteNames.welcome);
            }
          },
          child: const SplashScreen(),
        ),
      ),

      GoRoute(
        path: RouteNames.welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomePage(),
      ),

      GoRoute(
        path: RouteNames.login,
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

      // ---------- Profile Completion Routes ----------
      GoRoute(
        path: RouteNames.completeProfileCoach,
        name: 'completeProfileCoach',
        builder: (context, state) => const CompleteProfileCoachPage(),
      ),

      GoRoute(
        path: RouteNames.completeProfilePupil,
        name: 'completeProfilePupil',
        builder: (context, state) => const CompleteProfilePupilPage(),
      ),

      // ---------- Main Routes ----------
      GoRoute(
        path: RouteNames.coachHome,
        name: 'coachHome',
        builder: (context, state) => const Placeholder(),
      ),

      GoRoute(
        path: RouteNames.pupilHome,
        name: 'pupilHome',
        builder: (context, state) => const Placeholder(),
      ),

      GoRoute(
        path: RouteNames.guestHome,
        name: 'guestHome',
        builder: (context, state) => const Placeholder(),
      ),
    ],
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;

      // Allow initial state to load
      if (authState is AuthInitial || authState is AuthLoading) {
        return null;
      }

      final publicRoutes = [
        RouteNames.welcome,
        RouteNames.login,
        RouteNames.register,
        RouteNames.forgotPassword,
      ];

      final isPublicRoute = publicRoutes.contains(state.path);

      if (authState is AuthAuthenticated) {
        final user = authState.user;

        if (isPublicRoute) {
          return user.profileCompleted
              ? _getRoleBasedHome(user.role)
              : (user.isCoach
                    ? RouteNames.completeProfileCoach
                    : RouteNames.completeProfilePupil);
        }

        if (!user.profileCompleted &&
                !state.path!.startsWith(RouteNames.completeProfile) ??
            true) {
          return user.isCoach
              ? RouteNames.completeProfileCoach
              : RouteNames.completeProfilePupil;
        }
      }

      if (authState is AuthUnauthenticated && !isPublicRoute) {
        return RouteNames.welcome;
      }

      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Route not found: ${state.uri}', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.letStart),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );

  static String _getRoleBasedHome(String role) {
    switch (role) {
      case 'coach':
        return RouteNames.coachHome;
      case 'pupil':
        return RouteNames.pupilHome;
      case 'guest':
        return RouteNames.guestHome;
      default:
        return RouteNames.pupilHome;
    }
  }
}
