import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/user.dart';
import '../failure.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class CreateCoachProfileUseCase {
  final AuthRepository repository;
  CreateCoachProfileUseCase({required this.repository});

  Future<Either<Failure, void>> call({
    required String coachId,
    required String userId,
    required String name,
    required String? bio,
    required String? clubId,
    required int? experience,
  }) async {
    return repository.createCoachProfile(
      coachId: coachId,
      userId: userId,
      name: name,
      bio: bio,
      clubId: clubId,
      experience: experience,
    );
  }
}
