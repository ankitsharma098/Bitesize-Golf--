import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../../../subscription/data/model/subscription.dart';
import 'level_progress.dart';

class PupilModel extends Equatable {
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

  // Progress tracking
  final int currentLevel;
  final List<int> unlockedLevels;
  final int totalXP;
  final Map<int, LevelProgress> levelProgress;
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
      levelProgress: _defaultLevelProgress(),
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

  // Default level progress
  static Map<int, LevelProgress> _defaultLevelProgress() {
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

  // Computed Properties
  int? get age => dateOfBirth != null
      ? DateTime.now().difference(dateOfBirth!).inDays ~/ 365
      : null;

  bool get hasAssignedCoach =>
      assignedCoachId != null && assignedCoachId!.isNotEmpty;

  bool get hasRequestedCoach =>
      selectedCoachId != null && selectedCoachId!.isNotEmpty;

  bool get isPendingCoachAssignment => assignmentStatus == 'pending';

  bool get isAssignedToCoach => assignmentStatus == 'assigned';

  bool get isPremium => subscription?.isActive == true;

  // Level Progress Methods
  LevelProgress? getProgressForLevel(int levelNumber) {
    return levelProgress[levelNumber];
  }

  bool isLevelCompleted(int levelNumber) {
    final progress = levelProgress[levelNumber];
    return progress?.isCompleted ?? false;
  }

  bool isLevelUnlocked(int levelNumber) {
    return unlockedLevels.contains(levelNumber);
  }

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

  PupilModel updateLevelProgress(int levelNumber, LevelProgress progress) {
    final updatedLevelProgress = Map<int, LevelProgress>.from(levelProgress);
    updatedLevelProgress[levelNumber] = progress;

    return copyWith(
      levelProgress: updatedLevelProgress,
      lastActivityDate: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // JSON Serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'dateOfBirth': dateOfBirth != null
        ? Timestamp.fromDate(dateOfBirth!)
        : null,
    'avatar': avatar,
    'handicap': handicap,
    'selectedCoachId': selectedCoachId,
    'selectedCoachName': selectedCoachName,
    'selectedClubId': selectedClubId,
    'selectedClubName': selectedClubName,
    'assignedCoachId': assignedCoachId,
    'assignedCoachName': assignedCoachName,
    'coachAssignedAt': coachAssignedAt != null
        ? Timestamp.fromDate(coachAssignedAt!)
        : null,
    'assignmentStatus': assignmentStatus,
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

  // Updated fromJson method with proper date parsing
  factory PupilModel.fromJson(Map<String, dynamic> json) {
    return PupilModel(
      id: json['id'] as String? ?? '',
      userId: (json['userId'] ?? json['parentId']) as String? ?? '',
      name: json['name'] as String? ?? '',
      dateOfBirth: _parseDateTime(json['dateOfBirth']),
      avatar: json['avatar'] as String?,
      handicap: json['handicap'] as String?,
      selectedCoachId: json['selectedCoachId'] as String?,
      selectedCoachName: json['selectedCoachName'] as String?,
      selectedClubId: json['selectedClubId'] as String?,
      selectedClubName: json['selectedClubName'] as String?,
      assignedCoachId:
          (json['assignedCoachId'] ?? json['assignedCoach']) as String?,
      assignedCoachName: json['assignedCoachName'] as String?,
      coachAssignedAt: _parseDateTime(json['coachAssignedAt']),
      assignmentStatus: json['assignmentStatus'] as String? ?? 'none',
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
          _parseDateTime(json['lastActivityDate']) ?? DateTime.now(),
      badges: List<String>.from(json['badges'] ?? []),
      subscription: json['subscription'] != null
          ? Subscription.fromJson(json['subscription'])
          : null,
      createdAt: _parseDateTime(json['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDateTime(json['updatedAt']) ?? DateTime.now(),
    );
  }

  // Helper method to parse different date formats
  static DateTime? _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return null;

    try {
      // If it's already a Timestamp (from Firestore)
      if (dateValue is Timestamp) {
        return dateValue.toDate();
      }

      // If it's a string (ISO 8601 format)
      if (dateValue is String) {
        return DateTime.parse(dateValue);
      }

      // If it's already a DateTime
      if (dateValue is DateTime) {
        return dateValue;
      }

      // If it's milliseconds since epoch
      if (dateValue is int) {
        return DateTime.fromMillisecondsSinceEpoch(dateValue);
      }
    } catch (e) {
      print('Error parsing date: $dateValue - $e');
      return null;
    }

    return null;
  }

  // Parse level progress from JSON
  static Map<int, LevelProgress> _parseLevelProgress(
    dynamic levelProgressData,
  ) {
    if (levelProgressData == null) return _defaultLevelProgress();

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
      result[1] = _defaultLevelProgress()[1]!;
    }

    return result;
  }

  // CopyWith method
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

  @override
  String toString() =>
      'PupilModel(id: $id, name: $name, userId: $userId, currentLevel: $currentLevel)';
}
