import 'package:bitesize_golf/core/themes/theme_colors.dart';
import 'package:flutter/cupertino.dart';

import 'asset_custom.dart';

class LevelUtils {
  static LinearGradient getLevelGradient(int levelNumber) {
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
        return LevelType.redLevel.gradient;
    }
  }

  static LevelType getLevelTypeFromNumber(int levelNumber) {
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
        return LevelType.redLevel; // Default fallback
    }
  }

  static String getBallAssetFromLevelNumber(
    BallType ballType,
    int levelNumber,
  ) {
    final levelType = getLevelTypeFromNumber(levelNumber);
    return BallAssetProvider.getBallAsset(ballType, levelType);
  }
}
