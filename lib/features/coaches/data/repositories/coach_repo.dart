import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../entities/coach_entity.dart';
import '../models/coach_model.dart';

@LazySingleton()
class CoachRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Collections
  CollectionReference get _coaches => _firestore.collection('coaches');

  // Get single coach
  Future<Coach?> getCoach(String coachId) async {
    try {
      final doc = await _coaches.doc(coachId).get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      final model = CoachModel.fromFirestore(
        doc.data() as Map<String, dynamic>,
      );
      return model.toEntity();
    } catch (e) {
      print('Error getting coach: $e');
      throw Exception('Failed to get coach: $e');
    }
  }

  // Watch single coach (real-time updates)
  Stream<Coach?> watchCoach(String coachId) {
    try {
      return _coaches.doc(coachId).snapshots().map((doc) {
        if (!doc.exists || doc.data() == null) {
          return null;
        }
        final model = CoachModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
        );
        return model.toEntity();
      });
    } catch (e) {
      print('Error watching coach: $e');
      throw Exception('Failed to watch coach: $e');
    }
  }

  // Create new coach
  Future<Coach> createCoach({
    required String userId,
    required String name,
    String bio = '',
    List<String> qualifications = const [],
    int experience = 0,
    List<String> specialties = const [],
  }) async {
    try {
      final coachModel =
          CoachModel.create(
            id: userId, // Using userId as coach document ID
            userId: userId,
            name: name,
          ).copyWith(
            bio: bio,
            qualifications: qualifications,
            experience: experience,
            specialties: specialties,
          );

      await _coaches.doc(userId).set(coachModel.toJson());
      return coachModel.toEntity();
    } catch (e) {
      print('Error creating coach: $e');
      throw Exception('Failed to create coach: $e');
    }
  }

  // Update coach
  Future<void> updateCoach(Coach coach) async {
    try {
      final model = CoachModel.fromEntity(coach);
      final updatedModel = model.copyWith(updatedAt: DateTime.now());

      await _coaches.doc(coach.id).update(updatedModel.toJson());
    } catch (e) {
      print('Error updating coach: $e');
      throw Exception('Failed to update coach: $e');
    }
  }

  // Delete coach
  Future<void> deleteCoach(String coachId) async {
    try {
      await _coaches.doc(coachId).delete();
    } catch (e) {
      print('Error deleting coach: $e');
      throw Exception('Failed to delete coach: $e');
    }
  }

  // Get coaches by club
  // In your CoachRepository class
  Future<List<Coach>> getCoachesByClub(String clubId) async {
    try {
      print("Club Id -- ${clubId}");
      final snapshot = await _coaches
          .where('assignedClubId', isEqualTo: clubId)
          .where('verificationStatus', isEqualTo: 'verified')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Ensure the document ID is included
        data['id'] = doc.id; // This is crucial!
        return CoachModel.fromFirestore(data).toEntity();
      }).toList();
    } catch (e) {
      throw Exception('Failed to get coaches by club: $e');
    }
  }

  // Get all coaches
  Future<List<Coach>> getAllCoaches() async {
    try {
      final querySnapshot = await _coaches
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map(
            (doc) =>
                CoachModel.fromFirestore(doc.data() as Map<String, dynamic>),
          )
          .map((model) => model.toEntity())
          .toList();
    } catch (e) {
      print('Error getting all coaches: $e');
      throw Exception('Failed to get all coaches: $e');
    }
  }

  // Get verified coaches only
  Future<List<Coach>> getVerifiedCoaches() async {
    try {
      final querySnapshot = await _coaches
          .where('verificationStatus', isEqualTo: 'verified')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map(
            (doc) =>
                CoachModel.fromFirestore(doc.data() as Map<String, dynamic>),
          )
          .map((model) => model.toEntity())
          .toList();
    } catch (e) {
      print('Error getting verified coaches: $e');
      throw Exception('Failed to get verified coaches: $e');
    }
  }

  // Get coaches accepting new pupils
  Future<List<Coach>> getAvailableCoaches() async {
    try {
      final querySnapshot = await _coaches
          .where('verificationStatus', isEqualTo: 'verified')
          .where('acceptingNewPupils', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      // Filter coaches who haven't reached their max capacity
      final coaches = querySnapshot.docs
          .map(
            (doc) =>
                CoachModel.fromFirestore(doc.data() as Map<String, dynamic>),
          )
          .map((model) => model.toEntity())
          .where((coach) => coach.currentPupils < coach.maxPupils)
          .toList();

      return coaches;
    } catch (e) {
      print('Error getting available coaches: $e');
      throw Exception('Failed to get available coaches: $e');
    }
  }

  // Search coaches by name or specialties
  Future<List<Coach>> searchCoaches(String searchTerm) async {
    try {
      final querySnapshot = await _coaches
          .where('verificationStatus', isEqualTo: 'verified')
          .get();

      final searchTermLower = searchTerm.toLowerCase();

      final coaches = querySnapshot.docs
          .map(
            (doc) =>
                CoachModel.fromFirestore(doc.data() as Map<String, dynamic>),
          )
          .map((model) => model.toEntity())
          .where((coach) {
            final nameMatch = coach?.name.toLowerCase().contains(
              searchTermLower,
            );
            final specialtyMatch = coach.specialties.any(
              (specialty) => specialty.toLowerCase().contains(searchTermLower),
            );
            return nameMatch! || specialtyMatch;
          })
          .toList();

      return coaches;
    } catch (e) {
      print('Error searching coaches: $e');
      throw Exception('Failed to search coaches: $e');
    }
  }

  // Update coach verification status (admin function)
  Future<void> updateCoachVerification({
    required String coachId,
    required String verificationStatus,
    required String verifiedBy,
    String? verificationNote,
  }) async {
    try {
      await _coaches.doc(coachId).update({
        'verificationStatus': verificationStatus,
        'verifiedBy': verifiedBy,
        'verifiedAt': FieldValue.serverTimestamp(),
        'verificationNote': verificationNote,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating coach verification: $e');
      throw Exception('Failed to update coach verification: $e');
    }
  }

  // Assign coach to club
  Future<void> assignCoachToClub({
    required String coachId,
    required String clubId,
    required String clubName,
  }) async {
    try {
      await _coaches.doc(coachId).update({
        'assignedClubId': clubId,
        'assignedClubName': clubName,
        'clubAssignedAt': FieldValue.serverTimestamp(),
        'clubAssignmentStatus': 'assigned',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error assigning coach to club: $e');
      throw Exception('Failed to assign coach to club: $e');
    }
  }

  // Update coach pupil count
  Future<void> updateCoachPupilCount({
    required String coachId,
    required int newCount,
  }) async {
    try {
      await _coaches.doc(coachId).update({
        'currentPupils': newCount,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating coach pupil count: $e');
      throw Exception('Failed to update coach pupil count: $e');
    }
  }

  // Update coach stats
  Future<void> updateCoachStats({
    required String coachId,
    required Map<String, dynamic> stats,
  }) async {
    try {
      await _coaches.doc(coachId).update({
        'stats': stats,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating coach stats: $e');
      throw Exception('Failed to update coach stats: $e');
    }
  }

  // Toggle accepting new pupils status
  Future<void> toggleAcceptingPupils({
    required String coachId,
    required bool acceptingNewPupils,
  }) async {
    try {
      await _coaches.doc(coachId).update({
        'acceptingNewPupils': acceptingNewPupils,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error toggling accepting pupils: $e');
      throw Exception('Failed to toggle accepting pupils: $e');
    }
  }

  Future<List<Coach>> getPendingCoaches() async {
    try {
      final querySnapshot = await _coaches
          .where('verificationStatus', isEqualTo: 'pending')
          .orderBy('createdAt', descending: false)
          .get();

      return querySnapshot.docs
          .map(
            (doc) =>
                CoachModel.fromFirestore(doc.data() as Map<String, dynamic>),
          )
          .map((model) => model.toEntity())
          .toList();
    } catch (e) {
      print('Error getting pending coaches: $e');
      throw Exception('Failed to get pending coaches: $e');
    }
  }

  // Get coaches by specialty
  Future<List<Coach>> getCoachesBySpecialty(String specialty) async {
    try {
      final querySnapshot = await _coaches
          .where('verificationStatus', isEqualTo: 'verified')
          .where('specialties', arrayContains: specialty)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map(
            (doc) =>
                CoachModel.fromFirestore(doc.data() as Map<String, dynamic>),
          )
          .map((model) => model.toEntity())
          .toList();
    } catch (e) {
      print('Error getting coaches by specialty: $e');
      throw Exception('Failed to get coaches by specialty: $e');
    }
  }
}
