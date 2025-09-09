import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bitesize_golf/failure.dart';
import '../entities/coach_entity.dart';
import '../repositories/coach_repository.dart';

@injectable
class SearchCoachesUseCase {
  final CoachRepository repository;

  SearchCoachesUseCase(this.repository);

  Future<Either<Failure, List<Coach>>> call({
    required String query,
    String? clubId,
    bool verifiedOnly = false,
  }) async {
    if (query.trim().isEmpty) {
      return Left(AuthFailure(message: 'Search query cannot be empty'));
    }

    // Get coaches from appropriate source
    final Either<Failure, List<Coach>> result;
    if (clubId != null && clubId.isNotEmpty) {
      result = await repository.getCoachesByClub(clubId);
    } else {
      result = await repository.getAllCoaches();
    }

    return result.fold((failure) => Left(failure), (coaches) {
      final searchQuery = query.toLowerCase().trim();

      List<Coach> filteredCoaches = coaches.where((coach) {
        final nameMatch = coach.name.toLowerCase().contains(searchQuery);
        final bioMatch = coach.bio.toLowerCase().contains(searchQuery);
        final specialtyMatch = coach.specialties.any(
          (s) => s.toLowerCase().contains(searchQuery),
        );
        final qualificationMatch = coach.qualifications.any(
          (q) => q.toLowerCase().contains(searchQuery),
        );

        return nameMatch || bioMatch || specialtyMatch || qualificationMatch;
      }).toList();

      // Apply verification filter if requested
      if (verifiedOnly) {
        filteredCoaches = filteredCoaches
            .where((coach) => coach.verificationStatus == 'verified')
            .toList();
      }

      return Right(filteredCoaches);
    });
  }
}
