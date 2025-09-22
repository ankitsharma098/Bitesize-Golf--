abstract class CoachHomeEvent {}

class LoadCoachHomeData extends CoachHomeEvent {}

class RefreshCoachHome extends CoachHomeEvent {}

class NavigateToLevel extends CoachHomeEvent {
  final int levelNumber;

  NavigateToLevel(this.levelNumber);
}
