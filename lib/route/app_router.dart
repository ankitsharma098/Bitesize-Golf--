// // lib/route/app_router.dart
// import 'package:bitesize_golf/route/routes_names.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart' as fb;
// import '../features/auth/presentation/bloc/auth_bloc.dart';
//
// import '../features/auth/domain/entities/user.dart';
//
// // Auth pages
// import '../features/auth/presentation/pages/coach_profile.dart';
// import '../features/auth/presentation/pages/complete_pupil_profile_page.dart';
// import '../features/auth/presentation/pages/forgot_password.dart';
// import '../features/auth/presentation/pages/splash_page.dart';
// import '../features/auth/presentation/pages/welcome_page.dart';
// import '../features/auth/presentation/pages/login_page.dart';
// import '../features/auth/presentation/pages/register_page.dart';
//
// class AppRouter {
//   static final GoRouter router = GoRouter(
//     initialLocation: RouteNames.letStart,
//     routes: [
//       // ---------- Auth Routes ----------
//       GoRoute(
//         path: RouteNames.letStart,
//         name: 'letStart',
//         builder: (context, state) => BlocListener<AuthBloc, AuthState>(
//           listener: (context, authState) {
//             if (authState is AuthAuthenticated) {
//               if (authState.user.profileCompleted) {
//                 context.go(_getRoleBasedHome(authState.user.role));
//               } else {
//                 context.go(
//                   authState.user.isCoach
//                       ? RouteNames.completeProfileCoach
//                       : RouteNames.completeProfilePupil,
//                 );
//               }
//             } else if (authState is AuthUnauthenticated) {
//               context.go(RouteNames.welcome);
//             }
//           },
//           child: const SplashScreen(),
//         ),
//       ),
//
//       GoRoute(
//         path: RouteNames.welcome,
//         name: 'welcome',
//         builder: (context, state) => const WelcomePage(),
//       ),
//
//       GoRoute(
//         path: RouteNames.login,
//         builder: (context, state) => const LoginPage(),
//       ),
//
//       GoRoute(
//         path: RouteNames.register,
//         name: 'register',
//         builder: (context, state) => const RegisterPage(),
//       ),
//
//       GoRoute(
//         path: RouteNames.forgotPassword,
//         name: 'forgotPassword',
//         builder: (context, state) => const ForgotPasswordPage(),
//       ),
//
//       // ---------- Profile Completion Routes ----------
//       GoRoute(
//         path: RouteNames.completeProfileCoach,
//         name: 'completeProfileCoach',
//         builder: (context, state) => const CompleteProfileCoachPage(),
//       ),
//
//       GoRoute(
//         path: RouteNames.completeProfilePupil,
//         name: 'completeProfilePupil',
//         builder: (context, state) => const CompleteProfilePupilPage(),
//       ),
//
//       // ---------- Main Routes ----------
//       GoRoute(
//         path: RouteNames.coachHome,
//         name: 'coachHome',
//         builder: (context, state) => const Placeholder(),
//       ),
//
//       GoRoute(
//         path: RouteNames.pupilHome,
//         name: 'pupilHome',
//         builder: (context, state) => const Placeholder(),
//       ),
//
//       GoRoute(
//         path: RouteNames.guestHome,
//         name: 'guestHome',
//         builder: (context, state) => const Placeholder(),
//       ),
//     ],
//     redirect: _handleRedirect,
//     errorBuilder: (context, state) => Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 64),
//             const SizedBox(height: 16),
//             Text('Route not found: ${state.uri}', textAlign: TextAlign.center),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () => context.go(RouteNames.letStart),
//               child: const Text('Go Home'),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
//
//   static String _getRoleBasedHome(String role) {
//     switch (role) {
//       case 'coach':
//         return RouteNames.coachHome;
//       case 'pupil':
//         return RouteNames.pupilHome;
//       case 'guest':
//         return RouteNames.guestHome;
//       default:
//         return RouteNames.pupilHome;
//     }
//   }
//
//   // lib/route/app_router.dart - Update redirect method
//   static String? _handleRedirect(BuildContext context, GoRouterState state) {
//     final authState = context.read<AuthBloc>().state;
//
//     // Allow these routes for everyone
//     final publicRoutes = [
//       RouteNames.welcome,
//       RouteNames.login,
//       RouteNames.register,
//       RouteNames.forgotPassword,
//       RouteNames.letStart,
//     ];
//
//     final isPublicRoute = publicRoutes.any(
//       (route) => state.path?.startsWith(route) ?? false,
//     );
//
//     print("DEBUG: Redirect - Path: ${state.path}, AuthState: $authState");
//
//     // Allow public routes regardless of auth state
//     if (isPublicRoute) {
//       return null; // Allow access
//     }
//
//     // Only redirect for protected routes
//     if (authState is AuthAuthenticated) {
//       final user = authState.user;
//
//       // Force profile completion for protected routes
//       if (!user.profileCompleted &&
//               !state.path!.startsWith(RouteNames.completeProfile) ??
//           true) {
//         return user.isCoach
//             ? RouteNames.completeProfileCoach
//             : RouteNames.completeProfilePupil;
//       }
//
//       // Allow authenticated users to access their home
//       return null;
//     }
//
//     // For protected routes when unauthenticated, redirect to welcome
//     if (authState is AuthUnauthenticated) {
//       return RouteNames.welcome;
//     }
//
//     // Allow loading states
//     return null;
//   }
// }
// lib/route/app_router.dart - Complete fix
import 'package:bitesize_golf/route/routes_names.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/pages/coach_profile.dart';
import '../features/auth/presentation/pages/complete_pupil_profile_page.dart';
import '../features/auth/presentation/pages/forgot_password.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/welcome_page.dart';
import '../injection.dart';

// lib/route/app_router.dart - Proper redirect implementation
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.letStart,
    routes: [
      // Auth routes - always accessible
      GoRoute(
        path: RouteNames.letStart,
        name: 'letStart',
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: RouteNames.welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomePage(),
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
        builder: (context, state) => const CompleteProfileCoachPage(),
      ),

      GoRoute(
        path: RouteNames.completeProfilePupil,
        name: 'completeProfilePupil',
        builder: (context, state) => const CompleteProfilePupilPage(),
      ),

      // Protected routes - only after auth
      GoRoute(
        path: RouteNames.coachHome,
        name: 'coachHome',
        builder: (context, state) {
          final authBloc = getIt<AuthBloc>(); // ✅ Using DI
          final authState = authBloc.state;
          if (authState is AuthAuthenticated && authState.user.isCoach) {
            return const Placeholder();
          }
          return const SizedBox.shrink();
        },
      ),

      GoRoute(
        path: RouteNames.pupilHome,
        name: 'pupilHome',
        builder: (context, state) {
          final authBloc = getIt<AuthBloc>(); // ✅ Using DI
          final authState = authBloc.state;
          if (authState is AuthAuthenticated && authState.user.isPupil) {
            return const Placeholder();
          }
          return const SizedBox.shrink();
        },
      ),

      GoRoute(
        path: RouteNames.guestHome,
        name: 'guestHome',
        builder: (context, state) {
          final authBloc = getIt<AuthBloc>(); // ✅ Using DI
          final authState = authBloc.state;
          if (authState is AuthAuthenticated && authState.user.isGuest) {
            return const Placeholder();
          }
          return const SizedBox.shrink();
        },
      ),
    ],
    redirect: (context, state) {
      final authBloc = getIt<AuthBloc>(); // ✅ Using DI
      final authState = authBloc.state;
      // Define public routes that don't require auth
      final publicRoutes = [
        RouteNames.letStart,
        RouteNames.welcome,
        RouteNames.login,
        RouteNames.register,
        RouteNames.forgotPassword,
      ];

      final isPublicRoute = publicRoutes.any(
        (route) => state.path?.startsWith(route) ?? false,
      );

      print("DEBUG: Redirect - Path: ${state.path}, AuthState: $authState");

      // Allow public routes regardless of auth state
      if (isPublicRoute) {
        return null; // Allow access
      }

      // Handle profile completion routes
      if (state.path?.startsWith(RouteNames.completeProfile) ?? false) {
        if (authState is AuthAuthenticated) {
          return null; // Allow authenticated users
        }
        return RouteNames.welcome; // Redirect unauthenticated
      }

      // Handle protected routes (home screens)
      if (authState is AuthAuthenticated) {
        final user = authState.user;

        // Redirect to profile completion if needed
        if (!user.profileCompleted) {
          return user.isCoach
              ? RouteNames.completeProfileCoach
              : RouteNames.completeProfilePupil;
        }

        // Redirect to appropriate home based on role
        if (state.path == RouteNames.mainScreen) {
          return _getRoleBasedHome(user.role);
        }

        return null; // Allow access to protected routes
      }

      // Redirect unauthenticated users to welcome for protected routes
      if (authState is AuthUnauthenticated) {
        return RouteNames.welcome;
      }

      return null; // Allow all other cases
    },
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
