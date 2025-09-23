import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../data/level_overview_repo.dart';
import 'level_overview__event.dart';
import 'level_overview__state.dart';

class LevelOverviewBloc extends Bloc<LevelOverviewEvent, LevelOverviewState> {
  final LevelOverviewRepository repository = LevelOverviewRepository();

  LevelOverviewBloc() : super(LevelOverviewInitial()) {
    on<LoadLevelOverview>(_onLoadLevelOverview);
  }

  Future<void> _onLoadLevelOverview(
    LoadLevelOverview event,
    Emitter<LevelOverviewState> emit,
  ) async {
    emit(LevelOverviewLoading());
    try {
      final data = await repository.getLevelOverviewData(event.levelNumber);
      emit(LevelOverviewLoaded(data));
    } catch (e) {
      emit(LevelOverviewError(e.toString()));
    }
  }
}
