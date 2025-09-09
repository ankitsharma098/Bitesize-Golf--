// features/auth/domain/usecases/get_current_user_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/user.dart';
import '../../../../failure.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class GetCurrentUserUseCase {
  final AuthRepository repository;
  GetCurrentUserUseCase({required this.repository});

  Future<Either<Failure, User?>> call() => repository.getCurrentUser();
}
