part of 'edit_coach_bloc.dart';

@immutable
sealed class EditCoachState {}

class EditCoachInitial extends EditCoachState {}

class EditCoachLoading extends EditCoachState {}

class EditCoachLoaded extends EditCoachState {
  final CoachModel coach;

  EditCoachLoaded(this.coach);

  @override
  List<Object> get props => [coach];
}

class EditCoachSuccess extends EditCoachState {}

class EditCoachError extends EditCoachState {
  final String message;

  EditCoachError(this.message);

  @override
  List<Object> get props => [message];
}
