import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../../../../Models/coaches model/coach_model.dart';
import '../../../../core/constants/firebase_collections_names.dart';
import '../../../../core/utils/user_utils.dart';

part 'edit_coach_event.dart';
part 'edit_coach_state.dart';

class EditCoachBloc extends Bloc<EditCoachEvent, EditCoachState> {
  EditCoachBloc() : super(EditCoachInitial()) {
    on<LoadCoachProfile>(_onLoadCoachProfile);
    on<SaveCoachProfile>(_onSaveCoachProfile);
  }

  Future<void> _onLoadCoachProfile(
    LoadCoachProfile event,
    Emitter<EditCoachState> emit,
  ) async {
    try {
      emit(EditCoachLoading());

      final coach = await UserUtil().getCurrentCoach();
      if (coach == null) {
        emit(EditCoachError("Coach profile not found"));
        return;
      }

      emit(EditCoachLoaded(coach));
    } catch (e) {
      emit(EditCoachError("Failed to load coach profile: $e"));
    }
  }

  Future<void> _onSaveCoachProfile(
    SaveCoachProfile event,
    Emitter<EditCoachState> emit,
  ) async {
    try {
      emit(EditCoachLoading());

      final coach = await UserUtil().getCurrentCoach();
      if (coach == null) {
        emit(EditCoachError("Coach profile not found"));
        return;
      }

      final updateMap = <String, dynamic>{};

      // Build name from firstName and lastName
      final newName =
          "${event.updatedCoach['firstName'] ?? ''} ${event.updatedCoach['lastName'] ?? ''}"
              .trim();
      if (newName.isNotEmpty && newName != coach.name) {
        updateMap['name'] = newName;
      }

      // Update experience
      final experience = event.updatedCoach['experience'];
      if (experience != null && experience.toString().isNotEmpty) {
        final experienceInt = int.tryParse(experience.toString());
        if (experienceInt != null && experienceInt != coach.experience) {
          updateMap['experience'] = experienceInt;
        }
      }

      // Update club information
      final clubId = event.updatedCoach['clubId'];
      final clubName = event.updatedCoach['clubName'];
      if (clubId != null && clubId != coach.selectedClubId) {
        updateMap['selectedClubId'] = clubId;
        updateMap['selectedClubName'] = clubName;
      }

      // Update profile picture
      final profilePic = event.updatedCoach['profilePic'];
      if (profilePic != null && profilePic != coach.profilePic) {
        updateMap['profilePic'] = profilePic;
      }

      if (updateMap.isNotEmpty) {
        updateMap['updatedAt'] = Timestamp.now();
        await FirestoreCollections.coachesCol.doc(coach.id).update(updateMap);
      }

      emit(EditCoachSuccess());
    } catch (e) {
      emit(EditCoachError("Failed to save coach profile: $e"));
    }
  }
}
