import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../subscription/data/model/subscription.dart';
import '../../../level/data/model/level_progress.dart';
import '../../domain/entities/pupil_entity.dart' as entity;

class PupilModel {
  final String id;
  final String userId;
  final String name;
  final DateTime? dateOfBirth;
  final String? avatar;
  final String? handicap;
  final String? selectedCoachId;
  final String? selectedCoachName;
  final String? selectedClubId;
  final String? selectedClubName;
  final String? assignedCoachId;
  final String? assignedCoachName;
  final DateTime? coachAssignedAt;
  final String? assignmentStatus;

  // Updated progress structure
  final int currentLevel;
  final List<int> unlockedLevels;
  final int totalXP;
  final Map<int, LevelProgress>
  levelProgress; // Changed from Map<String, dynamic>
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

  const PupilModel({
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

  // Factory constructor for new pupils
  factory PupilModel.create({
    required String id,
    required String userId,
    required String name,
    String? avatar,
  }) {
    final now = DateTime.now();
    return PupilModel(
      id: id,
      userId: userId,
      name: name,
      avatar: avatar,
      assignmentStatus: 'none',
      currentLevel: 1,
      unlockedLevels: const [1],
      totalXP: 0,
      levelProgress: defaultLevelProgress(),
      totalLessonsCompleted: 0,
      totalQuizzesCompleted: 0,
      totalChallengesCompleted: 0,
      averageQuizScore: 0.0,
      streakDays: 0,
      lastActivityDate: now,
      badges: const [],
      subscription: null,
      createdAt: now,
      updatedAt: now,
    );
  }

  /* ---------- Default Functions ---------- */
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

  static Map<String, dynamic> defaultProgressMap() {
    return {
      'currentLevel': 1,
      'unlockedLevels': [1],
      'totalXP': 0,
      'levelProgress': defaultLevelProgress().map(
        (key, value) => MapEntry(key.toString(), value.toJson()),
      ),
      'totalLessonsCompleted': 0,
      'totalQuizzesCompleted': 0,
      'totalChallengesCompleted': 0,
      'averageQuizScore': 0.0,
      'streakDays': 0,
      'lastActivityDate': Timestamp.fromDate(DateTime.now()),
    };
  }

  /* ---------- Helper Methods ---------- */

  // Get progress for a specific level
  LevelProgress? getProgressForLevel(int levelNumber) {
    return levelProgress[levelNumber];
  }

  // Check if a level is completed
  bool isLevelCompleted(int levelNumber) {
    final progress = levelProgress[levelNumber];
    return progress?.isCompleted ?? false;
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

  // Add or update progress for a specific level
  PupilModel updateLevelProgress(int levelNumber, LevelProgress progress) {
    final updatedLevelProgress = Map<int, LevelProgress>.from(levelProgress);
    updatedLevelProgress[levelNumber] = progress;

    return copyWith(
      levelProgress: updatedLevelProgress,
      lastActivityDate: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /* ---------- to / from entity ---------- */

  entity.Pupil toEntity() => entity.Pupil(
    id: id,
    userId: userId,
    name: name,
    dateOfBirth: dateOfBirth,
    avatar: avatar,
    handicap: handicap,
    selectedCoachId: selectedCoachId,
    selectedCoachName: selectedCoachName,
    selectedClubId: selectedClubId,
    selectedClubName: selectedClubName,
    assignedCoachId: assignedCoachId,
    assignedCoachName: assignedCoachName,
    coachAssignedAt: coachAssignedAt,
    assignmentStatus: assignmentStatus,
    currentLevel: currentLevel,
    unlockedLevels: unlockedLevels,
    totalXP: totalXP,
    levelProgress: levelProgress,
    totalLessonsCompleted: totalLessonsCompleted,
    totalQuizzesCompleted: totalQuizzesCompleted,
    totalChallengesCompleted: totalChallengesCompleted,
    averageQuizScore: averageQuizScore,
    streakDays: streakDays,
    lastActivityDate: lastActivityDate,
    badges: badges,
    subscription: subscription,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory PupilModel.fromEntity(entity.Pupil pupil) => PupilModel(
    id: pupil.id,
    userId: pupil.userId,
    name: pupil.name,
    dateOfBirth: pupil.dateOfBirth,
    avatar: pupil.avatar,
    handicap: pupil.handicap,
    selectedCoachId: pupil.selectedCoachId,
    selectedCoachName: pupil.selectedCoachName,
    selectedClubId: pupil.selectedClubId,
    selectedClubName: pupil.selectedClubName,
    assignedCoachId: pupil.assignedCoachId,
    assignedCoachName: pupil.assignedCoachName,
    coachAssignedAt: pupil.coachAssignedAt,
    assignmentStatus: pupil.assignmentStatus,
    currentLevel: pupil.currentLevel,
    unlockedLevels: pupil.unlockedLevels,
    totalXP: pupil.totalXP,
    levelProgress: pupil.levelProgress,
    totalLessonsCompleted: pupil.totalLessonsCompleted,
    totalQuizzesCompleted: pupil.totalQuizzesCompleted,
    totalChallengesCompleted: pupil.totalChallengesCompleted,
    averageQuizScore: pupil.averageQuizScore,
    streakDays: pupil.streakDays,
    lastActivityDate: pupil.lastActivityDate,
    badges: pupil.badges,
    subscription: pupil.subscription,
    createdAt: pupil.createdAt,
    updatedAt: pupil.updatedAt,
  );

  /* ---------- to / from JSON ---------- */

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'dateOfBirth': dateOfBirth == null
        ? null
        : Timestamp.fromDate(dateOfBirth!),
    'avatar': avatar,
    'handicap': handicap,
    'selectedCoachId': selectedCoachId,
    'selectedCoachName': selectedCoachName,
    'selectedClubId': selectedClubId,
    'selectedClubName': selectedClubName,
    'assignedCoachId': assignedCoachId,
    'assignedCoachName': assignedCoachName,
    'coachAssignedAt': coachAssignedAt == null
        ? null
        : Timestamp.fromDate(coachAssignedAt!),
    'assignmentStatus': assignmentStatus,

    // Flatten progress fields directly at root level
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
    'lastActivityDate': Timestamp.fromDate(lastActivityDate),

    'badges': badges,
    'subscription': subscription?.toJson(),
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };

  factory PupilModel.fromJson(Map<String, dynamic> json) {
    return PupilModel(
      id: json['id'] as String? ?? '',
      userId: (json['userId'] ?? json['parentId']) as String? ?? '',
      name: json['name'] as String? ?? '',
      dateOfBirth: (json['dateOfBirth'] as Timestamp?)?.toDate(),
      avatar: json['avatar'] as String?,
      handicap: json['handicap'] as String?,
      selectedCoachId: json['selectedCoachId'] as String?,
      selectedCoachName: json['selectedCoachName'] as String?,
      selectedClubId: json['selectedClubId'] as String?,
      selectedClubName: json['selectedClubName'] as String?,
      assignedCoachId:
          (json['assignedCoachId'] ?? json['assignedCoach']) as String?,
      assignedCoachName: json['assignedCoachName'] as String?,
      coachAssignedAt: (json['coachAssignedAt'] as Timestamp?)?.toDate(),
      assignmentStatus: json['assignmentStatus'] as String? ?? 'none',

      // Read progress fields directly from root level
      currentLevel: json['currentLevel'] ?? 1,
      unlockedLevels: List<int>.from(json['unlockedLevels'] ?? [1]),
      totalXP: json['totalXP'] ?? 0,
      levelProgress: _parseLevelProgress(json['levelProgress']),
      totalLessonsCompleted: json['totalLessonsCompleted'] ?? 0,
      totalQuizzesCompleted: json['totalQuizzesCompleted'] ?? 0,
      totalChallengesCompleted: json['totalChallengesCompleted'] ?? 0,
      averageQuizScore: (json['averageQuizScore'] ?? 0.0).toDouble(),
      streakDays: json['streakDays'] ?? 0,
      lastActivityDate:
          (json['lastActivityDate'] as Timestamp?)?.toDate() ?? DateTime.now(),

      badges: List<String>.from(json['badges'] ?? []),
      subscription: json['subscription'] == null
          ? null
          : Subscription.fromJson(json['subscription']),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory PupilModel.fromFirestore(Map<String, dynamic> json) =>
      PupilModel.fromJson(json);

  /* ---------- Private Helper Methods ---------- */

  // Build progress map for backward compatibility and storage
  Map<String, dynamic> _buildProgressMap() => {
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
    'lastActivityDate': Timestamp.fromDate(lastActivityDate),
  };

  // Parse level progress from JSON
  static Map<int, LevelProgress> _parseLevelProgress(
    dynamic levelProgressData,
  ) {
    if (levelProgressData == null) return defaultLevelProgress();

    final Map<int, LevelProgress> result = {};
    final Map<String, dynamic> progressMap = Map<String, dynamic>.from(
      levelProgressData,
    );

    progressMap.forEach((key, value) {
      final levelNumber = int.tryParse(key);
      if (levelNumber != null && value is Map<String, dynamic>) {
        result[levelNumber] = LevelProgress.fromJson(value);
      }
    });

    // Ensure level 1 is always present
    if (!result.containsKey(1)) {
      result[1] = defaultLevelProgress()[1]!;
    }

    return result;
  }

  /* ---------- copyWith method ---------- */

  PupilModel copyWith({
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
    return PupilModel(
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

  @override
  String toString() =>
      'PupilModel(id: $id, name: $name, userId: $userId, currentLevel: $currentLevel)';
}
