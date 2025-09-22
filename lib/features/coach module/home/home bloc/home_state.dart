import 'package:bitesize_golf/Models/level%20model/level_model.dart';

import '../../../../Models/coaches model/coach_model.dart';

abstract class CoachHomeState {
  const CoachHomeState();
}

class CoachHomeInitial extends CoachHomeState {
  const CoachHomeInitial();
}

class CoachHomeLoading extends CoachHomeState {
  const CoachHomeLoading();
}

class CoachHomeLoaded extends CoachHomeState {
  final CoachModel coach;
  final List<LevelModel> levels;

  const CoachHomeLoaded({required this.coach, required this.levels});
}

class CoachHomeError extends CoachHomeState {
  final String message;

  const CoachHomeError(this.message);
}
