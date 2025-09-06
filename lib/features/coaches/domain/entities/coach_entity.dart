import 'package:equatable/equatable.dart';

class Coach extends Equatable {
  final String id;
  final String userId;
  final String displayName;
  final String? firstName;
  final String? lastName;
  final String bio;
  final List<String> qualifications;
  final int experience;
  final List<String> specialties;
  final String? clubId;
  final String verificationStatus;
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final int maxPupils;
  final int currentPupils;
  final bool acceptingNewPupils;
  final Map<String, dynamic>? stats;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Coach({
    required this.id,
    required this.userId,
    required this.displayName,
    required this.firstName,
    required this.lastName,
    this.bio = '',
    this.qualifications = const [],
    this.experience = 0,
    this.specialties = const [],
    this.clubId,
    this.verificationStatus = 'pending',
    this.verifiedBy,
    this.verifiedAt,
    this.maxPupils = 20,
    this.currentPupils = 0,
    this.acceptingNewPupils = true,
    this.stats,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    displayName,
    bio,
    firstName,
    lastName,
    qualifications,
    experience,
    specialties,
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

  bool get isVerified => verificationStatus == 'verified';
  bool get isPending => verificationStatus == 'pending';
  bool get isRejected => verificationStatus == 'rejected';
  bool get canAcceptPupils =>
      isVerified && acceptingNewPupils && currentPupils < maxPupils;
  double get averageImprovement =>
      stats?['averageImprovement']?.toDouble() ?? 0.0;
  double get responseTimeHours => stats?['responseTime']?.toDouble() ?? 24.0;
}
