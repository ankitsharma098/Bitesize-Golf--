import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

enum SessionStatus { scheduled, completed, cancelled }

enum ScheduleStatus { draft, sent, active, completed }

class SessionModel {
  final int sessionNumber;
  final DateTime date;
  final String time;
  final SessionStatus status;
  final bool isLevelTransition;

  const SessionModel({
    required this.sessionNumber,
    required this.date,
    required this.time,
    required this.status,
    this.isLevelTransition = false,
  });

  /* --------------------- copyWith --------------------- */
  SessionModel copyWith({
    int? sessionNumber,
    DateTime? date,
    String? time,
    SessionStatus? status,
    bool? isLevelTransition,
  }) {
    return SessionModel(
      sessionNumber: sessionNumber ?? this.sessionNumber,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      isLevelTransition: isLevelTransition ?? this.isLevelTransition,
    );
  }

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

  /* --------------------- Firestore --------------------- */
  Map<String, dynamic> toFirestore() => {
    'sessionNumber': sessionNumber,
    'date': Timestamp.fromDate(date),
    'time': time,
    'status': status.name,
    'isLevelTransition': isLevelTransition,
  };

  factory SessionModel.fromFirestore(Map<String, dynamic> json) => SessionModel(
    sessionNumber: json['sessionNumber'] ?? 1,
    date: _toDateTime(json['date']),
    time: json['time'] ?? '00:00',
    status: _parseSessionStatus(json['status']),
    isLevelTransition: json['isLevelTransition'] ?? false,
  );

  /* --------------------- Helpers --------------------- */
  static DateTime _parseDate(dynamic value) {
    if (value is String) {
      try {
        return DateFormat('MM/dd/yyyy').parse(value);
      } catch (_) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  static DateTime _toDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }

  static SessionStatus _parseSessionStatus(dynamic value) {
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'scheduled':
          return SessionStatus.scheduled;
        case 'completed':
          return SessionStatus.completed;
        case 'cancelled':
          return SessionStatus.cancelled;
      }
    }
    return SessionStatus.scheduled;
  }
}

class ScheduleModel {
  final String id;
  final String coachId;
  final String clubId;
  final int levelNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ScheduleStatus status;
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
    ScheduleStatus status = ScheduleStatus.draft,
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
    createdAt: SessionModel._toDateTime(json['createdAt']),
    updatedAt: SessionModel._toDateTime(json['updatedAt']),
    status: _parseScheduleStatus(json['status']),
    pupilIds: List<String>.from(json['pupilIds'] ?? []),
    sessions: _parseSessionsFromJson(json['sessions']),
    notes: json['notes'] ?? '',
  );

  /* --------------------- Firestore --------------------- */

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'coachId': coachId,
    'clubId': clubId,
    'levelNumber': levelNumber,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
    'status': status.name,
    'pupilIds': pupilIds,
    'sessions': _sessionsToFirestore(),
    'notes': notes,
  };

  factory ScheduleModel.fromFirestore(Map<String, dynamic> json) =>
      ScheduleModel(
        id: json['id'] ?? '',
        coachId: json['coachId'] ?? '',
        clubId: json['clubId'] ?? '',
        levelNumber: json['levelNumber'] ?? 1,
        createdAt: SessionModel._toDateTime(json['createdAt']),
        updatedAt: SessionModel._toDateTime(json['updatedAt']),
        status: _parseScheduleStatus(json['status']),
        pupilIds: List<String>.from(json['pupilIds'] ?? []),
        sessions: _parseSessionsFromFirestore(json['sessions']),
        notes: json['notes'] ?? '',
      );

  /* --------------------- copyWith --------------------- */

  ScheduleModel copyWith({
    String? id,
    String? coachId,
    String? clubId,
    int? levelNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    ScheduleStatus? status,
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

  static ScheduleStatus _parseScheduleStatus(dynamic value) {
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'draft':
          return ScheduleStatus.draft;
        case 'sent':
          return ScheduleStatus.sent;
        case 'active':
          return ScheduleStatus.active;
        case 'completed':
          return ScheduleStatus.completed;
        default:
          return ScheduleStatus.draft;
      }
    }
    return ScheduleStatus.draft;
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

  Map<String, dynamic> _sessionsToFirestore() {
    final Map<String, dynamic> sessionMap = {};
    for (int i = 0; i < sessions.length; i++) {
      final session = sessions[i];
      if (session.isLevelTransition) {
        sessionMap['nextLevelStart'] = session.toFirestore();
      } else {
        sessionMap['session${i + 1}'] = session.toFirestore();
      }
    }
    return sessionMap;
  }

  static List<SessionModel> _parseSessionsFromJson(dynamic sessionsData) {
    final List<SessionModel> sessionsList = [];

    if (sessionsData is Map<String, dynamic>) {
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

  static List<SessionModel> _parseSessionsFromFirestore(dynamic sessionsData) {
    final List<SessionModel> sessionsList = [];

    if (sessionsData is Map<String, dynamic>) {
      final sortedKeys = sessionsData.keys.toList()
        ..sort((a, b) {
          if (a == 'nextLevelStart') return 1;
          if (b == 'nextLevelStart') return -1;
          return a.compareTo(b);
        });

      for (String key in sortedKeys) {
        final sessionData = sessionsData[key];
        if (sessionData is Map<String, dynamic>) {
          sessionsList.add(SessionModel.fromFirestore(sessionData));
        }
      }
    }

    return sessionsList;
  }
}
