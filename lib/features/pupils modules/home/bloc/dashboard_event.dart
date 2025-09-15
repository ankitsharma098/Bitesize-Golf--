import 'package:equatable/equatable.dart';

// Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardData extends DashboardEvent {
  const LoadDashboardData();
}

class RefreshDashboard extends DashboardEvent {
  const RefreshDashboard();
}

class NavigateToLevel extends DashboardEvent {
  final int levelNumber;

  const NavigateToLevel(this.levelNumber);

  @override
  List<Object?> get props => [levelNumber];
}
