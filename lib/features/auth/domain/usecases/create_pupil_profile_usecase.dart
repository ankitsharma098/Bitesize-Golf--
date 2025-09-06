import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../failure.dart';
import '../repositories/auth_repository.dart';

@injectable
class CreatePupilProfileUseCase {
  final AuthRepository repository;

  CreatePupilProfileUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String pupilId,
    required String parentId,
    required String name,
    DateTime? dateOfBirth,
    String? handicap,
    String? selectedCoachName,
    String? selectedClubId,
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

    return repository.createPupilProfile(
      pupilId: pupilId,
      parentId: parentId,
      name: name.trim(),
      dateOfBirth: dateOfBirth,
      handicap: handicap?.trim(),
      selectedCoachName: selectedCoachName?.trim(),
      selectedClubId: selectedClubId?.trim(),
      avatar: avatar?.trim(),
    );
  }
}
