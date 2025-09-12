import 'package:cloud_firestore/cloud_firestore.dart';

import '../entity/game_attempt.dart' as entity;

class GameAttemptModel {
  final String id;
  final String pupilId;
  final String gameId;
  final String gameTitle;
  final int levelNumber;
  final int attemptNumber;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String status; // 'started', 'paused', 'completed', 'abandoned'
  final int timePlayed; // seconds actually watched
  final DateTime createdAt;
  final DateTime updatedAt;
  final int watchedDuration; // How many seconds they actually watched
  final int totalVideoDuration; // Total video length
  final bool
  isCompleted; // Whether they watched enough to mark as complete (e.g., 80%+)
  final int pauseCount; // How many times they paused
  final DateTime?
  lastWatchPosition; // Where they left off if they didn't finish
  final bool wasSkipped; // If they hit "Next" before finishing

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

  /* --------------------- Factories --------------------- */

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
    String createdBy = '',
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

  /* --------------------- JSON --------------------- */

  Map<String, dynamic> toJson() => {
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

  factory GameAttemptModel.fromJson(Map<String, dynamic> json) =>
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

  factory GameAttemptModel.fromFirestore(Map<String, dynamic> json) =>
      GameAttemptModel.fromJson(json);

  /* --------------------- Entity mapping --------------------- */

  entity.GameAttempt toEntity() => entity.GameAttempt(
    id: id,
    pupilId: pupilId,
    gameId: gameId,
    gameTitle: gameTitle,
    levelNumber: levelNumber,
    attemptNumber: attemptNumber,
    startedAt: startedAt,
    completedAt: completedAt,
    status: status,
    timePlayed: timePlayed,
    createdAt: createdAt,
    updatedAt: updatedAt,
    watchedDuration: watchedDuration,
    totalVideoDuration: totalVideoDuration,
    isCompleted: isCompleted,
    pauseCount: pauseCount,
    lastWatchPosition: lastWatchPosition,
    wasSkipped: wasSkipped,
  );

  factory GameAttemptModel.fromEntity(entity.GameAttempt attempt) =>
      GameAttemptModel(
        id: attempt.id,
        pupilId: attempt.pupilId,
        gameId: attempt.gameId,
        gameTitle: attempt.gameTitle,
        levelNumber: attempt.levelNumber,
        attemptNumber: attempt.attemptNumber,
        startedAt: attempt.startedAt,
        completedAt: attempt.completedAt,
        status: attempt.status,
        timePlayed: attempt.timePlayed,
        createdAt: attempt.createdAt,
        updatedAt: attempt.updatedAt,
        watchedDuration: attempt.watchedDuration,
        totalVideoDuration: attempt.totalVideoDuration,
        isCompleted: attempt.isCompleted,
        pauseCount: attempt.pauseCount,
        lastWatchPosition: attempt.lastWatchPosition,
        wasSkipped: attempt.wasSkipped,
      );

  /* --------------------- copyWith --------------------- */

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

  /* --------------------- Helpers --------------------- */

  static DateTime _toDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }
}
