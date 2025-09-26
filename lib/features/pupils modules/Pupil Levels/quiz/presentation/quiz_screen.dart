import 'package:bitesize_golf/features/pupils%20modules/Pupil%20Levels/quiz/presentation/quiz_question_widget.dart';
import 'package:bitesize_golf/features/pupils%20modules/Pupil%20Levels/quiz/presentation/quiz_submit_widget.dart';
import 'package:bitesize_golf/features/pupils%20modules/Pupil%20Levels/quiz/presentation/quiz_welcome_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Models/level model/level_model.dart';
import '../../../../../core/constants/common_controller.dart';
import '../../../../../core/themes/theme_colors.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_scaffold.dart';
import '../../../../components/utils/size_config.dart';

import '../quiz bloc/quiz_bloc.dart';
import '../quiz bloc/quiz_event.dart';
import '../quiz bloc/quiz_state.dart';

class QuizScreen extends StatelessWidget {
  final LevelModel levelModel;
  final String? quizId;

  const QuizScreen({super.key, required this.levelModel, this.quizId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizBloc()
        ..add(
          LoadQuiz(quizId: quizId ?? '', levelNumber: levelModel.levelNumber),
        ),
      child: _QuizScreenView(levelModel: levelModel),
    );
  }
}

class _QuizScreenView extends StatelessWidget {
  final LevelModel levelModel;

  const _QuizScreenView({required this.levelModel});

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizBloc, QuizState>(
      listener: (context, state) {
        // Handle state changes that require user notification
        if (state is QuizError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.redDark,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: AppScaffold.levelScreen(
        title: '${getLevelTypeFromModel(levelModel.levelNumber).name} Quiz',
        levelType: getLevelTypeFromModel(levelModel.levelNumber),
        actions: [
          BlocBuilder<QuizBloc, QuizState>(
            builder: (context, state) {
              // Show pause button only during active quiz
              if (state is QuizInProgress) {
                return IconButton(
                  icon: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.redLight.withOpacity(0.5),
                    ),
                    child: Icon(
                      Icons.pause,
                      color: AppColors.grey900,
                      size: 18,
                    ),
                  ),
                  onPressed: () => _showPauseQuizDialog(context),
                );
              }

              // Show close button for other states
              return IconButton(
                icon: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.redLight.withOpacity(0.5),
                  ),
                  child: Icon(Icons.close, color: AppColors.grey900, size: 18),
                ),
                onPressed: () => Navigator.of(context).pop(),
              );
            },
          ),
        ],
        showBackButton: false, // Handle back button manually
        scrollable: false,
        body: WillPopScope(
          onWillPop: () async {
            final state = context.read<QuizBloc>().state;
            if (state is QuizInProgress) {
              _showPauseQuizDialog(context);
              return false; // Prevent default back action
            }
            return true; // Allow normal back navigation
          },
          child: BlocBuilder<QuizBloc, QuizState>(
            builder: (context, state) {
              if (state is QuizLoading) {
                return _buildLoadingState();
              } else if (state is QuizError) {
                return _buildErrorState(context, state.message);
              } else if (state is QuizLoaded) {
                return _buildWelcomeState(context, state);
              } else if (state is QuizInProgress) {
                return _buildQuizInProgressState(context, state);
              } else if (state is QuizCompleted) {
                return _buildQuizCompletedState(context, state);
              }
              return _buildLoadingState();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: getLevelTypeFromModel(levelModel.levelNumber).color,
            strokeWidth: 3,
          ),
          SizedBox(height: SizeConfig.scaleHeight(16)),
          Text(
            'Loading Quiz...',
            style: TextStyle(
              fontSize: SizeConfig.scaleText(16),
              color: AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.scaleWidth(24)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: SizeConfig.scaleWidth(60),
              color: AppColors.redDark,
            ),
            SizedBox(height: SizeConfig.scaleHeight(16)),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(18),
                fontWeight: FontWeight.w600,
                color: AppColors.grey700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.scaleHeight(8)),
            Text(
              message,
              style: TextStyle(
                fontSize: SizeConfig.scaleText(14),
                color: AppColors.grey600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.scaleHeight(24)),
            Row(
              children: [
                Expanded(
                  child: CustomButtonFactory.secondary(
                    levelType: getLevelTypeFromModel(levelModel.levelNumber),
                    onPressed: () {
                      context.read<QuizBloc>().add(
                        LoadQuiz(
                          quizId: '',
                          levelNumber: levelModel.levelNumber,
                        ),
                      );
                    },
                    text: 'Try Again',
                  ),
                ),
                SizedBox(width: SizeConfig.scaleWidth(12)),
                Expanded(
                  child: CustomButtonFactory.primary(
                    levelType: getLevelTypeFromModel(levelModel.levelNumber),
                    onPressed: () => Navigator.of(context).pop(),
                    text: 'Go Back',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeState(BuildContext context, QuizLoaded state) {
    return QuizWelcomeWidget(
      quiz: state.quiz,
      levelType: getLevelTypeFromModel(levelModel.levelNumber),
      previousAttempt: state.previousAttempt,
      onStartQuiz: () {
        context.read<QuizBloc>().add(const StartQuiz());
      },
      onRetakeQuiz: _shouldShowRetakeOption(state)
          ? () {
              context.read<QuizBloc>().add(const RetakeQuiz());
            }
          : null,
    );
  }

  Widget _buildQuizInProgressState(BuildContext context, QuizInProgress state) {
    return QuizQuestionWidget(
      quiz: state.quiz,
      attempt: state.attempt,
      currentQuestion: state.currentQuestion,
      levelType: getLevelTypeFromModel(levelModel.levelNumber),
      hasAnsweredCurrentQuestion: state.hasAnsweredCurrentQuestion,
      onAnswerSelected: (answer) {
        context.read<QuizBloc>().add(AnswerQuestion(selectedAnswer: answer));
      },
      onNextQuestion: () {
        context.read<QuizBloc>().add(const NextQuestion());
      },
      onPreviousQuestion: () {
        context.read<QuizBloc>().add(const PreviousQuestion());
      },
      onSubmitQuiz: () {
        _showSubmitConfirmDialog(context, state);
      },
    );
  }

  Widget _buildQuizCompletedState(BuildContext context, QuizCompleted state) {
    return QuizResultWidget(
      quiz: state.quiz,
      attempt: state.attempt,
      levelType: getLevelTypeFromModel(levelModel.levelNumber),
      onReturnToLevel: () => Navigator.of(context).pop(),
      onRetakeQuiz: state.quiz.allowRetakes
          ? () {
              context.read<QuizBloc>().add(const RetakeQuiz());
            }
          : null,
    );
  }

  // Helper method to determine if retake option should be shown
  bool _shouldShowRetakeOption(QuizLoaded state) {
    if (state.previousAttempt == null || !state.quiz.allowRetakes) {
      return false;
    }

    // Show retake for completed attempts (both passed and failed)
    if (state.previousAttempt!.status == 'completed') {
      return true;
    }

    return false;
  }

  // Show confirmation dialog before submitting quiz
  void _showSubmitConfirmDialog(BuildContext context, QuizInProgress state) {
    // Check if all questions are answered
    final totalQuestions = state.quiz.totalQuestions;
    final answeredQuestions = state.attempt.responses.length;
    final unansweredCount = totalQuestions - answeredQuestions;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Submit Quiz?',
          style: TextStyle(
            fontSize: SizeConfig.scaleText(18),
            fontWeight: FontWeight.bold,
            color: AppColors.grey800,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You are about to submit your quiz.',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(14),
                color: AppColors.grey700,
                height: 1.4,
              ),
            ),
            SizedBox(height: SizeConfig.scaleHeight(8)),
            Text(
              'Current Score: ${state.attempt.scoreObtained}/${state.quiz.totalPoints}',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(14),
                fontWeight: FontWeight.w600,
                color: AppColors.grey800,
              ),
            ),
            if (unansweredCount > 0) ...[
              SizedBox(height: SizeConfig.scaleHeight(8)),
              Text(
                'Warning: $unansweredCount question${unansweredCount > 1 ? 's' : ''} unanswered.',
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(13),
                  color: Colors.orange[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            SizedBox(height: SizeConfig.scaleHeight(8)),
            Text(
              'You won\'t be able to change answers after submitting.',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(13),
                color: AppColors.grey600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.grey600,
                fontSize: SizeConfig.scaleText(14),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<QuizBloc>().add(const SubmitQuiz());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: getLevelTypeFromModel(
                levelModel.levelNumber,
              ).color,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Submit Quiz',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(14),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show dialog when user tries to pause/exit during active quiz
  void _showPauseQuizDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Pause Quiz?',
          style: TextStyle(
            fontSize: SizeConfig.scaleText(18),
            fontWeight: FontWeight.bold,
            color: AppColors.grey800,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your progress will be automatically saved.',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(14),
                color: AppColors.grey700,
                height: 1.4,
              ),
            ),
            SizedBox(height: SizeConfig.scaleHeight(8)),
            Text(
              'You can continue where you left off next time.',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(14),
                color: AppColors.grey700,
                height: 1.4,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Continue Quiz',
              style: TextStyle(
                color: getLevelTypeFromModel(levelModel.levelNumber).color,
                fontSize: SizeConfig.scaleText(14),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.grey600,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Pause & Exit',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(14),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
