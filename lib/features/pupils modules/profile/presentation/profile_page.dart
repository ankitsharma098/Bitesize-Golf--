import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/theme_colors.dart';
import '../../../components/avatar_widget.dart';
import '../../../components/custom_scaffold.dart';
import '../../../components/utils/size_config.dart';
import '../profile bloc/profile_bloc.dart';
import '../profile bloc/profile_event.dart';
import '../profile bloc/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const LoadProfileData());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Profile',
      screenType: ScreenType.fullScreen,
      scrollable: true,
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return _buildLoadingState();
          }
          if (state is ProfileError) {
            return _buildErrorState(state.message);
          }
          if (state is ProfileLoaded) {
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
            style: TextStyle(color: AppColors.grey600),
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
            'Unable to load profile',
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
                context.read<ProfileBloc>().add(const RefreshProfile()),
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
            child: Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Text(
        'Loading profile...',
        style: TextStyle(color: AppColors.grey600),
      ),
    );
  }

  Widget _buildProfileContent(ProfileLoaded state) {
    return Stack(
      children: [
        // Background golf course image
        Container(
          height: SizeConfig.scaleHeight(
            200,
          ), // Increased height to match image
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/profile_cover.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
              ),
            ),
          ),
        ),

        // Settings icon
        Positioned(
          top: SizeConfig.scaleHeight(50),
          right: SizeConfig.scaleWidth(20),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.grey600,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.settings, color: AppColors.grey700),
              onPressed: () => _openSettings(),
            ),
          ),
        ),

        // Profile content
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.scaleHeight(130),
              ), // Adjusted for image overlap
              // Profile card
              AvatarWidget(avatarUrl: state.pupil.avatar),
              SizedBox(height: SizeConfig.scaleHeight(12)),
              Text(
                state.pupil.name,
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(20),
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey900,
                ),
              ),
              Text(
                'Age: ${state.pupil.age ?? 'Not specified'}',
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(16),
                  color: AppColors.grey600,
                ),
              ),
              SizedBox(height: SizeConfig.scaleHeight(20)),

              // Profile info cards
              _buildInfoCard(
                'Golf Club:',
                state.pupil.selectedClubName ?? 'Not specified',
                Icons.golf_course,
              ),
              _buildInfoCard(
                'Coach:',
                state.pupil.assignedCoachName ?? 'Not assigned',
                Icons.person,
              ),
              _buildInfoCard(
                'Handicap:',
                state.pupil.handicap?.toString() ?? 'Not set',
                Icons.flag,
              ),

              // Lesson Schedule card
              _buildLessonScheduleCard(),

              SizedBox(height: SizeConfig.scaleHeight(20)),

              // Current Level card
              _buildCurrentLevelCard(state.currentLevel),

              SizedBox(height: SizeConfig.scaleHeight(100)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.scaleWidth(20),
        vertical: SizeConfig.scaleHeight(8),
      ),
      padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(12)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(SizeConfig.scaleWidth(8)),
            decoration: BoxDecoration(
              color: AppColors.greenDark.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.greenDark,
              size: SizeConfig.scaleWidth(20),
            ),
          ),
          Column(
            children: [
              SizedBox(width: SizeConfig.scaleWidth(12)),
              Text(
                '$title',
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(16),
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey900,
                ),
              ),
              Text(
                '$value',
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(16),
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLessonScheduleCard() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigating to Lesson Schedule'),
            backgroundColor: AppColors.greenDark,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(20)),
        padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(SizeConfig.scaleWidth(8)),
              decoration: BoxDecoration(
                color: AppColors.greenDark.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today,
                color: AppColors.greenDark,
                size: SizeConfig.scaleWidth(20),
              ),
            ),
            SizedBox(width: SizeConfig.scaleWidth(12)),
            Expanded(
              child: Text(
                'Lesson Schedule',
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(16),
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey900,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.greenDark,
              size: SizeConfig.scaleWidth(16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentLevelCard(dynamic currentLevel) {
    LinearGradient levelGradient = _getLevelGradient(currentLevel.levelNumber);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(20)),
      decoration: BoxDecoration(
        gradient: levelGradient,
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(16)),
      ),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.scaleWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check,
                  color: Colors.white,
                  size: SizeConfig.scaleWidth(24),
                ),
                SizedBox(width: SizeConfig.scaleWidth(8)),
                Text(
                  currentLevel.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.scaleText(18),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.scaleHeight(16)),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('More Information'),
                          backgroundColor: AppColors.greenDark,
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.scaleHeight(12),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(
                          SizeConfig.scaleWidth(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: SizeConfig.scaleWidth(20),
                          ),
                          SizedBox(width: SizeConfig.scaleWidth(8)),
                          Text(
                            'More Information',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.scaleText(14),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: SizeConfig.scaleWidth(12)),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _navigateToLevel(currentLevel.levelNumber),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.scaleHeight(12),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(
                          SizeConfig.scaleWidth(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sports_golf,
                            color: Colors.white,
                            size: SizeConfig.scaleWidth(20),
                          ),
                          SizedBox(width: SizeConfig.scaleWidth(8)),
                          Text(
                            'Go to Level',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.scaleText(14),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _getLevelGradient(int levelNumber) {
    switch (levelNumber) {
      case 1:
        return LevelType.redLevel.gradient;
      case 2:
        return LevelType.orangeLevel.gradient;
      case 3:
        return LevelType.yellowLevel.gradient;
      case 4:
        return LevelType.greenLevel.gradient;
      case 5:
        return LevelType.blueLevel.gradient;
      case 6:
        return LevelType.indigoLevel.gradient;
      case 7:
        return LevelType.violetLevel.gradient;
      case 8:
        return LevelType.coralLevel.gradient;
      case 9:
        return LevelType.silverLevel.gradient;
      case 10:
        return LevelType.goldLevel.gradient;
      default:
        return LevelType.redLevel.gradient;
    }
  }

  void _openSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening settings...'),
        backgroundColor: AppColors.greenDark,
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
