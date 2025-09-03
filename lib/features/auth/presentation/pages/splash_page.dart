import 'package:bitesize_golf/core/themes/theme_colors.dart';
import 'package:bitesize_golf/route/navigator_service.dart';
import 'package:flutter/material.dart';

import '../../../../route/app_routes.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Navigate to welcome screen after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      NavigationService.push(RouteNames.welcome);
    });

    return Scaffold(
      backgroundColor: AppColors.redDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(child: Image.asset("assets/images/golf_logo.png")),
            ),
            SizedBox(height: 50),
            Container(
              width: 100,
              height: 4,
              child: LinearProgressIndicator(
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
