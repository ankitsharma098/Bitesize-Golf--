import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Models/coaches model/coach_model.dart';
import '../../../auth/repositories/auth_repo.dart';
import '../data/pupil_profile_repo.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../../../core/utils/user_utils.dart';

class CoachProfileBloc extends Bloc<CoachProfileEvent, CoachProfileState> {
  final CoachProfilePageRepo _dashboardRepository;

  StreamSubscription<CoachModel?>? _coachSubscription;

  CoachProfileBloc(this._dashboardRepository)
    : super(const CoachProfileInitial()) {
    on<CoachLoadProfileData>(_onLoadProfileData);
    on<CoachRefreshProfile>(_onRefreshProfile);
    on<UpdateCoachProfile>(_onUpdateProfile);
    on<_UpdateCoachProfileData>(
      _onUpdateCoachProfileData,
    ); // Add internal event
  }

  Future<void> _onLoadProfileData(
    CoachLoadProfileData event,
    Emitter<CoachProfileState> emit,
  ) async {
    try {
      emit(const CoachProfileLoading());

      final coach = await UserUtil().getCurrentCoach();
      if (coach == null) {
        emit(const CoachProfileError('Coach profile not found'));
        return;
      }

      await _startListeningToUpdates(coach.id);
    } catch (e) {
      emit(CoachProfileError('Failed to load profile: $e'));
    }
  }

  Future<void> _onRefreshProfile(
    CoachRefreshProfile event,
    Emitter<CoachProfileState> emit,
  ) async {
    try {
      final coach = await UserUtil().getCurrentCoach();
      if (coach == null) {
        emit(const CoachProfileError('Coach profile not found'));
        return;
      }

      emit(CoachProfileLoaded(coach: coach));
    } catch (e) {
      emit(CoachProfileError('Failed to refresh profile: $e'));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateCoachProfile event,
    Emitter<CoachProfileState> emit,
  ) async {
    try {
      final coach = await UserUtil().getCurrentCoach();
      if (coach == null) {
        emit(const CoachProfileError('Coach profile not found'));
        return;
      }

      await _dashboardRepository.updateCoachesProgress(
        coach.id,
        event.updatedCoach,
      );
      // Firestore stream will update the UI
    } catch (e) {
      emit(CoachProfileError('Failed to update profile: $e'));
    }
  }

  // Internal event handler for stream updates
  void _onUpdateCoachProfileData(
    _UpdateCoachProfileData event,
    Emitter<CoachProfileState> emit,
  ) {
    if (event.error != null) {
      emit(CoachProfileError(event.error!));
    } else if (event.coach != null) {
      emit(CoachProfileLoaded(coach: event.coach!));
    }
  }

  Future<void> _startListeningToUpdates(String userId) async {
    await _coachSubscription?.cancel();

    _coachSubscription = _dashboardRepository
        .getCoachesDataStream(userId)
        .listen(
          (coach) {
            if (coach != null) {
              // Use add() with internal event instead of direct add(UpdateCoachProfile)
              add(_UpdateCoachProfileData(coach: coach));
            }
          },
          onError: (error) {
            add(
              _UpdateCoachProfileData(
                error: 'Failed to load profile book bloc: $error',
              ),
            );
          },
        );
  }

  @override
  Future<void> close() {
    _coachSubscription?.cancel();
    return super.close();
  }
}

// Internal event for handling stream updates
class _UpdateCoachProfileData extends CoachProfileEvent {
  final CoachModel? coach;
  final String? error;

  const _UpdateCoachProfileData({this.coach, this.error});

  @override
  List<Object?> get props => [coach, error];
}
