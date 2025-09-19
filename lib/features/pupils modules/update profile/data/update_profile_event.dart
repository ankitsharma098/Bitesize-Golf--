part of 'update_profile_bloc.dart';

abstract class UpdateProfileEvent {
  const UpdateProfileEvent();
}

class LoadUpdateProfile extends UpdateProfileEvent {
  const LoadUpdateProfile();
}

class RefreshUpdateProfile extends UpdateProfileEvent {
  const RefreshUpdateProfile();
}

class ClearUpdateProfile extends UpdateProfileEvent {
  const ClearUpdateProfile();
}
