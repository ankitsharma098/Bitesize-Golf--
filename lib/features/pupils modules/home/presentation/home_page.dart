import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/theme_colors.dart';
import '../../../components/custom_scaffold.dart';
import '../../../components/level_card.dart';
import '../../../components/utils/size_config.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const LoadDashboardData());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Home',
      screenType: ScreenType.content,
      scrollable: true,
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return _buildLoadingState();
          }

          if (state is DashboardError) {
            return _buildErrorState(state.message);
          }

          if (state is DashboardLoaded) {
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
          Text(
            'Loading your progress...',
            style: TextStyle(
              // fontSize: SizeConfig.scaleFont(16),
              color: AppColors.grey600,
            ),
          ),
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
            'Oops! Something went wrong',
            style: TextStyle(
              //fontSize: SizeConfig.scaleFont(18),
              fontWeight: FontWeight.w600,
              color: AppColors.grey900,
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(8)),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              // fontSize: SizeConfig.scaleFont(14),
              color: AppColors.grey600,
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(24)),
          ElevatedButton(
            onPressed: () {
              context.read<DashboardBloc>().add(const RefreshDashboard());
            },
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
            child: Text(
              'Try Again',
              style: TextStyle(
                //   fontSize: SizeConfig.scaleFont(16),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Text(
        'Welcome! Loading your golf journey...',
        style: TextStyle(
          // fontSize: SizeConfig.scaleFont(16),
          color: AppColors.grey600,
        ),
      ),
    );
  }

  Widget _buildHomeContent(DashboardLoaded state) {
    final levels = state.levels.take(4).toList(); // Show first 4 levels

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Welcome Section
        _buildWelcomeSection(state.pupil.name),
        SizedBox(height: SizeConfig.scaleHeight(24)),

        // Progress Overview
        _buildProgressOverview(state.pupil),
        SizedBox(height: SizeConfig.scaleHeight(24)),

        // Levels Section
        Text(
          'Your Levels',
          style: TextStyle(
            //fontSize: SizeConfig.scaleFont(20),
            fontWeight: FontWeight.w600,
            color: AppColors.grey900,
          ),
        ),
        SizedBox(height: SizeConfig.scaleHeight(16)),

        // Level Cards
        ...levels.map(
          (level) => LevelCard(
            level: level,
            pupil: state.pupil,
            onTap: () => _navigateToLevel(level.levelNumber),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(String name) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.scaleWidth(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(
                    // fontSize: SizeConfig.scaleFont(16),
                    color: AppColors.grey600,
                  ),
                ),
                SizedBox(height: SizeConfig.scaleHeight(4)),
                Text(
                  name,
                  style: TextStyle(
                    //fontSize: SizeConfig.scaleFont(24),
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey900,
                  ),
                ),
                SizedBox(height: SizeConfig.scaleHeight(8)),
                Text(
                  "Let's continue your golf journey!",
                  style: TextStyle(
                    //  fontSize: SizeConfig.scaleFont(14),
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.sports_golf,
            size: SizeConfig.scaleWidth(48),
            color: AppColors.greenDark,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressOverview(dynamic pupil) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.scaleWidth(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Progress',
            style: TextStyle(
              //fontSize: SizeConfig.scaleFont(18),
              fontWeight: FontWeight.w600,
              color: AppColors.grey900,
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(16)),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Current Level',
                  pupil.currentLevel.toString(),
                  Icons.flag,
                  AppColors.greenDark,
                ),
              ),
              SizedBox(width: SizeConfig.scaleWidth(12)),
              Expanded(
                child: _buildStatCard(
                  'Total XP',
                  pupil.totalXP.toString(),
                  Icons.star,
                  AppColors.warning,
                ),
              ),
              SizedBox(width: SizeConfig.scaleWidth(12)),
              Expanded(
                child: _buildStatCard(
                  'Streak',
                  '${pupil.streakDays} days',
                  Icons.local_fire_department,
                  AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.scaleWidth(12)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(12)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: SizeConfig.scaleWidth(24)),
          SizedBox(height: SizeConfig.scaleHeight(8)),
          Text(
            value,
            style: TextStyle(
              //  fontSize: SizeConfig.scaleFont(16),
              fontWeight: FontWeight.w700,
              color: AppColors.grey900,
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              // fontSize: SizeConfig.scaleFont(12),
              color: AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToLevel(int levelNumber) {
    // Navigate to level details screen
    context.read<DashboardBloc>().add(NavigateToLevel(levelNumber));

    // TODO: Implement navigation to level screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to Level $levelNumber'),
        backgroundColor: AppColors.greenDark,
      ),
    );
  }
}
