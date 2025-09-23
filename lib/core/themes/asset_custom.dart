import 'package:bitesize_golf/core/themes/theme_colors.dart';

enum BallType { welcome, swing, swingOne, skills, rosette, learn, know }

class BallAssetProvider {
  // Base asset path
  static const String _basePath = 'assets';

  // Get the folder name for each ball type
  static String _getBallFolder(BallType ballType) {
    switch (ballType) {
      case BallType.welcome:
        return 'welcome_balls';
      case BallType.swing:
        return 'swing_balls';
      case BallType.swingOne:
        return 'swing_balls_1';
      case BallType.skills:
        return 'skills_balls';
      case BallType.rosette:
        return 'rosette_balls';
      case BallType.learn:
        return 'learn_balls';
      case BallType.know:
        return 'know_balls';
    }
  }

  // Convert LevelType to file name format
  static String _getLevelFileName(LevelType levelType) {
    switch (levelType) {
      case LevelType.redLevel:
        return 'Level=red.svg';
      case LevelType.orangeLevel:
        return 'Level=orange.svg';
      case LevelType.yellowLevel:
        return 'Level=Yellow.svg';
      case LevelType.greenLevel:
        return 'Level=Green.svg';
      case LevelType.blueLevel:
        return 'Level=Blue.svg';
      case LevelType.indigoLevel:
        return 'Level=Indigo.svg';
      case LevelType.violetLevel:
        return 'Level=Violet.svg';
      case LevelType.coralLevel:
        return 'Level=Coral.svg';
      case LevelType.silverLevel:
        return 'Level=Silver.svg';
      case LevelType.goldLevel:
        return 'Level=Gold.svg';
    }
  }

  // Main function to get ball asset path
  static String getBallAsset(BallType ballType, LevelType levelType) {
    final folder = _getBallFolder(ballType);
    final fileName = _getLevelFileName(levelType);
    return '$_basePath/$folder/$fileName';
  }

  // Convenience functions for each ball type
  static String getWelcomeBall(LevelType levelType) {
    return getBallAsset(BallType.welcome, levelType);
  }

  static String getSwingBall(LevelType levelType) {
    return getBallAsset(BallType.swing, levelType);
  }

  static String getSwingOneBall(LevelType levelType) {
    return getBallAsset(BallType.swingOne, levelType);
  }

  static String getSkillsBall(LevelType levelType) {
    return getBallAsset(BallType.skills, levelType);
  }

  static String getRosetteBall(LevelType levelType) {
    return getBallAsset(BallType.rosette, levelType);
  }

  static String getLearnBall(LevelType levelType) {
    return getBallAsset(BallType.learn, levelType);
  }

  static String getKnowBall(LevelType levelType) {
    return getBallAsset(BallType.know, levelType);
  }

  // Get all ball assets for a specific level (useful for preloading or displaying all types)
  static Map<BallType, String> getAllBallsForLevel(LevelType levelType) {
    return {
      BallType.welcome: getWelcomeBall(levelType),
      BallType.swing: getSwingBall(levelType),
      BallType.swingOne: getSwingOneBall(levelType),
      BallType.skills: getSkillsBall(levelType),
      BallType.rosette: getRosetteBall(levelType),
      BallType.learn: getLearnBall(levelType),
      BallType.know: getKnowBall(levelType),
    };
  }

  // Get all assets for a specific ball type (useful for level progression display)
  static Map<LevelType, String> getAllLevelsForBallType(BallType ballType) {
    return {
      LevelType.redLevel: getBallAsset(ballType, LevelType.redLevel),
      LevelType.orangeLevel: getBallAsset(ballType, LevelType.orangeLevel),
      LevelType.yellowLevel: getBallAsset(ballType, LevelType.yellowLevel),
      LevelType.greenLevel: getBallAsset(ballType, LevelType.greenLevel),
      LevelType.blueLevel: getBallAsset(ballType, LevelType.blueLevel),
      LevelType.indigoLevel: getBallAsset(ballType, LevelType.indigoLevel),
      LevelType.violetLevel: getBallAsset(ballType, LevelType.violetLevel),
      LevelType.coralLevel: getBallAsset(ballType, LevelType.coralLevel),
      LevelType.silverLevel: getBallAsset(ballType, LevelType.silverLevel),
      LevelType.goldLevel: getBallAsset(ballType, LevelType.goldLevel),
    };
  }
}

// Extension on LevelType for easier asset access
extension LevelTypeAssets on LevelType {
  String getWelcomeBall() => BallAssetProvider.getWelcomeBall(this);
  String getSwingBall() => BallAssetProvider.getSwingBall(this);
  String getSwingOneBall() => BallAssetProvider.getSwingOneBall(this);
  String getSkillsBall() => BallAssetProvider.getSkillsBall(this);
  String getRosetteBall() => BallAssetProvider.getRosetteBall(this);
  String getLearnBall() => BallAssetProvider.getLearnBall(this);
  String getKnowBall() => BallAssetProvider.getKnowBall(this);
}
