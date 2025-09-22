import 'package:cloud_firestore/cloud_firestore.dart';

class GameAttemptModel {
  final String id;
  final String pupilId;
  final String gameId;
  final String gameTitle;
  final int levelNumber;
  final int attemptNumber;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String status;
  final int timePlayed;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int watchedDuration;
  final int totalVideoDuration;
  final bool isCompleted;
  final int pauseCount;
  final DateTime? lastWatchPosition;
  final bool wasSkipped;

  const GameAttemptModel({
    required this.id,
    required this.pupilId,
    required this.gameId,
    required this.gameTitle,
    required this.levelNumber,
    required this.attemptNumber,
    required this.startedAt,
    this.completedAt,
    required this.status,
    required this.timePlayed,
    required this.createdAt,
    required this.updatedAt,
    required this.watchedDuration,
    required this.totalVideoDuration,
    required this.isCompleted,
    required this.pauseCount,
    this.lastWatchPosition,
    required this.wasSkipped,
  });

  factory GameAttemptModel.create({
    required String id,
    required String pupilId,
    required String gameId,
    required String gameTitle,
    required int levelNumber,
    required int attemptNumber,
    required DateTime startedAt,
    String status = 'started',
    int timePlayed = 0,
    int watchedDuration = 0,
    required int totalVideoDuration,
    bool isCompleted = false,
    int pauseCount = 0,
    bool wasSkipped = false,
  }) {
    final now = DateTime.now();
    return GameAttemptModel(
      id: id,
      pupilId: pupilId,
      gameId: gameId,
      gameTitle: gameTitle,
      levelNumber: levelNumber,
      attemptNumber: attemptNumber,
      startedAt: startedAt,
      completedAt: null,
      status: status,
      timePlayed: timePlayed,
      createdAt: now,
      updatedAt: now,
      watchedDuration: watchedDuration,
      totalVideoDuration: totalVideoDuration,
      isCompleted: isCompleted,
      pauseCount: pauseCount,
      lastWatchPosition: null,
      wasSkipped: wasSkipped,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'pupilId': pupilId,
    'gameId': gameId,
    'gameTitle': gameTitle,
    'levelNumber': levelNumber,
    'attemptNumber': attemptNumber,
    'startedAt': Timestamp.fromDate(startedAt),
    'completedAt': completedAt == null
        ? null
        : Timestamp.fromDate(completedAt!),
    'status': status,
    'timePlayed': timePlayed,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
    'watchedDuration': watchedDuration,
    'totalVideoDuration': totalVideoDuration,
    'isCompleted': isCompleted,
    'pauseCount': pauseCount,
    'lastWatchPosition': lastWatchPosition == null
        ? null
        : Timestamp.fromDate(lastWatchPosition!),
    'wasSkipped': wasSkipped,
  };

  factory GameAttemptModel.fromFirestore(Map<String, dynamic> json) =>
      GameAttemptModel(
        id: json['id'] ?? '',
        pupilId: json['pupilId'] ?? '',
        gameId: json['gameId'] ?? '',
        gameTitle: json['gameTitle'] ?? '',
        levelNumber: json['levelNumber'] ?? 1,
        attemptNumber: json['attemptNumber'] ?? 1,
        startedAt: _toDateTime(json['startedAt']),
        completedAt: _toDateTime(json['completedAt']),
        status: json['status'] ?? 'started',
        timePlayed: json['timePlayed'] ?? 0,
        createdAt: _toDateTime(json['createdAt']),
        updatedAt: _toDateTime(json['updatedAt']),
        watchedDuration: json['watchedDuration'] ?? 0,
        totalVideoDuration: json['totalVideoDuration'] ?? 0,
        isCompleted: json['isCompleted'] ?? false,
        pauseCount: json['pauseCount'] ?? 0,
        lastWatchPosition: _toDateTime(json['lastWatchPosition']),
        wasSkipped: json['wasSkipped'] ?? false,
      );

  GameAttemptModel copyWith({
    String? id,
    String? pupilId,
    String? gameId,
    String? gameTitle,
    int? levelNumber,
    int? attemptNumber,
    DateTime? startedAt,
    DateTime? completedAt,
    String? status,
    int? timePlayed,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? watchedDuration,
    int? totalVideoDuration,
    bool? isCompleted,
    int? pauseCount,
    DateTime? lastWatchPosition,
    bool? wasSkipped,
  }) => GameAttemptModel(
    id: id ?? this.id,
    pupilId: pupilId ?? this.pupilId,
    gameId: gameId ?? this.gameId,
    gameTitle: gameTitle ?? this.gameTitle,
    levelNumber: levelNumber ?? this.levelNumber,
    attemptNumber: attemptNumber ?? this.attemptNumber,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt ?? this.completedAt,
    status: status ?? this.status,
    timePlayed: timePlayed ?? this.timePlayed,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    watchedDuration: watchedDuration ?? this.watchedDuration,
    totalVideoDuration: totalVideoDuration ?? this.totalVideoDuration,
    isCompleted: isCompleted ?? this.isCompleted,
    pauseCount: pauseCount ?? this.pauseCount,
    lastWatchPosition: lastWatchPosition ?? this.lastWatchPosition,
    wasSkipped: wasSkipped ?? this.wasSkipped,
  );

  static DateTime _toDateTime(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is String) return DateTime.parse(v);
    return DateTime.now();
  }
}
