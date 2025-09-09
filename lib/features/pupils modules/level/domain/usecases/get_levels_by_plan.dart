import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../failure.dart';
import '../entities/level_entity.dart';
import '../repositories/level_repo.dart';

@injectable
class GetLevelsByPlanUseCase {
  final LevelRepository _repo;

  GetLevelsByPlanUseCase(this._repo);

  Future<Either<Failure, List<Level>>> call(String plan) async =>
      await _repo.getLevelsByPlan(plan);
}
