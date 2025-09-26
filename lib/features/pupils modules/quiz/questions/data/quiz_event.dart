part of 'quiz_bloc.dart';

@immutable
sealed class QuizEvent {}

class LoadQuiz extends QuizEvent {
  final String quizId;
  LoadQuiz(this.quizId);
}

class SelectAnswer extends QuizEvent {
  final String questionId;
  final String selectedAnswer;
  SelectAnswer({required this.questionId, required this.selectedAnswer});
}

class NextQuestion extends QuizEvent {}

class RetryQuiz extends QuizEvent {}

class CompleteQuiz extends QuizEvent {}
