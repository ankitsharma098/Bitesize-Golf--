import '../../../../Models/coaches model/coach_model.dart';

abstract class CoachProfileEvent {
  const CoachProfileEvent();
}

class CoachLoadProfileData extends CoachProfileEvent {
  const CoachLoadProfileData();
}

class CoachRefreshProfile extends CoachProfileEvent {
  const CoachRefreshProfile();
}

class UpdateCoachProfile extends CoachProfileEvent {
  final CoachModel updatedCoach;

  const UpdateCoachProfile(this.updatedCoach);
}
