import 'package:cloud_firestore/cloud_firestore.dart';

import '../entity/game_entity.dart' as entity;

class GameModel {
  final String id;
  final String title;
  final String description;
  final int levelNumber;
  final String videoUrl;
  final String? thumbnailUrl;
  final int estimatedTime; // video duration in minutes
  final String accessTier;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String category; // 'chipping', 'iron', 'putting', 'wood'
  final String tipText; // The tip shown in the gray box
  final int videoDurationSeconds; // Actual video length

  const GameModel({
    required this.id,
    required this.title,
    required this.description,
    required this.levelNumber,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.estimatedTime,
    required this.accessTier,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.category,
    required this.tipText,
    required this.videoDurationSeconds,
  });

  /* --------------------- Factories --------------------- */

  factory GameModel.create({
    required String id,
    required String title,
    required String description,
    required int levelNumber,
    required String videoUrl,
    String? thumbnailUrl,
    required int estimatedTime,
    String accessTier = 'free',
    bool isActive = true,
    int sortOrder = 0,
    String createdBy = '',
    required String category,
    required String tipText,
    required int videoDurationSeconds,
  }) {
    final now = DateTime.now();
    return GameModel(
      id: id,
      title: title,
      description: description,
      levelNumber: levelNumber,
      videoUrl: videoUrl,
      thumbnailUrl: thumbnailUrl,
      estimatedTime: estimatedTime,
      accessTier: accessTier,
      isActive: isActive,
      sortOrder: sortOrder,
      createdAt: now,
      updatedAt: now,
      createdBy: createdBy,
      category: category,
      tipText: tipText,
      videoDurationSeconds: videoDurationSeconds,
    );
  }

  /* --------------------- JSON --------------------- */

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'levelNumber': levelNumber,
    'videoUrl': videoUrl,
    'thumbnailUrl': thumbnailUrl,
    'estimatedTime': estimatedTime,
    'accessTier': accessTier,
    'isActive': isActive,
    'sortOrder': sortOrder,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
    'createdBy': createdBy,
    'category': category,
    'tipText': tipText,
    'videoDurationSeconds': videoDurationSeconds,
  };

  factory GameModel.fromJson(Map<String, dynamic> json) => GameModel(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    levelNumber: json['levelNumber'] ?? 1,
    videoUrl: json['videoUrl'] ?? '',
    thumbnailUrl: json['thumbnailUrl'],
    estimatedTime: json['estimatedTime'] ?? 0,
    accessTier: json['accessTier'] ?? 'free',
    isActive: json['isActive'] ?? true,
    sortOrder: json['sortOrder'] ?? 0,
    createdAt: _toDateTime(json['createdAt']),
    updatedAt: _toDateTime(json['updatedAt']),
    createdBy: json['createdBy'] ?? '',
    category: json['category'] ?? '',
    tipText: json['tipText'] ?? '',
    videoDurationSeconds: json['videoDurationSeconds'] ?? 0,
  );

  factory GameModel.fromFirestore(Map<String, dynamic> json) =>
      GameModel.fromJson(json);

  /* --------------------- Entity mapping --------------------- */

  entity.Game toEntity() => entity.Game(
    id: id,
    title: title,
    description: description,
    levelNumber: levelNumber,
    videoUrl: videoUrl,
    thumbnailUrl: thumbnailUrl,
    estimatedTime: estimatedTime,
    accessTier: accessTier,
    isActive: isActive,
    sortOrder: sortOrder,
    createdAt: createdAt,
    updatedAt: updatedAt,
    createdBy: createdBy,
    category: category,
    tipText: tipText,
    videoDurationSeconds: videoDurationSeconds,
  );

  factory GameModel.fromEntity(entity.Game game) => GameModel(
    id: game.id,
    title: game.title,
    description: game.description,
    levelNumber: game.levelNumber,
    videoUrl: game.videoUrl,
    thumbnailUrl: game.thumbnailUrl,
    estimatedTime: game.estimatedTime,
    accessTier: game.accessTier,
    isActive: game.isActive,
    sortOrder: game.sortOrder,
    createdAt: game.createdAt,
    updatedAt: game.updatedAt,
    createdBy: game.createdBy,
    category: game.category,
    tipText: game.tipText,
    videoDurationSeconds: game.videoDurationSeconds,
  );

  /* --------------------- copyWith --------------------- */

  GameModel copyWith({
    String? id,
    String? title,
    String? description,
    int? levelNumber,
    String? videoUrl,
    String? thumbnailUrl,
    int? estimatedTime,
    String? accessTier,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? category,
    String? tipText,
    int? videoDurationSeconds,
  }) => GameModel(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    levelNumber: levelNumber ?? this.levelNumber,
    videoUrl: videoUrl ?? this.videoUrl,
    thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    estimatedTime: estimatedTime ?? this.estimatedTime,
    accessTier: accessTier ?? this.accessTier,
    isActive: isActive ?? this.isActive,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    createdBy: createdBy ?? this.createdBy,
    category: category ?? this.category,
    tipText: tipText ?? this.tipText,
    videoDurationSeconds: videoDurationSeconds ?? this.videoDurationSeconds,
  );

  /* --------------------- Helpers --------------------- */

  static DateTime _toDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }
}
