import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final String description;
  final int estimatedReadTime; // minutes
  final int levelNumber; // 1-10

  // Media
  final String pdfUrl;

  // Access control
  final String accessTier; // 'free', 'basic', 'premium'

  // Status
  final bool isActive;
  final DateTime? publishedAt;

  // Ordering
  final int sortOrder;

  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  const Book({
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

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    estimatedReadTime,
    levelNumber,
    pdfUrl,
    accessTier,
    isActive,
    publishedAt,
    sortOrder,
    createdAt,
    updatedAt,
    createdBy,
  ];

  Book copyWith({
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
  }) => Book(
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
}
