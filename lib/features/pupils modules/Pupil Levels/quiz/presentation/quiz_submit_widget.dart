import 'package:flutter/material.dart';
import '../../../../../Models/quiz attempt model/quiz_attempt_model.dart';
import '../../../../../Models/quiz model/quiz_model.dart';
import '../../../../../core/themes/theme_colors.dart';

import '../../../../components/custom_button.dart';
import '../../../../components/utils/size_config.dart';

class QuizResultWidget extends StatelessWidget {
  final QuizModel quiz;
  final QuizAttemptModel attempt;
  final LevelType levelType;
  final VoidCallback onReturnToLevel;
  final VoidCallback? onRetakeQuiz;

  const QuizResultWidget({
    super.key,
    required this.quiz,
    required this.attempt,
    required this.levelType,
    required this.onReturnToLevel,
    this.onRetakeQuiz,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (attempt.scoreObtained / attempt.totalPoints * 100)
        .round();

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.lightBlue[50]!, Colors.white],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.scaleWidth(24)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Result Header
              Text(
                attempt.passed ? 'Great job!' : 'Good try!',
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(28),
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey800,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.scaleHeight(8)),

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: attempt.passed
                          ? 'You Passed! '
                          : 'You didn\'t pass this time ',
                      style: TextStyle(
                        fontSize: SizeConfig.scaleText(20),
                        fontWeight: FontWeight.w600,
                        color: attempt.passed
                            ? Colors.green[600]
                            : AppColors.redDark,
                      ),
                    ),
                    if (attempt.passed)
                      TextSpan(
                        text: '🎉',
                        style: TextStyle(fontSize: SizeConfig.scaleText(20)),
                      ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: SizeConfig.scaleHeight(8)),

              Text(
                attempt.passed
                    ? 'Wowsers — what a great score!'
                    : 'Keep practicing and try again!',
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(16),
                  color: AppColors.grey600,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: SizeConfig.scaleHeight(40)),

              // Score Circle
              Container(
                width: SizeConfig.scaleWidth(200),
                height: SizeConfig.scaleWidth(200),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You scored',
                      style: TextStyle(
                        fontSize: SizeConfig.scaleText(14),
                        color: AppColors.grey600,
                      ),
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(8)),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${attempt.scoreObtained}',
                            style: TextStyle(
                              fontSize: SizeConfig.scaleText(36),
                              fontWeight: FontWeight.bold,
                              color: attempt.passed
                                  ? Colors.green[600]
                                  : AppColors.redDark,
                            ),
                          ),
                          TextSpan(
                            text: '/${attempt.totalPoints}',
                            style: TextStyle(
                              fontSize: SizeConfig.scaleText(24),
                              fontWeight: FontWeight.w500,
                              color: AppColors.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: SizeConfig.scaleHeight(40)),

              // Golf Ball Character with Speech
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Speech Bubble
                  Container(
                    padding: EdgeInsets.all(SizeConfig.scaleWidth(12)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.grey300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      attempt.passed ? "You're on fire! 🔥" : "Keep trying! 💪",
                      style: TextStyle(
                        fontSize: SizeConfig.scaleText(14),
                        color: AppColors.grey700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: SizeConfig.scaleWidth(16)),

                  // Golf Ball Character
                  Image.asset(
                    'assets/images/golf_ball_character.png', // Your golf ball character
                    width: SizeConfig.scaleWidth(80),
                    height: SizeConfig.scaleWidth(80),
                  ),

                  // Medal/Trophy for passed quiz
                  if (attempt.passed) ...[
                    SizedBox(width: SizeConfig.scaleWidth(16)),
                    Container(
                      width: SizeConfig.scaleWidth(60),
                      height: SizeConfig.scaleWidth(60),
                      decoration: BoxDecoration(
                        color: Colors.red[500],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: SizeConfig.scaleWidth(30),
                      ),
                    ),
                  ],
                ],
              ),

              SizedBox(height: SizeConfig.scaleHeight(50)),

              // Action Buttons
              Column(
                children: [
                  CustomButtonFactory.primary(
                    levelType: levelType,
                    onPressed: onReturnToLevel,
                    text: 'Return to Level',
                  ),

                  if (onRetakeQuiz != null) ...[
                    SizedBox(height: SizeConfig.scaleHeight(12)),
                    CustomButtonFactory.secondary(
                      levelType: levelType,
                      onPressed: onRetakeQuiz!,
                      text: 'Retake Quiz',
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
