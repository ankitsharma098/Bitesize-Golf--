import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../failure.dart';
import '../repositories/auth_repository.dart';

@injectable
class CreateCoachProfileUseCase {
  final AuthRepository repository;

  CreateCoachProfileUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String coachId,
    required String userId,
    required String name,
    String? bio,
    int? experience,
    String? clubId,
  }) async {
    // Validate inputs
    if (name.trim().isEmpty) {
      return Left(AuthFailure(message: 'Coach name is required'));
    }
    if (experience != null && experience < 0) {
      return Left(AuthFailure(message: 'Experience cannot be negative'));
    }

    return repository.createCoachProfile(
      coachId: coachId,
      userId: userId,
      name: name.trim(),
      bio: bio?.trim(),
      experience: experience ?? 0,
      clubId: clubId?.trim(),
    );
  }
}
