import 'package:flutter/material.dart';
import '../../../core/themes/theme_colors.dart';
import '../../../features/components/utils/size_config.dart';
import '../pupils modules/pupil/data/models/pupil_model.dart';

class ProfileInfoWidget extends StatelessWidget {
  final PupilModel pupil;

  const ProfileInfoWidget({Key? key, required this.pupil}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile Header
        Container(
          height: SizeConfig.scaleHeight(200),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1535131749006-b7f58c99034b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Settings button
              Positioned(
                top: SizeConfig.scaleHeight(16),
                right: SizeConfig.scaleWidth(16),
                child: Container(
                  padding: EdgeInsets.all(SizeConfig.scaleWidth(8)),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(
                      SizeConfig.scaleWidth(8),
                    ),
                  ),
                  child: Icon(
                    Icons.settings,
                    size: SizeConfig.scaleWidth(24),
                    color: AppColors.grey700,
                  ),
                ),
              ),
              // Profile Image
              Positioned(
                bottom: -SizeConfig.scaleHeight(30),
                left: SizeConfig.scaleWidth(24),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: SizeConfig.scaleWidth(40),
                    backgroundImage: pupil.avatar != null
                        ? NetworkImage(pupil.avatar!)
                        : null,
                    child: pupil.avatar == null
                        ? Icon(
                            Icons.person,
                            size: SizeConfig.scaleWidth(40),
                            color: AppColors.grey600,
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: SizeConfig.scaleHeight(40)),
        // Profile Info
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and Age
              Row(
                children: [
                  Text(
                    pupil.name,
                    style: TextStyle(
                      //  fontSize: SizeConfig.scaleFont(24),
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey900,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              SizedBox(height: SizeConfig.scaleHeight(4)),
              if (pupil.age != null)
                Text(
                  'Age: ${pupil.age}',
                  style: TextStyle(
                    // fontSize: SizeConfig.scaleFont(16),
                    color: AppColors.grey600,
                  ),
                ),
              SizedBox(height: SizeConfig.scaleHeight(24)),
              // Info Cards
              _buildInfoCard(
                icon: Icons.sports_golf,
                title: 'Golf Club:',
                value: pupil.selectedClubName ?? 'Not selected',
              ),
              SizedBox(height: SizeConfig.scaleHeight(12)),
              _buildInfoCard(
                icon: Icons.person_outline,
                title: 'Coach:',
                value: pupil.assignedCoachName ?? 'Not assigned',
              ),
              SizedBox(height: SizeConfig.scaleHeight(12)),
              _buildInfoCard(
                icon: Icons.flag_outlined,
                title: 'Handicap:',
                value: pupil.handicap ?? 'Not set',
              ),
              SizedBox(height: SizeConfig.scaleHeight(12)),
              _buildScheduleCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(12)),
        border: Border.all(color: AppColors.grey200, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(SizeConfig.scaleWidth(8)),
            decoration: BoxDecoration(
              color: AppColors.greenLight,
              borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
            ),
            child: Icon(
              icon,
              color: AppColors.greenDark,
              size: SizeConfig.scaleWidth(20),
            ),
          ),
          SizedBox(width: SizeConfig.scaleWidth(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    //  fontSize: SizeConfig.scaleFont(14),
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey700,
                  ),
                ),
                SizedBox(height: SizeConfig.scaleHeight(2)),
                Text(
                  value,
                  style: TextStyle(
                    //  fontSize: SizeConfig.scaleFont(16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard() {
    return Container(
      padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(12)),
        border: Border.all(color: AppColors.grey200, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(SizeConfig.scaleWidth(8)),
            decoration: BoxDecoration(
              color: AppColors.greenLight,
              borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
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
                // fontSize: SizeConfig.scaleFont(16),
                fontWeight: FontWeight.w600,
                color: AppColors.grey900,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.error,
            size: SizeConfig.scaleWidth(16),
          ),
        ],
      ),
    );
  }
}
