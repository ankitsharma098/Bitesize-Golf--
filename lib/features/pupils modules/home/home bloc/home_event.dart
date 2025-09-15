import '../../../level/entity/level_entity.dart';
import '../../pupil/data/models/pupil_model.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class LoadHomeData extends HomeEvent {
  const LoadHomeData();
}

class RefreshHome extends HomeEvent {
  const RefreshHome();
}

class NavigateToLevel extends HomeEvent {
  final int levelNumber;

  const NavigateToLevel(this.levelNumber);
}

class _HomeDataUpdated extends HomeEvent {
  final PupilModel pupil;
  final List<Level> levels;

  const _HomeDataUpdated({required this.pupil, required this.levels});
}

class _HomeError extends HomeEvent {
  final String message;

  const _HomeError(this.message);
}
