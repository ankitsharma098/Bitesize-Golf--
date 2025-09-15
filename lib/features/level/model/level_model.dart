import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class LevelModel extends Equatable {
  final int levelNumber;
  final String name;
  final String pupilDescription;
  final String coachDescription;
  final String accessTier;
  final String? prerequisite;
  final bool isActive;
  final bool isPublished;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LevelModel({
    required this.levelNumber,
    required this.name,
    required this.pupilDescription,
    required this.coachDescription,
    required this.accessTier,
    this.prerequisite,
    required this.isActive,
    required this.isPublished,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LevelModel.create({
    required int levelNumber,
    required String name,
    required String pupilDescription,
    required String coachDescription,
    required String accessTier,
    String? prerequisite,
  }) {
    final now = DateTime.now();
    return LevelModel(
      levelNumber: levelNumber,
      name: name,
      pupilDescription: pupilDescription,
      coachDescription: coachDescription,
      accessTier: accessTier,
      prerequisite: prerequisite,
      isActive: true,
      isPublished: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  List<Object?> get props => [
    levelNumber,
    name,
    pupilDescription,
    coachDescription,
    accessTier,
    prerequisite,
    isActive,
    isPublished,
    createdAt,
    updatedAt,
  ];

  LevelModel copyWith({
    int? levelNumber,
    String? name,
    String? pupilDescription,
    String? coachDescription,
    String? accessTier,
    String? prerequisite,
    bool? isActive,
    bool? isPublished,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LevelModel(
      levelNumber: levelNumber ?? this.levelNumber,
      name: name ?? this.name,
      pupilDescription: pupilDescription ?? this.pupilDescription,
      coachDescription: coachDescription ?? this.coachDescription,
      accessTier: accessTier ?? this.accessTier,
      prerequisite: prerequisite ?? this.prerequisite,
      isActive: isActive ?? this.isActive,
      isPublished: isPublished ?? this.isPublished,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'levelNumber': levelNumber,
    'name': name,
    'pupilDescription': pupilDescription,
    'coachDescription': coachDescription,
    'accessTier': accessTier,
    'prerequisite': prerequisite,
    'isActive': isActive,
    'isPublished': isPublished,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      levelNumber: json['levelNumber'] as int,
      name: json['name'] as String,
      pupilDescription: json['pupilDescription'] as String,
      coachDescription: json['coachDescription'] as String,
      accessTier: json['accessTier'] as String,
      prerequisite: json['prerequisite'] as String?,
      isActive: json['isActive'] as bool,
      isPublished: json['isPublished'] as bool,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }
}
