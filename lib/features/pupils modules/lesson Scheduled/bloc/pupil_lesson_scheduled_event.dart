abstract class LessonScheduleEvent {}

class LoadLessonSchedule extends LessonScheduleEvent {
  final String pupilId;
  LoadLessonSchedule(this.pupilId);
}
