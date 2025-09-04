import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/user.dart';
import '../failure.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class SignInAsGuestUseCase {
  final AuthRepository repository;
  SignInAsGuestUseCase({required this.repository});

  Future<Either<Failure, User>> call() async {
    return repository.signInAsGuest();
  }
}
