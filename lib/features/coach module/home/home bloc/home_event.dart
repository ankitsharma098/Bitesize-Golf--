import '../../../coaches/data/models/coach_model.dart';
import '../../../level/entity/level_entity.dart';

abstract class CoachHomeEvent {}

class LoadHomeData extends CoachHomeEvent {}

class RefreshHome extends CoachHomeEvent {}

class NavigateToLevel extends CoachHomeEvent {
  final int levelNumber;

  NavigateToLevel(this.levelNumber);
}

class _HomeDataUpdated extends CoachHomeEvent {
  final CoachModel coach;
  final List<Level> levels;

  _HomeDataUpdated({required this.coach, required this.levels});
}

class _HomeError extends CoachHomeEvent {
  final String message;

  _HomeError(this.message);
}
