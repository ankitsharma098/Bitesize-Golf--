import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bitesize_golf/failure.dart';
import '../entities/coach_entity.dart';
import '../repositories/coach_repository.dart';

@injectable
class GetCoachUseCase {
  final CoachRepository repository;

  GetCoachUseCase(this.repository);

  Future<Either<Failure, Coach?>> call(String coachId) async {
    if (coachId.isEmpty) {
      return Left(AuthFailure(message: 'Coach ID cannot be empty'));
    }

    return await repository.getCoach(coachId);
  }
}
