import 'package:bitesize_golf/features/components/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/themes/asset_custom.dart';
import '../../core/themes/level_utils.dart';
import '../../core/themes/theme_colors.dart';
import 'ball_image.dart'; // Import your BallAssetProvider

class SessionLevelCard extends StatelessWidget {
  final String levelName;
  final int levelNumber;
  final LevelType levelType;
  final VoidCallback onTap;

  const SessionLevelCard({
    super.key,
    required this.levelName,
    required this.levelNumber,
    required this.levelType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final LinearGradient levelGradient = LevelUtils.getLevelGradient(
      levelNumber,
    );

    // Create a lighter background color for the inner container
    final Color sessionBackgroundColor = Color.lerp(
      levelGradient.colors.first,
      AppColors.white,
      0.85,
    )!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: levelGradient,
          borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(16)),
        ),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.scaleWidth(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Level header - single level name display
              Text(
                levelName,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: SizeConfig.scaleText(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: SizeConfig.scaleHeight(8)),

              // Create Session container
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: double.infinity,
                  height: SizeConfig.screenHeight * 0.1,
                  decoration: BoxDecoration(
                    color: sessionBackgroundColor,
                    borderRadius: BorderRadius.circular(
                      SizeConfig.scaleWidth(12),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.scaleWidth(8),
                      vertical: SizeConfig.scaleHeight(4),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        // Golf ball icon using swing ball asset
                        BallImage(
                          ballType: BallType.swingOne,
                          levelType: levelType,
                          height: 50,
                          width: 50,
                        ),
                        SizedBox(height: SizeConfig.scaleHeight(2)),
                        Text(
                          'Create Session',
                          style: TextStyle(
                            color: AppColors.grey900,
                            fontSize: SizeConfig.scaleText(11),
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
