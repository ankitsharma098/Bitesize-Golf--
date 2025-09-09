import 'package:dartz/dartz.dart';

import '../../../../failure.dart';
import '../entities/golf_club_entity.dart';

abstract class ClubRepository {
  Future<Either<Failure, List<Club>>> getActiveClubs();
  Stream<Either<Failure, List<Club>>> watchActiveClubs();
}
