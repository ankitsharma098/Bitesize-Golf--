import 'package:equatable/equatable.dart';

enum ScheduleStatus { draft, sent, active, completed }

enum SessionStatus { scheduled, completed, cancelled }

class Session extends Equatable {
  final int sessionNumber;
  final DateTime date;
  final String time;
  final SessionStatus status;
  final bool isLevelTransition;

  const Session({
    required this.sessionNumber,
    required this.date,
    required this.time,
    required this.status,
    this.isLevelTransition = false,
  });

  @override
  List<Object?> get props => [
    sessionNumber,
    date,
    time,
    status,
    isLevelTransition,
  ];

  Session copyWith({
    int? sessionNumber,
    DateTime? date,
    String? time,
    SessionStatus? status,
    bool? isLevelTransition,
  }) => Session(
    sessionNumber: sessionNumber ?? this.sessionNumber,
    date: date ?? this.date,
    time: time ?? this.time,
    status: status ?? this.status,
    isLevelTransition: isLevelTransition ?? this.isLevelTransition,
  );
}

class Schedule extends Equatable {
  final String id;
  final String coachId;
  final String clubId;
  final int levelNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ScheduleStatus status;
  final List<String> pupilIds;
  final List<Session> sessions;
  final String notes;

  const Schedule({
    required this.id,
    required this.coachId,
    required this.clubId,
    required this.levelNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.pupilIds,
    required this.sessions,
    required this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    coachId,
    clubId,
    levelNumber,
    createdAt,
    updatedAt,
    status,
    pupilIds,
    sessions,
    notes,
  ];

  Schedule copyWith({
    String? id,
    String? coachId,
    String? clubId,
    int? levelNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    ScheduleStatus? status,
    List<String>? pupilIds,
    List<Session>? sessions,
    String? notes,
  }) => Schedule(
    id: id ?? this.id,
    coachId: coachId ?? this.coachId,
    clubId: clubId ?? this.clubId,
    levelNumber: levelNumber ?? this.levelNumber,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    status: status ?? this.status,
    pupilIds: pupilIds ?? this.pupilIds,
    sessions: sessions ?? this.sessions,
    notes: notes ?? this.notes,
  );
}
