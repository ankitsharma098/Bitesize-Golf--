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
    return AppScaffold.levelScreen(
      title: '${getLevelTypeFromModel(levelModel.levelNumber).name} Quiz',
      levelType: getLevelTypeFromModel(levelModel.levelNumber),
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
      showBackButton: true,
      scrollable: false,
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state is QuizLoading) {
            return _buildLoadingState();
          } else if (state is QuizError) {
            return _buildErrorState(context, state.message);
          } else if (state is QuizLoaded) {
            return _buildLoadedState(context, state);
          } else if (state is QuizInProgress) {
            return _buildQuizInProgressState(context, state);
          } else if (state is QuizCompleted) {
            return _buildQuizCompletedState(context, state);
          }
          return _buildLoadingState();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        color: getLevelTypeFromModel(levelModel.levelNumber).color,
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
              color: AppColors.grey500,
            ),
            SizedBox(height: SizeConfig.scaleHeight(16)),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(18),
                fontWeight: FontWeight.w600,
                color: AppColors.grey700,
              ),
            ),
            SizedBox(height: SizeConfig.scaleHeight(8)),
            Text(
              message,
              style: TextStyle(
                fontSize: SizeConfig.scaleText(14),
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.scaleHeight(24)),
            CustomButtonFactory.primary(
              levelType: getLevelTypeFromModel(levelModel.levelNumber),
              onPressed: () => Navigator.of(context).pop(),
              text: 'Go Back',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, QuizLoaded state) {
    return QuizWelcomeWidget(
      quiz: state.quiz,
      levelType: getLevelTypeFromModel(levelModel.levelNumber),
      onStartQuiz: () {
        context.read<QuizBloc>().add(const StartQuiz());
      },
    );
  }

  Widget _buildQuizInProgressState(BuildContext context, QuizInProgress state) {
    return QuizQuestionWidget(
      quiz: state.quiz,
      attempt: state.attempt,
      currentQuestion: state.currentQuestion,
      timeRemaining: state.timeRemaining,
      levelType: getLevelTypeFromModel(levelModel.levelNumber),
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
        context.read<QuizBloc>().add(const SubmitQuiz());
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
              context.read<QuizBloc>().add(
                LoadQuiz(
                  quizId: state.quiz.id,
                  levelNumber: levelModel.levelNumber,
                ),
              );
            }
          : null,
    );
  }
}
