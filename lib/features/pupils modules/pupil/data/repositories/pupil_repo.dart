import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../entities/level_entity.dart';
import '../models/level_progress.dart';
import '../models/pupil_model.dart';

@LazySingleton()
class PupilRepository {
  final FirebaseFirestore _firestore;

  PupilRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _pupils =>
      _firestore.collection('pupils');

  // Get pupil by ID
  Future<PupilModel?> getPupil(String pupilId) async {
    try {
      final pupilDoc = await _pupils.doc(pupilId).get();
      if (!pupilDoc.exists) {
        return null;
      }
      return PupilModel.fromJson(pupilDoc.data()!);
    } catch (e) {
      print('Error getting pupil: $e');
      rethrow;
    }
  }

  // Create new pupil
  Future<void> createPupil(PupilModel pupil) async {
    try {
      await _pupils.doc(pupil.id).set(pupil.toJson());
    } catch (e) {
      print('Error creating pupil: $e');
      rethrow;
    }
  }

  // Update pupil progress
  Future<void> updatePupilProgress({
    required String pupilId,
    required int levelNumber,
    required LevelProgress progress,
    required LevelRequirements requirements,
    required int nextLevelNumber,
    required int subscriptionCap,
  }) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final pupilRef = _pupils.doc(pupilId);
        final pupilDoc = await transaction.get(pupilRef);

        if (!pupilDoc.exists) {
          throw Exception('Pupil not found');
        }

        final pupil = PupilModel.fromJson(pupilDoc.data()!);

        // Check if level requirements are met
        final isLevelCompleted =
            progress.booksCompleted >= requirements.requiredBooks &&
            progress.quizzesCompleted >= requirements.requiredQuizzes &&
            progress.challengesDone >= requirements.requiredChallenges &&
            progress.averageScore >= requirements.passingScore;

        // Update progress
        final updatedLevelProgress = Map<int, LevelProgress>.from(
          pupil.levelProgress,
        );
        updatedLevelProgress[levelNumber] = progress.copyWith(
          isCompleted: isLevelCompleted,
        );

        // Update unlocked levels if completed and next level is within subscription cap
        final updatedUnlockedLevels = List<int>.from(pupil.unlockedLevels);
        if (isLevelCompleted &&
            nextLevelNumber <= subscriptionCap &&
            !updatedUnlockedLevels.contains(nextLevelNumber)) {
          updatedUnlockedLevels.add(nextLevelNumber);
        }

        // Calculate updated activity counts
        final currentLevelProgress = pupil.levelProgress[levelNumber];
        final totalLessonsCompleted =
            pupil.totalLessonsCompleted +
            (progress.booksCompleted -
                (currentLevelProgress?.booksCompleted ?? 0));
        final totalQuizzesCompleted =
            pupil.totalQuizzesCompleted +
            (progress.quizzesCompleted -
                (currentLevelProgress?.quizzesCompleted ?? 0));
        final totalChallengesCompleted =
            pupil.totalChallengesCompleted +
            (progress.challengesDone -
                (currentLevelProgress?.challengesDone ?? 0));

        // Calculate average quiz score
        double averageQuizScore = pupil.averageQuizScore;
        if (totalQuizzesCompleted > 0) {
          final totalScore =
              (pupil.averageQuizScore * pupil.totalQuizzesCompleted) +
              progress.averageScore;
          averageQuizScore = (totalScore / totalQuizzesCompleted).clamp(
            0.0,
            100.0,
          );
        }

        // Update pupil
        final updatedPupil = pupil.copyWith(
          levelProgress: updatedLevelProgress,
          unlockedLevels: updatedUnlockedLevels,
          currentLevel: isLevelCompleted && nextLevelNumber <= subscriptionCap
              ? nextLevelNumber
              : pupil.currentLevel,
          totalLessonsCompleted: totalLessonsCompleted,
          totalQuizzesCompleted: totalQuizzesCompleted,
          totalChallengesCompleted: totalChallengesCompleted,
          averageQuizScore: averageQuizScore,
          lastActivityDate: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        transaction.set(pupilRef, updatedPupil.toJson());
      });
    } catch (e) {
      print('Error updating pupil progress: $e');
      rethrow;
    }
  }

  // Update pupil profile
  Future<void> updatePupilProfile({
    required String pupilId,
    required String name,
    DateTime? dateOfBirth,
    String? handicap,
    String? selectedCoachId,
    String? selectedCoachName,
    String? selectedClubId,
    String? selectedClubName,
    String? avatar,
  }) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final pupilRef = _pupils.doc(pupilId);
        final pupilDoc = await transaction.get(pupilRef);

        if (!pupilDoc.exists) {
          throw Exception('Pupil not found');
        }

        final pupil = PupilModel.fromJson(pupilDoc.data()!);
        final updatedPupil = pupil.copyWith(
          name: name,
          dateOfBirth: dateOfBirth,
          handicap: handicap,
          selectedCoachId: selectedCoachId,
          selectedCoachName: selectedCoachName,
          selectedClubId: selectedClubId,
          selectedClubName: selectedClubName,
          avatar: avatar,
          assignmentStatus: selectedCoachId != null ? 'pending' : 'none',
          updatedAt: DateTime.now(),
          lastActivityDate: DateTime.now(),
        );

        transaction.set(pupilRef, updatedPupil.toJson());
      });
    } catch (e) {
      print('Error updating pupil profile: $e');
      rethrow;
    }
  }

  // Get pupils by user ID (parent)
  Future<List<PupilModel>> getPupilsByUserId(String userId) async {
    try {
      final querySnapshot = await _pupils
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => PupilModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting pupils by user ID: $e');
      rethrow;
    }
  }

  // Delete pupil
  Future<void> deletePupil(String pupilId) async {
    try {
      await _pupils.doc(pupilId).delete();
    } catch (e) {
      print('Error deleting pupil: $e');
      rethrow;
    }
  }

  // Update pupil subscription
  Future<void> updatePupilSubscription({
    required String pupilId,
    required dynamic subscription,
  }) async {
    try {
      await _pupils.doc(pupilId).update({
        'subscription': subscription?.toJson(),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error updating pupil subscription: $e');
      rethrow;
    }
  }

  // Assign coach to pupil
  Future<void> assignCoachToPupil({
    required String pupilId,
    required String coachId,
    required String coachName,
  }) async {
    try {
      await _pupils.doc(pupilId).update({
        'assignedCoachId': coachId,
        'assignedCoachName': coachName,
        'coachAssignedAt': Timestamp.fromDate(DateTime.now()),
        'assignmentStatus': 'assigned',
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error assigning coach to pupil: $e');
      rethrow;
    }
  }

  // Remove coach from pupil
  Future<void> removeCoachFromPupil(String pupilId) async {
    try {
      await _pupils.doc(pupilId).update({
        'assignedCoachId': null,
        'assignedCoachName': null,
        'coachAssignedAt': null,
        'assignmentStatus': 'none',
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error removing coach from pupil: $e');
      rethrow;
    }
  }

  // Update pupil badges
  Future<void> updatePupilBadges({
    required String pupilId,
    required List<String> badges,
  }) async {
    try {
      await _pupils.doc(pupilId).update({
        'badges': badges,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error updating pupil badges: $e');
      rethrow;
    }
  }

  // Get pupils by coach ID
  Future<List<PupilModel>> getPupilsByCoachId(String coachId) async {
    try {
      final querySnapshot = await _pupils
          .where('assignedCoachId', isEqualTo: coachId)
          .get();

      return querySnapshot.docs
          .map((doc) => PupilModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting pupils by coach ID: $e');
      rethrow;
    }
  }
}
