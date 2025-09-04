// Enhanced auth_repository.dart
import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signIn(String email, String password);
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String role,
    required String firstName,
    required String lastName,
  });
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, User?>> getCurrentUser();
  Stream<User?> authState$();
  Future<Either<Failure, User>> updateProfile(
    String uid,
    Map<String, dynamic> profileData,
  );
  Future<Either<Failure, User>> signInAsGuest();
  Future<Either<Failure, void>> resetPassword(String email);
}
