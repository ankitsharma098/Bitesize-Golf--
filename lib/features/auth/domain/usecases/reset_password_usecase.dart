import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/user.dart';
import '../failure.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class ResetPasswordUseCase {
  final AuthRepository repository;
  ResetPasswordUseCase({required this.repository});

  Future<Either<Failure, void>> call({required String email}) async {
    return repository.resetPassword(email);
  }
}
