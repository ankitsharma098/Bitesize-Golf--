import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../failure.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class CreatePupilProfileUseCase {
  final AuthRepository repository;
  CreatePupilProfileUseCase({required this.repository});

  Future<Future<Either<Failure, void>>> call({
    required String pupilId,
    required String parentId,
    required String name,
    required String? avatar,
    required DateTime? dateOfBirth,
    required String? handicap,
    required String? selectedClubId,
    required String? selectedCoachName,
  }) async {
    return repository.createPupilProfile(
      pupilId: pupilId,
      parentId: parentId,
      name: name,
      avatar: avatar,
      dateOfBirth: dateOfBirth,
      handicap: handicap,
      selectedClubId: selectedClubId,
      selectedCoachName: selectedCoachName,
    );
  }
}
