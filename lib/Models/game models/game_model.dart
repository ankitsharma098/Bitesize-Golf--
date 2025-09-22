import 'package:cloud_firestore/cloud_firestore.dart';

class GameModel {
  final String id;
  final String title;
  final String description;
  final int levelNumber;
  final String videoUrl;
  final String? thumbnailUrl;
  final int estimatedTime;
  final String accessTier;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String category;
  final String tipText;
  final int videoDurationSeconds;

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

  Map<String, dynamic> toFirestore() => {
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

  factory GameModel.fromFirestore(Map<String, dynamic> json) => GameModel(
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

  static DateTime _toDateTime(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is String) return DateTime.parse(v);
    return DateTime.now();
  }
}
