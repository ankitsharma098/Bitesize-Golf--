// features/auth/domain/usecases/sign_up_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/user.dart'; // ✅ Now correctly imports entity.User
import '../failure.dart';
import '../repositories/auth_repository.dart';

@injectable
class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
    required String role,
    required String firstName,
    required String lastName,
  }) async {
    return repository.signUp(
      email: email,
      password: password,
      role: role,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
