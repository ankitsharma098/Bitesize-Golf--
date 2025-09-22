part of 'update_profile_bloc.dart';

@immutable
abstract class UpdatePupilProfileState {
  const UpdatePupilProfileState();
}

class UpdatePupilProfileInitial extends UpdatePupilProfileState {
  const UpdatePupilProfileInitial();
}

class UpdatePupilProfileLoading extends UpdatePupilProfileState {
  const UpdatePupilProfileLoading();
}

class UpdatePupilProfileLoaded extends UpdatePupilProfileState {
  final PupilModel pupil;
  const UpdatePupilProfileLoaded({required this.pupil});
}

class UpdatePupilProfileError extends UpdatePupilProfileState {
  final String message;
  const UpdatePupilProfileError(this.message);
}

class UpdatePupilProfileSuccess extends UpdatePupilProfileState {
  const UpdatePupilProfileSuccess();
}
