import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bitesize_golf/failure.dart';
import '../entities/coach_entity.dart';
import '../repositories/coach_repository.dart';

@injectable
class WatchCoachUseCase {
  final CoachRepository repository;

  WatchCoachUseCase(this.repository);

  Stream<Either<Failure, Coach?>> call(String coachId) {
    if (coachId.isEmpty) {
      return Stream.value(
        Left(AuthFailure(message: 'Coach ID cannot be empty')),
      );
    }

    return repository.watchCoach(coachId);
  }
}
