import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/pupil.dart';
import '../../domain/repositories/pupil_repository.dart';
import 'package:bitesize_golf/features/auth/domain/failure.dart';
import '../datasources/pupil_remote_datasource.dart';
import '../models/pupil_model.dart';

@LazySingleton(as: PupilRepository)
class PupilRepositoryImpl implements PupilRepository {
  final PupilRemoteDataSource remoteDataSource;

  PupilRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> createPupil(Pupil pupil) async {
    try {
      final model = PupilModel.fromEntity(pupil);
      await remoteDataSource.createPupil(model);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Pupil?>> getPupil(String pupilId) async {
    try {
      final model = await remoteDataSource.getPupil(pupilId);
      return Right(model?.toEntity());
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, Pupil?>> watchPupil(String pupilId) async* {
    try {
      yield* remoteDataSource
          .watchPupil(pupilId)
          .map((model) => Right(model?.toEntity()));
    } catch (e) {
      yield Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePupil(Pupil pupil) async {
    try {
      final model = PupilModel.fromEntity(pupil);
      await remoteDataSource.updatePupil(model);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Pupil>>> getPupilsByParent(
    String parentId,
  ) async {
    try {
      final models = await remoteDataSource.getPupilsByParent(parentId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
}
