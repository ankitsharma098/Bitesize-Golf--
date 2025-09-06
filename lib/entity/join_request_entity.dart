import 'package:equatable/equatable.dart';

class JoinRequest extends Equatable {
  final String id;
  final String? pupilId;
  final String? coachId;
  final String? parentId;
  final String? clubId;
  final String requestType;
  final String status;
  final DateTime requestedAt;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? rejectedBy;
  final DateTime? rejectedAt;
  final String? rejectionReason;
  final String? parentMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const JoinRequest({
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

  @override
  List<Object?> get props => [
    id,
    pupilId,
    coachId,
    parentId,
    clubId,
    requestType,
    status,
    requestedAt,
    approvedBy,
    approvedAt,
    rejectedBy,
    rejectedAt,
    rejectionReason,
    parentMessage,
    createdAt,
    updatedAt,
  ];

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
  bool get isPupilToCoach => requestType == 'pupil_to_coach';
  bool get isCoachVerification => requestType == 'coach_verification';
}
