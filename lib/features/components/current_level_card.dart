import 'package:flutter/material.dart';

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

  LinearGradient _getGradient() {
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
        return LevelType.redLevel.gradient; // Default to red gradient
    }
  }

  Color _getLightColor() {
    switch (levelNumber) {
      case 1:
        return LevelType.redLevel.lightColor;
      case 2:
        return LevelType.orangeLevel.lightColor;
      case 3:
        return LevelType.yellowLevel.lightColor;
      case 4:
        return LevelType.greenLevel.lightColor;
      case 5:
        return LevelType.blueLevel.lightColor;
      case 6:
        return LevelType.indigoLevel.lightColor;
      case 7:
        return LevelType.violetLevel.lightColor;
      case 8:
        return LevelType.coralLevel.lightColor;
      case 9:
        return LevelType.silverLevel.lightColor;
      case 10:
        return LevelType.goldLevel.lightColor;
      default:
        return LevelType.redLevel.lightColor; // Default to red light color
    }
  }

  String getSwingAsset() {
    switch (levelNumber) {
      case 1:
        return 'assets/swing_balls_1/Level=red.png';
      case 2:
        return 'assets/swing_balls_1/Level=orange.png';
      case 3:
        return 'assets/swing_balls_1/Level=Yellow.png';
      case 4:
        return 'assets/swing_balls_1/Level=Green.png';
      case 5:
        return 'assets/swing_balls_1/Level=Blue.png';
      case 6:
        return 'assets/swing_balls_1/Level=Indigo.png';
      case 7:
        return 'assets/swing_balls_1/Level=Violet.png';
      case 8:
        return 'assets/swing_balls_1/Level=Coral.png';
      case 9:
        return 'assets/swing_balls_1/Level=Silver.png';
      case 10:
        return 'assets/swing_balls_1/Level=Gold.png';
      default:
        return 'assets/swing_balls_1/Level=red.png'; // Default to red light color
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: _getGradient(),
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
                    // Icon(Icons.check, color: Colors.white, size: 24),
                    Image.asset("assets/bird/bird.png", width: 40, height: 40),
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
                    child: Image.asset(
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
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _getLightColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon placeholder - to be managed by you
                    Image.asset(
                      getSwingAsset(),
                      width: 34,
                      height: 32,
                    ), // Space for your icon
                    Text(
                      'Go to Level',
                      style: TextStyle(
                        color: Colors.black, // Use gradient start color
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
