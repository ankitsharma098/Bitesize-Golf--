// lib/features/clubs/data/repositories/club_repository_impl.dart

import 'package:bitesize_golf/failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/golf_club_entity.dart';
import '../../domain/repositories/golf_club_repository.dart';

@LazySingleton(as: ClubRepository)
class ClubRepositoryImpl implements ClubRepository {
  final FirebaseFirestore firestore;

  ClubRepositoryImpl(this.firestore);

  @override
  Future<Either<Failure, List<Club>>> getActiveClubs() async {
    try {
      final snapshot = await firestore
          .collection('clubs')
          .where('isActive', isEqualTo: true)
          .get();

      List<Club> clubs = snapshot.docs.map((doc) {
        final data = doc.data();
        return Club(
          id: doc.id,
          name: data['name'] ?? '',
          location: data['location'] ?? '',
          description: data['description'] ?? '',
          contactEmail: data['contactEmail'] ?? '',
          isActive: data['isActive'] ?? true,
          totalCoaches: data['totalCoaches'] ?? 0, // Changed from string to int
          totalPupils: data['totalPupils'] ?? 0, // Changed from string to int
          createdAt: data['createdAt'] != null
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.now(), // Fixed DateTime conversion
          updatedAt: data['updatedAt'] != null
              ? (data['updatedAt'] as Timestamp).toDate()
              : DateTime.now(), // Fixed DateTime conversion
        );
      }).toList();

      print('ClubRepositoryImpl: Found ${clubs.length} active clubs');
      return Right(clubs);
    } catch (e) {
      print('ClubRepositoryImpl: Error fetching clubs: $e');
      return Left(
        AuthFailure(message: 'Failed to fetch clubs: ${e.toString()}'),
      );
    }
  }

  @override
  Stream<Either<Failure, List<Club>>> watchActiveClubs() {
    return firestore
        .collection('clubs')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          try {
            List<Club> clubs = snapshot.docs.map((doc) {
              final data = doc.data();
              return Club(
                id: doc.id,
                name: data['name'] ?? '',
                location: data['location'] ?? '',
                description: data['description'] ?? '',
                contactEmail: data['contactEmail'] ?? '',
                isActive: data['isActive'] ?? true,
                totalCoaches: data['totalCoaches'] ?? 0,
                totalPupils: data['totalPupils'] ?? 0,
                createdAt: data['createdAt'] != null
                    ? (data['createdAt'] as Timestamp).toDate()
                    : DateTime.now(),
                updatedAt: data['updatedAt'] != null
                    ? (data['updatedAt'] as Timestamp).toDate()
                    : DateTime.now(),
              );
            }).toList();

            return Right<Failure, List<Club>>(clubs);
          } catch (e) {
            return Left<Failure, List<Club>>(
              AuthFailure(message: 'Failed to watch clubs: ${e.toString()}'),
            );
          }
        });
  }
}
