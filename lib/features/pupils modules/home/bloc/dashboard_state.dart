import 'package:equatable/equatable.dart';

import '../../../level/entity/level_entity.dart';
import '../../pupil/data/models/pupil_model.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final PupilModel pupil;
  final List<Level> levels;

  const DashboardLoaded({required this.pupil, required this.levels});

  @override
  List<Object?> get props => [pupil, levels];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
