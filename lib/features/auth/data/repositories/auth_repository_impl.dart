// features/auth/data/repositories/auth_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/user.dart' as entity;
import '../../domain/failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_firebase_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseDataSource firebaseDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.firebaseDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, entity.User>> signIn(
    String email,
    String password,
  ) async {
    try {
      final user = await firebaseDataSource.signIn(email, password);
      await localDataSource.cacheUser(user);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entity.User>> signUp(
    String email,
    String password,
  ) async {
    try {
      final user = await firebaseDataSource.signUp(email, password);
      await localDataSource.cacheUser(user);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await firebaseDataSource.signOut();
      await localDataSource.clear();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entity.User?>> getCurrentUser() async {
    try {
      // prefer cache
      final cached = await localDataSource.getUser();
      if (cached != null) return Right(cached);

      final remote = await firebaseDataSource.currentUser();
      if (remote != null) {
        await localDataSource.cacheUser(remote);
      }
      return Right(remote);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Stream<entity.User?> authState$() async* {
    // keep cache in sync
    await for (final user in firebaseDataSource.authState$()) {
      if (user != null) {
        await localDataSource.cacheUser(user);
      } else {
        await localDataSource.clear();
      }
      yield user;
    }
  }
}
