import 'package:equatable/equatable.dart';
import '../../../../../Models/quiz attempt model/quiz_attempt_model.dart';
import '../../../../../Models/quiz model/quiz_model.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final QuizModel quiz;
  final QuizAttemptModel? previousAttempt;

  const QuizLoaded({required this.quiz, this.previousAttempt});

  @override
  List<Object?> get props => [quiz, previousAttempt];
}

class QuizInProgress extends QuizState {
  final QuizModel quiz;
  final QuizAttemptModel attempt;
  final int currentQuestionIndex;
  final int timeRemaining;
  final bool hasAnsweredCurrentQuestion;

  const QuizInProgress({
    required this.quiz,
    required this.attempt,
    required this.currentQuestionIndex,
    required this.timeRemaining,
    this.hasAnsweredCurrentQuestion = false,
  });

  QuizQuestionModel get currentQuestion => quiz.questions[currentQuestionIndex];

  bool get isLastQuestion => currentQuestionIndex == quiz.questions.length - 1;
  bool get isFirstQuestion => currentQuestionIndex == 0;

  @override
  List<Object?> get props => [
    quiz,
    attempt,
    currentQuestionIndex,
    timeRemaining,
    hasAnsweredCurrentQuestion,
  ];
}

class QuizCompleted extends QuizState {
  final QuizModel quiz;
  final QuizAttemptModel attempt;

  const QuizCompleted({required this.quiz, required this.attempt});

  @override
  List<Object?> get props => [quiz, attempt];
}

class QuizError extends QuizState {
  final String message;

  const QuizError({required this.message});

  @override
  List<Object> get props => [message];
}
