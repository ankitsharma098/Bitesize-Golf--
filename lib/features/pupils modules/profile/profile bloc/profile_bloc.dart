import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Models/level model/level_model.dart';
import '../../../../Models/pupil model/pupil_model.dart';
import '../../../../core/constants/firebase_collections_names.dart';
import '../../../../core/utils/user_utils.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class PupilProfileBloc extends Bloc<PupilProfileEvent, PupilProfileState> {
  StreamSubscription? _pupilSubscription;

  PupilProfileBloc() : super(const PupilProfileInitial())
  {
    on<PupilLoadProfileData>(_onLoadProfileData);
    on<PupilRefreshProfile>(_onRefreshProfile);
    on<PupilUpdateProfile>(_onUpdateProfile);
    on<_UpdateProfileData>(_onUpdateProfileData);
  }

  Future<void> _onLoadProfileData(
    PupilLoadProfileData event,
    Emitter<PupilProfileState> emit,
  ) async {
    emit(const PupilProfileLoading());
    try {
      final pupil = await UserUtil().getCurrentPupil();
      if (pupil == null) {
        emit(const PupilProfileError('Pupil profile not found'));
        return;
      }
      await _startListeningToUpdates(pupil.id);
    } catch (e) {
      emit(PupilProfileError('Failed to load profile: $e'));
    }
  }

  Future<void> _onRefreshProfile(
    PupilRefreshProfile event,
    Emitter<PupilProfileState> emit,
  ) async {
    try {
      final pupil = await UserUtil().getCurrentPupil();
      if (pupil == null) {
        emit(const PupilProfileError('Pupil profile not found'));
        return;
      }
      final levelQuery = await FirestoreCollections.levelsCol
          .where('isActive', isEqualTo: true)
          .where('isPublished', isEqualTo: true)
          .orderBy('levelNumber')
          .get();
      final levels = levelQuery.docs
          .map((doc) => LevelModel.fromJson(doc.data()))
          .toList();
      final currentLevel = levels.firstWhere(
        (lvl) => lvl.levelNumber == pupil.currentLevel,
        orElse: () => levels.first,
      );
      emit(PupilProfileLoaded(pupil: pupil, currentLevel: currentLevel));
    } catch (e) {
      emit(PupilProfileError('Failed to refresh profile: $e'));
    }
  }

  Future<void> _onUpdateProfile(
    PupilUpdateProfile event,
    Emitter<PupilProfileState> emit,
  ) async {
    try {
      final pupil = await UserUtil().getCurrentPupil();
      if (pupil == null) {
        emit(const PupilProfileError('Pupil profile not found'));
        return;
      }
      await FirestoreCollections.pupilsCol
          .doc(pupil.id)
          .update(event.updatedPupil.toFirestore());
    } catch (e) {
      emit(PupilProfileError('Failed to update profile: $e'));
    }
  }

  void _onUpdateProfileData(
    _UpdateProfileData event,
    Emitter<PupilProfileState> emit,
  ) {
    if (event.error != null) {
      emit(PupilProfileError(event.error!));
    } else if (event.pupil != null && event.currentLevel != null) {
      emit(
        PupilProfileLoaded(
          pupil: event.pupil!,
          currentLevel: event.currentLevel!,
        ),
      );
    }
  }

  Future<void> _startListeningToUpdates(String userId) async {
    await _pupilSubscription?.cancel();
    _pupilSubscription = FirestoreCollections.pupilsCol
        .doc(userId)
        .snapshots()
        .listen(
          (doc) async {
            if (doc.exists) {
              try {
                final pupil = PupilModel.fromFirestore(
                  doc.data() as Map<String, dynamic>,
                );
                final levelQuery = await FirestoreCollections.levelsCol
                    .where('isActive', isEqualTo: true)
                    .where('isPublished', isEqualTo: true)
                    .orderBy('levelNumber')
                    .get();
                final levels = levelQuery.docs
                    .map((d) => LevelModel.fromJson(d.data()))
                    .toList();
                final currentLevel = levels.firstWhere(
                  (lvl) => lvl.levelNumber == pupil.currentLevel,
                  orElse: () => levels.first,
                );
                add(
                  _UpdateProfileData(pupil: pupil, currentLevel: currentLevel),
                );
              } catch (e) {
                add(_UpdateProfileData(error: 'Failed to load level bloc: $e'));
              }
            }
          },
          onError: (error) {
            add(
              _UpdateProfileData(error: 'Failed to load profile bloc: $error'),
            );
          },
        );
  }

  @override
  Future<void> close() {
    _pupilSubscription?.cancel();
    return super.close();
  }
}

class _UpdateProfileData extends PupilProfileEvent {
  final PupilModel? pupil;
  final LevelModel? currentLevel;
  final String? error;
  const _UpdateProfileData({this.pupil, this.currentLevel, this.error});

  @override
  List<Object?> get props => [pupil, currentLevel, error];
}
