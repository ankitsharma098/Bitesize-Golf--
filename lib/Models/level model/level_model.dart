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

  // Factory constructor for Firestore DocumentSnapshot
  factory LevelModel.fromFirestoreDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document book bloc is null for level: ${doc.id}');
    }
    return LevelModel.fromJson(data);
  }

  // Factory constructor for Firestore book bloc (Map format)
  factory LevelModel.fromFirestore(Map<String, dynamic> data) {
    return LevelModel.fromJson(data);
  }

  // Factory constructor for Firestore QueryDocumentSnapshot
  factory LevelModel.fromFirestoreQuery(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LevelModel.fromJson(data);
  }

  // Firestore Serialization - Optimized for Firestore operations
  Map<String, dynamic> toFirestore() {
    final data = <String, dynamic>{
      'levelNumber': levelNumber,
      'name': name,
      'pupilDescription': pupilDescription,
      'coachDescription': coachDescription,
      'accessTier': accessTier,
      'isActive': isActive,
      'isPublished': isPublished,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };

    // Add optional fields only if they have values
    if (prerequisite != null && prerequisite!.isNotEmpty) {
      data['prerequisite'] = prerequisite;
    }

    return data;
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

  // JSON Serialization (keeping original for backward compatibility)
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

  // Helper method to safely parse DateTime from various formats
  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) {
      return DateTime.now();
    }

    if (dateValue is Timestamp) {
      return dateValue.toDate();
    }

    if (dateValue is String) {
      try {
        // Handle ISO 8601 strings (like from toIso8601String())
        return DateTime.parse(dateValue);
      } catch (e) {
        print('Error parsing date string: $dateValue, error: $e');
        return DateTime.now();
      }
    }

    if (dateValue is int) {
      // Assuming it's milliseconds since epoch
      return DateTime.fromMillisecondsSinceEpoch(dateValue);
    }

    print('Unexpected date type: ${dateValue.runtimeType}, value: $dateValue');
    return DateTime.now();
  }

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    try {
      return LevelModel(
        levelNumber: (json['levelNumber'] is int)
            ? json['levelNumber'] as int
            : int.tryParse(json['levelNumber'].toString()) ?? 0,
        name: json['name']?.toString() ?? '',
        pupilDescription: json['pupilDescription']?.toString() ?? '',
        coachDescription: json['coachDescription']?.toString() ?? '',
        accessTier: json['accessTier']?.toString() ?? '',
        prerequisite: json['prerequisite']?.toString(),
        isActive: json['isActive'] is bool
            ? json['isActive'] as bool
            : (json['isActive'].toString().toLowerCase() == 'true'),
        isPublished: json['isPublished'] is bool
            ? json['isPublished'] as bool
            : (json['isPublished'].toString().toLowerCase() == 'true'),
        createdAt: _parseDateTime(json['createdAt']),
        updatedAt: _parseDateTime(json['updatedAt']),
      );
    } catch (e, stack) {
      print('❌ Error parsing LevelModel from JSON: $json');
      print('Error details: $e');
      print(stack);
      rethrow;
    }
  }

  @override
  String toString() =>
      'LevelModel(levelNumber: $levelNumber, name: $name, accessTier: $accessTier, isActive: $isActive, isPublished: $isPublished)';
}
