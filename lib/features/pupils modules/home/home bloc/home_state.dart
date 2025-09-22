import 'package:equatable/equatable.dart';
import '../../../../Models/level model/level_model.dart';
import '../../../../Models/pupil model/pupil_model.dart';

abstract class PupilHomeState extends Equatable {
  const PupilHomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends PupilHomeState {
  const HomeInitial();
}

class HomeLoading extends PupilHomeState {
  const HomeLoading();
}

class HomeLoaded extends PupilHomeState {
  final PupilModel pupil;
  final List<LevelModel> levels;

  const HomeLoaded({required this.pupil, required this.levels});

  @override
  List<Object?> get props => [pupil, levels];
}

class HomeError extends PupilHomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
