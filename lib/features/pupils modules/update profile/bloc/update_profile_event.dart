part of 'update_profile_bloc.dart';

@immutable
abstract class UpdatePupilProfileEvent {
  const UpdatePupilProfileEvent();
}

class LoadPupilUpdateProfile extends UpdatePupilProfileEvent {
  const LoadPupilUpdateProfile();
}

class SavePupilUpdateProfile extends UpdatePupilProfileEvent {
  final PupilModel updatedPupil;
  const SavePupilUpdateProfile(this.updatedPupil);
}

class ClearPupilUpdateProfile extends UpdatePupilProfileEvent {
  const ClearPupilUpdateProfile();
}
