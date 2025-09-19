import 'dart:async';
import 'package:bitesize_golf/features/pupils%20modules/profile/profile%20bloc/profile_event.dart';
import 'package:bitesize_golf/features/pupils%20modules/profile/profile%20bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../auth/data/repositories/auth_repo.dart';
import '../../../level/entity/level_entity.dart';
import '../../home/data/dashboard_repo.dart';
import '../../pupil/data/models/pupil_model.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final DashboardRepository _dashboardRepository;
  final AuthRepository _authRepository;

  StreamSubscription<PupilModel?>? _pupilSubscription;

  ProfileBloc(this._dashboardRepository, this._authRepository)
    : super(const ProfileInitial()) {
    on<LoadProfileData>(_onLoadProfileData);
    on<RefreshProfile>(_onRefreshProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<_ProfileDataUpdated>(_onProfileDataUpdated);
  }

  Future<void> _onLoadProfileData(
    LoadProfileData event,
    Emitter<ProfileState> emit,
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
    Emitter<ProfileState> emit,
  ) async {
    try {
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        emit(const ProfileError('User not found'));
        return;
      }
      final pupil = await _dashboardRepository.getPupilData(currentUser.uid);
      final levels = await _dashboardRepository.getAllLevels();
      if (pupil != null) {
        final currentLevel = levels.firstWhere(
          (level) => level.levelNumber == pupil.currentLevel,
          orElse: () => levels.first,
        );
        emit(ProfileLoaded(pupil: pupil, currentLevel: currentLevel));
      } else {
        emit(const ProfileError('Profile data not found'));
      }
    } catch (e) {
      emit(ProfileError('Failed to refresh profile: $e'));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        emit(const ProfileError('User not found'));
        return;
      }
      await _dashboardRepository.updatePupilProgress(
        currentUser.uid,
        event.updatedPupil,
      );
    } catch (e) {
      emit(ProfileError('Failed to update profile: $e'));
    }
  }

  void _onProfileDataUpdated(
    _ProfileDataUpdated event,
    Emitter<ProfileState> emit,
  ) {
    emit(ProfileLoaded(pupil: event.pupil, currentLevel: event.currentLevel));
  }

  Future<void> _startListeningToUpdates(String userId) async {
    await _pupilSubscription?.cancel();
    _pupilSubscription = _dashboardRepository
        .getPupilDataStream(userId)
        .listen(
          (pupil) async {
            if (pupil != null) {
              try {
                final levels = await _dashboardRepository.getAllLevels();
                final currentLevel = levels.firstWhere(
                  (level) => level.levelNumber == pupil.currentLevel,
                  orElse: () => levels.first,
                );
                add(
                  _ProfileDataUpdated(pupil: pupil, currentLevel: currentLevel),
                );
              } catch (e) {
                add(_ProfileError('Failed to load level data: $e'));
              }
            }
          },
          onError: (error) {
            add(_ProfileError('Failed to load profile data: $error'));
          },
        );
  }

  @override
  Future<void> close() {
    _pupilSubscription?.cancel();
    return super.close();
  }
}

class _ProfileDataUpdated extends ProfileEvent {
  final PupilModel pupil;
  final Level currentLevel;

  const _ProfileDataUpdated({required this.pupil, required this.currentLevel});
}

class _ProfileError extends ProfileEvent {
  final String message;

  const _ProfileError(this.message);
}
