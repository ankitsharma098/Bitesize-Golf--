import 'package:equatable/equatable.dart';

import '../../../pupils modules/pupil/data/models/pupil_model.dart';
import '../data/entity/session_schedule_entity.dart';

abstract class CreateScheduleState extends Equatable {
  const CreateScheduleState();

  @override
  List<Object?> get props => [];
}

class CreateScheduleInitial extends CreateScheduleState {}

class CreateScheduleLoading extends CreateScheduleState {}

class CreateScheduleLoaded extends CreateScheduleState {
  final List<PupilModel> allPupils;
  final List<String> selectedPupilIds;
  final List<Session> sessions;
  final bool isSelectAllChecked;

  const CreateScheduleLoaded({
    required this.allPupils,
    required this.selectedPupilIds,
    required this.sessions,
    required this.isSelectAllChecked,
  });

  List<PupilModel> get selectedPupils =>
      allPupils.where((pupil) => selectedPupilIds.contains(pupil.id)).toList();

  bool get canSubmit =>
      selectedPupilIds.isNotEmpty &&
      sessions.every(
        (session) =>
            session.date.isAfter(
              DateTime.now().subtract(const Duration(days: 1)),
            ) &&
            session.time.isNotEmpty,
      );

  @override
  List<Object> get props => [
    allPupils,
    selectedPupilIds,
    sessions,
    isSelectAllChecked,
  ];
}

class CreateScheduleError extends CreateScheduleState {
  final String message;

  const CreateScheduleError(this.message);

  @override
  List<Object> get props => [message];
}

class CreateScheduleSuccess extends CreateScheduleState {
  final String scheduleId;

  const CreateScheduleSuccess(this.scheduleId);

  @override
  List<Object> get props => [scheduleId];
}

extension CreateScheduleLoadedExtension on CreateScheduleLoaded {
  CreateScheduleLoaded copyWith({
    List<PupilModel>? allPupils,
    List<String>? selectedPupilIds,
    List<Session>? sessions,
    bool? isSelectAllChecked,
  }) {
    return CreateScheduleLoaded(
      allPupils: allPupils ?? this.allPupils,
      selectedPupilIds: selectedPupilIds ?? this.selectedPupilIds,
      sessions: sessions ?? this.sessions,
      isSelectAllChecked: isSelectAllChecked ?? this.isSelectAllChecked,
    );
  }
}
