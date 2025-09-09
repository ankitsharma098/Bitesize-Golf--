import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bitesize_golf/failure.dart';
import '../entities/coach_entity.dart';
import '../repositories/coach_repository.dart';

@injectable
class UpdateCoachUseCase {
  final CoachRepository repository;

  UpdateCoachUseCase(this.repository);

  Future<Either<Failure, void>> call(Coach coach) async {
    // Validation
    if (coach.id.isEmpty) {
      return Left(AuthFailure(message: 'Coach ID cannot be empty'));
    }

    if (coach.name.isEmpty) {
      return Left(AuthFailure(message: 'Coach name cannot be empty'));
    }

    if (coach.experience < 0) {
      return Left(AuthFailure(message: 'Experience cannot be negative'));
    }

    if (coach.maxPupils < 0) {
      return Left(
        AuthFailure(message: 'Max pupils modules cannot be negative'),
      );
    }

    if (coach.currentPupils < 0) {
      return Left(
        AuthFailure(message: 'Current pupils modules cannot be negative'),
      );
    }

    if (coach.currentPupils > coach.maxPupils) {
      return Left(
        AuthFailure(
          message: 'Current pupils modules cannot exceed max pupils modules',
        ),
      );
    }

    return await repository.updateCoach(coach);
  }
}
