import 'package:equatable/equatable.dart';

class Coach extends Equatable {
  final String id; // Coach document ID (auto-generated)
  final String userId; // Reference to Users collection
  final String name;
  final String? avatarUrl; // NEW: Download URL from Firebase Storage
  final String bio;
  final List<String> qualifications;
  final int experience;
  final List<String> specialties;

  // Club association fields (similar to pupil's coach fields)
  final String? selectedClubId; // Club they want to join
  final String? selectedClubName; // For display purposes
  final String? assignedClubId; // Actually assigned club (after approval)
  final String? assignedClubName; // Assigned club name
  final DateTime? clubAssignedAt; // When club assignment happened
  final String? clubAssignmentStatus; // 'pending', 'assigned', 'none'

  // Verification fields
  final String verificationStatus; // 'pending', 'verified', 'rejected'
  final String? verifiedBy; // Admin who verified
  final DateTime? verifiedAt;
  final String? verificationNote; // Admin's note

  // Pupil management
  final int maxPupils;
  final int currentPupils;
  final bool acceptingNewPupils;

  // Performance tracking
  final Map<String, dynamic> stats;

  // Timestamps
  final DateTime createdAt;
  final DateTime updatedAt;

  const Coach({
    required this.id,
    required this.userId,
    required this.name,
    this.avatarUrl, // NEW: Optional, defaults to null
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

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    avatarUrl, // NEW: Added to props
    bio,
    qualifications,
    experience,
    specialties,
    selectedClubId,
    selectedClubName,
    assignedClubId,
    assignedClubName,
    clubAssignedAt,
    clubAssignmentStatus,
    verificationStatus,
    verifiedBy,
    verifiedAt,
    verificationNote,
    maxPupils,
    currentPupils,
    acceptingNewPupils,
    stats,
    createdAt,
    updatedAt,
  ];

  // Verification status getters
  bool get isVerified => verificationStatus == 'verified';
  bool get isPending => verificationStatus == 'pending';
  bool get isRejected => verificationStatus == 'rejected';

  // NEW: Avatar-related getters
  bool get hasAvatar => avatarUrl != null && avatarUrl!.isNotEmpty;
  String get avatarUrlWithFallback => avatarUrl ?? ''; // Or use a default URL

  // Club assignment getters
  bool get hasAssignedClub =>
      assignedClubId != null && assignedClubId!.isNotEmpty;
  bool get hasRequestedClub =>
      selectedClubId != null && selectedClubId!.isNotEmpty;
  bool get isPendingClubAssignment => clubAssignmentStatus == 'pending';
  bool get isAssignedToClub => clubAssignmentStatus == 'assigned';

  // Capacity getters
  bool get canAcceptPupils =>
      isVerified && acceptingNewPupils && currentPupils < maxPupils;
  bool get isAtCapacity => currentPupils >= maxPupils;
  int get availableSlots => maxPupils - currentPupils;
  double get capacityPercentage =>
      maxPupils > 0 ? (currentPupils / maxPupils) * 100 : 0.0;

  // Stats getters
  int get totalPupils => stats['totalPupils'] ?? 0;
  int get activePupils => stats['activePupils'] ?? currentPupils;
  double get averageImprovement =>
      (stats['averageImprovement'] ?? 0.0).toDouble();
  double get responseTimeHours => (stats['responseTime'] ?? 24.0).toDouble();
  double get rating => (stats['rating'] ?? 0.0).toDouble();
  int get totalReviews => stats['totalReviews'] ?? 0;
  // Add validation for stats access

  // Add business logic methods
  bool get needsProfileCompletion => bio.isEmpty || qualifications.isEmpty;
  bool get isEligibleForClubAssignment =>
      isVerified && needsProfileCompletion == false;
  // Copy with method for updates
  Coach copyWith({
    String? id,
    String? userId,
    String? name,
    String? avatarUrl, // NEW: Added
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
    return Coach(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl, // NEW
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
}
