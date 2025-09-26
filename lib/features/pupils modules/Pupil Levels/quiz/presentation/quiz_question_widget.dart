import 'package:flutter/material.dart';

import '../../../../../Models/quiz attempt model/quiz_attempt_model.dart';
import '../../../../../Models/quiz model/quiz_model.dart';
import '../../../../../core/themes/theme_colors.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/utils/size_config.dart';

class QuizQuestionWidget extends StatelessWidget {
  final QuizModel quiz;
  final QuizAttemptModel attempt;
  final QuizQuestionModel currentQuestion;
  final LevelType levelType;
  final bool hasAnsweredCurrentQuestion;
  final Function(String) onAnswerSelected;
  final VoidCallback onNextQuestion;
  final VoidCallback onPreviousQuestion;
  final VoidCallback onSubmitQuiz;

  const QuizQuestionWidget({
    super.key,
    required this.quiz,
    required this.attempt,
    required this.currentQuestion,
    required this.levelType,
    this.hasAnsweredCurrentQuestion = false,
    required this.onAnswerSelected,
    required this.onNextQuestion,
    required this.onPreviousQuestion,
    required this.onSubmitQuiz,
  });

  @override
  Widget build(BuildContext context) {
    final currentQuestionIndex = quiz.questions.indexOf(currentQuestion);
    final isLastQuestion = currentQuestionIndex == quiz.questions.length - 1;
    final isFirstQuestion = currentQuestionIndex == 0;

    // Get current answer if exists
    final currentResponse = attempt.responses
        .where((r) => r.questionId == currentQuestion.questionId)
        .firstOrNull;
    final selectedAnswer = currentResponse?.selectedAnswer;

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.scaleWidth(5),
        horizontal: 4,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header with progress (no timer)
            _buildHeader(currentQuestionIndex),

            SizedBox(height: SizeConfig.scaleHeight(32)),

            // Question Content
            Expanded(
              child: Column(
                children: [
                  // Question Card
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(SizeConfig.scaleWidth(24)),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Question Title
                          Text(
                            'Question ${currentQuestionIndex + 1}',
                            style: TextStyle(
                              fontSize: SizeConfig.scaleText(20),
                              fontWeight: FontWeight.bold,
                              color: levelType.color,
                            ),
                          ),
                          SizedBox(height: SizeConfig.scaleHeight(16)),

                          // Question Text
                          Text(
                            currentQuestion.question,
                            style: TextStyle(
                              fontSize: SizeConfig.scaleText(16),
                              color: AppColors.grey800,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: SizeConfig.scaleHeight(24)),

                          // Answer Options
                          if (currentQuestion.options != null)
                            ...currentQuestion.options!.asMap().entries.map(
                              (entry) => _buildOptionCard(
                                entry.key,
                                entry.value,
                                selectedAnswer,
                                hasAnsweredCurrentQuestion,
                              ),
                            ),

                          // Removed explanation feature completely
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.scaleHeight(16)),

                  // Navigation Buttons
                  _buildNavigationButtons(isFirstQuestion, isLastQuestion),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int currentQuestionIndex) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: (currentQuestionIndex + 1) / quiz.totalQuestions,
            borderRadius: BorderRadius.circular(12),
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(levelType.color),
            minHeight: 13,
          ),
          SizedBox(height: SizeConfig.scaleHeight(8)),

          // Progress Text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${currentQuestionIndex + 1}/${quiz.totalQuestions}',
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(12),
                  color: AppColors.grey600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Show current score
              Text(
                'Score: ${attempt.scoreObtained}/${quiz.totalPoints}',
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(12),
                  color: AppColors.grey600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(
    int index,
    String option,
    String? selectedAnswer,
    bool hasAnswered,
  ) {
    final optionLetter = String.fromCharCode(65 + index); // A, B, C, D
    final isSelected = selectedAnswer == optionLetter;

    // FIX: Compare option text with correctAnswer, not optionLetter
    final isCorrect = option == currentQuestion.correctAnswer;

    // Determine card styling based on state
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    IconData? trailingIcon;
    Color? iconColor;
    double borderWidth = 1;

    if (!hasAnswered) {
      // Before answering - normal styling, allow selection
      backgroundColor = AppColors.white;
      borderColor = Colors.grey[300]!;
      textColor = AppColors.grey800;
    } else {
      // After answering - show both selected wrong answer AND correct answer
      if (isCorrect) {
        // Always show correct answer in green (whether selected or not)
        backgroundColor = Colors.green.withOpacity(0.1);
        borderColor = Colors.green;
        textColor = Colors.green[800]!;
        trailingIcon = Icons.check_circle;
        iconColor = Colors.green;
        borderWidth = 2;
      } else if (isSelected) {
        // Show selected wrong answer in red
        backgroundColor = Colors.red.withOpacity(0.1);
        borderColor = Colors.red;
        textColor = Colors.red[800]!;
        trailingIcon = Icons.cancel;
        iconColor = Colors.red;
        borderWidth = 2;
      } else {
        // Other unselected, incorrect options - muted
        backgroundColor = Colors.grey[50]!;
        borderColor = Colors.grey[300]!;
        textColor = AppColors.grey600;
      }
    }

    return GestureDetector(
      onTap: hasAnswered ? null : () => onAnswerSelected(optionLetter),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: SizeConfig.scaleHeight(12)),
        padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: borderWidth),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Option Letter Circle
            Container(
              width: SizeConfig.scaleWidth(32),
              height: SizeConfig.scaleWidth(32),
              decoration: BoxDecoration(
                color: hasAnswered && isCorrect
                    ? Colors.green
                    : hasAnswered && isSelected && !isCorrect
                    ? Colors.red
                    : Colors.transparent,
                border: Border.all(
                  color: hasAnswered && isCorrect
                      ? Colors.green
                      : hasAnswered && isSelected && !isCorrect
                      ? Colors.red
                      : Colors.grey[400]!,
                  width: 1.5,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  optionLetter,
                  style: TextStyle(
                    fontSize: SizeConfig.scaleText(14),
                    fontWeight: FontWeight.bold,
                    color: hasAnswered && isCorrect
                        ? Colors.white
                        : hasAnswered && isSelected && !isCorrect
                        ? Colors.white
                        : Colors.grey[600],
                  ),
                ),
              ),
            ),
            SizedBox(width: SizeConfig.scaleWidth(16)),

            // Option Text
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(14),
                  color: textColor,
                  height: 1.3,
                  fontWeight:
                      hasAnswered && (isCorrect || (isSelected && !isCorrect))
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),

            // Trailing Icon
            if (trailingIcon != null) ...[
              SizedBox(width: SizeConfig.scaleWidth(8)),
              Icon(trailingIcon, color: iconColor, size: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(bool isFirstQuestion, bool isLastQuestion) {
    return Row(
      children: [
        // No Previous Button - remove previous functionality completely

        // Next/Submit Button - full width
        Expanded(
          child: isLastQuestion
              ? CustomButtonFactory.primary(
                  levelType: levelType,
                  onPressed: hasAnsweredCurrentQuestion ? onSubmitQuiz : null,
                  text: 'Submit Quiz',
                )
              : CustomButtonFactory.primary(
                  levelType: levelType,
                  onPressed: hasAnsweredCurrentQuestion ? onNextQuestion : null,
                  text: 'Next Question',
                ),
        ),
      ],
    );
  }
}
