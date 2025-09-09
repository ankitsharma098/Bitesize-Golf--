import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LevelProgress extends Equatable {
  final int booksCompleted;
  final int quizzesCompleted;
  final int challengesDone;
  final int gamesDone;
  final double averageScore;
  final bool isCompleted;
  final DateTime lastActivity;

  const LevelProgress({
    this.booksCompleted = 0,
    this.quizzesCompleted = 0,
    this.gamesDone = 0,
    this.challengesDone = 0,
    this.averageScore = 0.0,
    this.isCompleted = false,
    required this.lastActivity,
  });

  @override
  List<Object?> get props => [
    booksCompleted,
    quizzesCompleted,
    challengesDone,
    averageScore,
    gamesDone,
    isCompleted,
    lastActivity,
  ];

  LevelProgress copyWith({
    int? booksCompleted,
    int? quizzesCompleted,
    int? challengesDone,
    int? gamesDone,
    double? averageScore,
    bool? isCompleted,
    DateTime? lastActivity,
  }) => LevelProgress(
    booksCompleted: booksCompleted ?? this.booksCompleted,
    quizzesCompleted: quizzesCompleted ?? this.quizzesCompleted,
    challengesDone: challengesDone ?? this.challengesDone,
    gamesDone: gamesDone ?? this.gamesDone,
    averageScore: averageScore ?? this.averageScore,
    isCompleted: isCompleted ?? this.isCompleted,
    lastActivity: lastActivity ?? this.lastActivity,
  );

  /* ---------- json ---------- */

  Map<String, dynamic> toJson() => {
    'booksCompleted': booksCompleted,
    'quizzesCompleted': quizzesCompleted,
    'challengesDone': challengesDone,
    'gamesDone': gamesDone,
    'averageScore': averageScore,
    'isCompleted': isCompleted,
    'lastActivity': Timestamp.fromDate(lastActivity),
  };

  factory LevelProgress.fromJson(Map<String, dynamic> json) => LevelProgress(
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
