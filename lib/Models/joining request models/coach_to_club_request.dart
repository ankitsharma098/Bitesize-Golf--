import 'package:cloud_firestore/cloud_firestore.dart';

class CoachToClubRequest {
  final String id;
  final String coachId;
  final String coachName;
  final String clubId;
  final String clubName;
  final String message;
  final String status;
  final DateTime requestedAt;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? reviewNote;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CoachToClubRequest({
    required this.id,
    required this.coachId,
    required this.coachName,
    required this.clubId,
    required this.clubName,
    this.message = '',
    this.status = 'pending',
    required this.requestedAt,
    this.reviewedBy,
    this.reviewedAt,
    this.reviewNote,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CoachToClubRequest.create({
    required String id,
    required String coachId,
    required String coachName,
    required String clubId,
    required String clubName,
    String? message,
  }) {
    final now = DateTime.now();
    return CoachToClubRequest(
      id: id,
      coachId: coachId,
      coachName: coachName,
      clubId: clubId,
      clubName: clubName,
      message: message ?? '',
      requestedAt: now,
      createdAt: now,
      updatedAt: now,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'coachId': coachId,
    'coachName': coachName,
    'clubId': clubId,
    'clubName': clubName,
    'message': message,
    'status': status,
    'requestedAt': Timestamp.fromDate(requestedAt),
    'reviewedBy': reviewedBy,
    'reviewedAt': reviewedAt == null ? null : Timestamp.fromDate(reviewedAt!),
    'reviewNote': reviewNote,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };

  factory CoachToClubRequest.fromFirestore(
    Map<String, dynamic> json,
  ) => CoachToClubRequest(
    id: json['id'] ?? '',
    coachId: json['coachId'] ?? '',
    coachName: json['coachName'] ?? '',
    clubId: json['clubId'] ?? '',
    clubName: json['clubName'] ?? '',
    message: json['message'] ?? '',
    status: json['status'] ?? 'pending',
    requestedAt:
        (json['requestedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    reviewedBy: json['reviewedBy'],
    reviewedAt: (json['reviewedAt'] as Timestamp?)?.toDate(),
    reviewNote: json['reviewNote'],
    createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );

  CoachToClubRequest copyWith({
    String? id,
    String? coachId,
    String? coachName,
    String? clubId,
    String? clubName,
    String? message,
    String? status,
    DateTime? requestedAt,
    String? reviewedBy,
    DateTime? reviewedAt,
    String? reviewNote,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CoachToClubRequest(
    id: id ?? this.id,
    coachId: coachId ?? this.coachId,
    coachName: coachName ?? this.coachName,
    clubId: clubId ?? this.clubId,
    clubName: clubName ?? this.clubName,
    message: message ?? this.message,
    status: status ?? this.status,
    requestedAt: requestedAt ?? this.requestedAt,
    reviewedBy: reviewedBy ?? this.reviewedBy,
    reviewedAt: reviewedAt ?? this.reviewedAt,
    reviewNote: reviewNote ?? this.reviewNote,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
}
