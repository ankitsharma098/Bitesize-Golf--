// import 'package:bitesize_golf/route/navigator_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../../core/themes/theme_colors.dart';
// import '../../../../route/routes_names.dart';
// import '../../../components/custom_button.dart';
// import '../../../components/utils/size_config.dart';
//
// class WelcomePage extends StatelessWidget {
//   const WelcomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBgColor,
//
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
//                   print("Log In Clicked");
//                   NavigationService.push(RouteNames.login);
//                   //context.go(RouteNames.login);
//                 },
//                 customGradient: AppColors.redGradient,
//               ),
//               SizedBox(height: 12),
//
//               // Add this debug button to your WelcomePage
//               CustomButton(
//                 text: 'Create an Account',
//                 onPressed: () {
//                   NavigationService.push(RouteNames.register);
//                   // context.go(RouteNames.register);
//                 },
//                 customColor: AppColors.redLight,
//               ),
//               SizedBox(height: 12),
//               TextButton(
//                 onPressed: () {
//                   context.go(RouteNames.guestHome);
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/theme_colors.dart';
import '../../../route/navigator_service.dart';
import '../../../route/routes_names.dart';
import '../../components/custom_button.dart';
import '../../components/custom_scaffold.dart';
import '../../components/utils/size_config.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // MUCH CLEANER - Using AppScaffold.fullScreen()
    return AppScaffold.fullScreen(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
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
            const SizedBox(height: 32),
            const Text(
              'Welcome\nto Bitesize Golf',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Learn, play, and grow with our interactive golf lessons, games, and progress tracking. Choose your role and get started!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.grey900),
            ),
            const SizedBox(height: 32),
            Text(
              'Enter the world of junior golf development like no other, where potential turns into excellence',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.grey900),
            ),
            const Spacer(flex: 2),
            // Buttons
            CustomButtonFactory.primary(
              text: 'Log in',
              onPressed: () {
                print("Log In Clicked");
                NavigationService.push(RouteNames.login);
              },
              levelType: LevelType.redLevel, // Use red theme for consistency
            ),
            const SizedBox(height: 12),
            CustomButtonFactory.faded(
              text: 'Create an Account',
              onPressed: () {
                NavigationService.push(RouteNames.register);
              },
              levelType: LevelType.redLevel, // Use red theme for faded style
            ),
            const SizedBox(height: 12),
            CustomButtonFactory.text(
              text: 'Continue as Guest',
              onPressed: () {
                context.go(RouteNames.guestHome);
              },
              levelType: LevelType.redLevel, // Use red theme for text color
            ),
          ],
        ),
      ),
    );
  }
}
