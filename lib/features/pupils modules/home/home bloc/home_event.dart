import 'package:equatable/equatable.dart';

abstract class PupilHomeEvent extends Equatable {
  const PupilHomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeData extends PupilHomeEvent {
  const LoadHomeData();
}

class RefreshHome extends PupilHomeEvent {
  const RefreshHome();
}

class NavigateToLevel extends PupilHomeEvent {
  final int levelNumber;

  const NavigateToLevel(this.levelNumber);

  @override
  List<Object?> get props => [levelNumber];
}
