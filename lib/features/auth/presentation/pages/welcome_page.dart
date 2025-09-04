// import 'package:bitesize_golf/route/navigator_service.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../core/themes/theme_colors.dart';
// import '../../../../route/app_routes.dart';
// import '../../../components/custom_button.dart';
//
// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Spacer(flex: 2),
//               // Logo
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: Colors.transparent,
//                   borderRadius: BorderRadius.circular(40),
//                 ),
//                 child: Center(child: Image.asset("assets/logo/logo.png")),
//               ),
//               SizedBox(height: 32),
//               Text(
//                 'Welcome\nto Bitesize Golf',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'Learn, play, and grow with our interactive golf lessons, games, and progress tracking. Choose your role and get started!',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16, color: AppColors.grey900),
//               ),
//               SizedBox(height: 32),
//               Text(
//                 'Enter the world of junior golf development like no other, where potential turns into excellence',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 14, color: AppColors.grey900),
//               ),
//               Spacer(flex: 2),
//               // Buttons
//               CustomButton(
//                 text: 'Log in',
//                 onPressed: () {
//                   print('Login button pressed');
//                   NavigationService.push(RouteNames.login);
//                 },
//                 customGradient: AppColors.redGradient,
//               ),
//               SizedBox(height: 12),
//               CustomButton(
//                 text: 'Create an Account',
//                 onPressed: () {
//                   NavigationService.push(RouteNames.register);
//                 },
//                 customColor: AppColors.redLight,
//               ),
//
//               SizedBox(height: 12),
//               TextButton(
//                 onPressed: () {
//                   NavigationService.push(RouteNames.login);
//                 },
//                 child: Text(
//                   'Continue as Guest',
//                   style: TextStyle(color: AppColors.redDark, fontSize: 16),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// features/auth/presentation/pages/welcome_page.dart
import 'package:bitesize_golf/route/navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/themes/theme_colors.dart';
import '../../../../route/routes_names.dart';
import '../../../components/custom_button.dart';
import '../../../components/utils/size_config.dart';
import '../bloc/auth_bloc.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2),
              // Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(child: Image.asset("assets/logo/logo.png")),
              ),
              SizedBox(height: 32),
              Text(
                'Welcome\nto Bitesize Golf',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Learn, play, and grow with our interactive golf lessons, games, and progress tracking. Choose your role and get started!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.grey900),
              ),
              SizedBox(height: 32),
              Text(
                'Enter the world of junior golf development like no other, where potential turns into excellence',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.grey900),
              ),
              Spacer(flex: 2),
              // Buttons
              CustomButton(
                text: 'Log in',
                onPressed: () {
                  print("Log In Clicked");
                  NavigationService.push(RouteNames.login);
                  //context.go(RouteNames.login);
                },
                customGradient: AppColors.redGradient,
              ),
              SizedBox(height: 12),

              // Add this debug button to your WelcomePage
              CustomButton(
                text: 'Create an Account',
                onPressed: () {
                  NavigationService.push(RouteNames.register);
                  // context.go(RouteNames.register);
                },
                customColor: AppColors.redLight,
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  context.go(RouteNames.guestHome);
                },
                child: Text(
                  'Continue as Guest',
                  style: TextStyle(color: AppColors.redDark, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
