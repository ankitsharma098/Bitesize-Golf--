import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../failure.dart';
import '../../../pupil/data/models/pupil_model.dart';
import '../../domain/entities/level_entity.dart';
import '../../domain/repositories/level_repo.dart';
import '../datasource/level_firestore_data_sources.dart';
import '../model/level_progress.dart';

@LazySingleton(as: LevelRepository)
class LevelRepositoryImpl implements LevelRepository {
  final LevelFirebaseDataSource _remote;
  final FirebaseFirestore _firestore;

  LevelRepositoryImpl(this._remote, this._firestore);

  CollectionReference<Map<String, dynamic>> get _pupils =>
      _firestore.collection('pupils');

  @override
  Future<Either<Failure, List<Level>>> getAllLevels() async {
    try {
      final models = await _remote.getAllLevels();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Level>> getLevelById(String id) async {
    try {
      final model = await _remote.getLevelById(id);
      return model == null
          ? Left(ServerFailure(message: 'Level not found'))
          : Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Level>>> getLevelsByPlan(String plan) async {
    try {
      final models = await _remote.getLevelsByPlan(plan);
      return Right(models.map((m) => m.toEntity()).toList());
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

        // Update pupil
        final updatedPupil = pupil.copyWith(
          levelProgress: updatedLevelProgress,
          unlockedLevels: updatedUnlockedLevels,
          currentLevel: isLevelCompleted && nextLevelNumber <= subscriptionCap
              ? nextLevelNumber
              : pupil.currentLevel,
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
}
