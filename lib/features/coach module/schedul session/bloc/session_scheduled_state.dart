// session_scheduled_state.dart
import 'package:equatable/equatable.dart';
import '../../../../Models/pupil model/pupil_model.dart';
import '../../../../Models/scheduled model/scheduled_model.dart';

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
  final List<SessionModel> sessions;
  final bool isSelectAllChecked;
  final String? existingScheduleId;
  final bool isUpdate;

  const CreateScheduleLoaded({
    required this.allPupils,
    required this.selectedPupilIds,
    required this.sessions,
    required this.isSelectAllChecked,
    this.existingScheduleId,
    this.isUpdate = false,
  });

  // This is the getter that was missing
  List<PupilModel> get selectedPupils =>
      allPupils.where((p) => selectedPupilIds.contains(p.id)).toList();

  bool get canSubmit =>
      selectedPupilIds.isNotEmpty &&
      sessions.every(
        (s) =>
            s.date!.isAfter(DateTime.now().subtract(const Duration(days: 1))) &&
            s.time.isNotEmpty,
      );

  @override
  List<Object?> get props => [
    allPupils,
    selectedPupilIds,
    sessions,
    isSelectAllChecked,
    existingScheduleId,
    isUpdate,
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

// Extension for copyWith method
extension CreateScheduleLoadedExtension on CreateScheduleLoaded {
  CreateScheduleLoaded copyWith({
    List<PupilModel>? allPupils,
    List<String>? selectedPupilIds,
    List<SessionModel>? sessions,
    bool? isSelectAllChecked,
    String? existingScheduleId,
    bool? isUpdate,
  }) {
    return CreateScheduleLoaded(
      allPupils: allPupils ?? this.allPupils,
      selectedPupilIds: selectedPupilIds ?? this.selectedPupilIds,
      sessions: sessions ?? this.sessions,
      isSelectAllChecked: isSelectAllChecked ?? this.isSelectAllChecked,
      existingScheduleId: existingScheduleId ?? this.existingScheduleId,
      isUpdate: isUpdate ?? this.isUpdate,
    );
  }
}
