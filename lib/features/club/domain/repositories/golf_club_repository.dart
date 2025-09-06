import 'package:dartz/dartz.dart';

import '../../../auth/domain/failure.dart';
import '../entities/golf_club_entity.dart';

abstract class ClubRepository {
  Future<Either<Failure, List<GolfClub>>> getActiveClubs();
  Stream<Either<Failure, List<GolfClub>>> watchActiveClubs();
}
