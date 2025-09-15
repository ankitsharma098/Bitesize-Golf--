import 'package:flutter/material.dart';
import '../../../core/themes/theme_colors.dart';
import '../../../features/components/utils/size_config.dart';
import '../level/entity/level_entity.dart';

import '../pupils modules/pupil/data/models/pupil_model.dart';

class CurrentLevelCard extends StatelessWidget {
  final Level level;
  final PupilModel pupil;
  final VoidCallback onMoreInfo;
  final VoidCallback onGoToLevel;

  const CurrentLevelCard({
    Key? key,
    required this.level,
    required this.pupil,
    required this.onMoreInfo,
    required this.onGoToLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelType = _getLevelType(level.levelNumber);
    final progress = pupil.getProgressForLevel(level.levelNumber);

    return Container(
      decoration: BoxDecoration(
        gradient: levelType.gradient,
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.scaleWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: SizeConfig.scaleWidth(24),
                ),
                SizedBox(width: SizeConfig.scaleWidth(8)),
                Expanded(
                  child: Text(
                    level.name,
                    style: TextStyle(
                      //      fontSize: SizeConfig.scaleFont(18),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.scaleHeight(16)),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    title: 'More Information',
                    icon: Icons.info_outline,
                    onTap: onMoreInfo,
                  ),
                ),
                SizedBox(width: SizeConfig.scaleWidth(12)),
                Expanded(
                  child: _buildActionButton(
                    title: 'Go to Level',
                    icon: Icons.play_arrow,
                    onTap: onGoToLevel,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.scaleWidth(12),
          vertical: SizeConfig.scaleHeight(12),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(12)),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: SizeConfig.scaleWidth(20),
              backgroundColor: AppColors.grey200,
              child: Icon(
                icon,
                color: AppColors.grey700,
                size: SizeConfig.scaleWidth(20),
              ),
            ),
            SizedBox(height: SizeConfig.scaleHeight(8)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                //  fontSize: SizeConfig.scaleFont(12),
                fontWeight: FontWeight.w500,
                color: AppColors.grey700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  LevelType _getLevelType(int levelNumber) {
    switch (levelNumber) {
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
        return LevelType.redLevel;
    }
  }
}
