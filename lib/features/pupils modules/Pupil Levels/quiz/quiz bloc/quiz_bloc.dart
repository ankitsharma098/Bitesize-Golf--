import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../Models/quiz attempt model/quiz_attempt_model.dart';
import '../../../../../Models/quiz model/quiz_model.dart';

import '../data/quiz_repo.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository _repository = QuizRepository();
  Timer? _timer;
  int _timeRemaining = 0;

  QuizBloc() : super(QuizInitial()) {
    on<LoadQuiz>(_onLoadQuiz);
    on<StartQuiz>(_onStartQuiz);
    on<AnswerQuestion>(_onAnswerQuestion);
    on<NextQuestion>(_onNextQuestion);
    on<PreviousQuestion>(_onPreviousQuestion);
    on<SubmitQuiz>(_onSubmitQuiz);
    on<TimerTicked>(_onTimerTicked);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> _onLoadQuiz(LoadQuiz event, Emitter<QuizState> emit) async {
    emit(QuizLoading());

    try {
      QuizModel? quiz;

      // First try to get quiz by ID if provided
      if (event.quizId.isNotEmpty) {
        quiz = await _repository.getQuizById(event.quizId);
      }

      // If no quiz found by ID, get first quiz by level
      quiz ??= await _repository.getFirstQuizByLevel(event.levelNumber);

      if (quiz == null) {
        emit(const QuizError(message: 'No quiz found for this level'));
        return;
      }

      emit(QuizLoaded(quiz: quiz));
    } catch (e) {
      emit(QuizError(message: e.toString()));
    }
  }

  Future<void> _onStartQuiz(StartQuiz event, Emitter<QuizState> emit) async {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;

      try {
        emit(QuizLoading());

        // Initialize quiz attempt
        final attempt = await _repository.startQuizAttempt(
          currentState.quiz.id,
          currentState.quiz.levelNumber,
          currentState.quiz.totalQuestions,
          currentState.quiz.totalPoints,
        );

        // Set up timer if quiz has time limit
        if (currentState.quiz.timeLimit != null) {
          _timeRemaining =
              currentState.quiz.timeLimit! * 60; // Convert to seconds
          _startTimer();
        }

        emit(
          QuizInProgress(
            quiz: currentState.quiz,
            attempt: attempt,
            currentQuestionIndex: 0,
            timeRemaining: _timeRemaining,
          ),
        );
      } catch (e) {
        emit(QuizError(message: e.toString()));
      }
    }
  }

  void _onAnswerQuestion(AnswerQuestion event, Emitter<QuizState> emit) {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      final currentIndex = currentState.currentQuestionIndex;
      final question = currentState.quiz.questions[currentIndex];

      // Create response for current question
      final response = QuestionResponse(
        questionId: question.questionId,
        question: question.question,
        options: question.options ?? [],
        selectedAnswer: event.selectedAnswer,
        correctAnswer: question.correctAnswer,
        isCorrect: event.selectedAnswer == question.correctAnswer,
        points: question.points,
        pointsEarned: event.selectedAnswer == question.correctAnswer
            ? question.points
            : 0,
        wasSkipped: false,
        answeredAt: DateTime.now(),
      );

      // Update responses list
      final updatedResponses = List<QuestionResponse>.from(
        currentState.attempt.responses,
      );

      // Replace if answer already exists, otherwise add
      final existingIndex = updatedResponses.indexWhere(
        (r) => r.questionId == question.questionId,
      );

      if (existingIndex != -1) {
        updatedResponses[existingIndex] = response;
      } else {
        updatedResponses.add(response);
      }

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

      emit(
        QuizInProgress(
          quiz: currentState.quiz,
          attempt: updatedAttempt,
          currentQuestionIndex: currentIndex,
          timeRemaining: _timeRemaining,
        ),
      );
    }
  }

  void _onNextQuestion(NextQuestion event, Emitter<QuizState> emit) {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      final nextIndex = currentState.currentQuestionIndex + 1;

      if (nextIndex < currentState.quiz.questions.length) {
        emit(
          QuizInProgress(
            quiz: currentState.quiz,
            attempt: currentState.attempt,
            currentQuestionIndex: nextIndex,
            timeRemaining: _timeRemaining,
          ),
        );
      }
    }
  }

  void _onPreviousQuestion(PreviousQuestion event, Emitter<QuizState> emit) {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      final previousIndex = currentState.currentQuestionIndex - 1;

      if (previousIndex >= 0) {
        emit(
          QuizInProgress(
            quiz: currentState.quiz,
            attempt: currentState.attempt,
            currentQuestionIndex: previousIndex,
            timeRemaining: _timeRemaining,
          ),
        );
      }
    }
  }

  Future<void> _onSubmitQuiz(SubmitQuiz event, Emitter<QuizState> emit) async {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;

      try {
        _timer?.cancel();

        // Calculate final results
        final totalTimeTaken = currentState.quiz.timeLimit != null
            ? (currentState.quiz.timeLimit! * 60) - _timeRemaining
            : DateTime.now()
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

  void _onTimerTicked(TimerTicked event, Emitter<QuizState> emit) {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      _timeRemaining = event.timeRemaining;

      if (_timeRemaining <= 0) {
        // Time's up, auto-submit
        add(const SubmitQuiz());
        return;
      }

      emit(
        QuizInProgress(
          quiz: currentState.quiz,
          attempt: currentState.attempt,
          currentQuestionIndex: currentState.currentQuestionIndex,
          timeRemaining: _timeRemaining,
        ),
      );
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        add(TimerTicked(timeRemaining: _timeRemaining - 1));
      } else {
        timer.cancel();
      }
    });
  }
}
