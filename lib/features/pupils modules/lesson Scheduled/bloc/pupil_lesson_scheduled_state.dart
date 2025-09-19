import 'package:bitesize_golf/features/coach%20module/schedul%20session/data/model/session_schedule_model.dart';

import '../../../coach module/schedul session/data/entity/session_schedule_entity.dart';

abstract class LessonScheduleState {}

class LessonScheduleInitial extends LessonScheduleState {}

class LessonScheduleLoading extends LessonScheduleState {}

class LessonScheduleLoaded extends LessonScheduleState {
  final List<ScheduleModel> schedules;
  final List<SessionModel> allSessions;
  final SessionModel? nextLevelSession;

  LessonScheduleLoaded({
    required this.schedules,
    required this.allSessions,
    this.nextLevelSession,
  });
}

class LessonScheduleError extends LessonScheduleState {
  final String message;
  LessonScheduleError(this.message);
}
