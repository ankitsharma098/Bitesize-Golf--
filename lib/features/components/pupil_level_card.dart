import 'package:bitesize_golf/features/components/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/themes/asset_custom.dart';
import '../../core/themes/theme_colors.dart';

class CustomLevelCard extends StatelessWidget {
  final String levelName;
  final int levelNumber;
  final bool isUnlocked;
  final bool isCompleted;
  final VoidCallback onTap;

  const CustomLevelCard({
    super.key,
    required this.levelName,
    required this.levelNumber,
    required this.isUnlocked,
    required this.isCompleted,
    required this.onTap,
  });

  LevelType _getLevelType() {
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
        return LevelType.redLevel; // Default to red level
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelType = _getLevelType();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: levelType.gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 15,
          bottom: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/bird/bird.png",
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      levelName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                if (!isUnlocked)
                  Positioned(
                    top: 0,
                    right: 2,
                    child: SvgPicture.asset(
                      "assets/lock/lock.png",
                      width: 35,
                      height: 35,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: isUnlocked ? onTap : null,

              child: Container(
                width: double.infinity,
                //padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: levelType.lightColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Using BallAssetProvider for swing ball
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 3),
                      child: Image.asset(
                        BallAssetProvider.getSwingOneBall(levelType),
                        width: SizeConfig.scaleWidth(80),
                        height: SizeConfig.scaleWidth(50),

                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.sports_golf,
                            size: 32,
                            color: levelType.color,
                          );
                        },
                      ),
                    ),
                    const Text(
                      'Go to Level',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
