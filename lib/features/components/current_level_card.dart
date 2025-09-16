import 'package:bitesize_golf/core/themes/theme_colors.dart';
import 'package:bitesize_golf/features/components/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:bitesize_golf/core/themes/level_utils.dart';

import '../../core/themes/asset_custom.dart';
import 'ball_image.dart'; // Assuming BallImage is defined

class CurrentLevelCard extends StatelessWidget {
  final String levelName;
  final int levelNumber;
  final LevelType levelType;
  final VoidCallback onMoreInfoTap;
  final VoidCallback onLevelTap;

  const CurrentLevelCard({
    super.key,
    required this.levelName,
    required this.levelNumber,
    required this.levelType,
    required this.onMoreInfoTap,
    required this.onLevelTap,
  });

  @override
  Widget build(BuildContext context) {
    final LinearGradient levelGradient = LevelUtils.getLevelGradient(
      levelNumber,
    );
    // Extract the first color from the gradient as the base color
    final Color baseColor = levelGradient.colors.first;
    // Create a lighter version by blending with white (e.g., 70% white, 30% base color)
    final Color lighterColor = Color.lerp(baseColor, AppColors.white, 0.7)!;

    final Color moreLighterColor = Color.lerp(baseColor, AppColors.white, 0.9)!;

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
                  levelName,
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
                    onTap: onMoreInfoTap,
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            lighterColor, // Use the lighter version of the base color
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
                    onTap: onLevelTap,
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            moreLighterColor, // Use the lighter version of the base color
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
                            'Go to Level',
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
}
