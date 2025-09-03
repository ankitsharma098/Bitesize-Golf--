// features/auth/domain/usecases/check_auth_status_usecase.dart
import 'package:injectable/injectable.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class CheckAuthStatusUseCase {
  final AuthRepository repository;
  CheckAuthStatusUseCase({required this.repository});

  Stream<User?> call() => repository.authState$();
}
