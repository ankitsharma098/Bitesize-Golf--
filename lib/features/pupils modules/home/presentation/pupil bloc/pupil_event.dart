import 'package:equatable/equatable.dart';
import '../../../level/data/model/level_progress.dart';
import '../../../level/domain/entities/level_entity.dart';

abstract class PupilEvent extends Equatable {
  const PupilEvent();

  @override
  List<Object?> get props => [];
}

class LoadPupil extends PupilEvent {}

class RefreshPupil extends PupilEvent {}

class UpdateLevelProgress extends PupilEvent {
  final String pupilId;
  final int levelNumber;
  final LevelProgress progress;
  final LevelRequirements levelRequirements;
  final int nextLevelNumber;
  final int subscriptionCap;

  const UpdateLevelProgress({
    required this.pupilId,
    required this.levelNumber,
    required this.progress,
    required this.levelRequirements,
    required this.nextLevelNumber,
    required this.subscriptionCap,
  });

  @override
  List<Object?> get props => [
    pupilId,
    levelNumber,
    progress,
    levelRequirements,
    nextLevelNumber,
    subscriptionCap,
  ];
}
