part of 'quiz_bloc.dart';

@immutable
sealed class QuizState {}

final class QuizInitial extends QuizState {}

final class QuizLoading extends QuizState {}

final class QuizLoaded extends QuizState {
  final QuizModel quiz;
  final int currentQuestion;
  final double progress;
  final Map<String, String> selectedAnswers;

  QuizLoaded({
    required this.quiz,
    required this.currentQuestion,
    required this.progress,
    required this.selectedAnswers,
  });

  QuizLoaded copyWith({
    QuizModel? quiz,
    int? currentQuestion,
    double? progress,
    Map<String, String>? selectedAnswers,
  }) {
    return QuizLoaded(
      quiz: quiz ?? this.quiz,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      progress: progress ?? this.progress,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
    );
  }
}

final class QuizCompleted extends QuizState {
  final QuizModel quiz;
  final Map<String, String> selectedAnswers;
  final int correctCount;
  final double scorePercentage;

  QuizCompleted({
    required this.quiz,
    required this.selectedAnswers,
    required this.correctCount,
    required this.scorePercentage,
  });
}

final class QuizError extends QuizState {
  final String message;
  QuizError(this.message);
}
