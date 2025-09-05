import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/golf_club_entity.dart';

class GolfClubModel {
  final String id;
  final String name;
  final String location;
  final bool isActive;

  const GolfClubModel({
    required this.id,
    required this.name,
    required this.location,
    this.isActive = true,
  });

  GolfClub toEntity() =>
      GolfClub(id: id, name: name, location: location, isActive: isActive);

  factory GolfClubModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GolfClubModel(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'location': location,
    'isActive': isActive,
  };
}
