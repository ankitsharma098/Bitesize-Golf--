import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../auth/domain/entities/user_enums.dart';
import '../../../../subscription/data/model/subscription.dart';
import '../../../level/data/model/level_progress.dart'; // For Timestamp in default

class Pupil extends Equatable {
  final String id;
  final String userId;
  final String name;
  final DateTime? dateOfBirth;
  final String? avatar;
  final String? handicap;

  // Coach selection/assignment fields
  final String? selectedCoachId;
  final String? selectedCoachName;
  final String? selectedClubId;
  final String? selectedClubName;
  final String? assignedCoachId;
  final String? assignedCoachName;
  final DateTime? coachAssignedAt;
  final String? assignmentStatus;

  // Updated progress tracking with typed structure
  final int currentLevel;
  final List<int> unlockedLevels;
  final int totalXP;
  final Map<int, LevelProgress> levelProgress; // Typed level progress
  final int totalLessonsCompleted;
  final int totalQuizzesCompleted;
  final int totalChallengesCompleted;
  final double averageQuizScore;
  final int streakDays;
  final DateTime lastActivityDate;

  final List<String> badges;
  final Subscription? subscription;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Pupil({
    required this.id,
    required this.userId,
    required this.name,
    this.dateOfBirth,
    this.avatar,
    this.handicap,
    this.selectedCoachId,
    this.selectedCoachName,
    this.selectedClubId,
    this.selectedClubName,
    this.assignedCoachId,
    this.assignedCoachName,
    this.coachAssignedAt,
    this.assignmentStatus,
    this.currentLevel = 1,
    this.unlockedLevels = const [1],
    this.totalXP = 0,
    this.levelProgress = const {},
    this.totalLessonsCompleted = 0,
    this.totalQuizzesCompleted = 0,
    this.totalChallengesCompleted = 0,
    this.averageQuizScore = 0.0,
    this.streakDays = 0,
    required this.lastActivityDate,
    this.badges = const [],
    this.subscription,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    dateOfBirth,
    avatar,
    handicap,
    selectedCoachId,
    selectedCoachName,
    selectedClubId,
    selectedClubName,
    assignedCoachId,
    assignedCoachName,
    coachAssignedAt,
    assignmentStatus,
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
    badges,
    subscription,
    createdAt,
    updatedAt,
  ];

  /* ---------- Computed Properties ---------- */

  int? get age => dateOfBirth != null
      ? DateTime.now().difference(dateOfBirth!).inDays ~/ 365
      : null;

  bool get hasAssignedCoach =>
      assignedCoachId != null && assignedCoachId!.isNotEmpty;

  bool get hasRequestedCoach =>
      selectedCoachId != null && selectedCoachId!.isNotEmpty;

  bool get isPendingCoachAssignment => assignmentStatus == 'pending';

  bool get isAssignedToCoach => assignmentStatus == 'assigned';

  // Subscription properties
  bool get isPremium => subscription?.status == SubscriptionStatus.active;

  /* ---------- Level Progress Methods ---------- */

  // Get progress for a specific level
  LevelProgress? getProgressForLevel(int levelNumber) {
    return levelProgress[levelNumber];
  }

  // Check if a level is completed
  bool isLevelCompleted(int levelNumber) {
    final progress = levelProgress[levelNumber];
    return progress?.isCompleted ?? false;
  }

  // Check if a level is unlocked
  bool isLevelUnlocked(int levelNumber) {
    return unlockedLevels.contains(levelNumber);
  }

  // Get total completed activities across all levels
  int get totalActivitiesCompleted {
    return levelProgress.values.fold(
      0,
      (sum, progress) =>
          sum +
          progress.booksCompleted +
          progress.quizzesCompleted +
          progress.challengesDone +
          progress.gamesDone,
    );
  }

  // Get completion percentage for current level
  double getLevelCompletionPercentage(
    int levelNumber, {
    required int requiredBooks,
    required int requiredQuizzes,
    required int requiredChallenges,
  }) {
    final progress = levelProgress[levelNumber];
    if (progress == null) return 0.0;

    final totalRequired = requiredBooks + requiredQuizzes + requiredChallenges;
    if (totalRequired == 0) return 0.0;

    final totalCompleted =
        progress.booksCompleted +
        progress.quizzesCompleted +
        progress.challengesDone;

    return (totalCompleted / totalRequired).clamp(0.0, 1.0);
  }

  // Check if level requirements are met
  bool hasMetLevelRequirements(
    int levelNumber, {
    required int requiredBooks,
    required int requiredQuizzes,
    required int requiredChallenges,
    required double passingScore,
  }) {
    final progress = levelProgress[levelNumber];
    if (progress == null) return false;

    return progress.booksCompleted >= requiredBooks &&
        progress.quizzesCompleted >= requiredQuizzes &&
        progress.challengesDone >= requiredChallenges &&
        progress.averageScore >= passingScore;
  }

  // Get the last activity date across all levels
  DateTime get mostRecentActivity {
    if (levelProgress.isEmpty) return lastActivityDate;

    DateTime latest = lastActivityDate;
    for (final progress in levelProgress.values) {
      if (progress.lastActivity.isAfter(latest)) {
        latest = progress.lastActivity;
      }
    }
    return latest;
  }

  /* ---------- Backward Compatibility ---------- */

  // For backward compatibility with existing code that expects Map<String, dynamic>
  Map<String, dynamic> get progress => {
    'currentLevel': currentLevel,
    'unlockedLevels': unlockedLevels,
    'totalXP': totalXP,
    'levelProgress': levelProgress.map(
      (key, value) => MapEntry(key.toString(), value.toJson()),
    ),
    'totalLessonsCompleted': totalLessonsCompleted,
    'totalQuizzesCompleted': totalQuizzesCompleted,
    'totalChallengesCompleted': totalChallengesCompleted,
    'averageQuizScore': averageQuizScore,
    'streakDays': streakDays,
    'lastActivityDate': lastActivityDate,
  };

  /* ---------- Copy With Method ---------- */

  Pupil copyWith({
    String? id,
    String? userId,
    String? name,
    DateTime? dateOfBirth,
    String? avatar,
    String? handicap,
    String? selectedCoachId,
    String? selectedCoachName,
    String? selectedClubId,
    String? selectedClubName,
    String? assignedCoachId,
    String? assignedCoachName,
    DateTime? coachAssignedAt,
    String? assignmentStatus,
    int? currentLevel,
    List<int>? unlockedLevels,
    int? totalXP,
    Map<int, LevelProgress>? levelProgress,
    int? totalLessonsCompleted,
    int? totalQuizzesCompleted,
    int? totalChallengesCompleted,
    double? averageQuizScore,
    int? streakDays,
    DateTime? lastActivityDate,
    List<String>? badges,
    Subscription? subscription,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Pupil(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      avatar: avatar ?? this.avatar,
      handicap: handicap ?? this.handicap,
      selectedCoachId: selectedCoachId ?? this.selectedCoachId,
      selectedCoachName: selectedCoachName ?? this.selectedCoachName,
      selectedClubId: selectedClubId ?? this.selectedClubId,
      selectedClubName: selectedClubName ?? this.selectedClubName,
      assignedCoachId: assignedCoachId ?? this.assignedCoachId,
      assignedCoachName: assignedCoachName ?? this.assignedCoachName,
      coachAssignedAt: coachAssignedAt ?? this.coachAssignedAt,
      assignmentStatus: assignmentStatus ?? this.assignmentStatus,
      currentLevel: currentLevel ?? this.currentLevel,
      unlockedLevels: unlockedLevels ?? this.unlockedLevels,
      totalXP: totalXP ?? this.totalXP,
      levelProgress: levelProgress ?? this.levelProgress,
      totalLessonsCompleted:
          totalLessonsCompleted ?? this.totalLessonsCompleted,
      totalQuizzesCompleted:
          totalQuizzesCompleted ?? this.totalQuizzesCompleted,
      totalChallengesCompleted:
          totalChallengesCompleted ?? this.totalChallengesCompleted,
      averageQuizScore: averageQuizScore ?? this.averageQuizScore,
      streakDays: streakDays ?? this.streakDays,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      badges: badges ?? this.badges,
      subscription: subscription ?? this.subscription,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /* ---------- Default Progress Factory ---------- */
  static Map<int, LevelProgress> defaultLevelProgress() {
    return {
      1: LevelProgress(
        booksCompleted: 0,
        quizzesCompleted: 0,
        challengesDone: 0,
        gamesDone: 0,
        averageScore: 0.0,
        isCompleted: false,
        lastActivity: DateTime.now(),
      ),
    };
  }
}
