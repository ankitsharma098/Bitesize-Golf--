// import 'package:bitesize_golf/core/themes/theme_colors.dart';
// import 'package:bitesize_golf/route/navigator_service.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../route/app_routes.dart';
//
// class SplashScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Navigate to welcome screen after 3 seconds
//     Future.delayed(Duration(seconds: 3), () {
//       NavigationService.push(RouteNames.welcome);
//     });
//
//     return Scaffold(
//       backgroundColor: AppColors.redDark,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(50),
//               ),
//               child: Center(child: Image.asset("assets/images/golf_logo.png")),
//             ),
//             SizedBox(height: 50),
//             Container(
//               width: 100,
//               height: 4,
//               child: LinearProgressIndicator(
//                 backgroundColor: Colors.white.withOpacity(0.3),
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// features/auth/presentation/pages/splash_page.dart
import 'package:bitesize_golf/route/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger auth check on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(AuthAppStarted());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            if (state.user.photoURL!.isEmpty) {
              context.go(
                state.user.isCoach
                    ? RouteNames.coachHome
                    : RouteNames.pupilHome,
              );
            } else {
              context.go(
                state.user.isCoach
                    ? RouteNames.completeProfileCoach
                    : RouteNames.completeProfilePupil,
              );
            }
          } else if (state is AuthUnauthenticated) {
            // Allow showing welcome/login/register
            context.go(RouteNames.welcome);
          }
        },

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
    );
  }
}
