import 'package:equatable/equatable.dart';

class Level extends Equatable {
  final int levelNumber;
  final String title;
  final String description;
  final String requiredPlan; // 'basic', 'premium', 'pro'
  final LevelContent content;
  final LevelRequirements requirements;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  const Level({
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

  @override
  List<Object?> get props => [
    levelNumber,
    title,
    description,
    requiredPlan,
    content,
    requirements,
    isActive,
    sortOrder,
    createdAt,
    updatedAt,
    createdBy,
  ];
}

class LevelContent extends Equatable {
  final List<String> books;
  final List<String> quizzes;
  final List<String> challenges;
  final List<String> games;

  const LevelContent({
    required this.books,
    required this.quizzes,
    required this.challenges,
    required this.games,
  });

  @override
  List<Object?> get props => [books, quizzes, challenges, games];
}

class LevelRequirements extends Equatable {
  final int minimumItems;
  final int requiredBooks;
  final int requiredQuizzes;
  final int requiredChallenges;
  final double passingScore;

  const LevelRequirements({
    required this.minimumItems,
    required this.requiredBooks,
    required this.requiredQuizzes,
    required this.requiredChallenges,
    required this.passingScore,
  });

  @override
  List<Object?> get props => [
    minimumItems,
    requiredBooks,
    requiredQuizzes,
    requiredChallenges,
    passingScore,
  ];
}
