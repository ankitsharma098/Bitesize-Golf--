import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/themes/theme_colors.dart';
import '../../../../components/custom_scaffold.dart';
import '../../../../components/utils/size_config.dart';
import '../data/quiz_bloc.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizBloc()..add(LoadQuiz(QuizBloc.staticQuizId)),
      child: const QuizView(),
    );
  }
}

class QuizView extends StatelessWidget {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) {},
      builder: (context, state) {
        return AppScaffold.content(
          title: state is QuizLoaded ? state.quiz.title : "Quiz",
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

          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, QuizState state) {
    switch (state) {
      case QuizInitial():
      case QuizLoading():
        return const Center(child: CircularProgressIndicator());

      case QuizError():
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.message),
              SizedBox(height: SizeConfig.scaleHeight(20)),
              ElevatedButton(
                onPressed: () => context.read<QuizBloc>().add(
                  LoadQuiz(QuizBloc.staticQuizId),
                ),
                child: const Text("Retry"),
              ),
            ],
          ),
        );

      case QuizLoaded():
        return _buildQuizContent(context, state);

      case QuizCompleted():
        return _buildCompletedContent(context, state);
    }
  }

  Widget _buildQuizContent(BuildContext context, QuizLoaded state) {
    final currentQ = state.quiz.questions[state.currentQuestion];
    final selectedAnswer = state.selectedAnswers[currentQ.questionId];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: SizeConfig.scaleHeight(20)),

          Column(
            children: [
              LinearProgressIndicator(
                value: state.progress,
                backgroundColor: Colors.grey[300],
                borderRadius: BorderRadius.circular(6),
                color: Colors.red,
                minHeight: 8,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Question ${state.currentQuestion + 1}/${state.quiz.questions.length}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey900,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.scaleHeight(30)),
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Good luck with your\n",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: "Red Quiz!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: SizeConfig.scaleHeight(30)),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Question ${state.currentQuestion + 1}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.redDark,
                  ),
                ),
                SizedBox(height: SizeConfig.scaleHeight(12)),
                Text(
                  currentQ.question,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.scaleHeight(20)),

                ...?currentQ.options?.asMap().entries.map((entry) {
                  int index = entry.key;
                  String option = entry.value;
                  bool isSelected = selectedAnswer == option;
                  Color borderColor = isSelected
                      ? AppColors.greenDark
                      : AppColors.grey500;

                  return GestureDetector(
                    onTap: () {
                      context.read<QuizBloc>().add(
                        SelectAnswer(
                          questionId: currentQ.questionId,
                          selectedAnswer: option,
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor, width: 2),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${String.fromCharCode(65 + index)}. $option",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          const Spacer(),

          ElevatedButton(
            onPressed: selectedAnswer != null
                ? () => context.read<QuizBloc>().add(NextQuestion())
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text("Next", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedContent(BuildContext context, QuizCompleted state) {
    final lastQ = state.quiz.questions.last;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: SizeConfig.scaleHeight(20)),

          Column(
            children: [
              LinearProgressIndicator(
                value: 1.0,
                backgroundColor: Colors.grey[300],
                borderRadius: BorderRadius.circular(6),
                color: Colors.red,
                minHeight: 8,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Question ${state.quiz.questions.length}/${state.quiz.questions.length}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey900,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: SizeConfig.scaleHeight(30)),

          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Quiz Completed!\n",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                TextSpan(
                  text: "Well done!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: SizeConfig.scaleHeight(30)),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Final Results",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.redDark,
                  ),
                ),
                SizedBox(height: SizeConfig.scaleHeight(20)),
                Text(
                  "You got ${state.correctCount} out of ${state.quiz.questions.length} correct!",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.scaleHeight(10)),
                Text(
                  "Score: ${state.scorePercentage.toStringAsFixed(1)}%",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
