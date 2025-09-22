import '../../../../Models/coaches model/coach_model.dart';

abstract class CoachProfileState {
  const CoachProfileState();
}

class CoachProfileInitial extends CoachProfileState {
  const CoachProfileInitial();
}

class CoachProfileLoading extends CoachProfileState {
  const CoachProfileLoading();
}

class CoachProfileLoaded extends CoachProfileState {
  final CoachModel coach;

  const CoachProfileLoaded({required this.coach});
}

class CoachProfileError extends CoachProfileState {
  final String message;

  const CoachProfileError(this.message);
}
