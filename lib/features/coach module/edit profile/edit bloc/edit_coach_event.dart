part of 'edit_coach_bloc.dart';

@immutable
sealed class EditCoachEvent {}

class LoadCoachProfile extends EditCoachEvent {}

class SaveCoachProfile extends EditCoachEvent {
  final Map<String, dynamic> updatedCoach;

  SaveCoachProfile(this.updatedCoach);

  @override
  List<Object?> get props => [updatedCoach];
}
