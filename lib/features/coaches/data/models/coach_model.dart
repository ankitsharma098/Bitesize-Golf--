import 'package:cloud_firestore/cloud_firestore.dart';

class CoachModel {
  final String id;
  final String userId; // Reference to users collection
  final String displayName;
  final String? firstName;
  final String? lastName;
  final String bio;
  final List<String> qualifications;
  final int experience; // years
  final List<String> specialties;
  final String? clubId;
  final String verificationStatus; // 'pending', 'verified', 'rejected'
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final int maxPupils;
  final int currentPupils;
  final bool acceptingNewPupils;
  final Map<String, dynamic>? stats;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CoachModel({
    required this.id,
    required this.userId,
    required this.displayName,
    this.bio = '',
    this.qualifications = const [],
    this.experience = 0,
    this.specialties = const [],
    this.clubId,
    this.firstName,
    this.lastName,
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': displayName,
    'bio': bio,
    'qualifications': qualifications,
    'experience': experience,
    'firstName': firstName,
    'lastName': lastName,
    'specialties': specialties,
    'clubId': clubId,
    'verificationStatus': verificationStatus,
    'verifiedBy': verifiedBy,
    'verifiedAt': verifiedAt != null ? Timestamp.fromDate(verifiedAt!) : null,
    'maxPupils': maxPupils,
    'currentPupils': currentPupils,
    'acceptingNewPupils': acceptingNewPupils,
    'stats': stats ?? _getDefaultStats(),
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };

  factory CoachModel.fromJson(Map<String, dynamic> json) => CoachModel(
    id: json['id'],
    userId: json['userId'],
    displayName: json['name'],
    bio: json['bio'] ?? '',
    qualifications: List<String>.from(json['qualifications'] ?? []),
    experience: json['experience'] ?? 0,
    specialties: List<String>.from(json['specialties'] ?? []),
    clubId: json['clubId'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    verificationStatus: json['verificationStatus'] ?? 'pending',
    verifiedBy: json['verifiedBy'],
    verifiedAt: json['verifiedAt']?.toDate(),
    maxPupils: json['maxPupils'] ?? 20,
    currentPupils: json['currentPupils'] ?? 0,
    acceptingNewPupils: json['acceptingNewPupils'] ?? true,
    stats: json['stats'] as Map<String, dynamic>?,
    createdAt: json['createdAt']?.toDate() ?? DateTime.now(),
    updatedAt: json['updatedAt']?.toDate() ?? DateTime.now(),
  );

  static Map<String, dynamic> _getDefaultStats() => {
    'totalPupils': 0,
    'activePupils': 0,
    'averageImprovement': 0.0,
    'responseTime': 24.0, // hours
  };
}
