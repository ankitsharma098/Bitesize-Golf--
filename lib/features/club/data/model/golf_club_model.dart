import 'package:cloud_firestore/cloud_firestore.dart';

class ClubModel {
  final String id;
  final String name;
  final String location;
  final String description;
  final String? website;
  final String contactEmail;
  final String approvalMode; // 'coach_only', 'admin_only', 'coach_or_admin'
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
    this.website,
    required this.contactEmail,
    this.approvalMode = 'coach_or_admin',
    this.isActive = true,
    this.totalCoaches = 0,
    this.totalPupils = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'description': description,
    'website': website,
    'contactEmail': contactEmail,
    'approvalMode': approvalMode,
    'isActive': isActive,
    'totalCoaches': totalCoaches,
    'totalPupils': totalPupils,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };

  factory ClubModel.fromJson(Map<String, dynamic> json) => ClubModel(
    id: json['id'],
    name: json['name'],
    location: json['location'],
    description: json['description'],
    website: json['website'],
    contactEmail: json['contactEmail'],
    approvalMode: json['approvalMode'] ?? 'coach_or_admin',
    isActive: json['isActive'] ?? true,
    totalCoaches: json['totalCoaches'] ?? 0,
    totalPupils: json['totalPupils'] ?? 0,
    createdAt: json['createdAt']?.toDate() ?? DateTime.now(),
    updatedAt: json['updatedAt']?.toDate() ?? DateTime.now(),
  );
}
