import '../../../coaches/data/models/coach_model.dart';
import '../../../level/entity/level_entity.dart';

abstract class CoachHomeState {
  const CoachHomeState();
}

class HomeInitial extends CoachHomeState {
  const HomeInitial();
}

class HomeLoading extends CoachHomeState {
  const HomeLoading();
}

class HomeLoaded extends CoachHomeState {
  final CoachModel coach;
  final List<Level> levels;

  const HomeLoaded({required this.coach, required this.levels});
}

class HomeError extends CoachHomeState {
  final String message;

  const HomeError(this.message);
}
