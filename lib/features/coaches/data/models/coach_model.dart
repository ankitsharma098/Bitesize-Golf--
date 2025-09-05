import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/coach_entity.dart';
import '../../domain/entities/coach_stats_entity.dart';

class CoachModel {
  final String id;
  final String userId;
  final String name;
  final String bio;
  final int experience;
  final String? clubId;
  final String verificationStatus;
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final int maxPupils;
  final int currentPupils;
  final bool acceptingNewPupils;
  final CoachStats stats;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CoachModel({
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

  Coach toEntity() => Coach(
    id: id,
    userId: userId,
    name: name,
    bio: bio,
    experience: experience,
    clubId: clubId,
    verificationStatus: verificationStatus,
    verifiedBy: verifiedBy,
    verifiedAt: verifiedAt,
    maxPupils: maxPupils,
    currentPupils: currentPupils,
    acceptingNewPupils: acceptingNewPupils,
    stats: stats,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory CoachModel.fromEntity(Coach coach) => CoachModel(
    id: coach.id,
    userId: coach.userId,
    name: coach.name,
    bio: coach.bio,
    experience: coach.experience,
    clubId: coach.clubId,
    verificationStatus: coach.verificationStatus,
    verifiedBy: coach.verifiedBy,
    verifiedAt: coach.verifiedAt,
    maxPupils: coach.maxPupils,
    currentPupils: coach.currentPupils,
    acceptingNewPupils: coach.acceptingNewPupils,
    stats: coach.stats,
    createdAt: coach.createdAt,
    updatedAt: coach.updatedAt,
  );

  factory CoachModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CoachModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      bio: data['bio'] ?? '',
      experience: data['experience'] ?? 0,
      clubId: data['clubId'],
      verificationStatus: data['verificationStatus'] ?? 'pending',
      verifiedBy: data['verifiedBy'],
      verifiedAt: (data['verifiedAt'] as Timestamp?)?.toDate(),
      maxPupils: data['maxPupils'] ?? 50,
      currentPupils: data['currentPupils'] ?? 0,
      acceptingNewPupils: data['acceptingNewPupils'] ?? true,
      stats: CoachStats.fromJson(
        Map<String, dynamic>.from(data['stats'] ?? {}),
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'name': name,
    'bio': bio,
    'experience': experience,
    'clubId': clubId,
    'verificationStatus': verificationStatus,
    'verifiedBy': verifiedBy,
    'verifiedAt': verifiedAt != null ? Timestamp.fromDate(verifiedAt!) : null,
    'maxPupils': maxPupils,
    'currentPupils': currentPupils,
    'acceptingNewPupils': acceptingNewPupils,
    'stats': stats.toJson(),
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };
}
