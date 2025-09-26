import 'package:flutter/material.dart';
import '../../../../../Models/quiz model/quiz_model.dart';
import '../../../../../Models/quiz attempt model/quiz_attempt_model.dart';
import '../../../../../core/constants/common_controller.dart';
import '../../../../../core/themes/asset_custom.dart';
import '../../../../../core/themes/theme_colors.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/utils/size_config.dart';

class QuizWelcomeWidget extends StatelessWidget {
  final QuizModel quiz;
  final LevelType levelType;
  final QuizAttemptModel? previousAttempt;
  final VoidCallback onStartQuiz;
  final VoidCallback? onRetakeQuiz;

  const QuizWelcomeWidget({
    super.key,
    required this.quiz,
    required this.levelType,
    this.previousAttempt,
    required this.onStartQuiz,
    this.onRetakeQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.scaleWidth(16),
        vertical: SizeConfig.scaleHeight(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: SizeConfig.scaleHeight(40)),
          // Quiz Welcome Card
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(SizeConfig.scaleWidth(24)),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey300.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Welcome Title
                    RichText(
                      text: TextSpan(
                        text: _getWelcomeTitle(),
                        style: TextStyle(
                          fontSize: SizeConfig.scaleText(24),
                          fontWeight: FontWeight.bold,
                          color: AppColors.grey700,
                        ),
                        children: [
                          TextSpan(
                            text: ' ${levelType.name} Quiz!',
                            style: TextStyle(
                              fontSize: SizeConfig.scaleText(24),
                              fontWeight: FontWeight.bold,
                              color: levelType.color,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig.scaleHeight(16)),

                    // Previous Attempt Info (if exists)
                    if (previousAttempt != null) ...[
                      _buildPreviousAttemptInfo(),
                      SizedBox(height: SizeConfig.scaleHeight(24)),
                    ],

                    // Quiz Requirements
                    _buildQuizRequirements(),

                    SizedBox(height: SizeConfig.scaleHeight(32)),

                    // Golf Ball Character
                    Image.asset(
                      BallAssetProvider.getSwingBall(levelType),
                      width: SizeConfig.scaleWidth(172),
                      height: SizeConfig.scaleWidth(150),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: SizeConfig.scaleHeight(24)),

          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  String _getWelcomeTitle() {
    if (previousAttempt == null) {
      return 'Get ready for the';
    }

    switch (previousAttempt!.status) {
      case 'completed':
        return previousAttempt!.passed
            ? 'Try again to improve your score on the'
            : 'Give it another shot at the';
      case 'in_progress':
        return 'Continue your';
      case 'abandoned':
      case 'expired':
        return 'Restart your';
      default:
        return 'Get ready for the';
    }
  }

  Widget _buildPreviousAttemptInfo() {
    if (previousAttempt == null) return const SizedBox.shrink();

    final percentageScore = previousAttempt!.totalPoints > 0
        ? (previousAttempt!.scoreObtained / previousAttempt!.totalPoints * 100)
              .toStringAsFixed(1)
        : '0.0';

    String statusMessage;
    Color statusColor;
    IconData statusIcon;

    switch (previousAttempt!.status) {
      case 'completed':
        if (previousAttempt!.passed) {
          statusMessage = 'Previously Passed';
          statusColor = Colors.green;
          statusIcon = Icons.check_circle;
        } else {
          statusMessage = 'Previous Attempt - Not Passed';
          statusColor = Colors.orange;
          statusIcon = Icons.info;
        }
        break;
      case 'in_progress':
        statusMessage = 'Quiz In Progress';
        statusColor = Colors.blue;
        statusIcon = Icons.play_circle;
        break;
      case 'abandoned':
      case 'expired':
        statusMessage = 'Previous Attempt Incomplete';
        statusColor = Colors.grey;
        statusIcon = Icons.error_outline;
        break;
      default:
        statusMessage = 'Previous Attempt';
        statusColor = Colors.grey;
        statusIcon = Icons.info;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                statusIcon,
                color: statusColor,
                size: SizeConfig.scaleWidth(24),
              ),
              SizedBox(width: SizeConfig.scaleWidth(8)),
              Text(
                statusMessage,
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(16),
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.scaleHeight(12)),
          if (previousAttempt!.status == 'completed') ...[
            Text(
              'Score: ${previousAttempt!.scoreObtained}/${previousAttempt!.totalPoints} ($percentageScore%)',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(14),
                color: AppColors.grey700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.scaleHeight(8)),
            Text(
              previousAttempt!.passed
                  ? 'You passed! Want to improve your score?'
                  : 'You need ${quiz.passingScore}% to pass. Try again!',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(13),
                color: AppColors.grey600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (previousAttempt!.status == 'in_progress') ...[
            Text(
              'Progress: ${previousAttempt!.responses.length}/${quiz.totalQuestions} questions answered',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(14),
                color: AppColors.grey700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.scaleHeight(8)),
            Text(
              'Continue where you left off!',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(13),
                color: AppColors.grey600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (previousAttempt!.status == 'abandoned' ||
              previousAttempt!.status == 'expired') ...[
            Text(
              'Your previous attempt was not completed.',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(14),
                color: AppColors.grey700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.scaleHeight(8)),
            Text(
              'Start fresh with a new attempt!',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(13),
                color: AppColors.grey600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],

          // Show attempts remaining if applicable
          if (previousAttempt!.status == 'completed' &&
              quiz.maxAttempts != null) ...[
            SizedBox(height: SizeConfig.scaleHeight(8)),
            FutureBuilder<int>(
              future: _getAttemptsUsed(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final attemptsRemaining = quiz.maxAttempts! - snapshot.data!;
                  if (attemptsRemaining > 0) {
                    return Text(
                      'Attempts remaining: $attemptsRemaining/${quiz.maxAttempts}',
                      style: TextStyle(
                        fontSize: SizeConfig.scaleText(12),
                        color: AppColors.grey600,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    );
                  } else {
                    return Text(
                      'No attempts remaining',
                      style: TextStyle(
                        fontSize: SizeConfig.scaleText(12),
                        color: Colors.red[600],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ],
      ),
    );
  }

  Future<int> _getAttemptsUsed() async {
    // This would typically be calculated in the repository/bloc
    // For now, assuming 1 attempt used if there's a completed attempt
    return previousAttempt?.status == 'completed' ? 1 : 0;
  }

  Widget _buildQuizRequirements() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quiz Requirements',
            style: TextStyle(
              fontSize: SizeConfig.scaleText(16),
              fontWeight: FontWeight.bold,
              color: AppColors.grey800,
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(12)),
          _buildRequirementRow(
            icon: Icons.question_answer,
            text:
                '${quiz.totalQuestions} Question${quiz.totalQuestions > 1 ? 's' : ''}',
          ),
          SizedBox(height: SizeConfig.scaleHeight(8)),
          _buildRequirementRow(
            icon: Icons.score,
            text: 'Passing Score: ${quiz.passingScore}%',
          ),
          SizedBox(height: SizeConfig.scaleHeight(8)),
          _buildRequirementRow(
            icon: Icons.star,
            text: 'Total Points: ${quiz.totalPoints}',
          ),
          SizedBox(height: SizeConfig.scaleHeight(8)),
          _buildRequirementRow(icon: Icons.schedule, text: 'No Time Limit'),
          if (quiz.allowRetakes) ...[
            SizedBox(height: SizeConfig.scaleHeight(8)),
            _buildRequirementRow(
              icon: Icons.refresh,
              text: quiz.maxAttempts != null
                  ? 'Max Attempts: ${quiz.maxAttempts}'
                  : 'Unlimited Attempts',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRequirementRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: SizeConfig.scaleWidth(20), color: levelType.color),
        SizedBox(width: SizeConfig.scaleWidth(12)),
        Text(
          text,
          style: TextStyle(
            fontSize: SizeConfig.scaleText(14),
            color: AppColors.grey700,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    // Determine button text based on previous attempt status
    String primaryButtonText;

    if (previousAttempt == null) {
      primaryButtonText = 'Start Quiz';
    } else {
      switch (previousAttempt!.status) {
        case 'in_progress':
          primaryButtonText = 'Continue Quiz';
          break;
        case 'completed':
          primaryButtonText = previousAttempt!.passed
              ? 'Improve Score'
              : 'Try Again';
          break;
        case 'abandoned':
        case 'expired':
          primaryButtonText = 'Start New Attempt';
          break;
        default:
          primaryButtonText = 'Start Quiz';
      }
    }

    return Column(
      children: [
        CustomButtonFactory.primary(
          levelType: levelType,
          onPressed: onStartQuiz,
          text: primaryButtonText,
        ),

        // Show retake button only for completed attempts if retakes allowed
        if (previousAttempt?.status == 'completed' &&
            quiz.allowRetakes &&
            onRetakeQuiz != null &&
            !previousAttempt!.passed) ...[
          SizedBox(height: SizeConfig.scaleHeight(12)),
          CustomButtonFactory.secondary(
            levelType: levelType,
            onPressed: onRetakeQuiz,
            text: 'Start Fresh Attempt',
          ),
        ],
      ],
    );
  }
}
