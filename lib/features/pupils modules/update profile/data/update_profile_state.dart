part of 'update_profile_bloc.dart';

abstract class UpdateProfileState {
  const UpdateProfileState();
}

class UpdateProfileInitial extends UpdateProfileState {
  const UpdateProfileInitial();
}

class UpdateProfileLoading extends UpdateProfileState {
  const UpdateProfileLoading();
}

class UpdateProfileLoaded extends UpdateProfileState {
  final Map<String, dynamic> profile;
  const UpdateProfileLoaded({required this.profile});
}

class UpdateProfileError extends UpdateProfileState {
  final String message;
  const UpdateProfileError(this.message);
}
