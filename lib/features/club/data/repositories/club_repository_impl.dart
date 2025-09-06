import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bitesize_golf/features/auth/domain/failure.dart';
import '../../domain/entities/golf_club_entity.dart';
import '../../domain/repositories/golf_club_repository.dart';
import '../datasources/club_remote_datasource.dart';

@LazySingleton(as: ClubRepository)
class ClubRepositoryImpl implements ClubRepository {
  final ClubRemoteDataSource remoteDataSource;

  ClubRepositoryImpl(this.remoteDataSource);

  @override
  Stream<Either<Failure, List<GolfClub>>> watchActiveClubs() async* {
    try {
      yield* remoteDataSource.watchActiveClubs().map(
        (models) => Right(models.map((m) => m.toEntity()).toList()),
      );
    } catch (e) {
      yield Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GolfClub>>> getActiveClubs() async {
    try {
      final models = await remoteDataSource.getActiveClubs();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
}
