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
  final int timeRemaining;
  final LevelType levelType;
  final Function(String) onAnswerSelected;
  final VoidCallback onNextQuestion;
  final VoidCallback onPreviousQuestion;
  final VoidCallback onSubmitQuiz;

  const QuizQuestionWidget({
    super.key,
    required this.quiz,
    required this.attempt,
    required this.currentQuestion,
    required this.timeRemaining,
    required this.levelType,
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
            // Header with progress and timer
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
                              ),
                            ),
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
      child: Row(
        children: [
          // Progress Bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: (currentQuestionIndex + 1) / quiz.totalQuestions,
                  borderRadius: BorderRadius.circular(12),
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(levelType.color),
                  minHeight: 13,
                ),
                SizedBox(height: SizeConfig.scaleHeight(8)),

                Text(
                  'Question ${currentQuestionIndex + 1}/${quiz.totalQuestions}',
                  style: TextStyle(
                    fontSize: SizeConfig.scaleText(12),
                    color: AppColors.grey600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Timer (if applicable)
          if (quiz.timeLimit != null) ...[
            SizedBox(width: SizeConfig.scaleWidth(16)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.scaleWidth(12),
                vertical: SizeConfig.scaleHeight(6),
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _formatTime(timeRemaining),
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(14),
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionCard(int index, String option, String? selectedAnswer) {
    final optionLetter = String.fromCharCode(65 + index); // A, B, C
    final isSelected = selectedAnswer == optionLetter;

    return GestureDetector(
      onTap: () => onAnswerSelected(optionLetter),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: SizeConfig.scaleHeight(12)),
        padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
        decoration: BoxDecoration(
          color: isSelected
              ? levelType.color.withOpacity(0.1)
              : AppColors.white,
          border: Border.all(
            color: isSelected ? levelType.color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Option Letter
            Text(
              '${optionLetter}.',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(16),
                fontWeight: FontWeight.bold,
                color: AppColors.grey900,
              ),
            ),
            SizedBox(width: SizeConfig.scaleWidth(16)),

            // Option Text
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(14),
                  color: AppColors.grey800,
                  height: 1.3,
                ),
              ),
            ),

            // Selection Indicator
            if (isSelected)
              Icon(Icons.check_circle, color: levelType.color, size: 20),
          ],
        ),
      ),
    );
  }

  // Widget _buildOptionCard(int index, String option, String? selectedAnswer) {
  //   final optionLetter = String.fromCharCode(65 + index); // A, B, C
  //   final isSelected = selectedAnswer == optionLetter;
  //
  //   return GestureDetector(
  //     onTap: () => onAnswerSelected(optionLetter),
  //     child: Container(
  //       width: double.infinity,
  //       margin: EdgeInsets.only(bottom: SizeConfig.scaleHeight(12)),
  //       padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
  //       decoration: BoxDecoration(
  //         color: isSelected
  //             ? levelType.color.withOpacity(0.1)
  //             : AppColors.white,
  //         border: Border.all(
  //           color: isSelected ? levelType.color : Colors.grey[300]!,
  //           width: isSelected ? 2 : 1,
  //         ),
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Row(
  //         children: [
  //           // Option Letter
  //           Text(
  //             '${optionLetter}.',
  //             style: TextStyle(
  //               fontSize: SizeConfig.scaleText(16),
  //               fontWeight: FontWeight.bold,
  //               color: AppColors.grey900,
  //             ),
  //           ),
  //           SizedBox(width: SizeConfig.scaleWidth(16)),
  //
  //           // Option Text
  //           Expanded(
  //             child: Text(
  //               option,
  //               style: TextStyle(
  //                 fontSize: SizeConfig.scaleText(14),
  //                 color: AppColors.grey800,
  //                 height: 1.3,
  //               ),
  //             ),
  //           ),
  //
  //           // Radio Button at trailing
  //           Radio<String>(
  //             value: optionLetter,
  //             groupValue: selectedAnswer,
  //             onChanged: (value) {
  //               if (value != null) {
  //                 onAnswerSelected(value);
  //               }
  //             },
  //             activeColor: levelType.color,
  //             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //             visualDensity: VisualDensity.compact,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildNavigationButtons(bool isFirstQuestion, bool isLastQuestion) {
    return Row(
      children: [
        // Previous Button
        if (!isFirstQuestion)
          Expanded(
            child: CustomButtonFactory.secondary(
              levelType: levelType,
              onPressed: onPreviousQuestion,
              text: 'Previous',
            ),
          ),

        if (!isFirstQuestion && !isLastQuestion)
          SizedBox(width: SizeConfig.scaleWidth(12)),

        // Next/Submit Button
        Expanded(
          child: isLastQuestion
              ? CustomButtonFactory.primary(
                  levelType: levelType,
                  onPressed: onSubmitQuiz,
                  text: 'Submit Quiz',
                )
              : CustomButtonFactory.primary(
                  levelType: levelType,
                  onPressed: onNextQuestion,
                  text: 'Next',
                ),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
