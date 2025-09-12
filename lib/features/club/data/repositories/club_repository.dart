// features/club/data/repositories/club_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../entities/golf_club_entity.dart';

@LazySingleton()
class ClubRepository {
  final FirebaseFirestore firestore;

  ClubRepository(this.firestore);

  // Collections
  CollectionReference get _clubs => firestore.collection('clubs');

  // Get all active clubs
  Future<List<Club>> getAllClubs() async {
    try {
      final snapshot = await _clubs
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();

      final clubs = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
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

      print('ClubRepository: Found ${clubs.length} active clubs');
      return clubs;
    } catch (e) {
      print('Error fetching clubs: $e');
      throw Exception('Failed to fetch clubs: $e');
    }
  }

  // Get active clubs (alias for getAllClubs for backward compatibility)
  Future<List<Club>> getActiveClubs() async {
    return getAllClubs();
  }

  // Watch active clubs (real-time updates)
  Stream<List<Club>> watchActiveClubs() {
    try {
      return _clubs
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
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
          });
    } catch (e) {
      print('Error watching clubs: $e');
      throw Exception('Failed to watch clubs: $e');
    }
  }

  // Get single club by ID
  Future<Club?> getClub(String clubId) async {
    try {
      final doc = await _clubs.doc(clubId).get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      final data = doc.data() as Map<String, dynamic>;
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
    } catch (e) {
      print('Error getting club: $e');
      throw Exception('Failed to get club: $e');
    }
  }

  // Create new club
  Future<Club> createClub({
    required String name,
    required String location,
    String description = '',
    String contactEmail = '',
    bool isActive = true,
  }) async {
    try {
      final now = DateTime.now();
      final clubData = {
        'name': name,
        'location': location,
        'description': description,
        'contactEmail': contactEmail,
        'isActive': isActive,
        'totalCoaches': 0,
        'totalPupils': 0,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      };

      final docRef = await _clubs.add(clubData);

      return Club(
        id: docRef.id,
        name: name,
        location: location,
        description: description,
        contactEmail: contactEmail,
        isActive: isActive,
        totalCoaches: 0,
        totalPupils: 0,
        createdAt: now,
        updatedAt: now,
      );
    } catch (e) {
      print('Error creating club: $e');
      throw Exception('Failed to create club: $e');
    }
  }

  // Update club
  Future<void> updateClub({
    required String clubId,
    String? name,
    String? location,
    String? description,
    String? contactEmail,
    bool? isActive,
    int? totalCoaches,
    int? totalPupils,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (name != null) updateData['name'] = name;
      if (location != null) updateData['location'] = location;
      if (description != null) updateData['description'] = description;
      if (contactEmail != null) updateData['contactEmail'] = contactEmail;
      if (isActive != null) updateData['isActive'] = isActive;
      if (totalCoaches != null) updateData['totalCoaches'] = totalCoaches;
      if (totalPupils != null) updateData['totalPupils'] = totalPupils;

      await _clubs.doc(clubId).update(updateData);
    } catch (e) {
      print('Error updating club: $e');
      throw Exception('Failed to update club: $e');
    }
  }

  // Delete club (soft delete by setting isActive to false)
  Future<void> deleteClub(String clubId) async {
    try {
      await _clubs.doc(clubId).update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error deleting club: $e');
      throw Exception('Failed to delete club: $e');
    }
  }

  // Hard delete club (permanent deletion)
  Future<void> permanentlyDeleteClub(String clubId) async {
    try {
      await _clubs.doc(clubId).delete();
    } catch (e) {
      print('Error permanently deleting club: $e');
      throw Exception('Failed to permanently delete club: $e');
    }
  }

  // Search clubs by name or location
  Future<List<Club>> searchClubs(String searchTerm) async {
    try {
      final searchTermLower = searchTerm.toLowerCase();
      final snapshot = await _clubs.where('isActive', isEqualTo: true).get();

      final clubs = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
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
          })
          .where((club) {
            final nameMatch = club.name.toLowerCase().contains(searchTermLower);
            final locationMatch = club.location.toLowerCase().contains(
              searchTermLower,
            );
            return nameMatch || locationMatch;
          })
          .toList();

      return clubs;
    } catch (e) {
      print('Error searching clubs: $e');
      throw Exception('Failed to search clubs: $e');
    }
  }

  // Get clubs by location
  Future<List<Club>> getClubsByLocation(String location) async {
    try {
      final snapshot = await _clubs
          .where('isActive', isEqualTo: true)
          .where('location', isEqualTo: location)
          .orderBy('name')
          .get();

      final clubs = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
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

      return clubs;
    } catch (e) {
      print('Error getting clubs by location: $e');
      throw Exception('Failed to get clubs by location: $e');
    }
  }

  // Update club statistics
  Future<void> updateClubStats({
    required String clubId,
    int? totalCoaches,
    int? totalPupils,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (totalCoaches != null) updateData['totalCoaches'] = totalCoaches;
      if (totalPupils != null) updateData['totalPupils'] = totalPupils;

      await _clubs.doc(clubId).update(updateData);
    } catch (e) {
      print('Error updating club stats: $e');
      throw Exception('Failed to update club stats: $e');
    }
  }

  // Increment coach count
  Future<void> incrementCoachCount(String clubId) async {
    try {
      await _clubs.doc(clubId).update({
        'totalCoaches': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error incrementing coach count: $e');
      throw Exception('Failed to increment coach count: $e');
    }
  }

  // Decrement coach count
  Future<void> decrementCoachCount(String clubId) async {
    try {
      await _clubs.doc(clubId).update({
        'totalCoaches': FieldValue.increment(-1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error decrementing coach count: $e');
      throw Exception('Failed to decrement coach count: $e');
    }
  }

  // Increment pupil count
  Future<void> incrementPupilCount(String clubId) async {
    try {
      await _clubs.doc(clubId).update({
        'totalPupils': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error incrementing pupil count: $e');
      throw Exception('Failed to increment pupil count: $e');
    }
  }

  // Decrement pupil count
  Future<void> decrementPupilCount(String clubId) async {
    try {
      await _clubs.doc(clubId).update({
        'totalPupils': FieldValue.increment(-1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error decrementing pupil count: $e');
      throw Exception('Failed to decrement pupil count: $e');
    }
  }

  // Get all clubs (including inactive ones) - admin function
  Future<List<Club>> getAllClubsIncludingInactive() async {
    try {
      final snapshot = await _clubs.orderBy('name').get();

      final clubs = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
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

      return clubs;
    } catch (e) {
      print('Error getting all clubs: $e');
      throw Exception('Failed to get all clubs: $e');
    }
  }
}
