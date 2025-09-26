// lib/Models/quiz_attempt_model/quiz_attempt_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizAttemptModel {
  final String id;
  final String pupilId;
  final String quizId;
  final int levelNumber;

  // Time tracking
  final DateTime startedAt;
  final DateTime? completedAt;
  final String status; // 'in_progress', 'completed', 'abandoned', 'expired'

  // Results
  final int totalQuestions;
  final int totalPoints;
  final int scoreObtained;
  final bool passed;

  // Performance metrics
  final int timeTaken; // in seconds - actual time spent

  // Detailed responses
  final List<QuestionResponse> responses;
  final Map<String, dynamic> analytics;

  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;

  const QuizAttemptModel({
    required this.id,
    required this.pupilId,
    required this.quizId,
    required this.levelNumber,
    required this.startedAt,
    this.completedAt,
    this.status = 'in_progress',
    required this.totalQuestions,
    required this.totalPoints,
    this.scoreObtained = 0,
    this.passed = false,
    this.timeTaken = 0,
    this.responses = const [],
    this.analytics = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  // Helper method to calculate remaining time dynamically
  int getTimeRemaining(int? quizTimeLimit) {
    if (quizTimeLimit == null || status != 'in_progress') return 0;
    return (quizTimeLimit * 60 - timeTaken).clamp(0, quizTimeLimit * 60);
  }

  // Check if attempt has expired
  bool get isExpired {
    return status == 'expired';
  }

  // Calculate duration of attempt
  Duration get attemptDuration {
    final endTime = completedAt ?? DateTime.now();
    return endTime.difference(startedAt);
  }

  // Calculate percentage score
  double get percentage {
    if (totalPoints == 0) return 0.0;
    return (scoreObtained / totalPoints) * 100;
  }

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'pupilId': pupilId,
    'quizId': quizId,
    'levelNumber': levelNumber,
    'startedAt': Timestamp.fromDate(startedAt),
    'completedAt': completedAt != null
        ? Timestamp.fromDate(completedAt!)
        : null,
    'status': status,
    'totalQuestions': totalQuestions,
    'totalPoints': totalPoints,
    'scoreObtained': scoreObtained,
    'passed': passed,
    'timeTaken': timeTaken,
    'responses': responses.map((r) => r.toFirestore()).toList(),
    'analytics': analytics,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };

  factory QuizAttemptModel.fromFirestore(Map<String, dynamic> json) =>
      QuizAttemptModel(
        id: json['id'] ?? '',
        pupilId: json['pupilId'] ?? '',
        quizId: json['quizId'] ?? '',
        levelNumber: json['levelNumber'] ?? 1,
        startedAt: _toDateTime(json['startedAt']),
        completedAt: json['completedAt'] != null
            ? _toDateTime(json['completedAt'])
            : null,
        status: json['status'] ?? 'in_progress',
        totalQuestions: json['totalQuestions'] ?? 0,
        totalPoints: json['totalPoints'] ?? 0,
        scoreObtained: json['scoreObtained'] ?? 0,
        passed: json['passed'] ?? false,
        timeTaken: json['timeTaken'] ?? 0,
        responses:
            (json['responses'] as List<dynamic>?)
                ?.map((e) => QuestionResponse.fromFirestore(e))
                .toList() ??
            [],
        analytics: json['analytics'] ?? {},
        createdAt: _toDateTime(json['createdAt']),
        updatedAt: _toDateTime(json['updatedAt']),
      );

  QuizAttemptModel copyWith({
    String? id,
    String? pupilId,
    String? quizId,
    int? levelNumber,
    DateTime? startedAt,
    DateTime? completedAt,
    String? status,
    int? totalQuestions,
    int? totalPoints,
    int? scoreObtained,
    bool? passed,
    int? timeTaken,
    List<QuestionResponse>? responses,
    Map<String, dynamic>? analytics,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => QuizAttemptModel(
    id: id ?? this.id,
    pupilId: pupilId ?? this.pupilId,
    quizId: quizId ?? this.quizId,
    levelNumber: levelNumber ?? this.levelNumber,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt ?? this.completedAt,
    status: status ?? this.status,
    totalQuestions: totalQuestions ?? this.totalQuestions,
    totalPoints: totalPoints ?? this.totalPoints,
    scoreObtained: scoreObtained ?? this.scoreObtained,
    passed: passed ?? this.passed,
    timeTaken: timeTaken ?? this.timeTaken,
    responses: responses ?? this.responses,
    analytics: analytics ?? this.analytics,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  static DateTime _toDateTime(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is String) return DateTime.parse(v);
    return DateTime.now();
  }
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
    this.wasSkipped = false,
    required this.answeredAt,
  });

  Map<String, dynamic> toFirestore() => {
    'questionId': questionId,
    'question': question,
    'options': options,
    'selectedAnswer': selectedAnswer,
    'correctAnswer': correctAnswer,
    'isCorrect': isCorrect,
    'points': points,
    'pointsEarned': pointsEarned,
    'wasSkipped': wasSkipped,
    'answeredAt': Timestamp.fromDate(answeredAt),
  };

  factory QuestionResponse.fromFirestore(Map<String, dynamic> json) =>
      QuestionResponse(
        questionId: json['questionId'] ?? '',
        question: json['question'] ?? '',
        options: json['options']?.cast<String>() ?? [],
        selectedAnswer: json['selectedAnswer'],
        correctAnswer: json['correctAnswer'] ?? '',
        isCorrect: json['isCorrect'] ?? false,
        points: json['points'] ?? 1,
        pointsEarned: json['pointsEarned'] ?? 0,
        wasSkipped: json['wasSkipped'] ?? false,
        answeredAt: _toDateTime(json['answeredAt']),
      );

  static DateTime _toDateTime(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is String) return DateTime.parse(v);
    return DateTime.now();
  }

  QuestionResponse copyWith({
    String? questionId,
    String? question,
    List<String>? options,
    String? selectedAnswer,
    String? correctAnswer,
    bool? isCorrect,
    int? points,
    int? pointsEarned,
    bool? wasSkipped,
    DateTime? answeredAt,
  }) => QuestionResponse(
    questionId: questionId ?? this.questionId,
    question: question ?? this.question,
    options: options ?? this.options,
    selectedAnswer: selectedAnswer ?? this.selectedAnswer,
    correctAnswer: correctAnswer ?? this.correctAnswer,
    isCorrect: isCorrect ?? this.isCorrect,
    points: points ?? this.points,
    pointsEarned: pointsEarned ?? this.pointsEarned,
    wasSkipped: wasSkipped ?? this.wasSkipped,
    answeredAt: answeredAt ?? this.answeredAt,
  );
}
