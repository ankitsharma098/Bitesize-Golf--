// lib/presentation/screens/books/bloc/book_state.dart
import 'package:equatable/equatable.dart';

import '../../../../../Models/book model/book_model.dart';
import '../../../../../Models/book progress model/book_progress_model.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  final BookModel book;
  final BookProgress? progress;
  final bool isFirstTime;

  const BookLoaded({
    required this.book,
    this.progress,
    required this.isFirstTime,
  });

  @override
  List<Object?> get props => [book, progress, isFirstTime];
}

class BookError extends BookState {
  final String message;

  const BookError({required this.message});

  @override
  List<Object?> get props => [message];
}

class BookProgressUpdated extends BookState {
  final BookProgress progress;

  const BookProgressUpdated({required this.progress});

  @override
  List<Object?> get props => [progress];
}
