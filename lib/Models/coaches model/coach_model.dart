import 'package:cloud_firestore/cloud_firestore.dart';

class CoachModel {
  final String id;
  final String name;
  final String? profilePic;
  final String? selectedClubId;
  final String? selectedClubName;
  final String? assignedClubId;
  final String? assignedClubName;
  final DateTime? clubAssignedAt;
  final String? clubAssignmentStatus;
  final String verificationStatus;
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final int maxPupils;
  final int currentPupils;
  final bool acceptingNewPupils;
  final int? experience; // Added experience field
  final DateTime createdAt;
  final DateTime updatedAt;

  const CoachModel({
    required this.id,
    required this.name,
    this.profilePic,
    this.selectedClubId,
    this.selectedClubName,
    this.assignedClubId,
    this.assignedClubName,
    this.clubAssignedAt,
    this.clubAssignmentStatus,
    this.verificationStatus = 'pending',
    this.verifiedBy,
    this.verifiedAt,
    this.maxPupils = 20,
    this.currentPupils = 0,
    this.acceptingNewPupils = true,
    this.experience, // Added to constructor
    required this.createdAt,
    required this.updatedAt,
  });

  /// Computed helpers
  bool get isVerified => verificationStatus == 'verified';
  bool get isPending => verificationStatus == 'pending';
  bool get isRejected => verificationStatus == 'rejected';
  bool get isFull => currentPupils >= maxPupils;
  bool get canAcceptPupil => acceptingNewPupils && !isFull && isVerified;

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return DateTime.now();
      }
    }
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return DateTime.now();
  }

  static int _parseInt(dynamic value, {int fallback = 0}) {
    if (value == null) return fallback;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? fallback;
  }

  static bool _parseBool(dynamic value, {bool fallback = false}) {
    if (value == null) return fallback;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      final lower = value.toLowerCase();
      return lower == 'true' || lower == 'yes' || lower == '1';
    }
    return fallback;
  }

  /// CopyWith
  CoachModel copyWith({
    String? id,
    String? name,
    String? profilePic,
    String? selectedClubId,
    String? selectedClubName,
    String? assignedClubId,
    String? assignedClubName,
    DateTime? clubAssignedAt,
    String? clubAssignmentStatus,
    String? verificationStatus,
    String? verifiedBy,
    DateTime? verifiedAt,
    int? maxPupils,
    int? currentPupils,
    bool? acceptingNewPupils,
    int? experience, // Added to copyWith
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CoachModel(
      id: id ?? this.id,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      selectedClubId: selectedClubId ?? this.selectedClubId,
      selectedClubName: selectedClubName ?? this.selectedClubName,
      assignedClubId: assignedClubId ?? this.assignedClubId,
      assignedClubName: assignedClubName ?? this.assignedClubName,
      clubAssignedAt: clubAssignedAt ?? this.clubAssignedAt,
      clubAssignmentStatus: clubAssignmentStatus ?? this.clubAssignmentStatus,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      maxPupils: maxPupils ?? this.maxPupils,
      currentPupils: currentPupils ?? this.currentPupils,
      acceptingNewPupils: acceptingNewPupils ?? this.acceptingNewPupils,
      experience: experience ?? this.experience, // Added to copyWith
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'name': name,
    'profilePic': profilePic,
    'selectedClubId': selectedClubId,
    'selectedClubName': selectedClubName,
    'assignedClubId': assignedClubId,
    'assignedClubName': assignedClubName,
    'clubAssignedAt': clubAssignedAt != null
        ? Timestamp.fromDate(clubAssignedAt!)
        : null,
    'clubAssignmentStatus': clubAssignmentStatus,
    'verificationStatus': verificationStatus,
    'verifiedBy': verifiedBy,
    'verifiedAt': verifiedAt != null ? Timestamp.fromDate(verifiedAt!) : null,
    'maxPupils': maxPupils,
    'currentPupils': currentPupils,
    'acceptingNewPupils': acceptingNewPupils,
    'experience': experience,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };

  factory CoachModel.fromFirestore(Map<String, dynamic> data) {
    return CoachModel(
      id: data['id']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      profilePic: data['profilePic']?.toString(),
      selectedClubId: data['selectedClubId']?.toString(),
      selectedClubName: data['selectedClubName']?.toString(),
      assignedClubId: data['assignedClubId']?.toString(),
      assignedClubName: data['assignedClubName']?.toString(),
      clubAssignedAt: data['clubAssignedAt'] != null
          ? _parseDate(data['clubAssignedAt'])
          : null,
      clubAssignmentStatus: data['clubAssignmentStatus']?.toString() ?? 'none',
      verificationStatus: data['verificationStatus']?.toString() ?? 'pending',
      verifiedBy: data['verifiedBy']?.toString(),
      verifiedAt: data['verifiedAt'] != null
          ? _parseDate(data['verifiedAt'])
          : null,
      maxPupils: _parseInt(data['maxPupils'], fallback: 20),
      currentPupils: _parseInt(data['currentPupils'], fallback: 0),
      acceptingNewPupils: _parseBool(
        data['acceptingNewPupils'],
        fallback: true,
      ),
      experience: data['experience'] != null
          ? _parseInt(data['experience'])
          : null,
      createdAt: _parseDate(data['createdAt']),
      updatedAt: _parseDate(data['updatedAt']),
    );
  }
  factory CoachModel.fromJson(Map<String, dynamic> json) =>
      CoachModel.fromFirestore(json);
}
