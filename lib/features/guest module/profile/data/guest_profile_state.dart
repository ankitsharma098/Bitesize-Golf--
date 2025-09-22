part of 'guest_profile_bloc.dart';

abstract class GuestProfileState {
  const GuestProfileState();
}


class GuestProfileInitial extends GuestProfileState {
  const GuestProfileInitial();
}

class GuestProfileLoading extends GuestProfileState {
  const GuestProfileLoading();
}
class GuestProfileLoaded extends GuestProfileState {
  final Map<String, dynamic> profile;
  GuestProfileLoaded({required this.profile});
}

class GuestProfileError extends GuestProfileState {
  final String message;

  GuestProfileError(this.message);
}
