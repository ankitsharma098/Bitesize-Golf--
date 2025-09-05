import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'level_progress.dart';

class Pupil extends Equatable {
  final String id; // same as user.uid
  final String parentId; // user.uid of parent (self for now)
  final String name; // copied from users.displayName
  final DateTime? dateOfBirth; // NEW
  final String? handicap; // NEW
  final String? selectedCoachName; // NEW (free-text or coachId)
  final String? selectedClubId; // NEW (reference to golfClubs/{id})
  final String? avatar;
  final PupilProgress progress; // existing
  final List<String> badges; // existing
  final DateTime createdAt;
  final DateTime updatedAt;

  const Pupil({
    required this.id,
    required this.parentId,
    required this.name,
    this.dateOfBirth,
    this.handicap,
    this.selectedCoachName,
    this.selectedClubId,
    this.avatar,
    this.progress = const PupilProgress(),
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
    handicap,
    selectedCoachName,
    selectedClubId,
    avatar,
    progress,
    badges,
    createdAt,
    updatedAt,
  ];
}
