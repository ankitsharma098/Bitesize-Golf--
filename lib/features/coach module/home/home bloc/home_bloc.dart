import 'dart:async';
import 'package:bitesize_golf/features/coaches/data/models/coach_model.dart';
import 'package:bitesize_golf/features/level/entity/level_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../auth/data/repositories/auth_repo.dart';
import '../../profile/data/pupil_profile_repo.dart';
import '../data/home_level_repo.dart';
import 'home_event.dart';
import 'home_state.dart';

@injectable
class CoachHomeBloc extends Bloc<CoachHomeEvent, CoachHomeState> {
  final CoachProfilePageRepo _coachDashboardRepository;
  final LevelRepository _levelRepository;
  final AuthRepository _authRepository;

  StreamSubscription<CoachModel?>? _coachSubscription;
  StreamSubscription<List<Level>>? _levelsSubscription;

  CoachHomeBloc(
    this._coachDashboardRepository,
    this._levelRepository,
    this._authRepository,
  ) : super(const HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHome>(_onRefreshHome);
    on<NavigateToLevel>(_onNavigateToLevel);
    on<_HomeDataUpdated>(_onHomeDataUpdated);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<CoachHomeState> emit,
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
    Emitter<CoachHomeState> emit,
  ) async {
    try {
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        emit(const HomeError('User not found'));
        return;
      }

      final coach = await _coachDashboardRepository.getCoachData(
        currentUser.uid,
      );
      final levels = await _levelRepository.getAllLevels();

      if (coach != null) {
        emit(HomeLoaded(coach: coach, levels: levels));
      } else {
        emit(const HomeError('Coach data not found'));
      }
    } catch (e) {
      emit(HomeError('Failed to refresh home: $e'));
    }
  }

  void _onNavigateToLevel(NavigateToLevel event, Emitter<CoachHomeState> emit) {
    // Navigation logic will be handled by the UI layer
    // This could emit a navigation state or trigger a callback
    // ScaffoldMessenger.of(emit as BuildContext).showSnackBar(
    //   SnackBar(
    //     content: Text('Navigating to Level ${event.levelNumber}'),
    //     backgroundColor: AppColors.greenDark,
    //   ),
    // );
  }

  void _onHomeDataUpdated(
    _HomeDataUpdated event,
    Emitter<CoachHomeState> emit,
  ) {
    emit(HomeLoaded(coach: event.coach, levels: event.levels));
  }

  Future<void> _startListeningToUpdates(String userId) async {
    await _coachSubscription?.cancel();
    await _levelsSubscription?.cancel();

    CoachModel? currentCoach;
    List<Level> currentLevels = [];

    _coachSubscription = _coachDashboardRepository
        .getCoachesDataStream(userId)
        .listen(
          (coach) {
            if (coach != null) {
              currentCoach = coach;
              if (currentLevels.isNotEmpty) {
                add(_HomeDataUpdated(coach: coach, levels: currentLevels));
              }
            }
          },
          onError: (error) {
            add(_HomeError('Failed to load coach data: $error'));
          },
        );

    _levelsSubscription = _levelRepository.getLevelsStream().listen(
      (levels) {
        currentLevels = levels;
        if (currentCoach != null) {
          add(_HomeDataUpdated(coach: currentCoach!, levels: levels));
        }
      },
      onError: (error) {
        add(_HomeError('Failed to load levels: $error'));
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

class _HomeDataUpdated extends CoachHomeEvent {
  final CoachModel coach;
  final List<Level> levels;

  _HomeDataUpdated({required this.coach, required this.levels});
}

class _HomeError extends CoachHomeEvent {
  final String message;

  _HomeError(this.message);
}
