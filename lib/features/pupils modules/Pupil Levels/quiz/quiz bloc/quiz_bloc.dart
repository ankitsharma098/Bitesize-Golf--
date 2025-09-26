import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../Models/quiz attempt model/quiz_attempt_model.dart';
import '../../../../../Models/quiz model/quiz_model.dart';

import '../data/quiz_repo.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository _repository = QuizRepository();

  QuizBloc() : super(QuizInitial()) {
    on<LoadQuiz>(_onLoadQuiz);
    on<StartQuiz>(_onStartQuiz);
    on<AnswerQuestion>(_onAnswerQuestion);
    on<NextQuestion>(_onNextQuestion);
    on<PreviousQuestion>(_onPreviousQuestion);
    on<SubmitQuiz>(_onSubmitQuiz);
    on<RetakeQuiz>(_onRetakeQuiz);
  }

  Future<void> _onLoadQuiz(LoadQuiz event, Emitter<QuizState> emit) async {
    emit(QuizLoading());

    try {
      QuizModel? quiz;

      // Get quiz by ID if provided, otherwise get first quiz by level
      if (event.quizId.isNotEmpty) {
        quiz = await _repository.getQuizById(event.quizId);
      } else {
        quiz = await _repository.getFirstQuizByLevel(event.levelNumber);
      }

      if (quiz == null) {
        emit(const QuizError(message: 'No quiz found for this level'));
        return;
      }

      // Get the latest attempt for this quiz
      final latestAttempt = await _repository.getLatestQuizAttempt(quiz.id);

      if (latestAttempt == null) {
        // No previous attempts - show welcome screen for fresh start
        emit(QuizLoaded(quiz: quiz, previousAttempt: null));
        return;
      }

      // Handle different attempt statuses
      switch (latestAttempt.status) {
        case 'in_progress':
          // Resume the in-progress quiz
          final currentQuestionIndex = _getCurrentQuestionIndex(
            quiz,
            latestAttempt,
          );
          final hasAnsweredCurrent = _hasAnsweredCurrentQuestion(
            quiz,
            latestAttempt,
            currentQuestionIndex,
          );

          emit(
            QuizInProgress(
              quiz: quiz,
              attempt: latestAttempt,
              currentQuestionIndex: currentQuestionIndex,
              timeRemaining: 0, // No timer functionality
              hasAnsweredCurrentQuestion: hasAnsweredCurrent,
            ),
          );
          break;

        case 'completed':
          // Check if retakes are allowed and user hasn't exceeded attempts
          final canRetake = await _repository.canRetakeQuiz(quiz.id);

          if (canRetake) {
            // Show welcome screen with option to retake
            emit(QuizLoaded(quiz: quiz, previousAttempt: latestAttempt));
          } else {
            // Max attempts exceeded - show final results
            emit(QuizCompleted(quiz: quiz, attempt: latestAttempt));
          }
          break;

        case 'abandoned':
        case 'expired':
        default:
          // Previous attempt was not completed properly - show welcome for restart
          emit(QuizLoaded(quiz: quiz, previousAttempt: latestAttempt));
          break;
      }
    } catch (e) {
      emit(QuizError(message: e.toString()));
    }
  }

  Future<void> _onStartQuiz(StartQuiz event, Emitter<QuizState> emit) async {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;

      try {
        emit(QuizLoading());

        // Create new quiz attempt
        final attempt = await _repository.startQuizAttempt(
          currentState.quiz.id,
          currentState.quiz.levelNumber,
          currentState.quiz.totalQuestions,
          currentState.quiz.totalPoints,
        );

        emit(
          QuizInProgress(
            quiz: currentState.quiz,
            attempt: attempt,
            currentQuestionIndex: 0,
            timeRemaining: 0, // No timer
            hasAnsweredCurrentQuestion: false,
          ),
        );
      } catch (e) {
        emit(QuizError(message: e.toString()));
      }
    }
  }

  Future<void> _onRetakeQuiz(RetakeQuiz event, Emitter<QuizState> emit) async {
    if (state is QuizLoaded || state is QuizCompleted) {
      final quiz = state is QuizLoaded
          ? (state as QuizLoaded).quiz
          : (state as QuizCompleted).quiz;

      try {
        // Double-check retake eligibility
        final canRetake = await _repository.canRetakeQuiz(quiz.id);
        if (!canRetake) {
          emit(
            const QuizError(message: 'No more retakes allowed for this quiz'),
          );
          return;
        }

        emit(QuizLoading());

        // Create new quiz attempt for retake
        final attempt = await _repository.startQuizAttempt(
          quiz.id,
          quiz.levelNumber,
          quiz.totalQuestions,
          quiz.totalPoints,
        );

        emit(
          QuizInProgress(
            quiz: quiz,
            attempt: attempt,
            currentQuestionIndex: 0,
            timeRemaining: 0, // No timer
            hasAnsweredCurrentQuestion: false,
          ),
        );
      } catch (e) {
        emit(QuizError(message: e.toString()));
      }
    }
  }

  void _onAnswerQuestion(AnswerQuestion event, Emitter<QuizState> emit) async {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      final currentIndex = currentState.currentQuestionIndex;
      final question = currentState.quiz.questions[currentIndex];

      // Don't allow answering if already answered (one-time selection)
      if (currentState.hasAnsweredCurrentQuestion) {
        return;
      }

      // FIX: Convert option letter to actual option text for comparison
      final selectedOptionIndex =
          event.selectedAnswer.codeUnitAt(0) - 65; // A=0, B=1, C=2, D=3
      final selectedOptionText = question.options?[selectedOptionIndex] ?? '';

      // Create response for current question
      final response = QuestionResponse(
        questionId: question.questionId,
        question: question.question,
        options: question.options ?? [],
        selectedAnswer:
            event.selectedAnswer, // Keep the letter for UI reference
        correctAnswer: question.correctAnswer,
        // FIX: Compare the actual option text with correctAnswer
        isCorrect: selectedOptionText == question.correctAnswer,
        points: question.points,
        // FIX: Award points based on correct comparison
        pointsEarned: selectedOptionText == question.correctAnswer
            ? question.points
            : 0,
        wasSkipped: false,
        answeredAt: DateTime.now(),
      );

      // Update responses list
      final updatedResponses = List<QuestionResponse>.from(
        currentState.attempt.responses,
      );
      updatedResponses.add(response);

      // Calculate updated score
      final scoreObtained = updatedResponses.fold<int>(
        0,
        (sum, r) => sum + r.pointsEarned,
      );

      final updatedAttempt = currentState.attempt.copyWith(
        responses: updatedResponses,
        scoreObtained: scoreObtained,
        updatedAt: DateTime.now(),
      );

      // Immediately save progress to Firestore
      try {
        await _repository.saveQuizProgress(
          updatedAttempt.id,
          updatedResponses,
          scoreObtained,
        );
      } catch (error) {
        print('Auto-save failed: $error');
      }

      emit(
        QuizInProgress(
          quiz: currentState.quiz,
          attempt: updatedAttempt,
          currentQuestionIndex: currentIndex,
          timeRemaining: 0, // No timer
          hasAnsweredCurrentQuestion: true,
        ),
      );
    }
  }

  void _onNextQuestion(NextQuestion event, Emitter<QuizState> emit) {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      final nextIndex = currentState.currentQuestionIndex + 1;

      if (nextIndex < currentState.quiz.questions.length) {
        // Check if next question has been answered
        final nextQuestion = currentState.quiz.questions[nextIndex];
        final hasAnsweredNext = currentState.attempt.responses.any(
          (r) => r.questionId == nextQuestion.questionId,
        );

        emit(
          QuizInProgress(
            quiz: currentState.quiz,
            attempt: currentState.attempt,
            currentQuestionIndex: nextIndex,
            timeRemaining: 0, // No timer
            hasAnsweredCurrentQuestion: hasAnsweredNext,
          ),
        );
      }
    }
  }

  // Remove previous question functionality - no going back
  void _onPreviousQuestion(PreviousQuestion event, Emitter<QuizState> emit) {
    // Do nothing - previous functionality removed
    return;
  }

  Future<void> _onSubmitQuiz(SubmitQuiz event, Emitter<QuizState> emit) async {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;

      try {
        // Calculate final results - use actual duration
        final totalTimeTaken = DateTime.now()
            .difference(currentState.attempt.startedAt)
            .inSeconds;

        final passed =
            currentState.attempt.scoreObtained >=
            (currentState.quiz.passingScore *
                currentState.quiz.totalPoints /
                100);

        // Complete the attempt
        final completedAttempt = await _repository.completeQuizAttempt(
          currentState.attempt.id,
          currentState.quiz.id,
          currentState.quiz.levelNumber,
          currentState.attempt.responses,
          currentState.attempt.scoreObtained,
          totalTimeTaken,
          passed,
        );

        emit(QuizCompleted(quiz: currentState.quiz, attempt: completedAttempt));
      } catch (e) {
        emit(QuizError(message: e.toString()));
      }
    }
  }

  // Helper method to determine current question index based on responses
  int _getCurrentQuestionIndex(QuizModel quiz, QuizAttemptModel attempt) {
    if (attempt.responses.isEmpty) return 0;

    // Find the first unanswered question
    for (int i = 0; i < quiz.questions.length; i++) {
      final question = quiz.questions[i];
      final hasResponse = attempt.responses.any(
        (r) => r.questionId == question.questionId,
      );
      if (!hasResponse) return i;
    }

    // All questions answered, go to last question for review
    return quiz.questions.length - 1;
  }

  // Helper method to check if current question is answered
  bool _hasAnsweredCurrentQuestion(
    QuizModel quiz,
    QuizAttemptModel attempt,
    int questionIndex,
  ) {
    if (questionIndex >= quiz.questions.length) return false;
    final question = quiz.questions[questionIndex];
    return attempt.responses.any((r) => r.questionId == question.questionId);
  }
}
