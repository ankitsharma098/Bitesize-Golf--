import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../failure.dart';
import '../../../../auth/domain/repositories/auth_repository.dart';
import '../../../pupil/data/models/pupil_model.dart';

@injectable
class GetPupilUseCase {
  final AuthRepository _authRepository;

  GetPupilUseCase(this._authRepository);

  Future<Either<Failure, PupilModel>> call() async {
    final userResult = await _authRepository.getCurrentUser();
    return userResult.fold((failure) => Left(failure), (user) async {
      if (user == null || user.role != 'pupil') {
        return Left(ServerFailure(message: 'No pupil found'));
      }
      final pupilDoc = await FirebaseFirestore.instance
          .collection('pupils')
          .doc(user.uid)
          .get();
      if (!pupilDoc.exists) {
        return Left(ServerFailure(message: 'Pupil data not found'));
      }
      return Right(PupilModel.fromJson(pupilDoc.data()!));
    });
  }
}
