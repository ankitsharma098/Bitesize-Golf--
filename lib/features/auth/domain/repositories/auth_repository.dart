import 'package:bitesize_golf/features/coaches/domain/entities/coach_entity.dart';
import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../../../failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signIn(String email, String password);
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String role,
    required String firstName,
    required String lastName,
  });
  Future<Either<Failure, User>> signInAsGuest();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, User?>> getCurrentUser();
  Stream<User?> authState$();
  Future<Either<Failure, void>> resetPassword(String email);

  Future<Either<Failure, void>> updateEmail(String newEmail);
  Future<Either<Failure, void>> updatePassword(String newPassword);

  // Profile completion methods
  Future<Either<Failure, void>> updatePupilProfile({
    required String pupilId,
    required String userId,
    required String name,
    DateTime? dateOfBirth,
    String? handicap,
    String? selectedCoachName,
    String? selectedCoachId,
    String? selectedClubName,
    String? selectedClubId,
    String? avatar,
  });

  Future<Either<Failure, void>> updateCoachProfile({
    required String coachId,
    required String userId,
    required String name,
    String? bio,
    int? experience,
    List<String>? qualifications,
    List<String>? specialties,
    String? selectedClubName,
    String? selectedClubId,
    String? avatar,
  });
}
