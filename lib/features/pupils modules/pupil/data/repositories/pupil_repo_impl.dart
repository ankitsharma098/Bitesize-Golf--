import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../../failure.dart';
import '../../../level/data/model/level_progress.dart';
import '../../../level/domain/entities/level_entity.dart';
import '../../domain/repositories/pupil_repo.dart';
import '../models/pupil_model.dart';

@LazySingleton(as: PupilRepository)
class PupilRepositoryImpl implements PupilRepository {
  final FirebaseFirestore _firestore;

  PupilRepositoryImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> get _pupils =>
      _firestore.collection('pupils');

  @override
  Future<Either<Failure, PupilModel>> getPupil(String pupilId) async {
    try {
      final pupilDoc = await _pupils.doc(pupilId).get();
      if (!pupilDoc.exists) {
        return Left(ServerFailure(message: 'Pupil data not found'));
      }
      return Right(PupilModel.fromJson(pupilDoc.data()!));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePupilProgress({
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
        final totalLessonsCompleted =
            pupil.totalLessonsCompleted +
            (progress.booksCompleted -
                (pupil.levelProgress[levelNumber]?.booksCompleted ?? 0));
        final totalQuizzesCompleted =
            pupil.totalQuizzesCompleted +
            (progress.quizzesCompleted -
                (pupil.levelProgress[levelNumber]?.quizzesCompleted ?? 0));
        final totalChallengesCompleted =
            pupil.totalChallengesCompleted +
            (progress.challengesDone -
                (pupil.levelProgress[levelNumber]?.challengesDone ?? 0));
        final totalActivities =
            totalLessonsCompleted +
            totalQuizzesCompleted +
            totalChallengesCompleted;
        final averageQuizScore = totalActivities > 0
            ? ((pupil.averageQuizScore * pupil.totalQuizzesCompleted +
                          progress.averageScore) /
                      (pupil.totalQuizzesCompleted + 1))
                  .clamp(0.0, 100.0)
            : pupil.averageQuizScore;

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

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePupilProfile({
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

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
