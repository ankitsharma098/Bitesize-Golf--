part of 'guest_profile_bloc.dart';


abstract class GuestProfileEvent {
  const GuestProfileEvent();
}

class LoadGuestProfile extends GuestProfileEvent {
   LoadGuestProfile();
}

class RefreshGuestProfile extends GuestProfileEvent {
  RefreshGuestProfile();
}

 class ClearGuestProfile extends GuestProfileEvent {
   ClearGuestProfile();
}
