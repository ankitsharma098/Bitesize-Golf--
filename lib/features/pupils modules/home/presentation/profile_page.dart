import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/theme_colors.dart';
import '../../../components/current_level_card.dart';
import '../../../components/custom_scaffold.dart';
import '../../../components/profile_info_widget.dart';
import '../../../components/utils/size_config.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load dashboard data if not already loaded
    final bloc = context.read<DashboardBloc>();
    if (bloc.state is! DashboardLoaded) {
      bloc.add(const LoadDashboardData());
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Profile',
      screenType: ScreenType.fullScreen,
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
            return _buildProfileContent(state);
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
            'Loading your profile...',
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
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.scaleWidth(24)),
        child: Center(
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
                'Unable to load profile',
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
                  //  fontSize: SizeConfig.scaleFont(14),
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
                    borderRadius: BorderRadius.circular(
                      SizeConfig.scaleWidth(8),
                    ),
                  ),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(
                    // fontSize: SizeConfig.scaleFont(16),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return SafeArea(
      child: Center(
        child: Text(
          'Loading profile...',
          style: TextStyle(
            //  fontSize: SizeConfig.scaleFont(16),
            color: AppColors.grey600,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(DashboardLoaded state) {
    final currentLevel = state.levels.firstWhere(
      (level) => level.levelNumber == state.pupil.currentLevel,
      orElse: () => state.levels.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Header and Info
        ProfileInfoWidget(pupil: state.pupil),

        SizedBox(height: SizeConfig.scaleHeight(24)),

        // Current Level Card
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(24)),
          child: CurrentLevelCard(
            level: currentLevel,
            pupil: state.pupil,
            onMoreInfo: () => _showLevelInfo(currentLevel),
            onGoToLevel: () => _navigateToLevel(currentLevel.levelNumber),
          ),
        ),

        SizedBox(height: SizeConfig.scaleHeight(24)),

        // Statistics Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(24)),
          child: _buildStatisticsSection(state.pupil),
        ),

        SizedBox(height: SizeConfig.scaleHeight(100)), // Bottom padding
      ],
    );
  }

  Widget _buildStatisticsSection(dynamic pupil) {
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
            'Your Statistics',
            style: TextStyle(
              //fontSize: SizeConfig.scaleFont(18),
              fontWeight: FontWeight.w600,
              color: AppColors.grey900,
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(16)),

          // Statistics Grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Lessons Completed',
                  pupil.totalLessonsCompleted.toString(),
                  Icons.book_outlined,
                  AppColors.blueDark,
                ),
              ),
              SizedBox(width: SizeConfig.scaleWidth(12)),
              Expanded(
                child: _buildStatCard(
                  'Quizzes Completed',
                  pupil.totalQuizzesCompleted.toString(),
                  Icons.quiz_outlined,
                  AppColors.orangeDark,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.scaleHeight(12)),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Challenges Done',
                  pupil.totalChallengesCompleted.toString(),
                  Icons.emoji_events_outlined,
                  AppColors.violetDark,
                ),
              ),
              SizedBox(width: SizeConfig.scaleWidth(12)),
              Expanded(
                child: _buildStatCard(
                  'Average Score',
                  '${pupil.averageQuizScore.toStringAsFixed(1)}%',
                  Icons.trending_up,
                  AppColors.greenDark,
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
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: SizeConfig.scaleWidth(24)),
          SizedBox(height: SizeConfig.scaleHeight(8)),
          Text(
            value,
            style: TextStyle(
              //fontSize: SizeConfig.scaleFont(16),
              fontWeight: FontWeight.w700,
              color: AppColors.grey900,
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(2)),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              //  fontSize: SizeConfig.scaleFont(11),
              color: AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  void _showLevelInfo(dynamic level) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SizeConfig.scaleWidth(20)),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(SizeConfig.scaleWidth(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              level.name,
              style: TextStyle(
                // fontSize: SizeConfig.scaleFont(20),
                fontWeight: FontWeight.w600,
                color: AppColors.grey900,
              ),
            ),
            SizedBox(height: SizeConfig.scaleHeight(16)),
            Text(
              'Level Information',
              style: TextStyle(
                // fontSize: SizeConfig.scaleFont(16),
                fontWeight: FontWeight.w500,
                color: AppColors.grey700,
              ),
            ),
            SizedBox(height: SizeConfig.scaleHeight(8)),
            Text(
              level.pupilDescription.replaceAll(RegExp(r'<[^>]*>'), ''),
              style: TextStyle(
                // fontSize: SizeConfig.scaleFont(14),
                color: AppColors.grey600,
                height: 1.5,
              ),
            ),
            SizedBox(height: SizeConfig.scaleHeight(24)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _navigateToLevel(level.levelNumber);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenDark,
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.scaleHeight(12),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      SizeConfig.scaleWidth(8),
                    ),
                  ),
                ),
                child: Text(
                  'Start Level',
                  style: TextStyle(
                    //  fontSize: SizeConfig.scaleFont(16),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLevel(int levelNumber) {
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
