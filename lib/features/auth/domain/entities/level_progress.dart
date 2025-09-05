import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Nested inside pupils/{id}/progress
class PupilProgress extends Equatable {
  final int currentLevel;
  final List<int> unlockedLevels;
  final int totalXP;
  final Map<int, LevelProgress> levelProgress;
  final int totalLessonsCompleted;
  final int totalQuizzesCompleted;
  final int totalChallengesCompleted;
  final double averageQuizScore;
  final int streakDays;
  final DateTime? lastActivityDate;

  const PupilProgress({
    this.currentLevel = 1,
    this.unlockedLevels = const [1],
    this.totalXP = 0,
    this.levelProgress = const {},
    this.totalLessonsCompleted = 0,
    this.totalQuizzesCompleted = 0,
    this.totalChallengesCompleted = 0,
    this.averageQuizScore = 0.0,
    this.streakDays = 0,
    this.lastActivityDate,
  });

  @override
  List<Object?> get props => [
    currentLevel,
    unlockedLevels,
    totalXP,
    levelProgress,
    totalLessonsCompleted,
    totalQuizzesCompleted,
    totalChallengesCompleted,
    averageQuizScore,
    streakDays,
    lastActivityDate,
  ];

  factory PupilProgress.fromJson(Map<String, dynamic> json) {
    final lpMap = <int, LevelProgress>{};
    if (json['levelProgress'] != null) {
      (json['levelProgress'] as Map<String, dynamic>).forEach((k, v) {
        lpMap[int.parse(k)] = LevelProgress.fromJson(
          Map<String, dynamic>.from(v),
        );
      });
    }
    return PupilProgress(
      currentLevel: json['currentLevel'] ?? 1,
      unlockedLevels: List<int>.from(json['unlockedLevels'] ?? [1]),
      totalXP: json['totalXP'] ?? 0,
      levelProgress: lpMap,
      totalLessonsCompleted: json['totalLessonsCompleted'] ?? 0,
      totalQuizzesCompleted: json['totalQuizzesCompleted'] ?? 0,
      totalChallengesCompleted: json['totalChallengesCompleted'] ?? 0,
      averageQuizScore: (json['averageQuizScore'] ?? 0.0).toDouble(),
      streakDays: json['streakDays'] ?? 0,
      lastActivityDate: (json['lastActivityDate'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    final lpJson = <String, Map<String, dynamic>>{};
    levelProgress.forEach((k, v) => lpJson[k.toString()] = v.toJson());
    return {
      'currentLevel': currentLevel,
      'unlockedLevels': unlockedLevels,
      'totalXP': totalXP,
      'levelProgress': lpJson,
      'totalLessonsCompleted': totalLessonsCompleted,
      'totalQuizzesCompleted': totalQuizzesCompleted,
      'totalChallengesCompleted': totalChallengesCompleted,
      'averageQuizScore': averageQuizScore,
      'streakDays': streakDays,
      if (lastActivityDate != null)
        'lastActivityDate': Timestamp.fromDate(lastActivityDate!),
    };
  }
}

/* ------------------------------------------ */
class LevelProgress extends Equatable {
  final int booksCompleted;
  final int quizzesCompleted;
  final int challengesCompleted;
  final int totalItems;
  final int completedItems;
  final double completionPercentage;
  final DateTime? completedAt;

  const LevelProgress({
    this.booksCompleted = 0,
    this.quizzesCompleted = 0,
    this.challengesCompleted = 0,
    this.totalItems = 0,
    this.completedItems = 0,
    this.completionPercentage = 0.0,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
    booksCompleted,
    quizzesCompleted,
    challengesCompleted,
    totalItems,
    completedItems,
    completionPercentage,
    completedAt,
  ];

  factory LevelProgress.fromJson(Map<String, dynamic> json) => LevelProgress(
    booksCompleted: json['booksCompleted'] ?? 0,
    quizzesCompleted: json['quizzesCompleted'] ?? 0,
    challengesCompleted: json['challengesCompleted'] ?? 0,
    totalItems: json['totalItems'] ?? 0,
    completedItems: json['completedItems'] ?? 0,
    completionPercentage: (json['completionPercentage'] ?? 0.0).toDouble(),
    completedAt: (json['completedAt'] as Timestamp?)?.toDate(),
  );

  Map<String, dynamic> toJson() => {
    'booksCompleted': booksCompleted,
    'quizzesCompleted': quizzesCompleted,
    'challengesCompleted': challengesCompleted,
    'totalItems': totalItems,
    'completedItems': completedItems,
    'completionPercentage': completionPercentage,
    if (completedAt != null) 'completedAt': Timestamp.fromDate(completedAt!),
  };
}
