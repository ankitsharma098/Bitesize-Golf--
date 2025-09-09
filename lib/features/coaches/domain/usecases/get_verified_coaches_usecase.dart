import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bitesize_golf/failure.dart';
import '../entities/coach_entity.dart';
import '../repositories/coach_repository.dart';

@injectable
class GetVerifiedCoachesUseCase {
  final CoachRepository repository;

  GetVerifiedCoachesUseCase(this.repository);

  Future<Either<Failure, List<Coach>>> call() async {
    final result = await repository.getAllCoaches();

    return result.fold((failure) => Left(failure), (coaches) {
      final verifiedCoaches = coaches
          .where((coach) => coach.verificationStatus == 'verified')
          .toList();
      return Right(verifiedCoaches);
    });
  }
}
