// features/pupils/data/models/pupil_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/pupil_entity.dart' as entity;

class PupilModel {
  final String id;
  final String parentId;
  final String name;
  final DateTime? dateOfBirth;
  final String? avatar;
  final String? handicap;
  final String? selectedCoachName;
  final String? selectedClubId;
  final String? assignedCoach;
  final DateTime? coachAssignedAt;
  final Map<String, dynamic>? progress;
  final List<String> badges;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PupilModel({
    required this.id,
    required this.parentId,
    required this.name,
    this.dateOfBirth,
    this.avatar,
    this.handicap,
    this.selectedCoachName,
    this.selectedClubId,
    this.assignedCoach,
    this.coachAssignedAt,
    this.progress,
    this.badges = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /* ---------- to / from entity ---------- */

  entity.Pupil toEntity() => entity.Pupil(
    id: id,
    parentId: parentId,
    name: name,
    dateOfBirth: dateOfBirth,
    avatar: avatar,
    handicap: handicap,
    selectedCoachName: selectedCoachName,
    selectedClubId: selectedClubId,
    assignedCoach: assignedCoach,
    coachAssignedAt: coachAssignedAt,
    progress: progress ?? _defaultProgress(),
    badges: badges,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory PupilModel.fromEntity(entity.Pupil pupil) => PupilModel(
    id: pupil.id,
    parentId: pupil.parentId,
    name: pupil.name,
    dateOfBirth: pupil.dateOfBirth,
    avatar: pupil.avatar,
    handicap: pupil.handicap,
    selectedCoachName: pupil.selectedCoachName,
    selectedClubId: pupil.selectedClubId,
    assignedCoach: pupil.assignedCoach,
    coachAssignedAt: pupil.coachAssignedAt,
    progress: pupil.progress,
    badges: pupil.badges,
    createdAt: pupil.createdAt,
    updatedAt: pupil.updatedAt,
  );

  /* ---------- to / from JSON ---------- */

  Map<String, dynamic> toJson() => {
    'id': id,
    'parentId': parentId,
    'name': name,
    'dateOfBirth': dateOfBirth == null
        ? null
        : Timestamp.fromDate(dateOfBirth!),
    'avatar': avatar,
    'handicap': handicap,
    'selectedCoachName': selectedCoachName,
    'selectedClubId': selectedClubId,
    'assignedCoach': assignedCoach,
    'coachAssignedAt': coachAssignedAt == null
        ? null
        : Timestamp.fromDate(coachAssignedAt!),
    'progress': progress ?? _defaultProgress(),
    'badges': badges,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };

  factory PupilModel.fromJson(Map<String, dynamic> json) => PupilModel(
    id: json['id'] as String,
    parentId: json['parentId'] as String,
    name: json['name'] as String,
    dateOfBirth: (json['dateOfBirth'] as Timestamp?)?.toDate(),
    avatar: json['avatar'] as String?,
    handicap: json['handicap'] as String?,
    selectedCoachName: json['selectedCoachName'] as String?,
    selectedClubId: json['selectedClubId'] as String?,
    assignedCoach: json['assignedCoach'] as String?,
    coachAssignedAt: (json['coachAssignedAt'] as Timestamp?)?.toDate(),
    progress: json['progress'] as Map<String, dynamic>?,
    badges: List<String>.from(json['badges'] ?? []),
    createdAt: (json['createdAt'] as Timestamp).toDate(),
    updatedAt: (json['updatedAt'] as Timestamp).toDate(),
  );

  /* ---------- helpers ---------- */

  static Map<String, dynamic> _defaultProgress() => {
    'currentLevel': 1,
    'unlockedLevels': [1],
    'totalXP': 0,
    'levelProgress': <String, dynamic>{},
    'totalLessonsCompleted': 0,
    'totalQuizzesCompleted': 0,
    'totalChallengesCompleted': 0,
    'averageQuizScore': 0.0,
    'streakDays': 0,
    'lastActivityDate': Timestamp.now(),
  };
}
