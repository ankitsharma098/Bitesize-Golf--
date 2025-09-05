import 'package:equatable/equatable.dart';

class GolfClub extends Equatable {
  final String id;
  final String name;
  final String location;
  final bool isActive;

  const GolfClub({
    required this.id,
    required this.name,
    required this.location,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, name, location, isActive];
}
