// lib/presentation/screens/books/book_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Models/level model/level_model.dart';
import '../../../../../core/themes/theme_colors.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_scaffold.dart';
import '../../../../components/utils/size_config.dart';
import '../book bloc/book_bloc.dart';
import '../book bloc/book_event.dart';
import '../book bloc/book_state.dart';
import 'book_reader_widget.dart';
import 'book_welcome_widget.dart';

class BookScreen extends StatelessWidget {
  final LevelModel levelModel;
  final String? bookId;

  const BookScreen({super.key, required this.levelModel, this.bookId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookBloc()
        ..add(
          LoadBook(bookId: bookId ?? '', levelNumber: levelModel.levelNumber),
        ),
      child: _BookScreenView(levelModel: levelModel),
    );
  }
}

class _BookScreenView extends StatelessWidget {
  final LevelModel levelModel;

  const _BookScreenView({required this.levelModel});

  @override
  Widget build(BuildContext context) {
    return AppScaffold.levelScreen(
      title: '${_getLevelTypeFromModel().name} Book',
      levelType: _getLevelTypeFromModel(),
      actions: [
        IconButton(
          icon: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.redLight.withOpacity(0.5),
            ),
            child: Icon(Icons.close, color: AppColors.grey900),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      showBackButton: true,
      scrollable: false,
      body: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          if (state is BookLoading) {
            return _buildLoadingState();
          } else if (state is BookError) {
            return _buildErrorState(context, state.message);
          } else if (state is BookLoaded) {
            return _buildLoadedState(context, state);
          }
          return _buildLoadingState();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(color: _getLevelTypeFromModel().color),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.scaleWidth(24)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: SizeConfig.scaleWidth(60),
              color: AppColors.grey500,
            ),
            SizedBox(height: SizeConfig.scaleHeight(16)),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: SizeConfig.scaleText(18),
                fontWeight: FontWeight.w600,
                color: AppColors.grey700,
              ),
            ),
            SizedBox(height: SizeConfig.scaleHeight(8)),
            Text(
              message,
              style: TextStyle(
                fontSize: SizeConfig.scaleText(14),
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.scaleHeight(24)),
            CustomButtonFactory.primary(
              levelType: _getLevelTypeFromModel(),
              onPressed: () => Navigator.of(context).pop(),
              text: 'Go Back',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, BookLoaded state) {
    if (state.isFirstTime) {
      return BookWelcomeWidget(
        book: state.book,
        levelType: _getLevelTypeFromModel(),
        onStartReading: () {
          context.read<BookBloc>().add(const StartReading());
        },
      );
    } else {
      return BookReaderWidget(
        book: state.book,
        progress: state.progress,
        levelType: _getLevelTypeFromModel(),
        onPageChanged: (page) {
          context.read<BookBloc>().add(
            UpdateReadingProgress(currentPage: page),
          );
        },
        onComplete: () {
          context.read<BookBloc>().add(const CompleteBook());
        },
      );
    }
  }

  LevelType _getLevelTypeFromModel() {
    switch (levelModel.levelNumber) {
      case 1:
        return LevelType.redLevel;
      case 2:
        return LevelType.orangeLevel;
      case 3:
        return LevelType.yellowLevel;
      case 4:
        return LevelType.greenLevel;
      case 5:
        return LevelType.blueLevel;
      case 6:
        return LevelType.indigoLevel;
      case 7:
        return LevelType.violetLevel;
      case 8:
        return LevelType.coralLevel;
      case 9:
        return LevelType.silverLevel;
      case 10:
        return LevelType.goldLevel;
      default:
        return LevelType.redLevel;
    }
  }
}
