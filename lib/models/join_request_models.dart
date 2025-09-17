import 'package:cloud_firestore/cloud_firestore.dart';

class JoinRequestModel {
  final String id;
  final String
  requesterId; // The user making the request (always userId from Users collection)
  final String
  requesterRole; // 'pupil' or 'coach' - helps identify request type
  final String requesterName; // Display name for easy reference

  // Target IDs (what they want to join)
  final String? targetCoachId; // For pupil->coach requests (coach document ID)
  final String? targetCoachName; // Coach display name
  final String? targetClubId; // For coach->club requests (club document ID)
  final String? targetClubName; // Club display name

  final String
  requestType; // 'pupil_to_coach', 'coach_to_club', 'coach_verification'
  final String status; // 'pending', 'approved', 'rejected'

  // Request metadata
  final DateTime requestedAt;
  final String? message; // Optional message from requester

  // Admin actions
  final String? reviewedBy; // Admin who reviewed (userId)
  final DateTime? reviewedAt;
  final String? reviewNote; // Admin's note on approval/rejection

  // Timestamps
  final DateTime createdAt;
  final DateTime updatedAt;

  const JoinRequestModel({
    required this.id,
    required this.requesterId,
    required this.requesterRole,
    required this.requesterName,
    this.targetCoachId,
    this.targetCoachName,
    this.targetClubId,
    this.targetClubName,
    required this.requestType,
    this.status = 'pending',
    required this.requestedAt,
    this.message,
    this.reviewedBy,
    this.reviewedAt,
    this.reviewNote,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructors for different request types
  // Factory constructors for different request types
  factory JoinRequestModel.pupilToCoach({
    required String id,
    required String pupilUserId,
    required String pupilName,
    required String coachId,
    required String coachName,
    String? clubId, // ADD THIS PARAMETER
    String? clubName, // ADD THIS PARAMETER
    String? message,
    DateTime? requestedAt,
  }) {
    final now = DateTime.now();
    return JoinRequestModel(
      id: id,
      requesterId: pupilUserId,
      requesterRole: 'pupil',
      requesterName: pupilName,
      targetCoachId: coachId,
      targetCoachName: coachName,
      targetClubId: clubId, // SET THIS FIELD
      targetClubName: clubName, // SET THIS FIELD
      requestType: 'pupil_to_coach',
      requestedAt: requestedAt ?? now,
      message: message,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory JoinRequestModel.coachToClub({
    required String id,
    required String coachUserId,
    required String coachName,
    required String clubId,
    required String clubName,
    String? message,
    DateTime? requestedAt,
  }) {
    final now = DateTime.now();
    return JoinRequestModel(
      id: id,
      requesterId: coachUserId,
      requesterRole: 'coach',
      requesterName: coachName,
      targetClubId: clubId,
      targetClubName: clubName,
      requestType: 'coach_to_club',
      requestedAt: requestedAt ?? now,
      message: message,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory JoinRequestModel.coachVerification({
    required String id,
    required String coachUserId,
    required String coachName,
    String? message,
    DateTime? requestedAt,
  }) {
    final now = DateTime.now();
    return JoinRequestModel(
      id: id,
      requesterId: coachUserId,
      requesterRole: 'coach',
      requesterName: coachName,
      requestType: 'coach_verification',
      requestedAt: requestedAt ?? now,
      message: message,
      createdAt: now,
      updatedAt: now,
    );
  }

  // Helper methods
  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
  bool get isPupilRequest => requesterRole == 'pupil';
  bool get isCoachRequest => requesterRole == 'coach';

  // Create copy with updated status
  JoinRequestModel approve({required String reviewedBy, String? reviewNote}) {
    final now = DateTime.now();
    return copyWith(
      status: 'approved',
      reviewedBy: reviewedBy,
      reviewedAt: now,
      reviewNote: reviewNote,
      updatedAt: now,
    );
  }

  JoinRequestModel reject({required String reviewedBy, String? reviewNote}) {
    final now = DateTime.now();
    return copyWith(
      status: 'rejected',
      reviewedBy: reviewedBy,
      reviewedAt: now,
      reviewNote: reviewNote,
      updatedAt: now,
    );
  }

  JoinRequestModel copyWith({
    String? id,
    String? requesterId,
    String? requesterRole,
    String? requesterName,
    String? targetCoachId,
    String? targetCoachName,
    String? targetClubId,
    String? targetClubName,
    String? requestType,
    String? status,
    DateTime? requestedAt,
    String? message,
    String? reviewedBy,
    DateTime? reviewedAt,
    String? reviewNote,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JoinRequestModel(
      id: id ?? this.id,
      requesterId: requesterId ?? this.requesterId,
      requesterRole: requesterRole ?? this.requesterRole,
      requesterName: requesterName ?? this.requesterName,
      targetCoachId: targetCoachId ?? this.targetCoachId,
      targetCoachName: targetCoachName ?? this.targetCoachName,
      targetClubId: targetClubId ?? this.targetClubId,
      targetClubName: targetClubName ?? this.targetClubName,
      requestType: requestType ?? this.requestType,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
      message: message ?? this.message,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewNote: reviewNote ?? this.reviewNote,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'requesterId': requesterId,
    'requesterRole': requesterRole,
    'requesterName': requesterName,
    'targetCoachId': targetCoachId,
    'targetCoachName': targetCoachName,
    'targetClubId': targetClubId,
    'targetClubName': targetClubName,
    'requestType': requestType,
    'status': status,
    'requestedAt': Timestamp.fromDate(requestedAt),
    'message': message,
    'reviewedBy': reviewedBy,
    'reviewedAt': reviewedAt != null ? Timestamp.fromDate(reviewedAt!) : null,
    'reviewNote': reviewNote,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };

  factory JoinRequestModel.fromJson(Map<String, dynamic> json) =>
      JoinRequestModel(
        id: json['id'] ?? '',
        requesterId: json['requesterId'] ?? '',
        requesterRole: json['requesterRole'] ?? '',
        requesterName: json['requesterName'] ?? '',
        targetCoachId: json['targetCoachId'],
        targetCoachName: json['targetCoachName'],
        targetClubId: json['targetClubId'],
        targetClubName: json['targetClubName'],
        requestType: json['requestType'] ?? '',
        status: json['status'] ?? 'pending',
        requestedAt: json['requestedAt']?.toDate() ?? DateTime.now(),
        message: json['message'],
        reviewedBy: json['reviewedBy'],
        reviewedAt: json['reviewedAt']?.toDate(),
        reviewNote: json['reviewNote'],
        createdAt: json['createdAt']?.toDate() ?? DateTime.now(),
        updatedAt: json['updatedAt']?.toDate() ?? DateTime.now(),
      );

  factory JoinRequestModel.fromFirestore(Map<String, dynamic> json) =>
      JoinRequestModel.fromJson(json);

  @override
  String toString() {
    return 'JoinRequestModel(id: $id, requester: $requesterName, type: $requestType, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JoinRequestModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
