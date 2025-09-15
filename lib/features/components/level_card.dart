import 'package:flutter/material.dart';
import '../../../core/themes/theme_colors.dart';
import '../../../features/components/utils/size_config.dart';
import '../level/entity/level_entity.dart';
import '../pupils modules/pupil/data/models/pupil_model.dart';

class LevelCard extends StatelessWidget {
  final Level level;
  final PupilModel pupil;
  final VoidCallback onTap;

  const LevelCard({
    Key? key,
    required this.level,
    required this.pupil,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelType = _getLevelType(level.levelNumber);
    final isUnlocked = pupil.isLevelUnlocked(level.levelNumber);
    final isCompleted = pupil.isLevelCompleted(level.levelNumber);

    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.scaleHeight(16)),
      child: Stack(
        children: [
          Container(
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
            child: Container(
              padding: EdgeInsets.all(SizeConfig.scaleWidth(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isCompleted)
                        Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: SizeConfig.scaleWidth(24),
                        )
                      else if (isUnlocked)
                        Icon(
                          Icons.play_circle_outline,
                          color: Colors.white,
                          size: SizeConfig.scaleWidth(24),
                        )
                      else
                        Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: SizeConfig.scaleWidth(24),
                        ),
                      SizedBox(width: SizeConfig.scaleWidth(8)),
                      Expanded(
                        child: Text(
                          level.name,
                          style: TextStyle(
                            // fontSize: SizeConfig.scaleFont(18),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(16)),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        SizeConfig.scaleWidth(12),
                      ),
                    ),
                    padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: SizeConfig.scaleWidth(24),
                                backgroundColor: AppColors.grey200,
                                child: Icon(
                                  Icons.sports_golf,
                                  color: AppColors.grey700,
                                  size: SizeConfig.scaleWidth(24),
                                ),
                              ),
                              SizedBox(height: SizeConfig.scaleHeight(8)),
                              Text(
                                'Go to Level',
                                style: TextStyle(
                                  //fontSize: SizeConfig.scaleFont(14),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.grey700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Lock overlay for locked levels
          if (!isUnlocked && level.levelNumber > 1)
            Positioned(
              top: SizeConfig.scaleHeight(16),
              right: SizeConfig.scaleWidth(16),
              child: Container(
                padding: EdgeInsets.all(SizeConfig.scaleWidth(8)),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock,
                  color: AppColors.grey600,
                  size: SizeConfig.scaleWidth(20),
                ),
              ),
            ),
          // Tap area
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isUnlocked ? onTap : null,
                borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(16)),
              ),
            ),
          ),
        ],
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
