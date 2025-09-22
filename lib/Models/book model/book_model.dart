import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
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

  const BookModel({
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

  factory BookModel.create({
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
    String createdBy = '',
  }) {
    final now = DateTime.now();
    return BookModel(
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

  Map<String, dynamic> toFirestore() => {
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

  factory BookModel.fromFirestore(Map<String, dynamic> json) => BookModel(
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
    createdBy: json['createdBy'] ?? '',
  );

  BookModel copyWith({
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
  }) => BookModel(
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

  static DateTime _toDateTime(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is String) return DateTime.parse(v);
    return DateTime.now();
  }
}
