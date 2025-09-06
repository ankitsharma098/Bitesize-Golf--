import 'package:cloud_firestore/cloud_firestore.dart';

class JoinRequestModel {
  final String id;
  final String? pupilId; // For pupil->coach requests
  final String? coachId; // For coach->club requests or pupil->coach
  final String? parentId; // For pupil->coach requests
  final String? clubId;
  final String requestType; // 'pupil_to_coach', 'coach_verification'
  final String status; // 'pending', 'approved', 'rejected'
  final DateTime requestedAt;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? rejectedBy;
  final DateTime? rejectedAt;
  final String? rejectionReason;
  final String? parentMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const JoinRequestModel({
    required this.id,
    this.pupilId,
    this.coachId,
    this.parentId,
    this.clubId,
    required this.requestType,
    this.status = 'pending',
    required this.requestedAt,
    this.approvedBy,
    this.approvedAt,
    this.rejectedBy,
    this.rejectedAt,
    this.rejectionReason,
    this.parentMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'pupilId': pupilId,
    'coachId': coachId,
    'parentId': parentId,
    'clubId': clubId,
    'requestType': requestType,
    'status': status,
    'requestedAt': Timestamp.fromDate(requestedAt),
    'approvedBy': approvedBy,
    'approvedAt': approvedAt != null ? Timestamp.fromDate(approvedAt!) : null,
    'rejectedBy': rejectedBy,
    'rejectedAt': rejectedAt != null ? Timestamp.fromDate(rejectedAt!) : null,
    'rejectionReason': rejectionReason,
    'parentMessage': parentMessage,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };

  factory JoinRequestModel.fromJson(Map<String, dynamic> json) =>
      JoinRequestModel(
        id: json['id'],
        pupilId: json['pupilId'],
        coachId: json['coachId'],
        parentId: json['parentId'],
        clubId: json['clubId'],
        requestType: json['requestType'],
        status: json['status'] ?? 'pending',
        requestedAt: json['requestedAt']?.toDate() ?? DateTime.now(),
        approvedBy: json['approvedBy'],
        approvedAt: json['approvedAt']?.toDate(),
        rejectedBy: json['rejectedBy'],
        rejectedAt: json['rejectedAt']?.toDate(),
        rejectionReason: json['rejectionReason'],
        parentMessage: json['parentMessage'],
        createdAt: json['createdAt']?.toDate() ?? DateTime.now(),
        updatedAt: json['updatedAt']?.toDate() ?? DateTime.now(),
      );
}
