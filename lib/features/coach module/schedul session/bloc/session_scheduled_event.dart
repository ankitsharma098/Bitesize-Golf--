import 'package:equatable/equatable.dart';

abstract class CreateScheduleEvent extends Equatable {
  const CreateScheduleEvent();

  @override
  List<Object?> get props => [];
}

class LoadPupils extends CreateScheduleEvent {
  final String coachId;
  final int levelNumber;

  const LoadPupils({required this.coachId, required this.levelNumber});

  @override
  List<Object> get props => [coachId, levelNumber];
}

class SelectPupil extends CreateScheduleEvent {
  final String pupilId;

  const SelectPupil(this.pupilId);

  @override
  List<Object> get props => [pupilId];
}

class DeselectPupil extends CreateScheduleEvent {
  final String pupilId;

  const DeselectPupil(this.pupilId);

  @override
  List<Object> get props => [pupilId];
}

class ToggleSelectAllPupils extends CreateScheduleEvent {}

class UpdateSessionDate extends CreateScheduleEvent {
  final int sessionIndex;
  final DateTime date;

  const UpdateSessionDate({required this.sessionIndex, required this.date});

  @override
  List<Object> get props => [sessionIndex, date];
}

class UpdateSessionTime extends CreateScheduleEvent {
  final int sessionIndex;
  final String time;

  const UpdateSessionTime({required this.sessionIndex, required this.time});

  @override
  List<Object> get props => [sessionIndex, time];
}

class CreateScheduleSubmit extends CreateScheduleEvent {
  final String coachId;
  final String clubId;
  final int levelNumber;
  final String notes;

  const CreateScheduleSubmit({
    required this.coachId,
    required this.clubId,
    required this.levelNumber,
    this.notes = '',
  });

  @override
  List<Object> get props => [coachId, clubId, levelNumber, notes];
}

class ResetForm extends CreateScheduleEvent {}
