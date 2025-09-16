import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../entity/session_schedule_entity.dart' as entity;

class SessionModel {
  final int sessionNumber;
  final DateTime date;
  final String time;
  final entity.SessionStatus status;
  final bool isLevelTransition;

  const SessionModel({
    required this.sessionNumber,
    required this.date,
    required this.time,
    required this.status,
    this.isLevelTransition = false,
  });

  /* --------------------- JSON --------------------- */

  Map<String, dynamic> toJson() => {
    'sessionNumber': sessionNumber,
    'date': DateFormat('MM/dd/yyyy').format(date),
    'time': time,
    'status': status.name,
    'isLevelTransition': isLevelTransition,
  };

  factory SessionModel.fromJson(Map<String, dynamic> json) => SessionModel(
    sessionNumber: json['sessionNumber'] ?? 1,
    date: _parseDate(json['date']),
    time: json['time'] ?? '00:00',
    status: _parseSessionStatus(json['status']),
    isLevelTransition: json['isLevelTransition'] ?? false,
  );

  /* --------------------- Entity mapping --------------------- */

  entity.Session toEntity() => entity.Session(
    sessionNumber: sessionNumber,
    date: date,
    time: time,
    status: status,
    isLevelTransition: isLevelTransition,
  );

  factory SessionModel.fromEntity(entity.Session session) => SessionModel(
    sessionNumber: session.sessionNumber,
    date: session.date,
    time: session.time,
    status: session.status,
    isLevelTransition: session.isLevelTransition,
  );

  /* --------------------- Helpers --------------------- */

  static DateTime _parseDate(dynamic value) {
    if (value is String) {
      try {
        return DateFormat('MM/dd/yyyy').parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  static entity.SessionStatus _parseSessionStatus(dynamic value) {
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'scheduled':
          return entity.SessionStatus.scheduled;
        case 'completed':
          return entity.SessionStatus.completed;
        case 'cancelled':
          return entity.SessionStatus.cancelled;
        default:
          return entity.SessionStatus.scheduled;
      }
    }
    return entity.SessionStatus.scheduled;
  }
}

class ScheduleModel {
  final String id;
  final String coachId;
  final String clubId;
  final int levelNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final entity.ScheduleStatus status;
  final List<String> pupilIds;
  final List<SessionModel> sessions;
  final String notes;

  const ScheduleModel({
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

  /* --------------------- Factories --------------------- */

  factory ScheduleModel.create({
    required String id,
    required String coachId,
    required String clubId,
    required int levelNumber,
    entity.ScheduleStatus status = entity.ScheduleStatus.draft,
    List<String> pupilIds = const [],
    List<SessionModel> sessions = const [],
    String notes = '',
  }) {
    final now = DateTime.now();
    return ScheduleModel(
      id: id,
      coachId: coachId,
      clubId: clubId,
      levelNumber: levelNumber,
      createdAt: now,
      updatedAt: now,
      status: status,
      pupilIds: pupilIds,
      sessions: sessions,
      notes: notes,
    );
  }

  /* --------------------- JSON --------------------- */

  Map<String, dynamic> toJson() => {
    'id': id,
    'coachId': coachId,
    'clubId': clubId,
    'levelNumber': levelNumber,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
    'status': status.name,
    'pupilIds': pupilIds,
    'sessions': _sessionsToJson(),
    'notes': notes,
  };

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
    id: json['id'] ?? '',
    coachId: json['coachId'] ?? '',
    clubId: json['clubId'] ?? '',
    levelNumber: json['levelNumber'] ?? 1,
    createdAt: _toDateTime(json['createdAt']),
    updatedAt: _toDateTime(json['updatedAt']),
    status: _parseScheduleStatus(json['status']),
    pupilIds: List<String>.from(json['pupilIds'] ?? []),
    sessions: _parseSessionsFromJson(json['sessions']),
    notes: json['notes'] ?? '',
  );

  factory ScheduleModel.fromFirestore(Map<String, dynamic> json) =>
      ScheduleModel.fromJson(json);

  /* --------------------- Entity mapping --------------------- */

  entity.Schedule toEntity() => entity.Schedule(
    id: id,
    coachId: coachId,
    clubId: clubId,
    levelNumber: levelNumber,
    createdAt: createdAt,
    updatedAt: updatedAt,
    status: status,
    pupilIds: pupilIds,
    sessions: sessions.map((s) => s.toEntity()).toList(),
    notes: notes,
  );

  factory ScheduleModel.fromEntity(entity.Schedule schedule) => ScheduleModel(
    id: schedule.id,
    coachId: schedule.coachId,
    clubId: schedule.clubId,
    levelNumber: schedule.levelNumber,
    createdAt: schedule.createdAt,
    updatedAt: schedule.updatedAt,
    status: schedule.status,
    pupilIds: schedule.pupilIds,
    sessions: schedule.sessions.map((s) => SessionModel.fromEntity(s)).toList(),
    notes: schedule.notes,
  );

  /* --------------------- copyWith --------------------- */

  ScheduleModel copyWith({
    String? id,
    String? coachId,
    String? clubId,
    int? levelNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    entity.ScheduleStatus? status,
    List<String>? pupilIds,
    List<SessionModel>? sessions,
    String? notes,
  }) => ScheduleModel(
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

  /* --------------------- Helpers --------------------- */

  static DateTime _toDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }

  static entity.ScheduleStatus _parseScheduleStatus(dynamic value) {
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'draft':
          return entity.ScheduleStatus.draft;
        case 'sent':
          return entity.ScheduleStatus.sent;
        case 'active':
          return entity.ScheduleStatus.active;
        case 'completed':
          return entity.ScheduleStatus.completed;
        default:
          return entity.ScheduleStatus.draft;
      }
    }
    return entity.ScheduleStatus.draft;
  }

  Map<String, dynamic> _sessionsToJson() {
    final Map<String, dynamic> sessionMap = {};
    for (int i = 0; i < sessions.length; i++) {
      final session = sessions[i];
      if (session.isLevelTransition) {
        sessionMap['nextLevelStart'] = session.toJson();
      } else {
        sessionMap['session${i + 1}'] = session.toJson();
      }
    }
    return sessionMap;
  }

  static List<SessionModel> _parseSessionsFromJson(dynamic sessionsData) {
    final List<SessionModel> sessionsList = [];

    if (sessionsData is Map<String, dynamic>) {
      // Sort sessions by their keys to maintain order
      final sortedKeys = sessionsData.keys.toList()
        ..sort((a, b) {
          if (a == 'nextLevelStart') return 1;
          if (b == 'nextLevelStart') return -1;
          return a.compareTo(b);
        });

      for (String key in sortedKeys) {
        final sessionData = sessionsData[key];
        if (sessionData is Map<String, dynamic>) {
          sessionsList.add(SessionModel.fromJson(sessionData));
        }
      }
    }

    return sessionsList;
  }
}
