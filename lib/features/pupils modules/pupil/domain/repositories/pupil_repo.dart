import 'package:dartz/dartz.dart';
import '../../../../../failure.dart';
import '../../../level/data/model/level_progress.dart';
import '../../../level/domain/entities/level_entity.dart';
import '../../data/models/pupil_model.dart';

abstract class PupilRepository {
  Future<Either<Failure, PupilModel>> getPupil(String pupilId);
  Future<Either<Failure, void>> updatePupilProgress({
    required String pupilId,
    required int levelNumber,
    required LevelProgress progress,
    required LevelRequirements requirements,
    required int nextLevelNumber,
    required int subscriptionCap,
  });
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
  });
}
