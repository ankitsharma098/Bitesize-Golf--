// session_scheduled_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Models/scheduled model/scheduled_model.dart';
import '../repo/scheduled_session_repo.dart';
import 'session_scheduled_event.dart';
import 'session_scheduled_state.dart';

class CreateScheduleBloc
    extends Bloc<CreateScheduleEvent, CreateScheduleState> {
  final ScheduleRepository _repository;

  CreateScheduleBloc({required ScheduleRepository repository})
    : _repository = repository,
      super(CreateScheduleInitial()) {
    on<LoadExistingSchedule>(_onLoadExistingSchedule);
    on<LoadPupils>(_onLoadPupils);
    on<SelectPupil>(_onSelectPupil);
    on<DeselectPupil>(_onDeselectPupil);
    on<ToggleSelectAllPupils>(_onToggleSelectAllPupils);
    on<UpdateSessionDate>(_onUpdateSessionDate);
    on<UpdateSessionTime>(_onUpdateSessionTime);
    on<CreateOrUpdateScheduleSubmit>(_onCreateOrUpdateScheduleSubmit);
    on<ResetForm>(_onResetForm);
  }

  Future<void> _onLoadExistingSchedule(
    LoadExistingSchedule event,
    Emitter<CreateScheduleState> emit,
  ) async {
    emit(CreateScheduleLoading());
    try {
      // Get pupils for this coach and level
      final pupils = await _repository.getPupilsByCoachAndLevel(
        coachId: event.coachId,
        levelNumber: event.levelNumber,
      );

      // Check for existing schedule
      final existingSchedule = await _repository.getExistingSchedule(
        coachId: event.coachId,
        levelNumber: event.levelNumber,
      );

      List<SessionModel> sessions;
      List<String> selectedPupilIds;
      bool isUpdate = false;

      if (existingSchedule != null) {
        // Use existing schedule data
        sessions = existingSchedule.sessions;
        selectedPupilIds = existingSchedule.pupilIds;
        isUpdate = true;
      } else {
        // Create default sessions
        sessions = _generateDefaultSessions();
        selectedPupilIds = [];
      }

      emit(
        CreateScheduleLoaded(
          allPupils: pupils,
          selectedPupilIds: selectedPupilIds,
          sessions: sessions,
          isSelectAllChecked:
              pupils.isNotEmpty && selectedPupilIds.length == pupils.length,
          existingScheduleId: existingSchedule?.id,
          isUpdate: isUpdate,
        ),
      );
    } catch (e) {
      emit(CreateScheduleError(e.toString()));
    }
  }

  Future<void> _onLoadPupils(
    LoadPupils event,
    Emitter<CreateScheduleState> emit,
  ) async {
    emit(CreateScheduleLoading());
    try {
      final pupils = await _repository.getPupilsByCoachAndLevel(
        coachId: event.coachId,
        levelNumber: event.levelNumber,
      );

      final sessions = _generateDefaultSessions();

      emit(
        CreateScheduleLoaded(
          allPupils: pupils,
          selectedPupilIds: const [],
          sessions: sessions,
          isSelectAllChecked: false,
          isUpdate: false,
        ),
      );
    } catch (e) {
      emit(CreateScheduleError(e.toString()));
    }
  }

  void _onSelectPupil(SelectPupil event, Emitter<CreateScheduleState> emit) {
    if (state is CreateScheduleLoaded) {
      final current = state as CreateScheduleLoaded;
      final updated = List<String>.from(current.selectedPupilIds)
        ..add(event.pupilId);

      emit(
        current.copyWith(
          selectedPupilIds: updated,
          isSelectAllChecked: updated.length == current.allPupils.length,
        ),
      );
    }
  }

  void _onDeselectPupil(
    DeselectPupil event,
    Emitter<CreateScheduleState> emit,
  ) {
    if (state is CreateScheduleLoaded) {
      final current = state as CreateScheduleLoaded;
      final updated = List<String>.from(current.selectedPupilIds)
        ..remove(event.pupilId);

      emit(
        current.copyWith(selectedPupilIds: updated, isSelectAllChecked: false),
      );
    }
  }

  void _onToggleSelectAllPupils(
    ToggleSelectAllPupils event,
    Emitter<CreateScheduleState> emit,
  ) {
    if (state is CreateScheduleLoaded) {
      final current = state as CreateScheduleLoaded;

      if (current.isSelectAllChecked) {
        emit(current.copyWith(selectedPupilIds: [], isSelectAllChecked: false));
      } else {
        emit(
          current.copyWith(
            selectedPupilIds: current.allPupils.map((p) => p.id).toList(),
            isSelectAllChecked: true,
          ),
        );
      }
    }
  }

  void _onUpdateSessionDate(
    UpdateSessionDate event,
    Emitter<CreateScheduleState> emit,
  ) {
    if (state is CreateScheduleLoaded) {
      final current = state as CreateScheduleLoaded;
      final updated = List<SessionModel>.from(current.sessions);

      if (event.sessionIndex < updated.length) {
        updated[event.sessionIndex] = updated[event.sessionIndex].copyWith(
          date: event.date,
        );

        emit(current.copyWith(sessions: updated));
      }
    }
  }

  void _onUpdateSessionTime(
    UpdateSessionTime event,
    Emitter<CreateScheduleState> emit,
  ) {
    if (state is CreateScheduleLoaded) {
      final current = state as CreateScheduleLoaded;
      final updated = List<SessionModel>.from(current.sessions);

      if (event.sessionIndex < updated.length) {
        updated[event.sessionIndex] = updated[event.sessionIndex].copyWith(
          time: event.time,
        );

        emit(current.copyWith(sessions: updated));
      }
    }
  }

  Future<void> _onCreateOrUpdateScheduleSubmit(
    CreateOrUpdateScheduleSubmit event,
    Emitter<CreateScheduleState> emit,
  ) async {
    if (state is CreateScheduleLoaded) {
      final current = state as CreateScheduleLoaded;

      if (!current.canSubmit) {
        emit(const CreateScheduleError('Please complete all required fields'));
        return;
      }

      emit(CreateScheduleLoading());

      try {
        if (current.isUpdate && current.existingScheduleId != null) {
          // Update existing schedule
          final existingSchedule = await _repository.getScheduleById(
            current.existingScheduleId!,
          );

          final updatedSchedule = existingSchedule!.copyWith(
            pupilIds: current.selectedPupilIds,
            sessions: current.sessions,
            notes: event.notes,
            updatedAt: DateTime.now(),
            status: ScheduleStatus.active,
          );

          await _repository.updateSchedule(updatedSchedule);
          emit(CreateScheduleSuccess(current.existingScheduleId!));
        } else {
          // Create new schedule
          final schedule = ScheduleModel.create(
            id: '',
            coachId: event.coachId,
            clubId: event.clubId,
            levelNumber: event.levelNumber,
            status: ScheduleStatus.active,
            pupilIds: current.selectedPupilIds,
            sessions: current.sessions,
            notes: event.notes,
          );

          final id = await _repository.createSchedule(schedule);
          emit(CreateScheduleSuccess(id));
        }
      } catch (e) {
        emit(CreateScheduleError(e.toString()));
      }
    }
  }

  void _onResetForm(ResetForm event, Emitter<CreateScheduleState> emit) {
    emit(CreateScheduleInitial());
  }

  List<SessionModel> _generateDefaultSessions() {
    final now = DateTime.now();
    return [
      for (int i = 1; i <= 6; i++)
        SessionModel(
          sessionNumber: i,
          date: now.add(Duration(days: i * 7)),
          time: '10:00',
          status: SessionStatus.scheduled,
        ),
      SessionModel(
        sessionNumber: 7,
        date: now.add(const Duration(days: 49)),
        time: '10:00',
        status: SessionStatus.scheduled,
        isLevelTransition: true,
      ),
    ];
  }
}
