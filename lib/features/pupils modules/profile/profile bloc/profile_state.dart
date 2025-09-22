import '../../../../Models/level model/level_model.dart';
import '../../../../Models/pupil model/pupil_model.dart';

abstract class PupilProfileState {
  const PupilProfileState();
}

class PupilProfileInitial extends PupilProfileState {
  const PupilProfileInitial();
}

class PupilProfileLoading extends PupilProfileState {
  const PupilProfileLoading();
}

class PupilProfileLoaded extends PupilProfileState {
  final PupilModel pupil;
  final LevelModel currentLevel;

  const PupilProfileLoaded({required this.pupil, required this.currentLevel});
}

class PupilProfileError extends PupilProfileState {
  final String message;
  const PupilProfileError(this.message);
}
