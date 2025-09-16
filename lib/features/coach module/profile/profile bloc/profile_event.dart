import 'package:bitesize_golf/features/coaches/data/models/coach_model.dart';

abstract class CoachProfileEvent {
  const CoachProfileEvent();
}

class LoadProfileData extends CoachProfileEvent {
  const LoadProfileData();
}

class RefreshProfile extends CoachProfileEvent {
  const RefreshProfile();
}

class UpdateProfile extends CoachProfileEvent {
  final CoachModel updatedCoach;

  const UpdateProfile(this.updatedCoach);
}
