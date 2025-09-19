import 'package:bitesize_golf/core/themes/asset_custom.dart';
import 'package:bitesize_golf/features/components/custom_button.dart';
import 'package:bitesize_golf/route/navigator_service.dart';
import 'package:bitesize_golf/route/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/common_controller.dart';
import '../../../../core/themes/theme_colors.dart';
import '../../../components/avatar_widget.dart';
import '../../../components/custom_scaffold.dart';
import '../../../components/utils/size_config.dart';
import '../../schedul session/presentation/schedule_session_page.dart';
import '../profile bloc/profile_bloc.dart';
import '../profile bloc/profile_event.dart';
import '../profile bloc/profile_state.dart';

class CoachProfileScreen extends StatefulWidget {
  const CoachProfileScreen({super.key});

  @override
  State<CoachProfileScreen> createState() => _CoachProfileScreenState();
}

class _CoachProfileScreenState extends State<CoachProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CoachProfileBloc>().add(const LoadProfileData());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      screenType: ScreenType.fullScreen,
      appBarType: AppBarType.none,
      scrollable: false,
      body: BlocBuilder<CoachProfileBloc, CoachProfileState>(
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
                context.read<CoachProfileBloc>().add(const RefreshProfile()),
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
              _buildHeaderSection(),
              SizedBox(height: SizeConfig.scaleHeight(60)),
              Text(
                state.coach.name,
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(20),
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey900,
                ),
              ),
              Text(
                'Coach',
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(16),
                  color: AppColors.grey600,
                ),
              ),
              SizedBox(height: SizeConfig.scaleHeight(20)),
              _buildInfoCard(
                'Experience:',
                '${state.coach.experience} years of coaching',
                'assets/bird/bird.png',
              ),
              _buildInfoCard(
                'Golf Club:',
                state.coach.selectedClubName ?? 'Not specified',
                'assets/profile assets/club.png',
              ),
              _buildInfoCard(
                'Pupils:',
                '${state.coach.currentPupils}',
                'assets/profile assets/coach.png',
              ),
              _buildLessonScheduleFormCard(),
              SizedBox(height: SizeConfig.scaleHeight(20)),
              Padding(
                padding: EdgeInsets.all(SizeConfig.scaleWidth(12)),
                child: CustomButtonFactory.primary(
                  text: 'Start New Session',
                  levelType: LevelType.redLevel,
                  onPressed: () {
                    NavigationService.push(RouteNames.createSession);
                  },
                ),
              ),
              // _buildStartNewSessionButton(),
              SizedBox(height: SizeConfig.scaleHeight(30)),
            ],
          ),
          Positioned(
            top: SizeConfig.scaleHeight(130),
            left: 0,
            right: 0,
            child: Center(
              child: AvatarWidget(avatarUrl: state.coach.avatarUrl),
            ),
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
          Container(
            height: SizeConfig.scaleHeight(200),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/profile_cover.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: SizeConfig.scaleHeight(20),
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
                    logout(context);
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit Profile tapped'),
        backgroundColor: AppColors.greenDark,
      ),
    );
    // Add navigation to edit profile screen here
  }

  void _handleSubscription() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Subscription tapped'),
        backgroundColor: AppColors.greenDark,
      ),
    );
    // Add navigation to subscription screen here
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
          Image.asset(asset, height: 35, width: 35, color: AppColors.greenDark),
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

  Widget _buildLessonScheduleFormCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateScheduleScreen()),
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
        // margin: EdgeInsets.symmetric(
        //   horizontal: SizeConfig.scaleWidth(20),
        //   vertical: SizeConfig.scaleHeight(8),
        // ),
        // padding: EdgeInsets.all(SizeConfig.scaleWidth(12)),
        // decoration: BoxDecoration(
        //   color: AppColors.white,
        //   borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(12)),
        // ),
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
                'Lesson Schedule Form',
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey900,
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/images/navigation.svg',
              width: 25,
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartNewSessionButton() {
    return CustomButtonFactory.primary(
      text: 'Start New Session',
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Starting New Session'),
            backgroundColor: AppColors.redDark,
          ),
        );
      },
    );
  }
}
