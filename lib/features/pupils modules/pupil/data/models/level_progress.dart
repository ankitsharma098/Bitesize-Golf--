import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class LevelProgress extends Equatable {
  final int booksCompleted;
  final int quizzesCompleted;
  final int challengesDone;
  final int gamesDone;
  final double averageScore;
  final bool isCompleted;
  final DateTime lastActivity;

  const LevelProgress({
    required this.booksCompleted,
    required this.quizzesCompleted,
    required this.challengesDone,
    required this.gamesDone,
    required this.averageScore,
    required this.isCompleted,
    required this.lastActivity,
  });

  // Factory constructor for new level progress
  factory LevelProgress.initial() {
    return LevelProgress(
      booksCompleted: 0,
      quizzesCompleted: 0,
      challengesDone: 0,
      gamesDone: 0,
      averageScore: 0.0,
      isCompleted: false,
      lastActivity: DateTime.now(),
    );
  }

  // Get total activities completed
  int get totalActivities =>
      booksCompleted + quizzesCompleted + challengesDone + gamesDone;

  // Check if any activity has been completed
  bool get hasActivity => totalActivities > 0;

  // JSON Serialization
  Map<String, dynamic> toJson() => {
    'booksCompleted': booksCompleted,
    'quizzesCompleted': quizzesCompleted,
    'challengesDone': challengesDone,
    'gamesDone': gamesDone,
    'averageScore': averageScore,
    'isCompleted': isCompleted,
    'lastActivity': Timestamp.fromDate(lastActivity),
  };

  factory LevelProgress.fromJson(Map<String, dynamic> json) {
    return LevelProgress(
      booksCompleted: json['booksCompleted'] ?? 0,
      quizzesCompleted: json['quizzesCompleted'] ?? 0,
      challengesDone: json['challengesDone'] ?? 0,
      gamesDone: json['gamesDone'] ?? 0,
      averageScore: (json['averageScore'] ?? 0.0).toDouble(),
      isCompleted: json['isCompleted'] ?? false,
      lastActivity:
          (json['lastActivity'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // CopyWith method
  LevelProgress copyWith({
    int? booksCompleted,
    int? quizzesCompleted,
    int? challengesDone,
    int? gamesDone,
    double? averageScore,
    bool? isCompleted,
    DateTime? lastActivity,
  }) {
    return LevelProgress(
      booksCompleted: booksCompleted ?? this.booksCompleted,
      quizzesCompleted: quizzesCompleted ?? this.quizzesCompleted,
      challengesDone: challengesDone ?? this.challengesDone,
      gamesDone: gamesDone ?? this.gamesDone,
      averageScore: averageScore ?? this.averageScore,
      isCompleted: isCompleted ?? this.isCompleted,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }

  // Merge progress (useful for updating progress incrementally)
  LevelProgress merge(LevelProgress other) {
    return LevelProgress(
      booksCompleted: booksCompleted + other.booksCompleted,
      quizzesCompleted: quizzesCompleted + other.quizzesCompleted,
      challengesDone: challengesDone + other.challengesDone,
      gamesDone: gamesDone + other.gamesDone,
      averageScore: totalActivities > 0
          ? ((averageScore * totalActivities) +
                    (other.averageScore * other.totalActivities)) /
                (totalActivities + other.totalActivities)
          : other.averageScore,
      isCompleted: isCompleted || other.isCompleted,
      lastActivity: lastActivity.isAfter(other.lastActivity)
          ? lastActivity
          : other.lastActivity,
    );
  }

  @override
  List<Object?> get props => [
    booksCompleted,
    quizzesCompleted,
    challengesDone,
    gamesDone,
    averageScore,
    isCompleted,
    lastActivity,
  ];

  @override
  String toString() =>
      'LevelProgress(books: $booksCompleted, quizzes: $quizzesCompleted, challenges: $challengesDone, games: $gamesDone, score: $averageScore, completed: $isCompleted)';
}
