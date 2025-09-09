import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../failure.dart';
import '../entities/level_entity.dart';
import '../repositories/level_repo.dart';

@injectable
class GetAllLevelsUseCase {
  final LevelRepository _repo;

  GetAllLevelsUseCase(this._repo);

  Future<Either<Failure, List<Level>>> call() async =>
      await _repo.getAllLevels();
}
