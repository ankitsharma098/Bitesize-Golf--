import 'package:bitesize_golf/core/themes/asset_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/themes/level_utils.dart';
import '../../../../../core/themes/theme_colors.dart';
import '../../../../core/constants/common_controller.dart';
import '../../../components/avatar_widget.dart';
import '../../../components/ball_image.dart';
import '../../../components/custom_scaffold.dart';
import '../../../components/utils/size_config.dart';
import '../data/guest_profile_bloc.dart';

class GuestProfilePage extends StatelessWidget {
  const GuestProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GuestProfileBloc()..add(LoadGuestProfile()),
      child: const GuestProfilePageView(),
    );
  }
}

class GuestProfilePageView extends StatefulWidget {
  const GuestProfilePageView({super.key});

  @override
  State<GuestProfilePageView> createState() => _GuestProfilePageViewState();
}

class _GuestProfilePageViewState extends State<GuestProfilePageView> {
  @override
  void initState() {
    context.read<GuestProfileBloc>().add(LoadGuestProfile());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      screenType: ScreenType.fullScreen,
      appBarType: AppBarType.none,
      scrollable: false,
      body: BlocBuilder<GuestProfileBloc, GuestProfileState>(
        builder: (context, state) {
          if (state is GuestProfileLoading) {
            return _buildLoadingState();
          }
          if (state is GuestProfileError) {
            return _buildErrorState(state.message);
          }
          if (state is GuestProfileLoaded) {
            return _buildGuestProfileContent();
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
                context.read<GuestProfileBloc>().add(RefreshGuestProfile()),
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

  Widget _buildGuestProfileContent() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              _buildHeaderSection(),
              SizedBox(height: SizeConfig.scaleHeight(60)),
              Text(
                "Guest User",
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(20),
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey900,
                ),
              ),
              Text(
                'Age: Not specified',
                style: TextStyle(
                  fontSize: SizeConfig.scaleText(16),
                  color: AppColors.grey600,
                ),
              ),
              SizedBox(height: SizeConfig.scaleHeight(20)),

              _buildInfoCard(
                'Golf Club:',
                'Not specified',
                'assets/profile assets/club.png',
              ),
              _buildInfoCard(
                'Coach:',
                'Not assigned',
                'assets/profile assets/coach.png',
              ),
              _buildInfoCard(
                'Handicap:',
                'Not set',
                'assets/profile assets/handicap.png',
              ),
              SizedBox(height: SizeConfig.scaleHeight(20)),

              _buildCurrentLevelCard(),

              SizedBox(height: SizeConfig.scaleHeight(30)),
            ],
          ),

          Positioned(
            top: SizeConfig.scaleHeight(130),
            left: 0,
            right: 0,
            child: const Center(
              child: AvatarWidget(
                avatarUrl: null, // guest avatar placeholder
              ),
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
            decoration: const BoxDecoration(
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

  void _handleSubscription() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comming Soon'),
        backgroundColor: AppColors.error,
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

  Widget _buildCurrentLevelCard() {
    LinearGradient levelGradient = LevelUtils.getLevelGradient(1);
    LevelType levelType = LevelUtils.getLevelTypeFromNumber(1);

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
                  "Beginner Level",
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
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(
                        SizeConfig.scaleWidth(12),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                SizedBox(width: SizeConfig.scaleWidth(12)),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(
                        SizeConfig.scaleWidth(12),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
