import 'package:injectable/injectable.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@injectable
class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  Future<User?> call() async {
    final result = await repository.getCurrentUser();
    return result.fold((failure) => null, (user) => user);
  }
}
