import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Quiz extends Equatable {
  final String id;
  final String title;
  final String description;
  final int levelNumber;

  // Configuration
  final int? timeLimit; // seconds
  final double passingScore; // 0-100
  final bool allowRetakes;
  final int? maxAttempts;

  // Questions
  final List<QuizQuestion> questions;

  // Metadata
  final int totalQuestions;
  final int totalPoints;
  final int estimatedTime; // minutes

  // Access & status
  final String accessTier;
  final bool isActive;
  final int sortOrder;

  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  const Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.levelNumber,
    this.timeLimit,
    required this.passingScore,
    required this.allowRetakes,
    this.maxAttempts,
    required this.questions,
    required this.totalQuestions,
    required this.totalPoints,
    required this.estimatedTime,
    required this.accessTier,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    levelNumber,
    timeLimit,
    passingScore,
    allowRetakes,
    maxAttempts,
    questions,
    totalQuestions,
    totalPoints,
    estimatedTime,
    accessTier,
    isActive,
    sortOrder,
    createdAt,
    updatedAt,
    createdBy,
  ];

  Quiz copyWith({
    String? id,
    String? title,
    String? description,
    int? levelNumber,
    int? timeLimit,
    double? passingScore,
    bool? allowRetakes,
    int? maxAttempts,
    List<QuizQuestion>? questions,
    int? totalQuestions,
    int? totalPoints,
    int? estimatedTime,
    String? accessTier,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) => Quiz(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    levelNumber: levelNumber ?? this.levelNumber,
    timeLimit: timeLimit ?? this.timeLimit,
    passingScore: passingScore ?? this.passingScore,
    allowRetakes: allowRetakes ?? this.allowRetakes,
    maxAttempts: maxAttempts ?? this.maxAttempts,
    questions: questions ?? this.questions,
    totalQuestions: totalQuestions ?? this.totalQuestions,
    totalPoints: totalPoints ?? this.totalPoints,
    estimatedTime: estimatedTime ?? this.estimatedTime,
    accessTier: accessTier ?? this.accessTier,
    isActive: isActive ?? this.isActive,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    createdBy: createdBy ?? this.createdBy,
  );
}

/* ---------- Sub-entity: Question ---------- */

class QuizQuestion extends Equatable {
  final String questionId;
  final String type; // 'multiple_choice' | 'true_false'
  final String question;
  final List<String>? options;
  final String correctAnswer;
  final String? explanation;
  final int points;

  const QuizQuestion({
    required this.questionId,
    required this.type,
    required this.question,
    this.options,
    required this.correctAnswer,
    this.explanation,
    required this.points,
  });

  @override
  List<Object?> get props => [
    questionId,
    type,
    question,
    options,
    correctAnswer,
    explanation,
    points,
  ];

  QuizQuestion copyWith({
    String? questionId,
    String? type,
    String? question,
    List<String>? options,
    String? correctAnswer,
    String? explanation,
    int? points,
  }) => QuizQuestion(
    questionId: questionId ?? this.questionId,
    type: type ?? this.type,
    question: question ?? this.question,
    options: options ?? this.options,
    correctAnswer: correctAnswer ?? this.correctAnswer,
    explanation: explanation ?? this.explanation,
    points: points ?? this.points,
  );
}
