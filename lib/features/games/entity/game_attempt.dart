import 'package:equatable/equatable.dart';

class GameAttempt extends Equatable {
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

  const GameAttempt({
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

  @override
  List<Object?> get props => [
    id,
    pupilId,
    gameId,
    gameTitle,
    levelNumber,
    attemptNumber,
    startedAt,
    completedAt,
    status,
    timePlayed,
    createdAt,
    updatedAt,
    watchedDuration,
    totalVideoDuration,
    isCompleted,
    pauseCount,
    lastWatchPosition,
    wasSkipped,
  ];

  GameAttempt copyWith({
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
  }) => GameAttempt(
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
}
