import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../Models/level model/level_model.dart';
import '../../../../../core/themes/asset_custom.dart';
import '../../../../../core/themes/theme_colors.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_scaffold.dart';
import '../../../../components/utils/size_config.dart';
import '../../book/presentation/pupil_book_screen.dart';
import '../bloc/level_overview__bloc.dart';
import '../bloc/level_overview__event.dart';
import '../bloc/level_overview__state.dart';
import '../data/model/level_overview_model.dart';

class LevelOverviewScreen extends StatelessWidget {
  final LevelModel levelModel;

  const LevelOverviewScreen({super.key, required this.levelModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LevelOverviewBloc()
            ..add(LoadLevelOverview(levelModel.levelNumber.toString())),
      child: _LevelOverviewView(levelModel: levelModel),
    );
  }
}

class _LevelOverviewView extends StatelessWidget {
  final LevelModel levelModel;

  const _LevelOverviewView({required this.levelModel});

  @override
  Widget build(BuildContext context) {
    return AppScaffold.levelScreen(
      title: '${_getLevelTypeFromModel().name} Overview',
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
      scrollable: true,
      body: BlocBuilder<LevelOverviewBloc, LevelOverviewState>(
        builder: (context, state) {
          if (state is LevelOverviewLoading) {
            return _buildLoadingState();
          } else if (state is LevelOverviewError) {
            return _buildErrorState(state.message);
          } else if (state is LevelOverviewLoaded) {
            return _buildLoadedState(context, state.data);
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

  Widget _buildErrorState(String message) {
    return Center(
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
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, LevelOverviewData data) {
    return Column(
      children: [
        // Cards Grid
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.scaleWidth(0),
            vertical: SizeConfig.scaleWidth(15),
          ),
          child: Column(
            children: [
              // First Row - Book and Quiz
              Row(
                children: [
                  Expanded(
                    child: _buildOverviewCard(
                      title: 'Book',
                      progress:
                          '${data.bookPagesRead}/${data.totalBookPages} pages',
                      subtitle: 'read',
                      buttonText: 'Start Reading',
                      assetPath: BallAssetProvider.getKnowBall(
                        _getLevelTypeFromModel(),
                      ),
                      onPressed: () => _navigateToBook(context),
                      progressValue: data.totalBookPages > 0
                          ? data.bookPagesRead / data.totalBookPages
                          : 0.0,
                    ),
                  ),
                  SizedBox(width: SizeConfig.scaleWidth(12)),
                  Expanded(
                    child: _buildOverviewCard(
                      title: 'Quiz',
                      progress:
                          '${data.quizQuestionsAnswered}/${data.totalQuizQuestions} questions',
                      subtitle: 'answered',
                      buttonText: 'Continue Quiz',
                      assetPath: BallAssetProvider.getSwingBall(
                        _getLevelTypeFromModel(),
                      ),
                      onPressed: () => _navigateToQuiz(context),
                      progressValue: data.totalQuizQuestions > 0
                          ? data.quizQuestionsAnswered / data.totalQuizQuestions
                          : 0.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.scaleHeight(16)),

              // Second Row - Challenges and Games
              Row(
                children: [
                  Expanded(
                    child: _buildOverviewCard(
                      title: 'Challenges',
                      progress:
                          '${data.challengesCompleted}/${data.totalChallenges} challenges',
                      subtitle: 'completed',
                      buttonText: 'Start Challenges',
                      assetPath: BallAssetProvider.getSwingBall(
                        _getLevelTypeFromModel(),
                      ),
                      onPressed: () => _navigateToChallenges(context),
                      progressValue: data.totalChallenges > 0
                          ? data.challengesCompleted / data.totalChallenges
                          : 0.0,
                    ),
                  ),
                  SizedBox(width: SizeConfig.scaleWidth(12)),
                  Expanded(
                    child: _buildOverviewCard(
                      title: 'Games',
                      progress: '${data.gamesMarked}/${data.totalGames} games',
                      subtitle: 'marked as done',
                      buttonText: 'Start Games',
                      assetPath: BallAssetProvider.getSwingOneBall(
                        _getLevelTypeFromModel(),
                      ),
                      onPressed: () => _navigateToGames(context),
                      progressValue: data.totalGames > 0
                          ? data.gamesMarked / data.totalGames
                          : 0.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: SizeConfig.scaleHeight(70)),

        // View Media Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(16)),
          child: CustomButtonFactory.faded(
            levelType: _getLevelTypeFromModel(),
            onPressed: () => _navigateToMedia(context),
            text: 'View Media',
          ),
        ),

        SizedBox(height: SizeConfig.scaleHeight(24)),
      ],
    );
  }

  Widget _buildOverviewCard({
    required String title,
    required String progress,
    required String subtitle,
    required String buttonText,
    required String assetPath,
    required VoidCallback onPressed,
    required double progressValue,
  }) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(16)),
      ),
      child: Column(
        children: [
          // Character Image
          SizedBox(
            height: SizeConfig.scaleHeight(80),
            child: Center(
              child: SvgPicture.asset(
                'assets/learn_balls/Level=Coral.svg',
                width: SizeConfig.scaleWidth(60),
                height: SizeConfig.scaleWidth(60),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.sports_golf,
                    size: SizeConfig.scaleWidth(40),
                    color: _getLevelTypeFromModel().color,
                  );
                },
              ),
            ),
          ),

          SizedBox(height: SizeConfig.scaleHeight(12)),

          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: SizeConfig.scaleText(18),
              fontWeight: FontWeight.bold,
              color: AppColors.grey900,
            ),
          ),

          SizedBox(height: SizeConfig.scaleHeight(8)),

          // Progress
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: progress.split(' ')[0], // The numbers part
                  style: TextStyle(
                    fontSize: SizeConfig.scaleText(14),
                    fontWeight: FontWeight.w600,
                    color: AppColors.greenDark,
                  ),
                ),
                TextSpan(
                  text: ' ${progress.split(' ').skip(1).join(' ')}\n$subtitle',
                  style: TextStyle(
                    fontSize: SizeConfig.scaleText(14),
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: SizeConfig.scaleHeight(16)),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: CustomButtonFactory.text(
              levelType: _getLevelTypeFromModel(),
              onPressed: onPressed,
              text: buttonText,
            ),
          ),
        ],
      ),
    );
  }

  // Helper Methods
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
        return _getLevelTypeByAccessTier();
    }
  }

  LevelType _getLevelTypeByAccessTier() {
    switch (levelModel.accessTier.toLowerCase()) {
      case 'red':
        return LevelType.redLevel;
      case 'orange':
        return LevelType.orangeLevel;
      case 'yellow':
        return LevelType.yellowLevel;
      case 'green':
        return LevelType.greenLevel;
      case 'blue':
        return LevelType.blueLevel;
      case 'indigo':
        return LevelType.indigoLevel;
      case 'violet':
        return LevelType.violetLevel;
      case 'coral':
        return LevelType.coralLevel;
      case 'silver':
        return LevelType.silverLevel;
      case 'gold':
        return LevelType.goldLevel;
      default:
        return LevelType.redLevel;
    }
  }

  // Navigation Methods
  void _navigateToBook(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookScreen(levelModel: levelModel),
      ),
    );
  }

  void _navigateToQuiz(BuildContext context) {
    // TODO: Navigate to quiz screen
    print('Navigate to Quiz');
  }

  void _navigateToChallenges(BuildContext context) {
    // TODO: Navigate to challenges screen
    print('Navigate to Challenges');
  }

  void _navigateToGames(BuildContext context) {
    // TODO: Navigate to games screen
    print('Navigate to Games');
  }

  void _navigateToMedia(BuildContext context) {
    // TODO: Navigate to media screen
    print('Navigate to Media');
  }
}
