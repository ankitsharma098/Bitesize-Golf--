import '../../../level/entity/level_entity.dart';
import '../../pupil/data/models/pupil_model.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final PupilModel pupil;
  final List<Level> levels;

  const HomeLoaded({required this.pupil, required this.levels});
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);
}
