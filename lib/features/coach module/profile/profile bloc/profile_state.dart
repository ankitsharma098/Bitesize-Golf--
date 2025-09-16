import '../../../level/entity/level_entity.dart';
import '../../pupil/data/models/pupil_model.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final PupilModel pupil;
  final Level currentLevel;

  const ProfileLoaded({required this.pupil, required this.currentLevel});
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);
}
