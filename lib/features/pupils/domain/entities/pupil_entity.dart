import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Pupil extends Equatable {
  final String id; // same as user.uid
  final String parentId; // user.uid of parent (self for now)
  final String name; // copied from users.displayName
  final DateTime? dateOfBirth; // NEW - from complete profile
  final String? handicap; // NEW - from complete profile
  final String? selectedCoachName; // NEW - from complete profile
  final String? selectedClubId; // NEW - reference to golfClubs/{id}
  final String? avatar;
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
    createdAt,
    updatedAt,
  ];
}
