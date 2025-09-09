// features/auth/data/models/club_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/golf_club_entity.dart';

class ClubModel {
  final String id;
  final String name;
  final String location;
  final String description;
  final String contactEmail;
  final bool isActive;
  final int totalCoaches;
  final int totalPupils;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ClubModel({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.contactEmail,
    required this.isActive,
    required this.totalCoaches,
    required this.totalPupils,
    required this.createdAt,
    required this.updatedAt,
  });

  /* ---------- to / from entity ---------- */

  Club toEntity() => Club(
    id: id,
    name: name,
    location: location,
    description: description,
    contactEmail: contactEmail,
    isActive: isActive,
    totalCoaches: totalCoaches,
    totalPupils: totalPupils,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory ClubModel.fromEntity(Club club) => ClubModel(
    id: club.id,
    name: club.name,
    location: club.location,
    description: club.description,
    contactEmail: club.contactEmail,
    isActive: club.isActive,
    totalCoaches: club.totalCoaches,
    totalPupils: club.totalPupils,
    createdAt: club.createdAt,
    updatedAt: club.updatedAt,
  );

  /* ---------- to / from JSON ---------- */

  Map<String, dynamic> toJson() => {
    'name': name,
    'location': location,
    'description': description,
    'contactEmail': contactEmail,
    'isActive': isActive,
    'totalCoaches': totalCoaches,
    'totalPupils': totalPupils,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory ClubModel.fromJson(Map<String, dynamic> json) => ClubModel(
    id: json['id'] as String? ?? '', // Assuming id is the document ID
    name: json['name'] as String,
    location: json['location'] as String,
    description: json['description'] as String,
    contactEmail: json['contactEmail'] as String,
    isActive: json['isActive'] as bool,
    totalCoaches: json['totalCoaches'] as int,
    totalPupils: json['totalPupils'] as int,
    createdAt: DateTime.parse(json['createdAt'].toString()),
    updatedAt: DateTime.parse(json['updatedAt'].toString()),
  );

  /* ---------- from Firestore ---------- */

  factory ClubModel.fromFirestore(String id, Map<String, dynamic> data) =>
      ClubModel(
        id: id,
        name: data['name'] as String,
        location: data['location'] as String,
        description: data['description'] as String,
        contactEmail: data['contactEmail'] as String,
        isActive: data['isActive'] as bool,
        totalCoaches: data['totalCoaches'] as int,
        totalPupils: data['totalPupils'] as int,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      );
}
