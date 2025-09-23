abstract class LevelOverviewEvent {}

class LoadLevelOverview extends LevelOverviewEvent {
  final String levelNumber;
  LoadLevelOverview(this.levelNumber);
}
