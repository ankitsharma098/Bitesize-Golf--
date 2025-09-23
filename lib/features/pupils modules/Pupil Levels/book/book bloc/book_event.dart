// lib/presentation/screens/books/bloc/book_event.dart
abstract class BookEvent {
  const BookEvent();
}

class LoadBook extends BookEvent {
  final String bookId;
  final int levelNumber;

  const LoadBook({required this.bookId, required this.levelNumber});
}

class StartReading extends BookEvent {
  const StartReading();
}

class UpdateReadingProgress extends BookEvent {
  final int currentPage;
  final bool saveImmediately; // For immediate saving vs batched updates

  const UpdateReadingProgress({
    required this.currentPage,
    this.saveImmediately = false,
  });
}

class CompleteBook extends BookEvent {
  const CompleteBook();
}

// New events for PDF handling
class PdfDocumentLoaded extends BookEvent {
  final int totalPages;

  const PdfDocumentLoaded({required this.totalPages});
}

class SaveProgressBatch extends BookEvent {
  const SaveProgressBatch();
}

class JumpToPage extends BookEvent {
  final int pageNumber;

  const JumpToPage({required this.pageNumber});
}

class BookmarkPage extends BookEvent {
  final int pageNumber;
  final String? note;

  const BookmarkPage({required this.pageNumber, this.note});
}
