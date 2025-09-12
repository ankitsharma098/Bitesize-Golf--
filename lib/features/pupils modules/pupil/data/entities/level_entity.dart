import 'package:equatable/equatable.dart';

class LevelRequirements extends Equatable {
  final int requiredBooks;
  final int requiredQuizzes;
  final int requiredChallenges;
  final double passingScore;
  final int requiredXP;

  const LevelRequirements({
    required this.requiredBooks,
    required this.requiredQuizzes,
    required this.requiredChallenges,
    required this.passingScore,
    required this.requiredXP,
  });

  // Factory constructor for default requirements
  factory LevelRequirements.defaultRequirements() {
    return const LevelRequirements(
      requiredBooks: 3,
      requiredQuizzes: 2,
      requiredChallenges: 1,
      passingScore: 70.0,
      requiredXP: 100,
    );
  }

  // JSON Serialization
  Map<String, dynamic> toJson() => {
    'requiredBooks': requiredBooks,
    'requiredQuizzes': requiredQuizzes,
    'requiredChallenges': requiredChallenges,
    'passingScore': passingScore,
    'requiredXP': requiredXP,
  };

  factory LevelRequirements.fromJson(Map<String, dynamic> json) {
    return LevelRequirements(
      requiredBooks: json['requiredBooks'] ?? 3,
      requiredQuizzes: json['requiredQuizzes'] ?? 2,
      requiredChallenges: json['requiredChallenges'] ?? 1,
      passingScore: (json['passingScore'] ?? 70.0).toDouble(),
      requiredXP: json['requiredXP'] ?? 100,
    );
  }

  // Get total required activities
  int get totalRequiredActivities =>
      requiredBooks + requiredQuizzes + requiredChallenges;

  @override
  List<Object?> get props => [
    requiredBooks,
    requiredQuizzes,
    requiredChallenges,
    passingScore,
    requiredXP,
  ];

  @override
  String toString() =>
      'LevelRequirements(books: $requiredBooks, quizzes: $requiredQuizzes, challenges: $requiredChallenges, score: $passingScore, xp: $requiredXP)';
}

class Level extends Equatable {
  final int levelNumber;
  final String title;
  final String description;
  final LevelRequirements requirements;
  final int subscriptionTier; // 0 = free, 1 = basic, 2 = premium
  final String? imageUrl;
  final List<String> topics;
  final bool isUnlocked;

  const Level({
    required this.levelNumber,
    required this.title,
    required this.description,
    required this.requirements,
    this.subscriptionTier = 0,
    this.imageUrl,
    this.topics = const [],
    this.isUnlocked = false,
  });

  // Factory constructor for creating a new level
  factory Level.create({
    required int levelNumber,
    required String title,
    required String description,
    LevelRequirements? requirements,
    int subscriptionTier = 0,
    String? imageUrl,
    List<String> topics = const [],
  }) {
    return Level(
      levelNumber: levelNumber,
      title: title,
      description: description,
      requirements: requirements ?? LevelRequirements.defaultRequirements(),
      subscriptionTier: subscriptionTier,
      imageUrl: imageUrl,
      topics: topics,
      isUnlocked: levelNumber == 1, // Level 1 is always unlocked
    );
  }

  // Check if level is accessible with subscription
  bool isAccessibleWithSubscription(int userSubscriptionTier) {
    return userSubscriptionTier >= subscriptionTier;
  }

  // JSON Serialization
  Map<String, dynamic> toJson() => {
    'levelNumber': levelNumber,
    'title': title,
    'description': description,
    'requirements': requirements.toJson(),
    'subscriptionTier': subscriptionTier,
    'imageUrl': imageUrl,
    'topics': topics,
    'isUnlocked': isUnlocked,
  };

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      levelNumber: json['levelNumber'] ?? 1,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      requirements: LevelRequirements.fromJson(json['requirements'] ?? {}),
      subscriptionTier: json['subscriptionTier'] ?? 0,
      imageUrl: json['imageUrl'],
      topics: List<String>.from(json['topics'] ?? []),
      isUnlocked: json['isUnlocked'] ?? false,
    );
  }

  // CopyWith method
  Level copyWith({
    int? levelNumber,
    String? title,
    String? description,
    LevelRequirements? requirements,
    int? subscriptionTier,
    String? imageUrl,
    List<String>? topics,
    bool? isUnlocked,
  }) {
    return Level(
      levelNumber: levelNumber ?? this.levelNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      imageUrl: imageUrl ?? this.imageUrl,
      topics: topics ?? this.topics,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  @override
  List<Object?> get props => [
    levelNumber,
    title,
    description,
    requirements,
    subscriptionTier,
    imageUrl,
    topics,
    isUnlocked,
  ];

  @override
  String toString() =>
      'Level(number: $levelNumber, title: $title, tier: $subscriptionTier, unlocked: $isUnlocked)';
}
