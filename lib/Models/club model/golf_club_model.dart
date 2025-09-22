import 'package:cloud_firestore/cloud_firestore.dart';

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

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'location': location,
    'description': description,
    'contactEmail': contactEmail,
    'isActive': isActive,
    'totalCoaches': totalCoaches,
    'totalPupils': totalPupils,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };

  factory ClubModel.fromFirestore(
    Map<String, dynamic> json, {
    required String id,
  }) => ClubModel(
    id: id,
    name: json['name'] ?? '',
    location: json['location'] ?? '',
    description: json['description'] ?? '',
    contactEmail: json['contactEmail'] ?? '',
    isActive: json['isActive'] ?? true,
    totalCoaches: json['totalCoaches'] ?? 0,
    totalPupils: json['totalPupils'] ?? 0,
    createdAt: _toDateTime(json['createdAt']),
    updatedAt: _toDateTime(json['updatedAt']),
  );

  ClubModel copyWith({
    String? id,
    String? name,
    String? location,
    String? description,
    String? contactEmail,
    bool? isActive,
    int? totalCoaches,
    int? totalPupils,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ClubModel(
    id: id ?? this.id,
    name: name ?? this.name,
    location: location ?? this.location,
    description: description ?? this.description,
    contactEmail: contactEmail ?? this.contactEmail,
    isActive: isActive ?? this.isActive,
    totalCoaches: totalCoaches ?? this.totalCoaches,
    totalPupils: totalPupils ?? this.totalPupils,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  static DateTime _toDateTime(dynamic v) {
    if (v is Timestamp) return v.toDate();
    return DateTime.now();
  }
}
