import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../failure.dart';
import '../../../level/data/model/level_progress.dart';
import '../../../level/domain/entities/level_entity.dart';
import '../repositories/pupil_repo.dart';

@injectable
class UpdatePupilProgressUseCase {
  final PupilRepository _repository;

  UpdatePupilProgressUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String pupilId,
    required int levelNumber,
    required LevelProgress progress,
    required LevelRequirements requirements,
    required int nextLevelNumber,
    required int subscriptionCap,
  }) async {
    return await _repository.updatePupilProgress(
      pupilId: pupilId,
      levelNumber: levelNumber,
      progress: progress,
      requirements: requirements,
      nextLevelNumber: nextLevelNumber,
      subscriptionCap: subscriptionCap,
    );
  }
}
