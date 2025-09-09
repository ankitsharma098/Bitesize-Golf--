import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bitesize_golf/failure.dart';
import '../entities/coach_entity.dart';
import '../repositories/coach_repository.dart';

@injectable
class GetCoachesByClubUseCase {
  final CoachRepository repository;

  GetCoachesByClubUseCase(this.repository);

  Future<Either<Failure, List<Coach>>> call(String clubId) async {
    if (clubId.isEmpty) {
      return Left(AuthFailure(message: 'Club ID cannot be empty'));
    }

    return await repository.getCoachesByClub(clubId);
  }
}
