import 'package:equatable/equatable.dart';

class Game extends Equatable {
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

  const Game({
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

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    levelNumber,
    videoUrl,
    thumbnailUrl,
    estimatedTime,
    accessTier,
    isActive,
    sortOrder,
    createdAt,
    updatedAt,
    createdBy,
    category,
    tipText,
    videoDurationSeconds,
  ];

  Game copyWith({
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
  }) => Game(
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
}
