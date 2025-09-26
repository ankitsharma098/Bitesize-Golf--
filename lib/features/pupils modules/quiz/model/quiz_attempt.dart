class QuizAttemptModel {
  final String id;
  final String pupilId;
  final String quizId;
  final String quizTitle;
  final int levelNumber;

  final int attemptNumber;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String status;

  final int totalQuestions;
  final int totalPoints;
  final int scoreObtained;
  final double percentage;
  final bool passed;
  final int passingScore;

  final int timeLimit;
  final int timeTaken;
  final int timeRemaining;

  final List<QuestionResponse> responses;
  final Map<String, dynamic> analytics;

  final int xpEarned;
  final List<String> badgesEarned;

  final DateTime createdAt;
  final DateTime updatedAt;

  const QuizAttemptModel({
    required this.id,
    required this.pupilId,
    required this.quizId,
    required this.quizTitle,
    required this.levelNumber,
    required this.attemptNumber,
    required this.startedAt,
    this.completedAt,
    this.status = 'in_progress',
    required this.totalQuestions,
    required this.totalPoints,
    this.scoreObtained = 0,
    this.percentage = 0.0,
    this.passed = false,
    required this.passingScore,
    required this.timeLimit,
    this.timeTaken = 0,
    this.timeRemaining = 0,
    this.responses = const [],
    this.analytics = const {},
    this.xpEarned = 0,
    this.badgesEarned = const [],
    required this.createdAt,
    required this.updatedAt,
  });
}

class QuestionResponse {
  final String questionId;
  final String question;
  final List<String> options;
  final String? selectedAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final int points;
  final int pointsEarned;
  final int responseTime;
  final bool wasSkipped;
  final DateTime answeredAt;

  const QuestionResponse({
    required this.questionId,
    required this.question,
    required this.options,
    this.selectedAnswer,
    required this.correctAnswer,
    this.isCorrect = false,
    required this.points,
    this.pointsEarned = 0,
    this.responseTime = 0,
    this.wasSkipped = false,
    required this.answeredAt,
  });
}