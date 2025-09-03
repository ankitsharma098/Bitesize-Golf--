import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../failure.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class SignOutUseCase {
  final AuthRepository repository;
  SignOutUseCase({required this.repository});

  Future<Either<Failure, void>> call() => repository.signOut();
}
