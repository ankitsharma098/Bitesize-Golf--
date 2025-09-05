import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/coach_entity.dart';
import '../../domain/repositories/coach_repository.dart';
import 'package:bitesize_golf/features/auth/domain/failure.dart';
import '../datasources/coach_remote_datasource.dart';
import '../models/coach_model.dart';

@LazySingleton(as: CoachRepository)
class CoachRepositoryImpl implements CoachRepository {
  final CoachRemoteDataSource remoteDataSource;

  CoachRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> createCoach(Coach coach) async {
    try {
      final model = CoachModel.fromEntity(coach);
      await remoteDataSource.createCoach(model);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Coach?>> getCoach(String coachId) async {
    try {
      final model = await remoteDataSource.getCoach(coachId);
      return Right(model?.toEntity());
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, Coach?>> watchCoach(String coachId) async* {
    try {
      yield* remoteDataSource
          .watchCoach(coachId)
          .map((model) => Right(model?.toEntity()));
    } catch (e) {
      yield Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCoach(Coach coach) async {
    try {
      final model = CoachModel.fromEntity(coach);
      await remoteDataSource.updateCoach(model);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Coach>>> getCoachesByClub(String? clubId) async {
    try {
      final models = await remoteDataSource.getCoachesByClub(clubId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
}
