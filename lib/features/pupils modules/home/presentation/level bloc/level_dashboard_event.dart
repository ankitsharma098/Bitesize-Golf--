import 'package:equatable/equatable.dart';
import '../../../level/data/model/level_progress.dart';
import '../../../level/domain/entities/level_entity.dart';

abstract class LevelEvent extends Equatable {
  const LevelEvent();

  @override
  List<Object?> get props => [];
}

class LoadLevels extends LevelEvent {}

class RefreshLevels extends LevelEvent {}
