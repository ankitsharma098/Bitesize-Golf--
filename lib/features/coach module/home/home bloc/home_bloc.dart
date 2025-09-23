import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Models/level model/level_model.dart';
import '../../../../Models/coaches model/coach_model.dart';
import '../../../../core/utils/user_utils.dart';
import '../data/home_level_repo.dart';
import '../../profile/data/pupil_profile_repo.dart';
import 'home_event.dart';
import 'home_state.dart';

class CoachHomeBloc extends Bloc<CoachHomeEvent, CoachHomeState> {
  final CoachProfilePageRepo _coachRepo = CoachProfilePageRepo();
  final CoachHomeRepo _levelRepo = CoachHomeRepo();

  StreamSubscription<CoachModel?>? _coachSubscription;
  StreamSubscription<List<LevelModel>>? _levelsSubscription;

  CoachHomeBloc() : super(const CoachHomeInitial()) {
    on<LoadCoachHomeData>(_onLoadHomeData);
    on<RefreshCoachHome>(_onRefreshHome);
    on<NavigateToLevel>(_onNavigateToLevel);
    on<_UpdateCoachHomeData>(_onUpdateCoachHomeData); // Add internal event
  }

  Future<void> _onLoadHomeData(
    LoadCoachHomeData event,
    Emitter<CoachHomeState> emit,
  ) async {
    try {
      emit(const CoachHomeLoading());

      final coach = await UserUtil().getCurrentCoach();
      if (coach == null) {
        emit(const CoachHomeError('Coach profile not found'));
        return;
      }

      await _startListeningToUpdates(coach.id);
    } catch (e) {
      emit(CoachHomeError('Failed to load home: $e'));
    }
  }

  Future<void> _onRefreshHome(
    RefreshCoachHome event,
    Emitter<CoachHomeState> emit,
  ) async {
    try {
      final coach = await UserUtil().getCurrentCoach();
      if (coach == null) {
        emit(const CoachHomeError('Coach profile not found'));
        return;
      }

      final levels = await _levelRepo.getAllLevels();
      emit(CoachHomeLoaded(coach: coach, levels: levels));
    } catch (e) {
      emit(CoachHomeError('Failed to refresh home: $e'));
    }
  }

  void _onNavigateToLevel(NavigateToLevel event, Emitter<CoachHomeState> emit) {
    // UI handles navigation
  }

  // Internal event handler for stream updates
  void _onUpdateCoachHomeData(
    _UpdateCoachHomeData event,
    Emitter<CoachHomeState> emit,
  ) {
    if (event.error != null) {
      emit(CoachHomeError(event.error!));
    } else if (event.coach != null && event.levels != null) {
      emit(CoachHomeLoaded(coach: event.coach!, levels: event.levels!));
    }
  }

  Future<void> _startListeningToUpdates(String userId) async {
    await _coachSubscription?.cancel();
    await _levelsSubscription?.cancel();

    CoachModel? currentCoach;
    List<LevelModel> currentLevels = [];

    // Helper function to add internal event when both are loaded
    void tryEmitLoaded() {
      if (currentCoach != null && currentLevels.isNotEmpty) {
        add(_UpdateCoachHomeData(coach: currentCoach, levels: currentLevels));
      }
    }

    // Coach stream
    _coachSubscription = _coachRepo
        .getCoachesDataStream(userId)
        .listen(
          (coach) {
            if (coach != null) {
              currentCoach = coach;
              tryEmitLoaded();
            }
          },
          onError: (error) {
            add(
              _UpdateCoachHomeData(
                error: 'Failed to load coach book bloc: $error',
              ),
            );
          },
        );

    // Levels stream
    _levelsSubscription = _levelRepo.getLevelsStream().listen(
      (levels) {
        currentLevels = levels;
        if (currentCoach != null) {
          add(_UpdateCoachHomeData(coach: currentCoach, levels: levels));
        }
      },
      onError: (error) {
        add(_UpdateCoachHomeData(error: 'Failed to load levels: $error'));
      },
    );
  }

  @override
  Future<void> close() {
    _coachSubscription?.cancel();
    _levelsSubscription?.cancel();
    return super.close();
  }
}

// Internal event for handling stream updates
class _UpdateCoachHomeData extends CoachHomeEvent {
  final CoachModel? coach;
  final List<LevelModel>? levels;
  final String? error;

  _UpdateCoachHomeData({this.coach, this.levels, this.error});

  @override
  List<Object?> get props => [coach, levels, error];
}
