import 'package:dartz/dartz.dart';
import '../entities/coach.dart';
import 'package:bitesize_golf/features/auth/domain/failure.dart';

abstract class CoachRepository {
  Future<Either<Failure, void>> createCoach(Coach coach);
  Future<Either<Failure, Coach?>> getCoach(String coachId);
  Stream<Either<Failure, Coach?>> watchCoach(String coachId);
  Future<Either<Failure, void>> updateCoach(Coach coach);
  Future<Either<Failure, List<Coach>>> getCoachesByClub(String? clubId);
}
