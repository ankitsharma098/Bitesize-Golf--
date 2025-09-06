import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/user.dart';
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
    // Validate inputs
    if (email.trim().isEmpty) {
      return Left(AuthFailure(message: 'Email is required'));
    }
    if (!email.contains('@')) {
      return Left(AuthFailure(message: 'Invalid email format'));
    }
    if (password.length < 6) {
      return Left(
        AuthFailure(message: 'Password must be at least 6 characters'),
      );
    }
    if (firstName.trim().isEmpty || lastName.trim().isEmpty) {
      return Left(AuthFailure(message: 'First and last name are required'));
    }

    if (!['pupil', 'coach'].contains(role)) {
      return Left(AuthFailure(message: 'Invalid role selected'));
    }

    return repository.signUp(
      email: email.trim(),
      password: password,
      role: role,
      firstName: firstName.trim(),
      lastName: lastName.trim(),
    );
  }
}
