import 'package:flutter/material.dart';
import '../../../../../core/themes/theme_colors.dart';
import '../../../../../route/navigator_service.dart';
import '../../../../../route/routes_names.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_scaffold.dart';
import '../../../../components/utils/size_config.dart';

class RedQuizWelcomeScreen extends StatelessWidget {
  const RedQuizWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold.content(
      title: "Red Level Quiz",
      showBackButton: true,
      levelType: LevelType.redLevel,
      actions: [
        IconButton(
          icon: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.redLight.withOpacity(0.5),
            ),
            child: Icon(Icons.close, color: AppColors.grey900),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: SizeConfig.scaleHeight(20)),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.grey200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Good luck with your\n",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.grey900,
                          ),
                        ),
                        TextSpan(
                          text: "Red Quiz!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.redDark,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(16)),
                  const Text(
                    "You need 5 or more correct answers to pass.There are 10 questions.Just type A, B, or C for each answer.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: AppColors.grey900),
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(50)),
                  Image.asset("assets/know_balls/Level=red.png", height: 120),
                ],
              ),
            ),
            const Spacer(),
            CustomButtonFactory.primary(
              text: "Start Quiz",
              onPressed: () {
                NavigationService.push(RouteNames.quizStart);
              },
              levelType: LevelType.redLevel,
            ),
            SizedBox(height: SizeConfig.scaleHeight(20)),
          ],
        ),
      ),
    );
  }
}
