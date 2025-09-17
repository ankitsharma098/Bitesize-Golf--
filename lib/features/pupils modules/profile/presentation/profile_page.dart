import 'package:bitesize_golf/core/themes/asset_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/themes/level_utils.dart';
import '../../../../core/themes/theme_colors.dart';
import '../../../components/avatar_widget.dart';
import '../../../components/ball_image.dart';
import '../../../components/custom_scaffold.dart';
import '../../../components/utils/size_config.dart';
import '../../subcription/presentation/subscription_page.dart';
import '../../update profile/presentation/update_profile_page.dart';
import '../profile bloc/profile_bloc.dart';
import '../profile bloc/profile_event.dart';
import '../profile bloc/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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
      screenType: ScreenType.fullScreen,
      appBarType: AppBarType.none,
      scrollable: false,
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
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              // Background image with overlay title
              _buildHeaderSection(),

              // Space for overlapping avatar (half the avatar height)
              SizedBox(
                height: SizeConfig.scaleHeight(60),
              ), // Adjust based on avatar size
              // Profile info (name and age)
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
                'assets/profile assets/club.png',
              ),
              _buildInfoCard(
                'Coach:',
                state.pupil.assignedCoachName ?? 'Not assigned',
                'assets/profile assets/coach.png',
              ),
              _buildInfoCard(
                'Handicap:',
                state.pupil.handicap?.toString() ?? 'Not set',
                'assets/profile assets/handicap.png',
              ),
              SizedBox(height: SizeConfig.scaleHeight(8)),
              // Lesson Schedule card
              _buildLessonScheduleCard(),

              SizedBox(height: SizeConfig.scaleHeight(20)),

              // Current Level card
              _buildCurrentLevelCard(state.currentLevel),

              SizedBox(height: SizeConfig.scaleHeight(30)),
            ],
          ),

          // Overlapping Avatar - positioned to overlap background and content but scrolls with content
          Positioned(
            top: SizeConfig.scaleHeight(
              130,
            ), // Position it to overlap image and white area
            left: 0,
            right: 0,
            child: Center(child: AvatarWidget(avatarUrl: state.pupil.avatar)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return SizedBox(
      height: SizeConfig.scaleHeight(200),
      width: double.infinity,
      child: Stack(
        children: [
          // Background golf course image
          Container(
            height: SizeConfig.scaleHeight(200),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/profile_cover.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Profile title - positioned to overlay the image
          Positioned(
            top: SizeConfig.scaleHeight(20), // Adjust this to match your design
            left: SizeConfig.scaleWidth(20),
            child: Text(
              'Profile',
              style: TextStyle(
                color: AppColors.white,
                fontSize: SizeConfig.scaleText(25),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Settings popup menu
          Positioned(
            top: SizeConfig.scaleHeight(20),
            right: SizeConfig.scaleWidth(20),
            child: PopupMenuButton<String>(
              onSelected: (String value) {
                switch (value) {
                  case 'edit_profile':
                    _handleEditProfile();
                    break;
                  case 'subscription':
                    _handleSubscription();
                    break;
                  case 'log_out':
                    _handleLogOut();
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'edit_profile',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: AppColors.grey900,
                          fontSize: SizeConfig.scaleText(16),
                        ),
                      ),
                      // SizedBox(width: SizeConfig.scaleWidth(12)),
                      SvgPicture.asset(
                        'assets/setting/user.svg',
                        width: 25,
                        height: 25,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'subscription',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(
                        'Subscription',
                        style: TextStyle(
                          color: AppColors.grey900,
                          fontSize: SizeConfig.scaleText(16),
                        ),
                      ),

                      //  SizedBox(width: SizeConfig.scaleWidth(12)),
                      SvgPicture.asset(
                        'assets/setting/wallet-2.svg',
                        width: 25,
                        height: 25,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'log_out',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(
                        'Log Out',
                        style: TextStyle(
                          color: AppColors.grey900,
                          fontSize: SizeConfig.scaleText(16),
                        ),
                      ),

                      SvgPicture.asset(
                        'assets/setting/arrow-left.svg',
                        width: 25,
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ],
              color: AppColors.profilePopupColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(12)),
              ),
              child: Container(
                padding: EdgeInsets.all(SizeConfig.scaleWidth(8)),
                decoration: BoxDecoration(
                  color: AppColors.grey600.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(
                    SizeConfig.scaleWidth(12),
                  ),
                ),
                child: Icon(Icons.settings, color: AppColors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  EditProfilePage(),
      ),
    );
  }

  void _handleSubscription() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubscriptionPage(
          planName: "Annual Plan",
          price: "\$60/year",
          startDate: DateTime(2024, 3, 20), endDate: DateTime(2025, 4, 20),  // Expire 20 Mar 2026 (future)
        ),
      ),
    );
  }


  void _handleLogOut() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Log Out tapped'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, String asset) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.scaleWidth(20),
        vertical: SizeConfig.scaleHeight(8),
      ),
      padding: EdgeInsets.all(SizeConfig.scaleWidth(12)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(12)),
      ),
      child: Row(
        children: [
          Image.asset(asset, height: 35, width: 35),
          SizedBox(width: SizeConfig.scaleWidth(12)),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey900,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(16),
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey700,
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
        margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.scaleWidth(20),
          vertical: SizeConfig.scaleHeight(8),
        ),
        padding: EdgeInsets.all(SizeConfig.scaleWidth(12)),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(12)),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/profile assets/lesson schedule.png',
              height: 35,
              width: 35,
            ),
            SizedBox(width: SizeConfig.scaleWidth(12)),
            Expanded(
              child: Text(
                'Lesson Schedule',
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey900,
                ),
              ),
            ),

            Image.asset(
              'assets/images/navigation.png',
              color: AppColors.redDark,
              height: 35,
              width: 35,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentLevelCard(dynamic currentLevel) {
    LinearGradient levelGradient = LevelUtils.getLevelGradient(
      currentLevel.levelNumber,
    );
    LevelType levelType = LevelUtils.getLevelTypeFromNumber(
      currentLevel.levelNumber,
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(20)),
      decoration: BoxDecoration(
        gradient: levelGradient,
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(16)),
      ),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.scaleWidth(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/bird/bird.png",
                  width: 45,
                  height: 45,
                  color: AppColors.white,
                ),
                SizedBox(width: SizeConfig.scaleWidth(8)),
                Text(
                  currentLevel.name,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: SizeConfig.scaleText(18),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.scaleHeight(8)),
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
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(
                          SizeConfig.scaleWidth(12),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BallImage(
                            ballType: BallType.know,
                            levelType: levelType,
                            height: 55,
                            width: 55,
                          ),
                          Text(
                            'More Information',
                            style: TextStyle(
                              color: AppColors.grey900,
                              fontSize: SizeConfig.scaleText(12),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: SizeConfig.scaleHeight(8)),
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
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(
                          SizeConfig.scaleWidth(12),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BallImage(
                            ballType: BallType.swingOne,
                            levelType: levelType,
                            height: 55,
                            width: 55,
                          ),

                          Text(
                            'More Information',
                            style: TextStyle(
                              color: AppColors.grey900,
                              fontSize: SizeConfig.scaleText(12),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: SizeConfig.scaleHeight(8)),
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
