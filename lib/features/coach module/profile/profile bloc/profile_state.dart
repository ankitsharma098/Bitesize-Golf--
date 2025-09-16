import 'package:bitesize_golf/features/coaches/data/models/coach_model.dart';

abstract class CoachProfileState {
  const CoachProfileState();
}

class ProfileInitial extends CoachProfileState {
  const ProfileInitial();
}

class ProfileLoading extends CoachProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends CoachProfileState {
  final CoachModel coach;

  const ProfileLoaded({required this.coach});
}

class ProfileError extends CoachProfileState {
  final String message;

  const ProfileError(this.message);
}
