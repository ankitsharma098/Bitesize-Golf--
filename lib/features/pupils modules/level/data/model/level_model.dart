import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/level_entity.dart' as entity;

class LevelModel {
  final int levelNumber;
  final String title;
  final String description;
  final String requiredPlan;
  final LevelContentModel content;
  final LevelRequirementsModel requirements;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  const LevelModel({
    required this.levelNumber,
    required this.title,
    required this.description,
    required this.requiredPlan,
    required this.content,
    required this.requirements,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  /* --------------------- to / from entity --------------------- */

  entity.Level toEntity() => entity.Level(
    levelNumber: levelNumber,
    title: title,
    description: description,
    requiredPlan: requiredPlan,
    content: content.toEntity(),
    requirements: requirements.toEntity(),
    isActive: isActive,
    sortOrder: sortOrder,
    createdAt: createdAt,
    updatedAt: updatedAt,
    createdBy: createdBy,
  );

  factory LevelModel.fromEntity(entity.Level level) => LevelModel(
    levelNumber: level.levelNumber,
    title: level.title,
    description: level.description,
    requiredPlan: level.requiredPlan,
    content: LevelContentModel.fromEntity(level.content),
    requirements: LevelRequirementsModel.fromEntity(level.requirements),
    isActive: level.isActive,
    sortOrder: level.sortOrder,
    createdAt: level.createdAt,
    updatedAt: level.updatedAt,
    createdBy: level.createdBy,
  );

  /* --------------------- JSON --------------------- */

  Map<String, dynamic> toJson() => {
    'levelNumber': levelNumber,
    'title': title,
    'description': description,
    'requiredPlan': requiredPlan,
    'content': content.toJson(),
    'requirements': requirements.toJson(),
    'isActive': isActive,
    'sortOrder': sortOrder,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
    'createdBy': createdBy,
  };

  factory LevelModel.fromJson(Map<String, dynamic> json) => LevelModel(
    levelNumber: json['levelNumber'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    requiredPlan: json['requiredPlan'] as String,
    content: LevelContentModel.fromJson(json['content']),
    requirements: LevelRequirementsModel.fromJson(json['requirements']),
    isActive: json['isActive'] as bool,
    sortOrder: json['sortOrder'] as int,
    createdAt: (json['createdAt'] as Timestamp).toDate(),
    updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    createdBy: json['createdBy'] as String,
  );

  factory LevelModel.fromFirestore(Map<String, dynamic> json) =>
      LevelModel.fromJson(json);
}

/* =================================================================
   Nested models
   ================================================================= */

class LevelContentModel {
  final List<String> books;
  final List<String> quizzes;
  final List<String> challenges;
  final List<String> games;

  const LevelContentModel({
    required this.books,
    required this.quizzes,
    required this.challenges,
    required this.games,
  });

  entity.LevelContent toEntity() => entity.LevelContent(
    books: books,
    quizzes: quizzes,
    challenges: challenges,
    games: games,
  );

  factory LevelContentModel.fromEntity(entity.LevelContent content) =>
      LevelContentModel(
        books: content.books,
        quizzes: content.quizzes,
        challenges: content.challenges,
        games: content.games,
      );

  Map<String, dynamic> toJson() => {
    'books': books,
    'quizzes': quizzes,
    'challenges': challenges,
    'games': games,
  };

  factory LevelContentModel.fromJson(Map<String, dynamic> json) =>
      LevelContentModel(
        books: List<String>.from(json['books'] ?? []),
        quizzes: List<String>.from(json['quizzes'] ?? []),
        challenges: List<String>.from(json['challenges'] ?? []),
        games: List<String>.from(json['games'] ?? []),
      );
}

class LevelRequirementsModel {
  final int minimumItems;
  final int requiredBooks;
  final int requiredQuizzes;
  final int requiredChallenges;
  final double passingScore;

  const LevelRequirementsModel({
    required this.minimumItems,
    required this.requiredBooks,
    required this.requiredQuizzes,
    required this.requiredChallenges,
    required this.passingScore,
  });

  entity.LevelRequirements toEntity() => entity.LevelRequirements(
    minimumItems: minimumItems,
    requiredBooks: requiredBooks,
    requiredQuizzes: requiredQuizzes,
    requiredChallenges: requiredChallenges,
    passingScore: passingScore,
  );

  factory LevelRequirementsModel.fromEntity(entity.LevelRequirements req) =>
      LevelRequirementsModel(
        minimumItems: req.minimumItems,
        requiredBooks: req.requiredBooks,
        requiredQuizzes: req.requiredQuizzes,
        requiredChallenges: req.requiredChallenges,
        passingScore: req.passingScore,
      );

  Map<String, dynamic> toJson() => {
    'minimumItems': minimumItems,
    'requiredBooks': requiredBooks,
    'requiredQuizzes': requiredQuizzes,
    'requiredChallenges': requiredChallenges,
    'passingScore': passingScore,
  };

  factory LevelRequirementsModel.fromJson(Map<String, dynamic> json) =>
      LevelRequirementsModel(
        minimumItems: json['minimumItems'] as int,
        requiredBooks: json['requiredBooks'] as int,
        requiredQuizzes: json['requiredQuizzes'] as int,
        requiredChallenges: json['requiredChallenges'] as int,
        passingScore: (json['passingScore'] as num).toDouble(),
      );
}
