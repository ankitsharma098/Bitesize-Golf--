import 'package:flutter/material.dart';

import '../../../../../Models/quiz model/quiz_model.dart';
import '../../../../../core/constants/common_controller.dart';
import '../../../../../core/themes/asset_custom.dart';
import '../../../../../core/themes/theme_colors.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/utils/size_config.dart';

class QuizWelcomeWidget extends StatelessWidget {
  final QuizModel quiz;
  final LevelType levelType;
  final VoidCallback onStartQuiz;

  const QuizWelcomeWidget({
    super.key,
    required this.quiz,
    required this.levelType,
    required this.onStartQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        // color: Colors.green,
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [levelType.color.withOpacity(0.1), Colors.white],
        // ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.scaleWidth(5),
          vertical: 0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: SizeConfig.scaleHeight(40)),
            // Quiz Welcome Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(SizeConfig.scaleWidth(24)),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Good luck with your',
                      style: TextStyle(
                        fontSize: SizeConfig.scaleText(24),
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey700,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(8)),
                  RichText(
                    text: TextSpan(
                      text: '${levelType.name} Quiz!',
                      style: TextStyle(
                        fontSize: SizeConfig.scaleText(25),
                        fontWeight: FontWeight.bold,
                        color: levelType.color,
                      ),
                    ),

                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(24)),

                  // Quiz Info
                  _buildQuizInfo(),

                  SizedBox(height: SizeConfig.scaleHeight(32)),

                  // Golf Ball Character
                  Image.asset(
                    BallAssetProvider.getSwingBall(
                      levelType,
                    ), // Add your golf ball character image
                    width: SizeConfig.scaleWidth(172),
                    height: SizeConfig.scaleWidth(150),
                  ),
                ],
              ),
            ),

            Expanded(child: SizedBox(height: SizeConfig.scaleHeight(32))),

            // Start Quiz Button
            CustomButtonFactory.primary(
              levelType: levelType,
              onPressed: onStartQuiz,
              text: 'Start Quiz',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizInfo() {
    double passingPercentage = quiz.passingScore / 100.0;

    return Column(
      children: [
        Text(
          'You need ${(quiz.totalQuestions * passingPercentage).ceil()} or more correct answers',
          style: TextStyle(
            fontSize: SizeConfig.scaleText(14),
            color: AppColors.grey900,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          'to pass. There are ${quiz.totalQuestions} questions.',
          style: TextStyle(
            fontSize: SizeConfig.scaleText(14),
            color: AppColors.grey900,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        if (quiz.timeLimit != null) ...[
          SizedBox(height: SizeConfig.scaleHeight(8)),
          Text(
            'Time limit: ${quiz.timeLimit} minutes',
            style: TextStyle(
              fontSize: SizeConfig.scaleText(14),
              color: AppColors.grey900,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        SizedBox(height: SizeConfig.scaleHeight(12)),
        Text(
          'Just type A, B, or C',
          style: TextStyle(
            fontSize: SizeConfig.scaleText(14),
            color: AppColors.grey900,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          'for each answer.',
          style: TextStyle(
            fontSize: SizeConfig.scaleText(14),
            color: AppColors.grey900,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
