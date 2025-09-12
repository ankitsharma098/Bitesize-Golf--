// features/auth/domain/entities/club.dart
import 'package:equatable/equatable.dart';

class Club extends Equatable {
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

  const Club({
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

  @override
  List<Object?> get props => [
    id,
    name,
    location,
    description,
    contactEmail,
    isActive,
    totalCoaches,
    totalPupils,
    createdAt,
    updatedAt,
  ];

  Club copyWith({
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
  }) {
    return Club(
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
  }
}
