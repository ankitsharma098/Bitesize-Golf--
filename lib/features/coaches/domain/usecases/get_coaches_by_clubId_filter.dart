import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bitesize_golf/failure.dart';
import '../entities/coach_entity.dart';
import '../repositories/coach_repository.dart';

@injectable
class GetCoachesByClubWithFiltersUseCase {
  final CoachRepository repository;

  GetCoachesByClubWithFiltersUseCase(this.repository);

  Future<Either<Failure, List<Coach>>> call({
    required String clubId,
    bool? verifiedOnly,
    bool? availableOnly,
    int? minExperience,
    List<String>? specialties,
  }) async {
    if (clubId.isEmpty) {
      return Left(AuthFailure(message: 'Club ID cannot be empty'));
    }

    final result = await repository.getCoachesByClub(clubId);

    return result.fold((failure) => Left(failure), (coaches) {
      List<Coach> filteredCoaches = coaches;

      // Apply verification filter
      if (verifiedOnly == true) {
        filteredCoaches = filteredCoaches
            .where((coach) => coach.verificationStatus == 'verified')
            .toList();
      }

      // Apply availability filter
      if (availableOnly == true) {
        filteredCoaches = filteredCoaches
            .where(
              (coach) =>
                  coach.acceptingNewPupils &&
                  coach.currentPupils < coach.maxPupils,
            )
            .toList();
      }

      // Apply minimum experience filter
      if (minExperience != null) {
        filteredCoaches = filteredCoaches
            .where((coach) => coach.experience >= minExperience)
            .toList();
      }

      // Apply specialties filter
      if (specialties != null && specialties.isNotEmpty) {
        filteredCoaches = filteredCoaches
            .where(
              (coach) => specialties.any(
                (specialty) => coach.specialties.contains(specialty),
              ),
            )
            .toList();
      }

      return Right(filteredCoaches);
    });
  }
}
