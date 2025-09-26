import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object> get props => [];
}

class LoadQuiz extends QuizEvent {
  final String quizId;
  final int levelNumber;

  const LoadQuiz({required this.quizId, required this.levelNumber});

  @override
  List<Object> get props => [quizId, levelNumber];
}

class StartQuiz extends QuizEvent {
  const StartQuiz();
}

class RetakeQuiz extends QuizEvent {
  const RetakeQuiz();
}

class AnswerQuestion extends QuizEvent {
  final String selectedAnswer;

  const AnswerQuestion({required this.selectedAnswer});

  @override
  List<Object> get props => [selectedAnswer];
}

class NextQuestion extends QuizEvent {
  const NextQuestion();
}

class PreviousQuestion extends QuizEvent {
  const PreviousQuestion();
}

class SubmitQuiz extends QuizEvent {
  const SubmitQuiz();
}
