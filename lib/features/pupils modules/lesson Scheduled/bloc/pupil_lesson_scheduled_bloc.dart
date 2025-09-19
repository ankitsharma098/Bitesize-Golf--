import 'package:bitesize_golf/features/coach%20module/schedul%20session/data/model/session_schedule_model.dart';
import 'package:bitesize_golf/features/pupils%20modules/lesson%20Scheduled/bloc/pupil_lesson_scheduled_event.dart';
import 'package:bitesize_golf/features/pupils%20modules/lesson%20Scheduled/bloc/pupil_lesson_scheduled_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../coach module/schedul session/data/entity/session_schedule_entity.dart';
import '../data/pupil_lesson_scheduled_repo.dart';

class LessonScheduleBloc
    extends Bloc<LessonScheduleEvent, LessonScheduleState> {
  final PupilLessonScheduledRepo repository;

  LessonScheduleBloc({required this.repository})
    : super(LessonScheduleInitial()) {
    on<LoadLessonSchedule>(_onLoadLessonSchedule);
  }

  Future<void> _onLoadLessonSchedule(
    LoadLessonSchedule event,
    Emitter<LessonScheduleState> emit,
  ) async {
    emit(LessonScheduleLoading());
    try {
      final schedules = await repository.getPupilSchedules(event.pupilId);

      List<SessionModel> allSessions = [];
      SessionModel? nextLevelSession;

      for (final schedule in schedules) {
        for (final session in schedule.sessions) {
          if (session.isLevelTransition) {
            nextLevelSession = session;
          } else {
            allSessions.add(session);
          }
        }
      }

      // Sort sessions by session number
      allSessions.sort((a, b) => a.sessionNumber.compareTo(b.sessionNumber));

      emit(
        LessonScheduleLoaded(
          schedules: schedules,
          allSessions: allSessions,
          nextLevelSession: nextLevelSession,
        ),
      );
    } catch (e) {
      emit(LessonScheduleError(e.toString()));
    }
  }
}
