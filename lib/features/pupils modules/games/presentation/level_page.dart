import 'package:bitesize_golf/features/pupils%20modules/games/presentation/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/theme_colors.dart';
import '../../../components/custom_scaffold.dart';
import '../../../components/pupil_level_card.dart';
import '../../../components/utils/size_config.dart';
import '../../home/home bloc/home_bloc.dart';
import '../../home/home bloc/home_event.dart';
import '../../home/home bloc/home_state.dart';

class LevelPage extends StatefulWidget {
  const LevelPage({super.key});

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && context.mounted) {
        context.read<PupilHomeBloc>().add(const LoadHomeData());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Pupil home screen");
    return AppScaffold.withCustomAppBar(
      customPadding: EdgeInsets.all(5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Home',
            style: TextStyle(
              color: AppColors.grey900,
              fontSize: SizeConfig.scaleText(25),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      scrollable: true,
      body: BlocBuilder<PupilHomeBloc, PupilHomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return _buildLoadingState();
          }
          if (state is HomeError) {
            return _buildErrorState(state.message);
          }
          if (state is HomeLoaded) {
            return _buildHomeContent(state);
          }
          return _buildInitialState();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenDark),
          ),
          SizedBox(height: SizeConfig.scaleHeight(16)),
          Text('Loading levels...', style: TextStyle(color: AppColors.grey600)),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: SizeConfig.scaleWidth(64),
            color: AppColors.error,
          ),
          SizedBox(height: SizeConfig.scaleHeight(16)),
          Text(
            'Unable to load levels',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.grey900,
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(8)),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey600),
          ),
          SizedBox(height: SizeConfig.scaleHeight(24)),
          ElevatedButton(
            onPressed: () =>
                context.read<PupilHomeBloc>().add(const RefreshHome()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greenDark,
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.scaleWidth(24),
                vertical: SizeConfig.scaleHeight(12),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
              ),
            ),
            child: Text('Try Again', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Text(
        'Loading levels...',
        style: TextStyle(color: AppColors.grey600),
      ),
    );
  }

  Widget _buildHomeContent(HomeLoaded state) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.scaleWidth(5)),
      child: Column(
        children: [
          ...state.levels.map((level) {
            bool isUnlocked =
                state.pupil.unlockedLevels.contains(level.levelNumber) ||
                    level.levelNumber <= state.pupil.currentLevel;
            bool isCompleted = level.levelNumber < state.pupil.currentLevel;
            return CustomLevelCard(
              levelName: level.name,
              levelNumber: level.levelNumber,
              isUnlocked: isUnlocked,
              isCompleted: isCompleted,
              onTap: () => _navigateToLevel(level.levelNumber, level.name),
            );
          }),
          SizedBox(height: SizeConfig.scaleHeight(100)),
        ],
      ),
    );
  }

  void _navigateToLevel(int levelNumber, String levelName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GameWelcomePage(),
        settings: RouteSettings(
          arguments: {
            'levelNumber': levelNumber,
            'levelName': levelName,
          },
        ),
      ),
    );
  }
}