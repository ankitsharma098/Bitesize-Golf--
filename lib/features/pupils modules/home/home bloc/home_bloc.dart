import 'dart:async';
import 'package:bitesize_golf/core/storage/shared_preference_utils.dart';
import 'package:bitesize_golf/core/utils/user_utils.dart';
import 'package:bloc/bloc.dart';
import '../../../../Models/level model/level_model.dart';
import '../../../../Models/pupil model/pupil_model.dart';
import '../data/dashboard_repo.dart';
import 'home_event.dart';
import 'home_state.dart';

class PupilHomeBloc extends Bloc<PupilHomeEvent, PupilHomeState> {
  final DashboardRepository _dashboardRepository;
  StreamSubscription<PupilModel?>? _pupilSubscription;
  StreamSubscription<List<LevelModel>>? _levelsSubscription;

  PupilHomeBloc(this._dashboardRepository) : super(const HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHome>(_onRefreshHome);
    on<NavigateToLevel>(_onNavigateToLevel);
    on<_UpdateHomeData>(_onUpdateHomeData); // Add internal event
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<PupilHomeState> emit,
  ) async {
    try {
      emit(const HomeLoading());

      print("Loading home bloc...");

      final userId = await SharedPrefsService.getUserId();
      if (userId == null || userId.isEmpty) {
        emit(const HomeError('Something went wrong please login'));
        return;
      }

      print("Start listening for user: $userId");
      await _startListeningToUpdates();
    } catch (e) {
      print("Error loading home bloc: $e");
      emit(HomeError('Failed to load home: $e'));
    }
  }

  Future<void> _onRefreshHome(
    RefreshHome event,
    Emitter<PupilHomeState> emit,
  ) async {
    try {
      emit(const HomeLoading());

      final pupil = await UserUtil().getCurrentPupil();
      final levels = await _dashboardRepository.getAllLevels();

      if (pupil != null) {
        print(
          "Refresh successful - Pupil: ${pupil.name}, Levels: ${levels.length}",
        );
        emit(HomeLoaded(pupil: pupil, levels: levels));
      } else {
        emit(const HomeError('Pupil bloc not found'));
      }
    } catch (e) {
      print("Error refreshing home: $e");
      emit(HomeError('Failed to refresh home: $e'));
    }
  }

  void _onNavigateToLevel(NavigateToLevel event, Emitter<PupilHomeState> emit) {
    // UI can handle navigation (snackbar, page push, etc.)
  }

  // Internal event handler for stream updates
  void _onUpdateHomeData(_UpdateHomeData event, Emitter<PupilHomeState> emit) {
    if (event.pupil != null && event.levels != null) {
      print(
        "Emitting HomeLoaded - Pupil: ${event.pupil!.name}, Levels: ${event.levels!.length}",
      );
      emit(HomeLoaded(pupil: event.pupil!, levels: event.levels!));
    }
  }

  Future<void> _startListeningToUpdates() async {
    try {
      await _pupilSubscription?.cancel();
      await _levelsSubscription?.cancel();

      final pupil = await UserUtil().getCurrentPupil();
      if (pupil == null) {
        add(const _UpdateHomeData(error: "Pupil profile not found"));
        return;
      }

      print("Setting up streams for pupil: ${pupil.id}");

      // Variables to track both bloc streams
      PupilModel? currentPupil;
      List<LevelModel>? currentLevels;
      bool pupilLoaded = false;
      bool levelsLoaded = false;

      // Helper function to add internal event when both are loaded
      void tryEmitLoaded() {
        if (pupilLoaded &&
            levelsLoaded &&
            currentPupil != null &&
            currentLevels != null) {
          // Use add() instead of emit() to trigger internal event
          add(_UpdateHomeData(pupil: currentPupil, levels: currentLevels));
        }
      }

      // Listen to pupil updates
      _pupilSubscription = _dashboardRepository
          .getPupilDataStream(pupil.id)
          .listen(
            (pupilData) {
              print("Pupil bloc received: ${pupilData?.name}");
              if (pupilData != null) {
                currentPupil = pupilData;
                pupilLoaded = true;
                tryEmitLoaded();
              }
            },
            onError: (error) {
              print("Error in pupil stream: $error");
              add(_UpdateHomeData(error: 'Failed to load pupil bloc: $error'));
            },
          );

      // Listen to level updates
      _levelsSubscription = _dashboardRepository.getLevelsStream().listen(
        (levels) {
          print("Levels bloc received: ${levels.length} levels");
          currentLevels = levels;
          levelsLoaded = true;
          tryEmitLoaded();
        },
        onError: (error) {
          print("Error in levels stream: $error");
          add(_UpdateHomeData(error: 'Failed to load levels: $error'));
        },
      );
    } catch (e) {
      print("Error setting up streams: $e");
      add(_UpdateHomeData(error: 'Failed to initialize bloc streams: $e'));
    }
  }

  @override
  Future<void> close() {
    _pupilSubscription?.cancel();
    _levelsSubscription?.cancel();
    return super.close();
  }
}

// Internal event for handling stream updates
class _UpdateHomeData extends PupilHomeEvent {
  final PupilModel? pupil;
  final List<LevelModel>? levels;
  final String? error;

  const _UpdateHomeData({this.pupil, this.levels, this.error});

  @override
  List<Object?> get props => [pupil, levels, error];
}
