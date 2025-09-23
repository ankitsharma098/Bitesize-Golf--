// lib/presentation/screens/books/bloc/book_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../Models/book model/book_model.dart';
import '../../../../../Models/book progress model/book_progress_model.dart';
import '../data/book_repo.dart';
import 'book_event.dart';
import 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository _repository = BookRepository();

  BookBloc() : super(BookInitial()) {
    on<LoadBook>(_onLoadBook);
    on<UpdateReadingProgress>(_onUpdateReadingProgress);
    on<CompleteBook>(_onCompleteBook);
    on<StartReading>(_onStartReading);
  }

  Future<void> _onLoadBook(LoadBook event, Emitter<BookState> emit) async {
    emit(BookLoading());

    try {
      BookModel? book;

      // First try to get book by ID if provided
      if (event.bookId.isNotEmpty) {
        book = await _repository.getBookById(event.bookId);
      }

      // If no book found by ID, get first book by level
      book ??= await _repository.getFirstBookByLevel(event.levelNumber);

      if (book == null) {
        emit(const BookError(message: 'No book found for this level'));
        return;
      }

      // Get user's progress for this book
      final progress = await _repository.getCurrentUserBookProgress(book.id);
      final isFirstTime = progress == null;

      emit(
        BookLoaded(book: book, progress: progress, isFirstTime: isFirstTime),
      );
    } catch (e) {
      emit(BookError(message: e.toString()));
    }
  }

  Future<void> _onStartReading(
    StartReading event,
    Emitter<BookState> emit,
  ) async {
    if (state is BookLoaded) {
      final currentState = state as BookLoaded;

      try {
        // Show loading state briefly
        emit(BookLoading());

        // Initialize reading progress if first time
        BookProgress? initialProgress = currentState.progress;

        if (initialProgress == null) {
          initialProgress = await _repository.initializeBookProgress(
            currentState.book.id,
            currentState.book.levelNumber,
            currentState.book.totalPages,
          );
        }

        // Emit the loaded state with reading mode enabled
        emit(
          BookLoaded(
            book: currentState.book,
            progress: initialProgress,
            isFirstTime: false, // Now we're in reading mode
          ),
        );
      } catch (e) {
        emit(BookError(message: e.toString()));
      }
    } else {
      emit(const BookError(message: 'Cannot start reading at this time'));
    }
  }

  Future<void> _onUpdateReadingProgress(
    UpdateReadingProgress event,
    Emitter<BookState> emit,
  ) async {
    if (state is BookLoaded) {
      final currentState = state as BookLoaded;

      try {
        final updatedProgress = await _repository.updateBookProgress(
          bookId: currentState.book.id,
          levelNumber: currentState.book.levelNumber,
          totalPages: currentState.book.totalPages,
          pagesRead: event.currentPage,
        );

        emit(
          BookLoaded(
            book: currentState.book,
            progress: updatedProgress,
            isFirstTime: false,
          ),
        );
      } catch (e) {
        // Don't emit error for progress updates, just continue silently
        // This prevents disrupting the reading experience
      }
    }
  }

  Future<void> _onCompleteBook(
    CompleteBook event,
    Emitter<BookState> emit,
  ) async {
    if (state is BookLoaded) {
      final currentState = state as BookLoaded;

      try {
        final completedProgress = await _repository.completeBook(
          currentState.book.id,
          currentState.book.levelNumber,
          currentState.book.totalPages,
        );

        emit(
          BookLoaded(
            book: currentState.book,
            progress: completedProgress,
            isFirstTime: false,
          ),
        );
      } catch (e) {
        emit(BookError(message: e.toString()));
      }
    }
  }
}
