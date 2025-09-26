abstract class QuizEvent {
  const QuizEvent();
}

class LoadQuiz extends QuizEvent {
  final String quizId;
  final int levelNumber;

  const LoadQuiz({required this.quizId, required this.levelNumber});
}

class StartQuiz extends QuizEvent {
  const StartQuiz();
}

class AnswerQuestion extends QuizEvent {
  final String selectedAnswer;

  const AnswerQuestion({required this.selectedAnswer});
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

class TimerTicked extends QuizEvent {
  final int timeRemaining;

  const TimerTicked({required this.timeRemaining});
}
