import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
part 'guest_profile_event.dart';
part 'guest_profile_state.dart';

@injectable
class GuestProfileBloc extends Bloc<GuestProfileEvent, GuestProfileState> {
  GuestProfileBloc() : super(GuestProfileInitial()) {
    on<LoadGuestProfile>(_onLoadGuestProfile);
    on<ClearGuestProfile>(_onClearGuestProfile);
  }

  Future<void> _onLoadGuestProfile(
      LoadGuestProfile event,
      Emitter<GuestProfileState> emit,
      ) async {
    try {
      emit(GuestProfileLoading());

      final guestProfile = {
        "name": "Guest User",
        "email": "guest@example.com",
        "level": "Beginner",
      };

      emit(GuestProfileLoaded(profile: guestProfile));
    } catch (e) {
      emit(GuestProfileError("Failed to load guest profile: $e"));
    }
  }

  Future<void> _onClearGuestProfile(
      ClearGuestProfile event,
      Emitter<GuestProfileState> emit,
      ) async {
    emit(GuestProfileInitial());
  }
}
