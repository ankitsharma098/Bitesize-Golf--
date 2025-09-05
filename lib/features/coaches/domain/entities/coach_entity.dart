import 'package:equatable/equatable.dart';

import 'coach_stats_entity.dart';

class Coach extends Equatable {
  final String id; // same as user.uid
  final String userId; // ref to users.uid
  final String name;
  final String bio;
  final int experience; // years – NEW
  final String? clubId; // ref to golfClubs/{id} – NEW
  final String verificationStatus;
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final int maxPupils;
  final int currentPupils;
  final bool acceptingNewPupils;
  final CoachStats stats;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Coach({
    required this.id,
    required this.userId,
    required this.name,
    this.bio = '',
    this.experience = 0,
    this.clubId,
    this.verificationStatus = 'pending',
    this.verifiedBy,
    this.verifiedAt,
    this.maxPupils = 50,
    this.currentPupils = 0,
    this.acceptingNewPupils = true,
    this.stats = const CoachStats(),
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    bio,
    experience,
    clubId,
    verificationStatus,
    verifiedBy,
    verifiedAt,
    maxPupils,
    currentPupils,
    acceptingNewPupils,
    stats,
    createdAt,
    updatedAt,
  ];
}
