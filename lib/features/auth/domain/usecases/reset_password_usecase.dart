import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../failure.dart';
import '../repositories/auth_repository.dart';

@injectable
class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call({required String email}) async {
    if (email.trim().isEmpty || !email.contains('@')) {
      return Left(AuthFailure(message: 'Please enter a valid email address'));
    }

    return repository.resetPassword(email.trim());
  }
}