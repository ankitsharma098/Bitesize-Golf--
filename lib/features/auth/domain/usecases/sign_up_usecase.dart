import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/user.dart';
import '../failure.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class SignUpUseCase {
  final AuthRepository repository;
  SignUpUseCase({required this.repository});

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) async {
    return repository.signUp(email, password);
  }
}
