import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  final String id;
  final String title;
  final String description;
  final int levelNumber;
  final int? timeLimit;
  final double passingScore;
  final bool allowRetakes;
  final int? maxAttempts;
  final List<QuizQuestionModel> questions;
  final int totalQuestions;
  final int totalPoints;
  final int estimatedTime;
  final String accessTier;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  const QuizModel({
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

  factory QuizModel.create({
    required String id,
    required String title,
    required String description,
    required int levelNumber,
    required List<QuizQuestionModel> questions,
    required double passingScore,
    int? timeLimit,
    bool allowRetakes = true,
    int? maxAttempts,
    String accessTier = 'free',
    int sortOrder = 0,
    String createdBy = '',
  }) {
    final now = DateTime.now();
    final totalQ = questions.length;
    final totalP = questions.fold<int>(0, (sum, q) => sum + q.points);
    final estimated = (totalQ * 0.75).ceil();
    return QuizModel(
      id: id,
      title: title,
      description: description,
      levelNumber: levelNumber,
      timeLimit: timeLimit,
      passingScore: passingScore,
      allowRetakes: allowRetakes,
      maxAttempts: maxAttempts,
      questions: questions,
      totalQuestions: totalQ,
      totalPoints: totalP,
      estimatedTime: estimated,
      accessTier: accessTier,
      isActive: true,
      sortOrder: sortOrder,
      createdAt: now,
      updatedAt: now,
      createdBy: createdBy,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'title': title,
    'description': description,
    'levelNumber': levelNumber,
    'timeLimit': timeLimit,
    'passingScore': passingScore,
    'allowRetakes': allowRetakes,
    'maxAttempts': maxAttempts,
    'questions': questions.map((q) => q.toFirestore()).toList(),
    'totalQuestions': totalQuestions,
    'totalPoints': totalPoints,
    'estimatedTime': estimatedTime,
    'accessTier': accessTier,
    'isActive': isActive,
    'sortOrder': sortOrder,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
    'createdBy': createdBy,
  };

  factory QuizModel.fromFirestore(Map<String, dynamic> json) => QuizModel(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    levelNumber: json['levelNumber'] ?? 1,
    timeLimit: json['timeLimit'],
    passingScore: (json['passingScore'] ?? 0.0).toDouble(),
    allowRetakes: json['allowRetakes'] ?? true,
    maxAttempts: json['maxAttempts'],
    questions:
        (json['questions'] as List<dynamic>?)
            ?.map((e) => QuizQuestionModel.fromFirestore(e))
            .toList() ??
        [],
    totalQuestions: json['totalQuestions'] ?? 0,
    totalPoints: json['totalPoints'] ?? 0,
    estimatedTime: json['estimatedTime'] ?? 0,
    accessTier: json['accessTier'] ?? 'free',
    isActive: json['isActive'] ?? true,
    sortOrder: json['sortOrder'] ?? 0,
    createdAt: _toDateTime(json['createdAt']),
    updatedAt: _toDateTime(json['updatedAt']),
    createdBy: json['createdBy'] ?? '',
  );

  QuizModel copyWith({
    String? id,
    String? title,
    String? description,
    int? levelNumber,
    int? timeLimit,
    double? passingScore,
    bool? allowRetakes,
    int? maxAttempts,
    List<QuizQuestionModel>? questions,
    int? totalQuestions,
    int? totalPoints,
    int? estimatedTime,
    String? accessTier,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) => QuizModel(
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

  static DateTime _toDateTime(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is String) return DateTime.parse(v);
    return DateTime.now();
  }
}

/* -------------------------------------------------- */
class QuizQuestionModel {
  final String questionId;
  final String type;
  final String question;
  final List<String>? options;
  final String correctAnswer;
  final String? explanation;
  final int points;

  const QuizQuestionModel({
    required this.questionId,
    required this.type,
    required this.question,
    this.options,
    required this.correctAnswer,
    this.explanation,
    required this.points,
  });

  Map<String, dynamic> toFirestore() => {
    'questionId': questionId,
    'type': type,
    'question': question,
    'options': options,
    'correctAnswer': correctAnswer,
    'explanation': explanation,
    'points': points,
  };

  factory QuizQuestionModel.fromFirestore(Map<String, dynamic> json) =>
      QuizQuestionModel(
        questionId: json['questionId'] ?? '',
        type: json['type'] ?? 'multiple_choice',
        question: json['question'] ?? '',
        options: json['options']?.cast<String>(),
        correctAnswer: json['correctAnswer'] ?? '',
        explanation: json['explanation'],
        points: json['points'] ?? 1,
      );

  QuizQuestionModel copyWith({
    String? questionId,
    String? type,
    String? question,
    List<String>? options,
    String? correctAnswer,
    String? explanation,
    int? points,
  }) => QuizQuestionModel(
    questionId: questionId ?? this.questionId,
    type: type ?? this.type,
    question: question ?? this.question,
    options: options ?? this.options,
    correctAnswer: correctAnswer ?? this.correctAnswer,
    explanation: explanation ?? this.explanation,
    points: points ?? this.points,
  );
}
