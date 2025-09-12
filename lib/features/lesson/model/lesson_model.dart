import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../entity/lesson_entity.dart' as entity;

class LessonModel {
  final String id;
  final String title;
  final String description;
  final int estimatedReadTime;
  final int levelNumber;
  final String pdfUrl;
  final String accessTier;
  final bool isActive;
  final DateTime? publishedAt;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  const LessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.estimatedReadTime,
    required this.levelNumber,
    required this.pdfUrl,
    required this.accessTier,
    required this.isActive,
    this.publishedAt,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  /* --------------------- Factories --------------------- */

  factory LessonModel.create({
    required String id,
    required String title,
    required String description,
    required int estimatedReadTime,
    required int levelNumber,
    required String pdfUrl,
    String accessTier = 'free',
    bool isActive = true,
    DateTime? publishedAt,
    int sortOrder = 0,
    String createdBy = 'admin',
  }) {
    final now = DateTime.now();
    return LessonModel(
      id: id,
      title: title,
      description: description,
      estimatedReadTime: estimatedReadTime,
      levelNumber: levelNumber,
      pdfUrl: pdfUrl,
      accessTier: accessTier,
      isActive: isActive,
      publishedAt: publishedAt,
      sortOrder: sortOrder,
      createdAt: now,
      updatedAt: now,
      createdBy: createdBy,
    );
  }

  /* --------------------- JSON --------------------- */

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'estimatedReadTime': estimatedReadTime,
    'levelNumber': levelNumber,
    'pdfUrl': pdfUrl,
    'accessTier': accessTier,
    'isActive': isActive,
    'publishedAt': publishedAt == null
        ? null
        : Timestamp.fromDate(publishedAt!),
    'sortOrder': sortOrder,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
    'createdBy': createdBy,
  };

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    estimatedReadTime: json['estimatedReadTime'] ?? 0,
    levelNumber: json['levelNumber'] ?? 1,
    pdfUrl: json['pdfUrl'] ?? '',
    accessTier: json['accessTier'] ?? 'free',
    isActive: json['isActive'] ?? true,
    publishedAt: _toDateTime(json['publishedAt']),
    sortOrder: json['sortOrder'] ?? 0,
    createdAt: _toDateTime(json['createdAt']),
    updatedAt: _toDateTime(json['updatedAt']),
    createdBy: json['createdBy'] ?? 'admin',
  );

  factory LessonModel.fromFirestore(Map<String, dynamic> json) =>
      LessonModel.fromJson(json);

  /* --------------------- Entity mapping --------------------- */

  entity.Lesson toEntity() => entity.Lesson(
    id: id,
    title: title,
    description: description,
    estimatedReadTime: estimatedReadTime,
    levelNumber: levelNumber,
    pdfUrl: pdfUrl,
    accessTier: accessTier,
    isActive: isActive,
    publishedAt: publishedAt,
    sortOrder: sortOrder,
    createdAt: createdAt,
    updatedAt: updatedAt,
    createdBy: createdBy,
  );

  factory LessonModel.fromEntity(entity.Lesson lesson) => LessonModel(
    id: lesson.id,
    title: lesson.title,
    description: lesson.description,
    estimatedReadTime: lesson.estimatedReadTime,
    levelNumber: lesson.levelNumber,
    pdfUrl: lesson.pdfUrl,
    accessTier: lesson.accessTier,
    isActive: lesson.isActive,
    publishedAt: lesson.publishedAt,
    sortOrder: lesson.sortOrder,
    createdAt: lesson.createdAt,
    updatedAt: lesson.updatedAt,
    createdBy: lesson.createdBy,
  );

  /* --------------------- copyWith --------------------- */

  LessonModel copyWith({
    String? id,
    String? title,
    String? description,
    int? estimatedReadTime,
    int? levelNumber,
    String? pdfUrl,
    String? accessTier,
    bool? isActive,
    DateTime? publishedAt,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) => LessonModel(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    estimatedReadTime: estimatedReadTime ?? this.estimatedReadTime,
    levelNumber: levelNumber ?? this.levelNumber,
    pdfUrl: pdfUrl ?? this.pdfUrl,
    accessTier: accessTier ?? this.accessTier,
    isActive: isActive ?? this.isActive,
    publishedAt: publishedAt ?? this.publishedAt,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    createdBy: createdBy ?? this.createdBy,
  );

  /* --------------------- Helpers --------------------- */

  static DateTime _toDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }
}
