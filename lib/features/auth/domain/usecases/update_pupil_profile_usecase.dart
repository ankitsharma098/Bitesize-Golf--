import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../failure.dart';
import '../repositories/auth_repository.dart';

@injectable
class UpdatePupilProfileUseCase {
  final AuthRepository repository;

  UpdatePupilProfileUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String pupilId,
    required String userId,
    required String name,
    DateTime? dateOfBirth,
    String? handicap,
    String? selectedCoachId,
    String? selectedCoachName,
    String? selectedClubId,
    String? selectedClubName,
    String? avatar,
  }) async {
    // Validate inputs
    if (name.trim().isEmpty) {
      return Left(AuthFailure(message: 'Pupil name is required'));
    }
    if (dateOfBirth != null && dateOfBirth.isAfter(DateTime.now())) {
      return Left(
        AuthFailure(message: 'Date of birth cannot be in the future'),
      );
    }

    return repository.updatePupilProfile(
      pupilId: pupilId,
      userId: userId,
      name: name.trim(),
      dateOfBirth: dateOfBirth,
      handicap: handicap?.trim(),
      selectedCoachName: selectedCoachName?.trim(),
      selectedCoachId: selectedCoachId?.trim(),
      selectedClubId: selectedClubId?.trim(),
      selectedClubName: selectedClubName?.trim(),
      avatar: avatar?.trim(),
    );
  }
}
