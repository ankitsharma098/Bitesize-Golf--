import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../auth/data/repositories/auth_repo.dart';
import '../../../level/entity/level_entity.dart';
import '../../pupil/data/models/pupil_model.dart';
import '../data/dashboard_repo.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _dashboardRepository;
  final AuthRepository _authRepository;

  StreamSubscription<PupilModel?>? _pupilSubscription;
  StreamSubscription<List<Level>>? _levelsSubscription;

  DashboardBloc(this._dashboardRepository, this._authRepository)
    : super(const DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<RefreshDashboard>(_onRefreshDashboard);
    on<NavigateToLevel>(_onNavigateToLevel);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      emit(const DashboardLoading());

      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        emit(const DashboardError('User not found'));
        return;
      }

      // Start listening to real-time updates
      await _startListeningToUpdates(currentUser.uid, emit);
    } catch (e) {
      emit(DashboardError('Failed to load dashboard: $e'));
    }
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        emit(const DashboardError('User not found'));
        return;
      }

      final pupil = await _dashboardRepository.getPupilData(currentUser.uid);
      final levels = await _dashboardRepository.getAllLevels();

      if (pupil != null) {
        emit(DashboardLoaded(pupil: pupil, levels: levels));
      } else {
        emit(const DashboardError('Pupil data not found'));
      }
    } catch (e) {
      emit(DashboardError('Failed to refresh dashboard: $e'));
    }
  }

  Future<void> _onNavigateToLevel(
    NavigateToLevel event,
    Emitter<DashboardState> emit,
  ) async {
    // Handle level navigation logic here
    // This could trigger navigation or level-specific actions
  }

  Future<void> _startListeningToUpdates(
    String userId,
    Emitter<DashboardState> emit,
  ) async {
    // Cancel existing subscriptions
    await _pupilSubscription?.cancel();
    await _levelsSubscription?.cancel();

    PupilModel? currentPupil;
    List<Level> currentLevels = [];

    // Listen to pupil data changes
    _pupilSubscription = _dashboardRepository
        .getPupilDataStream(userId)
        .listen(
          (pupil) {
            if (pupil != null) {
              currentPupil = pupil;
              if (currentLevels.isNotEmpty) {
                emit(DashboardLoaded(pupil: pupil, levels: currentLevels));
              }
            }
          },
          onError: (error) {
            emit(DashboardError('Failed to load pupil data: $error'));
          },
        );

    // Listen to levels changes
    _levelsSubscription = _dashboardRepository.getLevelsStream().listen(
      (levels) {
        currentLevels = levels;
        if (currentPupil != null) {
          emit(DashboardLoaded(pupil: currentPupil!, levels: levels));
        }
      },
      onError: (error) {
        emit(DashboardError('Failed to load levels: $error'));
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
