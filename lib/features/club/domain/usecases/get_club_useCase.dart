import 'package:bitesize_golf/features/club/domain/entities/golf_club_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../failure.dart';
import '../repositories/golf_club_repository.dart';

@injectable
class GetClubsUseCase {
  final ClubRepository repository;

  GetClubsUseCase(this.repository);

  Future<Either<Failure, List<Club>>> call() async {
    return repository.getActiveClubs();
  }
}
