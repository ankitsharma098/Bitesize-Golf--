import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../failure.dart';
import '../../../../auth/domain/repositories/auth_repository.dart';

import '../../data/models/pupil_model.dart';
import '../repositories/pupil_repo.dart';

@injectable
class GetPupilUseCase {
  final AuthRepository _authRepository;
  final PupilRepository _pupilRepository;

  GetPupilUseCase(this._authRepository, this._pupilRepository);

  Future<Either<Failure, PupilModel>> call() async {
    final userResult = await _authRepository.getCurrentUser();
    return userResult.fold((failure) => Left(failure), (user) async {
      if (user == null || user.role != 'pupil') {
        return Left(ServerFailure(message: 'No pupil found'));
      }
      return await _pupilRepository.getPupil(user.uid);
    });
  }
}
