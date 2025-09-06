import 'package:equatable/equatable.dart';

class Pupil extends Equatable {
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

  const Pupil({
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

  @override
  List<Object?> get props => [
    id,
    parentId,
    name,
    dateOfBirth,
    avatar,
    handicap,
    selectedCoachName,
    selectedClubId,
    assignedCoach,
    coachAssignedAt,
    progress,
    badges,
    createdAt,
    updatedAt,
  ];

  int? get age => dateOfBirth != null
      ? DateTime.now().difference(dateOfBirth!).inDays ~/ 365
      : null;

  bool get hasCoach => assignedCoach != null;
  bool get hasRequestedCoach =>
      selectedCoachName != null && selectedCoachName!.isNotEmpty;
  int get currentLevel => progress?['currentLevel'] ?? 1;
  int get totalXP => progress?['totalXP'] ?? 0;
}
