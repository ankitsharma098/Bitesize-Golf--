import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../failure.dart';
import '../entities/level_entity.dart';
import '../repositories/level_repo.dart';

@injectable
class GetLevelByIdUseCase {
  final LevelRepository _repo;

  GetLevelByIdUseCase(this._repo);

  Future<Either<Failure, Level>> call(String id) async =>
      await _repo.getLevelById(id);
}
