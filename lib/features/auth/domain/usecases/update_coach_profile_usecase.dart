import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../failure.dart';
import '../repositories/auth_repository.dart';

@injectable
class UpdateCoachProfileUseCase {
  final AuthRepository repository;

  UpdateCoachProfileUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String coachId,
    required String userId,
    required String name,
    String? bio,
    int? experience,
    List<String>? qualifications,
    List<String>? specialties,
    String? selectedClubName,
    String? selectedClubId,
    String? avatar,
  }) async {
    // Validate inputs
    if (name.trim().isEmpty) {
      return Left(AuthFailure(message: 'Coach name is required'));
    }
    if (experience != null && experience < 0) {
      return Left(AuthFailure(message: 'Experience cannot be negative'));
    }
    if (selectedClubName != null && selectedClubName.isEmpty) {
      return Left(AuthFailure(message: 'ClubName required'));
    }
    if (selectedClubId != null && selectedClubId.isEmpty) {
      return Left(AuthFailure(message: 'Club is not found'));
    }

    return repository.updateCoachProfile(
      coachId: coachId,
      userId: userId,
      name: name.trim(),
      bio: bio?.trim(),
      experience: experience ?? 0,
      qualifications: qualifications ?? [],
      specialties: specialties ?? [],
      selectedClubName: selectedClubName,
      selectedClubId: selectedClubId,
    );
  }
}
