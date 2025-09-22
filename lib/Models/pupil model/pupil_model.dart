import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../subscription model/subscription.dart';
import 'level_progress.dart';

class PupilModel extends Equatable {
  final String id;
  final String name;
  final DateTime? dateOfBirth;
  final String? profilePic;
  final String? handicap;

  // Selection (before approval)
  final String? selectedCoachId;
  final String? selectedCoachName;
  final String? selectedClubId;
  final String? selectedClubName;

  // Assignment (after admin approval)
  final String? assignedCoachId;
  final String? assignedCoachName;
  final DateTime? coachAssignedAt;
  final String? assignmentStatus;

  final String? assignedClubId;
  final String? assignedClubName;
  final DateTime? clubAssignedAt;
  final String? clubAssignmentStatus;

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
    required this.name,
    this.dateOfBirth,
    this.profilePic,
    this.handicap,
    this.selectedCoachId,
    this.selectedCoachName,
    this.selectedClubId,
    this.selectedClubName,
    this.assignedCoachId,
    this.assignedCoachName,
    this.coachAssignedAt,
    this.assignmentStatus,
    this.assignedClubId,
    this.assignedClubName,
    this.clubAssignedAt,
    this.clubAssignmentStatus,
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

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return DateTime.now();
      }
    }
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return DateTime.now();
  }

  static double _parseDouble(dynamic value, {double fallback = 0.0}) {
    if (value == null) return fallback;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? fallback;
  }

  static int _parseInt(dynamic value, {int fallback = 0}) {
    if (value == null) return fallback;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? fallback;
  }

  /// Computed properties
  int? get age => dateOfBirth != null
      ? DateTime.now().difference(dateOfBirth!).inDays ~/ 365
      : null;

  bool get isPremium => subscription?.isActive == true;
  bool get hasAssignedCoach =>
      assignedCoachId != null && assignedCoachId!.isNotEmpty;
  bool get hasAssignedClub =>
      assignedClubId != null && assignedClubId!.isNotEmpty;

  /// CopyWith
  PupilModel copyWith({
    String? id,
    String? name,
    DateTime? dateOfBirth,
    String? profilePic,
    String? handicap,
    String? selectedCoachId,
    String? selectedCoachName,
    String? selectedClubId,
    String? selectedClubName,
    String? assignedCoachId,
    String? assignedCoachName,
    DateTime? coachAssignedAt,
    String? assignmentStatus,
    String? assignedClubId,
    String? assignedClubName,
    DateTime? clubAssignedAt,
    String? clubAssignmentStatus,
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
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profilePic: profilePic ?? this.profilePic,
      handicap: handicap ?? this.handicap,
      selectedCoachId: selectedCoachId ?? this.selectedCoachId,
      selectedCoachName: selectedCoachName ?? this.selectedCoachName,
      selectedClubId: selectedClubId ?? this.selectedClubId,
      selectedClubName: selectedClubName ?? this.selectedClubName,
      assignedCoachId: assignedCoachId ?? this.assignedCoachId,
      assignedCoachName: assignedCoachName ?? this.assignedCoachName,
      coachAssignedAt: coachAssignedAt ?? this.coachAssignedAt,
      assignmentStatus: assignmentStatus ?? this.assignmentStatus,
      assignedClubId: assignedClubId ?? this.assignedClubId,
      assignedClubName: assignedClubName ?? this.assignedClubName,
      clubAssignedAt: clubAssignedAt ?? this.clubAssignedAt,
      clubAssignmentStatus: clubAssignmentStatus ?? this.clubAssignmentStatus,
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

  factory PupilModel.fromFirestore(Map<String, dynamic> data, {String? id}) {
    return PupilModel(
      id: id ?? data['id']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      dateOfBirth: data['dateOfBirth'] != null
          ? _parseDate(data['dateOfBirth'])
          : null,
      profilePic: data['profilePic']?.toString(),
      handicap: data['handicap']?.toString(),
      selectedCoachId: data['selectedCoachId']?.toString(),
      selectedCoachName: data['selectedCoachName']?.toString(),
      selectedClubId: data['selectedClubId']?.toString(),
      selectedClubName: data['selectedClubName']?.toString(),
      assignedCoachId: data['assignedCoachId']?.toString(),
      assignedCoachName: data['assignedCoachName']?.toString(),
      coachAssignedAt: data['coachAssignedAt'] != null
          ? _parseDate(data['coachAssignedAt'])
          : null,
      assignmentStatus: data['assignmentStatus']?.toString(),
      assignedClubId: data['assignedClubId']?.toString(),
      assignedClubName: data['assignedClubName']?.toString(),
      clubAssignedAt: data['clubAssignedAt'] != null
          ? _parseDate(data['clubAssignedAt'])
          : null,
      clubAssignmentStatus: data['clubAssignmentStatus']?.toString(),
      currentLevel: _parseInt(data['currentLevel'], fallback: 1),
      unlockedLevels:
          (data['unlockedLevels'] as List<dynamic>?)
              ?.map((e) => _parseInt(e, fallback: 1))
              .toList() ??
          [1],
      totalXP: _parseInt(data['totalXP'], fallback: 0),
      levelProgress:
          (data['levelProgress'] as Map<String, dynamic>?)
              ?.map(
                (k, v) =>
                    MapEntry(int.tryParse(k) ?? 0, LevelProgress.fromJson(v)),
              )
              .cast<int, LevelProgress>() ??
          {},
      totalLessonsCompleted: _parseInt(
        data['totalLessonsCompleted'],
        fallback: 0,
      ),
      totalQuizzesCompleted: _parseInt(
        data['totalQuizzesCompleted'],
        fallback: 0,
      ),
      totalChallengesCompleted: _parseInt(
        data['totalChallengesCompleted'],
        fallback: 0,
      ),
      averageQuizScore: _parseDouble(data['averageQuizScore'], fallback: 0.0),
      streakDays: _parseInt(data['streakDays'], fallback: 0),
      lastActivityDate: _parseDate(data['lastActivityDate']),
      badges:
          (data['badges'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      subscription: data['subscription'] != null
          ? Subscription.fromFirestore(data['subscription'])
          : null,
      createdAt: _parseDate(data['createdAt']),
      updatedAt: _parseDate(data['updatedAt']),
    );
  }
  Map<String, dynamic> toFirestore() => {
    'id': id,
    'name': name,
    'dateOfBirth': dateOfBirth != null
        ? Timestamp.fromDate(dateOfBirth!)
        : null,
    'profilePic': profilePic,
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
    'assignedClubId': assignedClubId,
    'assignedClubName': assignedClubName,
    'clubAssignedAt': clubAssignedAt != null
        ? Timestamp.fromDate(clubAssignedAt!)
        : null,
    'clubAssignmentStatus': clubAssignmentStatus,
    'currentLevel': currentLevel,
    'unlockedLevels': unlockedLevels,
    'totalXP': totalXP,
    'levelProgress': levelProgress.map(
      (k, v) => MapEntry(k.toString(), v.toJson()),
    ),
    'totalLessonsCompleted': totalLessonsCompleted,
    'totalQuizzesCompleted': totalQuizzesCompleted,
    'totalChallengesCompleted': totalChallengesCompleted,
    'averageQuizScore': averageQuizScore,
    'streakDays': streakDays,
    'lastActivityDate': Timestamp.fromDate(lastActivityDate),
    'badges': badges,
    'subscription': subscription?.toFirestore(),
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };

  @override
  List<Object?> get props => [id, name, profilePic];
}
