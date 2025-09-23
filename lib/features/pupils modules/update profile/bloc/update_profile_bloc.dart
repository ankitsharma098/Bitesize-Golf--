import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../../../Models/pupil model/pupil_model.dart';
import '../../../../core/constants/firebase_collections_names.dart';
import '../../../../core/utils/user_utils.dart';

part 'update_profile_event.dart';
part 'update_profile_state.dart';

class UpdatePupilProfileBloc
    extends Bloc<UpdatePupilProfileEvent, UpdatePupilProfileState> {
  StreamSubscription? _pupilSubscription;

  UpdatePupilProfileBloc() : super(const UpdatePupilProfileInitial()) {
    on<LoadPupilUpdateProfile>(_onLoadProfile);
    on<SavePupilUpdateProfile>(_onSaveProfile);
    on<ClearPupilUpdateProfile>(_onClear);

    // Internal events
    on<_UpdateProfileData>(_onUpdateProfileData);
    on<_ProfileError>(_onProfileError);
  }

  Future<void> _onLoadProfile(
    LoadPupilUpdateProfile event,
    Emitter<UpdatePupilProfileState> emit,
  ) async {
    emit(const UpdatePupilProfileLoading());
    try {
      final pupil = await UserUtil().getCurrentPupil();
      if (pupil == null) {
        emit(const UpdatePupilProfileError("Pupil profile not found"));
        return;
      }

      // Start listening for updates
      await _startListeningToUpdates(pupil.id);
    } catch (e) {
      emit(UpdatePupilProfileError("Failed to load profile: $e"));
    }
  }

  // Future<void> _onSaveProfile(
  //   SaveUpdateProfile event,
  //   Emitter<UpdateProfileState> emit,
  // ) async {
  //   try {
  //     emit(const UpdateProfileLoading());
  //
  //     final pupil = await UserUtil().getCurrentPupil();
  //     if (pupil == null) {
  //       emit(const UpdateProfileError("Pupil profile not found"));
  //       return;
  //     }
  //
  //     final updated = event.updatedPupil;
  //     final updateMap = <String, dynamic>{};
  //
  //     /// --- Basic fields ---
  //     if (updated.name != pupil.name) updateMap['name'] = updated.name;
  //     if (updated.dateOfBirth != pupil.dateOfBirth) {
  //       updateMap['dateOfBirth'] = updated.dateOfBirth != null
  //           ? Timestamp.fromDate(updated.dateOfBirth!)
  //           : null;
  //     }
  //     if (updated.handicap != pupil.handicap) {
  //       updateMap['handicap'] = updated.handicap;
  //     }
  //     if (updated.profilePic != pupil.profilePic) {
  //       updateMap['profilePic'] = updated.profilePic;
  //     }
  //
  //     /// --- Club / Coach ---
  //     final newClubId = updated.selectedClubId;
  //     final newCoachId = updated.selectedCoachId;
  //
  //     final alreadyAssignedClub = pupil.assignedClubId != null;
  //     final alreadyAssignedCoach = pupil.assignedCoachId != null;
  //
  //     if ((newClubId != null && newClubId.isNotEmpty) ||
  //         (newCoachId != null && newCoachId.isNotEmpty)) {
  //       if (alreadyAssignedClub || alreadyAssignedCoach) {
  //         // → Create joining request
  //         final requestId = _firestore.collection('joiningRequests').doc().id;
  //         await _firestore.collection('joiningRequests').doc(requestId).set({
  //           'id': requestId,
  //           'pupilId': pupil.id,
  //           'pupilName': pupil.name,
  //           'clubId': newClubId,
  //           'clubName': updated.selectedClubName,
  //           'coachId': newCoachId,
  //           'coachName': updated.selectedCoachName,
  //           'status': 'pending',
  //           'createdAt': Timestamp.now(),
  //         });
  //       } else {
  //         // → Safe direct update
  //         if (newClubId != pupil.selectedClubId) {
  //           updateMap['selectedClubId'] = newClubId;
  //           updateMap['selectedClubName'] = updated.selectedClubName;
  //         }
  //         if (newCoachId != pupil.selectedCoachId) {
  //           updateMap['selectedCoachId'] = newCoachId;
  //           updateMap['selectedCoachName'] = updated.selectedCoachName;
  //         }
  //       }
  //     }
  //
  //     if (updateMap.isNotEmpty) {
  //       updateMap['updatedAt'] = Timestamp.now();
  //       await FirestoreCollections.pupilsCol.doc(pupil.id).update(updateMap);
  //     }
  //
  //     emit(const UpdateProfileSuccess());
  //   } catch (e) {
  //     emit(UpdateProfileError("Failed to update profile: $e"));
  //   }
  // }
  Future<void> _onSaveProfile(
    SavePupilUpdateProfile event,
    Emitter<UpdatePupilProfileState> emit,
  ) async {
    try {
      emit(const UpdatePupilProfileLoading());

      final pupil = await UserUtil().getCurrentPupil();
      if (pupil == null) {
        emit(const UpdatePupilProfileError("Pupil profile not found"));
        return;
      }

      final updated = event.updatedPupil;
      final updateMap = <String, dynamic>{};

      /// --- Allow only basic fields ---
      if (updated.name != pupil.name) updateMap['name'] = updated.name;
      if (updated.dateOfBirth != pupil.dateOfBirth) {
        updateMap['dateOfBirth'] = updated.dateOfBirth != null
            ? Timestamp.fromDate(updated.dateOfBirth!)
            : null;
      }
      if (updated.handicap != pupil.handicap) {
        updateMap['handicap'] = updated.handicap;
      }
      if (updated.profilePic != pupil.profilePic) {
        updateMap['profilePic'] = updated.profilePic;
      }

      /// ❌ Skip selectedClubId / selectedCoachId updates here
      /// (users cannot update them manually)

      if (updateMap.isNotEmpty) {
        updateMap['updatedAt'] = Timestamp.now();
        await FirestoreCollections.pupilsCol.doc(pupil.id).update(updateMap);
      }

      emit(const UpdatePupilProfileSuccess());
    } catch (e) {
      emit(UpdatePupilProfileError("Failed to update profile: $e"));
    }
  }

  void _onClear(
    ClearPupilUpdateProfile event,
    Emitter<UpdatePupilProfileState> emit,
  ) {
    emit(const UpdatePupilProfileInitial());
  }

  /// 🔹 Internal event handlers
  void _onUpdateProfileData(
    _UpdateProfileData event,
    Emitter<UpdatePupilProfileState> emit,
  ) {
    emit(UpdatePupilProfileLoaded(pupil: event.pupil));
  }

  void _onProfileError(
    _ProfileError event,
    Emitter<UpdatePupilProfileState> emit,
  ) {
    emit(UpdatePupilProfileError(event.message));
  }

  Future<void> _startListeningToUpdates(String pupilId) async {
    await _pupilSubscription?.cancel();

    _pupilSubscription = FirestoreCollections.pupilsCol
        .doc(pupilId)
        .snapshots()
        .listen(
          (doc) {
            if (doc.exists) {
              try {
                final pupil = PupilModel.fromFirestore(doc.data()!);
                add(_UpdateProfileData(pupil));
              } catch (e) {
                add(_ProfileError("Failed to parse profile book bloc: $e"));
              }
            }
          },
          onError: (error) {
            add(_ProfileError("Failed to listen to profile updates: $error"));
          },
        );
  }

  @override
  Future<void> close() {
    _pupilSubscription?.cancel();
    return super.close();
  }
}

/// 🔹 Internal events
class _UpdateProfileData extends UpdatePupilProfileEvent {
  final PupilModel pupil;
  const _UpdateProfileData(this.pupil);
}

class _ProfileError extends UpdatePupilProfileEvent {
  final String message;
  const _ProfileError(this.message);
}
