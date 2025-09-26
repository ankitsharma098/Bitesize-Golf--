import '../../../../../Models/quiz attempt model/quiz_attempt_model.dart';
import '../../../../../Models/quiz model/quiz_model.dart';

abstract class QuizState {
  const QuizState();
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizError extends QuizState {
  final String message;

  const QuizError({required this.message});
}

class QuizLoaded extends QuizState {
  final QuizModel quiz;

  const QuizLoaded({required this.quiz});
}

class QuizInProgress extends QuizState {
  final QuizModel quiz;
  final QuizAttemptModel attempt;
  final int currentQuestionIndex;
  final int timeRemaining; // in seconds

  const QuizInProgress({
    required this.quiz,
    required this.attempt,
    required this.currentQuestionIndex,
    required this.timeRemaining,
  });

  QuizQuestionModel get currentQuestion => quiz.questions[currentQuestionIndex];

  bool get isLastQuestion => currentQuestionIndex == quiz.questions.length - 1;

  bool get isFirstQuestion => currentQuestionIndex == 0;

  String? get currentAnswer {
    final response = attempt.responses
        .where((r) => r.questionId == currentQuestion.questionId)
        .firstOrNull;
    // final response = attempt.responses.firstWhere(
    //   (r) => r.questionId == currentQuestion.questionId,
    //   orElse: () => null,
    // );
    return response?.selectedAnswer;
  }
}

class QuizCompleted extends QuizState {
  final QuizModel quiz;
  final QuizAttemptModel attempt;

  const QuizCompleted({required this.quiz, required this.attempt});
}
