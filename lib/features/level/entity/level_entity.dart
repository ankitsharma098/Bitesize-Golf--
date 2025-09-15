import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Level extends Equatable {
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

  const Level({
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

  Level copyWith({
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
    return Level(
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

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
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
