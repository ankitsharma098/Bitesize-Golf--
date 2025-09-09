import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/entities/coach_entity.dart' as entity;

class CoachModel {
  final String id;
  final String userId;
  final String name;
  final String bio;
  final List<String> qualifications;
  final int experience;
  final List<String> specialties;
  final String? selectedClubId;
  final String? selectedClubName;
  final String? assignedClubId;
  final String? assignedClubName;
  final DateTime? clubAssignedAt;
  final String? clubAssignmentStatus;
  final String verificationStatus;
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final String? verificationNote;
  final int maxPupils;
  final int currentPupils;
  final bool acceptingNewPupils;
  final Map<String, dynamic> stats;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CoachModel({
    required this.id,
    required this.userId,
    required this.name,
    this.bio = '',
    this.qualifications = const [],
    this.experience = 0,
    this.specialties = const [],
    this.selectedClubId,
    this.selectedClubName,
    this.assignedClubId,
    this.assignedClubName,
    this.clubAssignedAt,
    this.clubAssignmentStatus,
    this.verificationStatus = 'pending',
    this.verifiedBy,
    this.verifiedAt,
    this.verificationNote,
    this.maxPupils = 20,
    this.currentPupils = 0,
    this.acceptingNewPupils = true,
    this.stats = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor for new coaches (during signup)
  factory CoachModel.create({
    required String id,
    required String userId,
    required String name,
  }) {
    final now = DateTime.now();
    return CoachModel(
      id: id,
      userId: userId,
      name: name,
      verificationStatus: 'pending',
      clubAssignmentStatus: 'none',
      stats: getDefaultStats(),
      createdAt: now,
      updatedAt: now,
    );
  }

  /* ---------- to / from entity ---------- */

  entity.Coach toEntity() => entity.Coach(
    id: id,
    userId: userId,
    name: name,
    bio: bio,
    qualifications: qualifications,
    experience: experience,
    specialties: specialties,
    selectedClubId: selectedClubId,
    selectedClubName: selectedClubName,
    assignedClubId: assignedClubId,
    assignedClubName: assignedClubName,
    clubAssignedAt: clubAssignedAt,
    clubAssignmentStatus: clubAssignmentStatus,
    verificationStatus: verificationStatus,
    verifiedBy: verifiedBy,
    verifiedAt: verifiedAt,
    verificationNote: verificationNote,
    maxPupils: maxPupils,
    currentPupils: currentPupils,
    acceptingNewPupils: acceptingNewPupils,
    stats: stats,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory CoachModel.fromEntity(entity.Coach coach) => CoachModel(
    id: coach.id,
    userId: coach.userId,
    name: coach.name,
    bio: coach.bio,
    qualifications: coach.qualifications,
    experience: coach.experience,
    specialties: coach.specialties,
    selectedClubId: coach.selectedClubId,
    selectedClubName: coach.selectedClubName,
    assignedClubId: coach.assignedClubId,
    assignedClubName: coach.assignedClubName,
    clubAssignedAt: coach.clubAssignedAt,
    clubAssignmentStatus: coach.clubAssignmentStatus,
    verificationStatus: coach.verificationStatus,
    verifiedBy: coach.verifiedBy,
    verifiedAt: coach.verifiedAt,
    verificationNote: coach.verificationNote,
    maxPupils: coach.maxPupils,
    currentPupils: coach.currentPupils,
    acceptingNewPupils: coach.acceptingNewPupils,
    stats: coach.stats,
    createdAt: coach.createdAt,
    updatedAt: coach.updatedAt,
  );

  /* ---------- to / from JSON ---------- */

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'bio': bio,
    'qualifications': qualifications,
    'experience': experience,
    'specialties': specialties,
    'selectedClubId': selectedClubId,
    'selectedClubName': selectedClubName,
    'assignedClubId': assignedClubId,
    'assignedClubName': assignedClubName,
    'clubAssignedAt': clubAssignedAt == null
        ? null
        : Timestamp.fromDate(clubAssignedAt!),
    'clubAssignmentStatus': clubAssignmentStatus,
    'verificationStatus': verificationStatus,
    'verifiedBy': verifiedBy,
    'verifiedAt': verifiedAt == null ? null : Timestamp.fromDate(verifiedAt!),
    'verificationNote': verificationNote,
    'maxPupils': maxPupils,
    'currentPupils': currentPupils,
    'acceptingNewPupils': acceptingNewPupils,
    'stats': stats.isNotEmpty ? stats : getDefaultStats(),
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };

  factory CoachModel.fromJson(Map<String, dynamic> json) => CoachModel(
    id: json['id'] as String? ?? '',
    userId: json['userId'] as String? ?? '',
    name: json['name'] as String? ?? '',
    bio: json['bio'] as String? ?? '',
    qualifications: List<String>.from(json['qualifications'] ?? []),
    experience: json['experience'] as int? ?? 0,
    specialties: List<String>.from(json['specialties'] ?? []),
    selectedClubId: json['selectedClubId'] as String?,
    selectedClubName: json['selectedClubName'] as String?,
    assignedClubId:
        (json['assignedClubId'] ?? json['clubId'])
            as String?, // Handle old field name
    assignedClubName: json['assignedClubName'] as String?,
    clubAssignedAt: (json['clubAssignedAt'] as Timestamp?)?.toDate(),
    clubAssignmentStatus: json['clubAssignmentStatus'] as String? ?? 'none',
    verificationStatus: json['verificationStatus'] as String? ?? 'pending',
    verifiedBy: json['verifiedBy'] as String?,
    verifiedAt: (json['verifiedAt'] as Timestamp?)?.toDate(),
    verificationNote: json['verificationNote'] as String?,
    maxPupils: json['maxPupils'] as int? ?? 20,
    currentPupils: json['currentPupils'] as int? ?? 0,
    acceptingNewPupils: json['acceptingNewPupils'] as bool? ?? true,
    stats: (json['stats'] as Map<String, dynamic>?) ?? getDefaultStats(),
    createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );

  factory CoachModel.fromFirestore(Map<String, dynamic> data) =>
      CoachModel.fromJson(data);

  /* ---------- from Firebase Auth only ---------- */
  factory CoachModel.fromFirebase(fb.User firebaseUser) => CoachModel(
    id: firebaseUser.uid,
    userId: firebaseUser.uid,
    name: firebaseUser.displayName ?? '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  /* ---------- helpers ---------- */

  static Map<String, dynamic> getDefaultStats() => {
    'totalPupils': 0,
    'activePupils': 0,
    'averageImprovement': 0.0,
    'responseTime': 24.0,
    'rating': 0.0,
    'totalReviews': 0,
    'lessonsGiven': 0,
    'completionRate': 0.0,
  };

  // Helper methods
  bool get isVerified => verificationStatus == 'verified';
  bool get isPending => verificationStatus == 'pending';
  bool get isRejected => verificationStatus == 'rejected';
  bool get canAcceptPupils =>
      isVerified && acceptingNewPupils && currentPupils < maxPupils;
  double get averageImprovement =>
      (stats['averageImprovement'] ?? 0.0).toDouble();
  double get responseTimeHours => (stats['responseTime'] ?? 24.0).toDouble();

  // Copy with method
  CoachModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? bio,
    List<String>? qualifications,
    int? experience,
    List<String>? specialties,
    String? selectedClubId,
    String? selectedClubName,
    String? assignedClubId,
    String? assignedClubName,
    DateTime? clubAssignedAt,
    String? clubAssignmentStatus,
    String? verificationStatus,
    String? verifiedBy,
    DateTime? verifiedAt,
    String? verificationNote,
    int? maxPupils,
    int? currentPupils,
    bool? acceptingNewPupils,
    Map<String, dynamic>? stats,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CoachModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      qualifications: qualifications ?? this.qualifications,
      experience: experience ?? this.experience,
      specialties: specialties ?? this.specialties,
      selectedClubId: selectedClubId ?? this.selectedClubId,
      selectedClubName: selectedClubName ?? this.selectedClubName,
      assignedClubId: assignedClubId ?? this.assignedClubId,
      assignedClubName: assignedClubName ?? this.assignedClubName,
      clubAssignedAt: clubAssignedAt ?? this.clubAssignedAt,
      clubAssignmentStatus: clubAssignmentStatus ?? this.clubAssignmentStatus,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      verificationNote: verificationNote ?? this.verificationNote,
      maxPupils: maxPupils ?? this.maxPupils,
      currentPupils: currentPupils ?? this.currentPupils,
      acceptingNewPupils: acceptingNewPupils ?? this.acceptingNewPupils,
      stats: stats ?? this.stats,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'CoachModel(id: $id, name: $name, userId: $userId)';
}
