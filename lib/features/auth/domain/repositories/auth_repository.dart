// features/auth/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signIn(String email, String password);
  Future<Either<Failure, User>> signUp(String email, String password);
  Future<Either<Failure, void>> signOut();

  /// Returns cached user if available, otherwise tries Firebase
  Future<Either<Failure, User?>> getCurrentUser();

  /// Stream of auth status (null when signed out)
  Stream<User?> authState$();
}
