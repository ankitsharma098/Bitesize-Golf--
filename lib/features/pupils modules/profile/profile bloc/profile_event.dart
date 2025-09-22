import 'package:equatable/equatable.dart';
import '../../../../Models/pupil model/pupil_model.dart';

abstract class PupilProfileEvent extends Equatable {
  const PupilProfileEvent();

  @override
  List<Object?> get props => [];
}

class PupilLoadProfileData extends PupilProfileEvent {
  const PupilLoadProfileData();
}

class PupilRefreshProfile extends PupilProfileEvent {
  const PupilRefreshProfile();
}

class PupilUpdateProfile extends PupilProfileEvent {
  final PupilModel updatedPupil;

  const PupilUpdateProfile(this.updatedPupil);

  @override
  List<Object> get props => [updatedPupil];
}
