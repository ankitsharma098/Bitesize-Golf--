import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bitesize_golf/failure.dart';
import '../entities/coach_entity.dart';
import '../repositories/coach_repository.dart';

@injectable
class GetAllCoachesUseCase {
  final CoachRepository repository;

  GetAllCoachesUseCase(this.repository);

  Future<Either<Failure, List<Coach>>> call() async {
    return await repository.getAllCoaches();
  }
}
