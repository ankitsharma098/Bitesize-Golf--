import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bitesize_golf/failure.dart';
import '../entities/coach_entity.dart';
import '../repositories/coach_repository.dart';

@injectable
class GetAvailableCoachesUseCase {
  final CoachRepository repository;

  GetAvailableCoachesUseCase(this.repository);

  Future<Either<Failure, List<Coach>>> call() async {
    final result = await repository.getAllCoaches();

    return result.fold((failure) => Left(failure), (coaches) {
      final availableCoaches = coaches
          .where(
            (coach) =>
                coach.verificationStatus == 'verified' &&
                coach.acceptingNewPupils &&
                coach.currentPupils < coach.maxPupils,
          )
          .toList();
      return Right(availableCoaches);
    });
  }
}
