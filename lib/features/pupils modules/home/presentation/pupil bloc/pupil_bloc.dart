import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../pupil/domain/usecases/update_pupil_usecase.dart';
import '../../domain/usecases/get_pupil_usecase.dart';
import 'pupil_event.dart';
import 'pupil_state.dart';

@injectable
class PupilBloc extends Bloc<PupilEvent, PupilState> {
  final GetPupilUseCase _getPupil;
  final UpdatePupilProgressUseCase _updatePupilProgress;

  PupilBloc(this._getPupil, this._updatePupilProgress) : super(PupilInitial()) {
    on<LoadPupil>(_onLoad);
    on<RefreshPupil>(_onRefresh);
    on<UpdateLevelProgress>(_onUpdateProgress);
  }

  Future<void> _onLoad(LoadPupil event, Emitter<PupilState> emit) async {
    emit(PupilLoading());
    final result = await _getPupil();
    result.fold(
      (failure) => emit(PupilError(failure.message)),
      (pupil) => emit(PupilLoaded(pupil)),
    );
  }

  Future<void> _onRefresh(RefreshPupil event, Emitter<PupilState> emit) async {
    final result = await _getPupil();
    result.fold(
      (failure) => emit(PupilError(failure.message)),
      (pupil) => emit(PupilLoaded(pupil)),
    );
  }

  Future<void> _onUpdateProgress(
    UpdateLevelProgress event,
    Emitter<PupilState> emit,
  ) async {
    final currentState = state;
    if (currentState is PupilLoaded) {
      emit(PupilLoading());
      final result = await _updatePupilProgress(
        pupilId: currentState.pupil.id,
        levelNumber: event.levelNumber,
        progress: event.progress,
        requirements: event.levelRequirements,
        nextLevelNumber: event.nextLevelNumber,
        subscriptionCap: event.subscriptionCap,
      );
      result.fold((failure) => emit(PupilError(failure.message)), (_) async {
        final updatedPupilResult = await _getPupil();
        updatedPupilResult.fold(
          (failure) => emit(PupilError(failure.message)),
          (pupil) => emit(PupilLoaded(pupil)),
        );
      });
    }
  }
}
