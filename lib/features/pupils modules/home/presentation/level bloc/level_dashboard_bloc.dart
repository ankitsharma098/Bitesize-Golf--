import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../level/domain/usecases/get_level_usecase.dart';
import 'level_dashboard_event.dart';
import 'level_dashboard_state.dart';

@injectable
class LevelBloc extends Bloc<LevelEvent, LevelState> {
  final GetAllLevelsUseCase _getAllLevels;

  LevelBloc(this._getAllLevels) : super(LevelInitial()) {
    on<LoadLevels>(_onLoad);
    on<RefreshLevels>(_onRefresh);
  }

  Future<void> _onLoad(LoadLevels event, Emitter<LevelState> emit) async {
    emit(LevelLoading());
    final result = await _getAllLevels();
    result.fold(
      (failure) => emit(LevelError(failure.message)),
      (levels) => emit(LevelLoaded(levels)),
    );
  }

  Future<void> _onRefresh(RefreshLevels event, Emitter<LevelState> emit) async {
    final result = await _getAllLevels();
    result.fold(
      (failure) => emit(LevelError(failure.message)),
      (levels) => emit(LevelLoaded(levels)),
    );
  }
}
