// lib/router/app_router.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/auth/presentation/bloc/auth_state.dart';

// Auth pages (we already built these earlier)
import '../features/auth/presentation/pages/forgot_password.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/welcome_page.dart';
import '../injection.dart';
import 'app_routes.dart';

// Your actual screens. Replace placeholders as you build them.

/// Notifies GoRouter when the auth stream changes to re-run redirects.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription _sub;
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

class AppRouter {
  static final _refresh = GoRouterRefreshStream(
    getIt<AuthRepository>().authState$(),
  );

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.letStart,
    refreshListenable: _refresh,
    redirect: _handleRedirect,
    routes: [
      // ---------- Welcome & Auth ----------
      GoRoute(
        path: RouteNames.letStart,
        name: 'letStart',
        builder: (_, __) => SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.welcome,
        name: 'welcome',
        builder: (_, __) => WelcomeScreen(),
      ),
      // In your app_router.dart
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>(),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>(),
          child: const RegisterPage(),
        ),
      ),

      GoRoute(
        path: RouteNames.forgetPass,
        name: 'forgetPass',
        builder: (_, __) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '${RouteNames.otpVerify}/:email',
        name: 'otpVerify',
        builder: (_, state) =>
            _OtpVerifyPage(email: state.pathParameters['email'] ?? ''),
      ),
      GoRoute(
        path: '${RouteNames.resetPass}/:email',
        name: 'resetPass',
        builder: (_, state) =>
            _ResetPassPage(email: state.pathParameters['email'] ?? ''),
      ),
    ],
    errorBuilder: _buildError,
  );

  // ---------- Redirect guard ----------
  static Future<String?> _handleRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    // Ask AuthRepository (which reads firebase/hive via our layers)
    final user = await getIt<AuthRepository>().getCurrentUser().then(
      (e) => e.fold((_) => null, (u) => u),
    );

    final uri = state.uri.toString();
    final isAuthRoute =
        uri.startsWith(RouteNames.login) ||
        uri.startsWith(RouteNames.register) ||
        uri.startsWith(RouteNames.welcome) ||
        uri.startsWith(RouteNames.letStart) ||
        uri.startsWith(RouteNames.forgetPass) ||
        uri.startsWith(RouteNames.otpVerify) ||
        uri.startsWith(RouteNames.resetPass);

    // Not logged in -> force auth routes
    if (user == null && !isAuthRoute) return RouteNames.login;

    // Logged in trying to visit auth pages -> push to main
    if (user != null && isAuthRoute) return RouteNames.mainScreen;

    return null; // no redirection
  }

  // ---------- Error page ----------
  static Widget _buildError(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Oops')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Route not found:\n${state.uri}', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.mainScreen),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

// =================== Simple Shell (bottom nav) ===================

class _MainShell extends StatelessWidget {
  final Widget child;
  const _MainShell({required this.child});

  @override
  Widget build(BuildContext context) {
    final idx = context.select((_BottomNavCubit c) => c.state);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) {
          context.read<_BottomNavCubit>().setIndex(i);
          switch (i) {
            case 0:
              context.go(RouteNames.home);
              break;
            case 1:
              context.go(RouteNames.courses);
              break;
            case 2:
              context.go(RouteNames.plans);
              break;
            case 3:
              context.go(RouteNames.practice);
              break;
            case 4:
              context.go(RouteNames.profile);
              break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.flag_outlined),
            label: 'Plans',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_golf_outlined),
            label: 'Practice',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _BottomNavCubit extends Cubit<int> {
  _BottomNavCubit() : super(0);
  void setIndex(int i) => emit(i);
}

// =================== Tiny placeholders (replace with real pages) ===================

class _LetStartPage extends StatelessWidget {
  const _LetStartPage();
  @override
  Widget build(BuildContext c) => const _SplashStub('Let’s get started');
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage();
  @override
  Widget build(BuildContext c) => const _SplashStub('Welcome');
}

class _HomePage extends StatelessWidget {
  const _HomePage();
  @override
  Widget build(BuildContext c) => const _Stub('Home');
}

class _CoursesPage extends StatelessWidget {
  const _CoursesPage();
  @override
  Widget build(BuildContext c) => const _Stub('Courses');
}

class _PlansPage extends StatelessWidget {
  const _PlansPage();
  @override
  Widget build(BuildContext c) => const _Stub('Plans');
}

class _PracticePage extends StatelessWidget {
  const _PracticePage();
  @override
  Widget build(BuildContext c) => const _Stub('Practice');
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();
  @override
  Widget build(BuildContext c) => const _Stub('Profile');
}

class _NotificationsPage extends StatelessWidget {
  const _NotificationsPage();
  @override
  Widget build(BuildContext c) => const _Stub('Notifications');
}

class _SearchPage extends StatelessWidget {
  const _SearchPage();
  @override
  Widget build(BuildContext c) => const _Stub('Search');
}

class _CourseDetailsPage extends StatelessWidget {
  final String courseId;
  const _CourseDetailsPage({required this.courseId});
  @override
  Widget build(BuildContext c) => _Stub('Course: $courseId');
}

class _LessonDetailsPage extends StatelessWidget {
  final String courseId;
  final String lessonId;
  const _LessonDetailsPage({required this.courseId, required this.lessonId});
  @override
  Widget build(BuildContext c) => _Stub('Lesson: $courseId / $lessonId');
}

class _OtpVerifyPage extends StatelessWidget {
  final String email;
  const _OtpVerifyPage({required this.email});
  @override
  Widget build(BuildContext c) => _Stub('Verify: $email');
}

class _ResetPassPage extends StatelessWidget {
  final String email;
  const _ResetPassPage({required this.email});
  @override
  Widget build(BuildContext c) => _Stub('Reset: $email');
}

class _SplashStub extends StatelessWidget {
  final String label;
  const _SplashStub(this.label);
  @override
  Widget build(BuildContext c) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

class _Stub extends StatelessWidget {
  final String label;
  const _Stub(this.label);
  @override
  Widget build(BuildContext c) => Scaffold(
    appBar: AppBar(title: Text(label)),
    body: Center(child: Text(label)),
  );
}
