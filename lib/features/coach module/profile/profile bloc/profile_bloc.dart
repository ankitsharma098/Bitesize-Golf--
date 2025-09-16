import 'dart:async';
import 'package:bitesize_golf/features/coach%20module/profile/profile%20bloc/profile_event.dart';
import 'package:bitesize_golf/features/coach%20module/profile/profile%20bloc/profile_state.dart';
import 'package:bitesize_golf/features/coaches/data/models/coach_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../auth/data/repositories/auth_repo.dart';
import '../data/pupil_profile_repo.dart';

@injectable
class CoachProfileBloc extends Bloc<CoachProfileEvent, CoachProfileState> {
  final CoachProfilePageRepo _dashboardRepository;
  final AuthRepository _authRepository;

  StreamSubscription<CoachModel?>? _coachSubscription;

  CoachProfileBloc(this._dashboardRepository, this._authRepository)
    : super(const ProfileInitial()) {
    on<LoadProfileData>(_onLoadProfileData);
    on<RefreshProfile>(_onRefreshProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<_ProfileDataUpdated>(_onProfileDataUpdated);
  }

  Future<void> _onLoadProfileData(
    LoadProfileData event,
    Emitter<CoachProfileState> emit,
  ) async {
    try {
      emit(const ProfileLoading());

      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        emit(const ProfileError('User not found'));
        return;
      }

      await _startListeningToUpdates(currentUser.uid);
    } catch (e) {
      emit(ProfileError('Failed to load profile: $e'));
    }
  }

  Future<void> _onRefreshProfile(
    RefreshProfile event,
    Emitter<CoachProfileState> emit,
  ) async {
    try {
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        emit(const ProfileError('User not found'));
        return;
      }

      final coach = await _dashboardRepository.getCoachData(currentUser.uid);
      if (coach != null) {
        emit(ProfileLoaded(coach: coach));
      } else {
        emit(const ProfileError('Profile data not found'));
      }
    } catch (e) {
      emit(ProfileError('Failed to refresh profile: $e'));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<CoachProfileState> emit,
  ) async {
    try {
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        emit(const ProfileError('User not found'));
        return;
      }

      await _dashboardRepository.updateCoachesProgress(
        currentUser.uid,
        event.updatedCoach,
      );

      // The stream will automatically update the UI
    } catch (e) {
      emit(ProfileError('Failed to update profile: $e'));
    }
  }

  void _onProfileDataUpdated(
    _ProfileDataUpdated event,
    Emitter<CoachProfileState> emit,
  ) {
    emit(ProfileLoaded(coach: event.coach));
  }

  Future<void> _startListeningToUpdates(String userId) async {
    await _coachSubscription?.cancel();

    _coachSubscription = _dashboardRepository
        .getCoachesDataStream(userId)
        .listen(
          (coach) {
            if (coach != null) {
              add(_ProfileDataUpdated(coach: coach));
            }
          },
          onError: (error) {
            add(_ProfileError('Failed to load profile data: $error'));
          },
        );
  }

  @override
  Future<void> close() {
    _coachSubscription?.cancel();
    return super.close();
  }
}

class _ProfileDataUpdated extends CoachProfileEvent {
  final CoachModel coach;

  const _ProfileDataUpdated({required this.coach});
}

class _ProfileError extends CoachProfileEvent {
  final String message;

  const _ProfileError(this.message);
}
