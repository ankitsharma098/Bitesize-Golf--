import 'package:bitesize_golf/core/utils/user_utils.dart';
import '../../../../../Models/book model/book_model.dart';
import '../../../../../Models/book progress model/book_progress_model.dart';
import '../../../../../core/constants/firebase_collections_names.dart';
import '../../../../../core/utils/pupil_progress_services.dart';

class BookRepository {
  final UserUtil _userUtil = UserUtil();
  final PupilProgressService _pupilProgressService = PupilProgressService();

  /// Get all books for a specific level
  Future<List<BookModel>> getBooksByLevel(int levelNumber) async {
    try {
      final querySnapshot = await FirestoreCollections.booksCol
          .where('levelNumber', isEqualTo: levelNumber)
          .where('isActive', isEqualTo: true)
          .orderBy('sortOrder')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return BookModel.fromFirestore(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch books by level: $e');
    }
  }

  /// Get a single book by ID
  Future<BookModel?> getBookById(String bookId) async {
    try {
      final doc = await FirestoreCollections.booksCol.doc(bookId).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return BookModel.fromFirestore(data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch book: $e');
    }
  }

  /// Get the first book for a specific level
  Future<BookModel?> getFirstBookByLevel(int levelNumber) async {
    try {
      final books = await getBooksByLevel(levelNumber);
      return books.isNotEmpty ? books.first : null;
    } catch (e) {
      throw Exception('Failed to fetch first book by level: $e');
    }
  }

  /// Get current user's book progress for a specific book
  Future<BookProgress?> getCurrentUserBookProgress(String bookId) async {
    try {
      final pupil = await _userUtil.getCurrentPupil();
      if (pupil == null) return null;

      final progressId = '${pupil.id}_$bookId';
      final doc = await FirestoreCollections.bookProgressCol
          .doc(progressId)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        return BookProgress.fromFirestore(data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch book progress: $e');
    }
  }

  /// Create or update book progress
  Future<BookProgress> updateBookProgress({
    required String bookId,
    required int levelNumber,
    required int totalPages,
    required int pagesRead,
    bool? isCompleted,
  }) async {
    try {
      final pupil = await _userUtil.getCurrentPupil();
      if (pupil == null) throw Exception('User not authenticated as pupil');

      final progressId = '${pupil.id}_$bookId';
      final now = DateTime.now();

      // Check if progress already exists
      final existingDoc = await FirestoreCollections.bookProgressCol
          .doc(progressId)
          .get();

      BookProgress progress;
      bool wasJustCompleted = false;

      if (existingDoc.exists && existingDoc.data() != null) {
        // Update existing progress
        final existingProgress = BookProgress.fromFirestore(
          existingDoc.data() as Map<String, dynamic>,
        );
        final completed = isCompleted ?? (pagesRead >= totalPages);

        // Check if book was just completed (wasn't completed before but is now)
        wasJustCompleted = !existingProgress.isCompleted && completed;

        progress = existingProgress.copyWith(
          pagesRead: pagesRead,
          totalPages: totalPages,
          lastReadAt: now,
          isCompleted: completed,
          completedAt: completed && !existingProgress.isCompleted
              ? now
              : existingProgress.completedAt,
        );
      } else {
        // Create new progress
        final completed = isCompleted ?? (pagesRead >= totalPages);
        wasJustCompleted = completed;

        progress = BookProgress.create(
          userId: pupil.id,
          bookId: bookId,
          totalPages: totalPages,
          pagesRead: pagesRead,
          isCompleted: completed,
        );
      }

      // Save to Firestore
      await FirestoreCollections.bookProgressCol
          .doc(progressId)
          .set(progress.toFirestore());

      // If book was just completed, update pupil progress
      if (wasJustCompleted) {
        await _pupilProgressService.updateBookCompletion(levelNumber);
        await _pupilProgressService.addXP(50); // Award XP for book completion

        // Check if level is completed
        final isLevelCompleted = await _pupilProgressService
            .checkLevelCompletion(levelNumber);
        if (isLevelCompleted) {
          await _pupilProgressService.completeLevelProgress(levelNumber);
          await _pupilProgressService.addXP(
            100,
          ); // Bonus XP for level completion
        }
      }

      return progress;
    } catch (e) {
      throw Exception('Failed to update book progress: $e');
    }
  }

  /// Mark book as completed
  Future<BookProgress> completeBook(
    String bookId,
    int levelNumber,
    int totalPages,
  ) async {
    return updateBookProgress(
      bookId: bookId,
      levelNumber: levelNumber,
      totalPages: totalPages,
      pagesRead: totalPages,
      isCompleted: true,
    );
  }

  /// Initialize book progress (for first-time reading)
  Future<BookProgress> initializeBookProgress(
    String bookId,
    int levelNumber,
    int totalPages,
  ) async {
    return updateBookProgress(
      bookId: bookId,
      levelNumber: levelNumber,
      totalPages: totalPages,
      pagesRead: 0,
      isCompleted: false,
    );
  }

  /// Get book progress for a specific level (useful for level overview)
  Future<List<BookProgress>> getBookProgressByLevel(int levelNumber) async {
    try {
      final pupil = await _userUtil.getCurrentPupil();
      if (pupil == null) return [];

      // First get all books for this level
      final books = await getBooksByLevel(levelNumber);
      if (books.isEmpty) return [];

      final bookIds = books.map((book) => book.id).toList();
      final List<BookProgress> progressList = [];

      // Get progress for each book in this level
      for (final bookId in bookIds) {
        final progress = await getCurrentUserBookProgress(bookId);
        if (progress != null) {
          progressList.add(progress);
        }
      }

      return progressList;
    } catch (e) {
      throw Exception('Failed to fetch book progress by level: $e');
    }
  }

  /// Check if user has started reading any book in a level
  Future<bool> hasStartedLevel(int levelNumber) async {
    try {
      final progressList = await getBookProgressByLevel(levelNumber);
      return progressList.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check level progress: $e');
    }
  }

  /// Get completion percentage for a level
  Future<double> getLevelCompletionPercentage(int levelNumber) async {
    try {
      final books = await getBooksByLevel(levelNumber);
      if (books.isEmpty) return 0.0;

      final progressList = await getBookProgressByLevel(levelNumber);

      int totalPages = books.fold(0, (sum, book) => sum + book.totalPages);
      int totalReadPages = progressList.fold(
        0,
        (sum, progress) => sum + progress.pagesRead,
      );

      return totalPages > 0 ? totalReadPages / totalPages : 0.0;
    } catch (e) {
      throw Exception('Failed to calculate level completion: $e');
    }
  }
}
