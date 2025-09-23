import '../data/model/level_overview_model.dart';

abstract class LevelOverviewState {}

class LevelOverviewInitial extends LevelOverviewState {}

class LevelOverviewLoading extends LevelOverviewState {}

class LevelOverviewLoaded extends LevelOverviewState {
  final LevelOverviewData data;
  LevelOverviewLoaded(this.data);
}

class LevelOverviewError extends LevelOverviewState {
  final String message;
  LevelOverviewError(this.message);
}
