import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/user.dart';
import '../../../../failure.dart';
import '../repositories/auth_repository.dart';

@injectable
class SignInAsGuestUseCase {
  final AuthRepository repository;

  SignInAsGuestUseCase(this.repository);

  Future<Either<Failure, User>> call() async {
    return repository.signInAsGuest();
  }
}
