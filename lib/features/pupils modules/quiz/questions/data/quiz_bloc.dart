import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../Models/quiz model/quiz_model.dart';

part 'quiz_event.dart';

part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  static const String staticQuizId = "IAkzdCb6CS26XY31kaf9";

  QuizBloc() : super(QuizInitial()) {
    on<LoadQuiz>(_onLoadQuiz);
    on<SelectAnswer>(_onSelectAnswer);
    on<NextQuestion>(_onNextQuestion);
    on<RetryQuiz>(_onRetryQuiz);
    on<CompleteQuiz>(_onCompleteQuiz);
  }

  Future<void> _onLoadQuiz(LoadQuiz event, Emitter<QuizState> emit) async {
    emit(QuizLoading());
    try {
      final doc = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(event.quizId)
          .get();

      if (!doc.exists) {
        emit(QuizError("Quiz not found!"));
        return;
      }

      final data = doc.data()!;
      final quiz = QuizModel.fromFirestore(data);

      emit(
        QuizLoaded(
          quiz: quiz,
          currentQuestion: 0,
          progress: 1 / quiz.questions.length,
          selectedAnswers: {},
        ),
      );
    } catch (e) {
      debugPrint("Error fetching quiz: $e");
      emit(QuizError("Failed to load quiz: ${e.toString()}"));
    }
  }

  void _onSelectAnswer(SelectAnswer event, Emitter<QuizState> emit) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      final updatedAnswers = Map<String, String>.from(
        currentState.selectedAnswers,
      );
      updatedAnswers[event.questionId] = event.selectedAnswer;
      emit(currentState.copyWith(selectedAnswers: updatedAnswers));
    }
  }

  void _onNextQuestion(NextQuestion event, Emitter<QuizState> emit) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      if (currentState.currentQuestion <
          currentState.quiz.questions.length - 1) {
        final nextQuestion = currentState.currentQuestion + 1;
        emit(
          currentState.copyWith(
            currentQuestion: nextQuestion,
            progress: (nextQuestion + 1) / currentState.quiz.questions.length,
          ),
        );
      } else {
        add(CompleteQuiz());
      }
    }
  }

  void _onCompleteQuiz(CompleteQuiz event, Emitter<QuizState> emit) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;

      int correctCount = 0;
      for (var question in currentState.quiz.questions) {
        if (currentState.selectedAnswers[question.questionId] ==
            question.correctAnswer) {
          correctCount++;
        }
      }

      final scorePercentage =
          (correctCount / currentState.quiz.questions.length) * 100;

      emit(
        QuizCompleted(
          quiz: currentState.quiz,
          selectedAnswers: currentState.selectedAnswers,
          correctCount: correctCount,
          scorePercentage: scorePercentage,
        ),
      );
    }
  }

  void _onRetryQuiz(RetryQuiz event, Emitter<QuizState> emit) {
    if (state is QuizCompleted) {
      final completedState = state as QuizCompleted;

      emit(
        QuizLoaded(
          quiz: completedState.quiz,
          currentQuestion: 0,
          progress: 1 / completedState.quiz.questions.length,
          selectedAnswers: {},
        ),
      );
    }
  }
}
