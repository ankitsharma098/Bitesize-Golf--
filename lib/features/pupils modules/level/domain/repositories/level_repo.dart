import 'package:dartz/dartz.dart';
import '../../../../../failure.dart';
import '../../data/model/level_progress.dart';
import '../../domain/entities/level_entity.dart';

abstract class LevelRepository {
  Future<Either<Failure, List<Level>>> getAllLevels();
  Future<Either<Failure, Level>> getLevelById(String id);
  Future<Either<Failure, List<Level>>> getLevelsByPlan(String plan);
}
