import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/user.dart';
import '../failure.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class UpdateProfileUseCase {
  final AuthRepository repository;
  UpdateProfileUseCase({required this.repository});

  Future<Either<Failure, User>> call({
    required String uid,
    required Map<String, dynamic> profileData,
  }) async {
    return repository.updateProfile(uid, profileData);
  }
}
