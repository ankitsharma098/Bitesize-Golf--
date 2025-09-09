import 'package:dartz/dartz.dart';
import 'package:bitesize_golf/failure.dart';

import '../entities/coach_entity.dart';

abstract class CoachRepository {
  Future<Either<Failure, Coach?>> getCoach(String coachId);
  Stream<Either<Failure, Coach?>> watchCoach(String coachId);
  Future<Either<Failure, void>> updateCoach(Coach coach);
  Future<Either<Failure, List<Coach>>> getCoachesByClub(String clubId);
  Future<Either<Failure, List<Coach>>> getAllCoaches();
}
