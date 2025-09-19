import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

part 'update_profile_event.dart';
part 'update_profile_state.dart';

@injectable
class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {

  UpdateProfileBloc() : super(const UpdateProfileInitial()) {
    on<LoadUpdateProfile>(_onLoadLoadUpdate);
    on<ClearUpdateProfile>(_onClearLoadUpdate);
  }

  Future<void> _onLoadLoadUpdate(
      LoadUpdateProfile event,
      Emitter<UpdateProfileState> emit,
      ) async {
    try {
      emit(const UpdateProfileLoading());

      await Future.delayed(const Duration(seconds: 1));

      final guestProfile = {
        "firstName": "John",
        "lastName": "Doe",
        "email": "john.doe@example.com",
        "dateOfBirth": "15/03/1995",
        "handicap": 12,
        "coachName": "Michael Smith",
        "golfClub": "Royal Golf Club",
        "level": "Intermediate",
        "profileImage": null,
        "phone": "+91 98765 43210",
        "address": "Sector 18, Noida, UP",
        "membershipType": "Premium",
        "joinDate": "01/01/2020",
        "selectedCoachId": "1",
        "selectedClubId": "1"
      };

      emit(UpdateProfileLoaded(profile: guestProfile));
    } catch (e) {
      emit(UpdateProfileError("Failed to load profile: $e"));
    }
  }

  Future<void> _onClearLoadUpdate(
      ClearUpdateProfile event,
      Emitter<UpdateProfileState> emit,
      ) async {
    emit(const UpdateProfileInitial());
  }
}
