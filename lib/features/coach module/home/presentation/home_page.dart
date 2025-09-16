import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/level_utils.dart';
import '../../../../core/themes/theme_colors.dart';
import '../../../components/current_level_card.dart'; // New import
import '../../../components/custom_scaffold.dart';
import '../../../components/utils/size_config.dart';
import '../home bloc/home_bloc.dart';
import '../home bloc/home_event.dart';
import '../home bloc/home_state.dart';

class CoachHomeScreen extends StatefulWidget {
  const CoachHomeScreen({super.key});

  @override
  State<CoachHomeScreen> createState() => _CoachHomeScreenState();
}

class _CoachHomeScreenState extends State<CoachHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Add null check and context availability check
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && context.mounted) {
        context.read<CoachHomeBloc>().add(LoadHomeData());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withCustomAppBar(
      customPadding: EdgeInsets.all(0),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30), // Custom height
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
      body: BlocBuilder<CoachHomeBloc, CoachHomeState>(
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
            onPressed: () => context.read<CoachHomeBloc>().add(RefreshHome()),
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
      padding: EdgeInsets.all(SizeConfig.scaleWidth(0)),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.scaleHeight(10),
        ), // Vertical padding for the list
        itemCount: state.levels.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final level = state.levels[index];
          final levelType = LevelUtils.getLevelTypeFromNumber(
            level.levelNumber,
          );
          return Padding(
            padding: EdgeInsets.only(
              bottom: SizeConfig.scaleHeight(15),
            ), // Space between cards
            child: CurrentLevelCard(
              levelName: level.name,
              levelNumber: level.levelNumber,
              levelType: levelType,
              onMoreInfoTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'More Information for Level ${level.levelNumber}',
                    ),
                    backgroundColor: AppColors.greenDark,
                  ),
                );
              },
              onLevelTap: () => _navigateToLevel(level.levelNumber),
            ),
          );
        },
      ),
    );
  }

  void _navigateToLevel(int levelNumber) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to Level $levelNumber'),
        backgroundColor: AppColors.greenDark,
      ),
    );
  }
}
