import '../../../level/entity/level_entity.dart';
import '../../pupil/data/models/pupil_model.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

class LoadProfileData extends ProfileEvent {
  const LoadProfileData();
}

class RefreshProfile extends ProfileEvent {
  const RefreshProfile();
}

class UpdateProfile extends ProfileEvent {
  final PupilModel updatedPupil;

  const UpdateProfile(this.updatedPupil);
}

class _ProfileDataUpdated extends ProfileEvent {
  final PupilModel pupil;
  final Level currentLevel;

  const _ProfileDataUpdated({required this.pupil, required this.currentLevel});
}

class _ProfileError extends ProfileEvent {
  final String message;

  const _ProfileError(this.message);
}
