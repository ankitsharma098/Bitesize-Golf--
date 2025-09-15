import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../auth/data/repositories/auth_repo.dart';
import '../../../level/entity/level_entity.dart';
import '../../pupil/data/models/pupil_model.dart';
import '../data/dashboard_repo.dart';
import 'home_event.dart';
import 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DashboardRepository _dashboardRepository;
  final AuthRepository _authRepository;

  StreamSubscription<PupilModel?>? _pupilSubscription;
  StreamSubscription<List<Level>>? _levelsSubscription;

  HomeBloc(this._dashboardRepository, this._authRepository)
    : super(const HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHome>(_onRefreshHome);
    on<NavigateToLevel>(_onNavigateToLevel);
    on<_HomeDataUpdated>(_onHomeDataUpdated);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(const HomeLoading());

      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        emit(const HomeError('User not found'));
        return;
      }

      await _startListeningToUpdates(currentUser.uid);
    } catch (e) {
      emit(HomeError('Failed to load home: $e'));
    }
  }

  Future<void> _onRefreshHome(
    RefreshHome event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        emit(const HomeError('User not found'));
        return;
      }

      final pupil = await _dashboardRepository.getPupilData(currentUser.uid);
      final levels = await _dashboardRepository.getAllLevels();

      if (pupil != null) {
        emit(HomeLoaded(pupil: pupil, levels: levels));
      } else {
        emit(const HomeError('Pupil data not found'));
      }
    } catch (e) {
      emit(HomeError('Failed to refresh home: $e'));
    }
  }

  void _onNavigateToLevel(NavigateToLevel event, Emitter<HomeState> emit) {
    // Navigation logic will be handled by the UI layer
    // This could emit a navigation state or trigger a callback
  }

  void _onHomeDataUpdated(_HomeDataUpdated event, Emitter<HomeState> emit) {
    emit(HomeLoaded(pupil: event.pupil, levels: event.levels));
  }

  Future<void> _startListeningToUpdates(String userId) async {
    await _pupilSubscription?.cancel();
    await _levelsSubscription?.cancel();

    PupilModel? currentPupil;
    List<Level> currentLevels = [];

    _pupilSubscription = _dashboardRepository
        .getPupilDataStream(userId)
        .listen(
          (pupil) {
            if (pupil != null) {
              currentPupil = pupil;
              if (currentLevels.isNotEmpty) {
                add(_HomeDataUpdated(pupil: pupil, levels: currentLevels));
              }
            }
          },
          onError: (error) {
            add(_HomeError('Failed to load pupil data: $error'));
          },
        );

    _levelsSubscription = _dashboardRepository.getLevelsStream().listen(
      (levels) {
        currentLevels = levels;
        if (currentPupil != null) {
          add(_HomeDataUpdated(pupil: currentPupil!, levels: levels));
        }
      },
      onError: (error) {
        add(_HomeError('Failed to load levels: $error'));
      },
    );
  }

  @override
  Future<void> close() {
    _pupilSubscription?.cancel();
    _levelsSubscription?.cancel();
    return super.close();
  }
}

class _HomeDataUpdated extends HomeEvent {
  final PupilModel pupil;
  final List<Level> levels;

  const _HomeDataUpdated({required this.pupil, required this.levels});
}

class _HomeError extends HomeEvent {
  final String message;

  const _HomeError(this.message);
}
