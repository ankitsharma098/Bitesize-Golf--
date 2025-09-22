import '../../../../Models/scheduled model/scheduled_model.dart';

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
