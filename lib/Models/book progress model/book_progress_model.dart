import 'package:cloud_firestore/cloud_firestore.dart';

class BookProgress {
  final String userId; // Reference to the PupilModel id
  final String bookId; // Reference to the BookModel id
  final int pagesRead; // Number of pages read
  final int totalPages; // Total pages in the book
  final DateTime lastReadAt; // Last time the user read this book
  final bool isCompleted; // Whether the book is fully read
  final DateTime? completedAt; // When the book was completed (if applicable)

  BookProgress({
    required this.userId,
    required this.bookId,
    required this.pagesRead,
    required this.totalPages,
    required this.lastReadAt,
    this.isCompleted = false,
    this.completedAt,
  });

  // Factory to create a new BookProgress
  factory BookProgress.create({
    required String userId,
    required String bookId,
    required int totalPages,
    int pagesRead = 0,
    bool isCompleted = false,
  }) {
    final now = DateTime.now();
    return BookProgress(
      userId: userId,
      bookId: bookId,
      pagesRead: pagesRead,
      totalPages: totalPages,
      lastReadAt: now,
      isCompleted: isCompleted,
      completedAt: isCompleted ? now : null,
    );
  }

  // Convert to Firestore map
  Map<String, dynamic> toFirestore() => {
    'userId': userId,
    'bookId': bookId,
    'pagesRead': pagesRead,
    'totalPages': totalPages,
    'lastReadAt': Timestamp.fromDate(lastReadAt),
    'isCompleted': isCompleted,
    'completedAt': completedAt != null
        ? Timestamp.fromDate(completedAt!)
        : null,
  };

  // Create from Firestore data
  factory BookProgress.fromFirestore(Map<String, dynamic> json) => BookProgress(
    userId: json['userId'] ?? '',
    bookId: json['bookId'] ?? '',
    pagesRead: json['pagesRead'] ?? 0,
    totalPages: json['totalPages'] ?? 0,
    lastReadAt: _toDateTime(json['lastReadAt']),
    isCompleted: json['isCompleted'] ?? false,
    completedAt: json['completedAt'] != null
        ? _toDateTime(json['completedAt'])
        : null,
  );

  // Helper to parse DateTime
  static DateTime _toDateTime(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is String) return DateTime.parse(v);
    return DateTime.now();
  }

  // CopyWith for updating progress
  BookProgress copyWith({
    String? userId,
    String? bookId,
    int? pagesRead,
    int? totalPages,
    DateTime? lastReadAt,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return BookProgress(
      userId: userId ?? this.userId,
      bookId: bookId ?? this.bookId,
      pagesRead: pagesRead ?? this.pagesRead,
      totalPages: totalPages ?? this.totalPages,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
