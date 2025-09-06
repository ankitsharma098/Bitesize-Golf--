import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/pupil_entity.dart';

class PupilModel {
  final String id;
  final String parentId;
  final String name;
  final DateTime? dateOfBirth;
  final String? handicap;
  final String? selectedCoachName;
  final String? selectedClubId;
  final String? avatar;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PupilModel({
    required this.id,
    required this.parentId,
    required this.name,
    this.dateOfBirth,
    this.handicap,
    this.selectedCoachName,
    this.selectedClubId,
    this.avatar,
    required this.createdAt,
    required this.updatedAt,
  });

  Pupil toEntity() => Pupil(
    id: id,
    parentId: parentId,
    name: name,
    dateOfBirth: dateOfBirth,
    handicap: handicap,
    selectedCoachName: selectedCoachName,
    selectedClubId: selectedClubId,
    avatar: avatar,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory PupilModel.fromEntity(Pupil pupil) => PupilModel(
    id: pupil.id,
    parentId: pupil.parentId,
    name: pupil.name,
    dateOfBirth: pupil.dateOfBirth,
    handicap: pupil.handicap,
    selectedCoachName: pupil.selectedCoachName,
    selectedClubId: pupil.selectedClubId,
    avatar: pupil.avatar,
    createdAt: pupil.createdAt,
    updatedAt: pupil.updatedAt,
  );

  factory PupilModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PupilModel(
      id: doc.id,
      parentId: data['parentId'] ?? '',
      name: data['name'] ?? '',
      dateOfBirth: (data['dateOfBirth'] as Timestamp?)?.toDate(),
      handicap: data['handicap'],
      selectedCoachName: data['selectedCoachName'],
      selectedClubId: data['selectedClubId'],
      avatar: data['avatar'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
    'parentId': parentId,
    'name': name,
    'dateOfBirth': dateOfBirth != null
        ? Timestamp.fromDate(dateOfBirth!)
        : null,
    'handicap': handicap,
    'selectedCoachName': selectedCoachName,
    'selectedClubId': selectedClubId,
    'avatar': avatar,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };
}
