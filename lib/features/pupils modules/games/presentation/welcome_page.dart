import 'package:flutter/material.dart';
import '../../../../../core/themes/theme_colors.dart';
import '../../../../../route/navigator_service.dart';
import '../../../../../route/routes_names.dart';
import '../../../../core/themes/asset_custom.dart';
import '../../../../core/themes/level_utils.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_scaffold.dart';
import '../../../components/utils/size_config.dart';

class GameWelcomePage extends StatelessWidget {
  const GameWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String levelName = arguments?['levelName'] ?? 'Red';
    final int levelNumber = arguments?['levelNumber'] ?? 1;

    final LevelType levelType = LevelUtils.getLevelTypeFromNumber(levelNumber);

    return AppScaffold.content(
      title: "${levelName.toUpperCase()} Level Game",
      showBackButton: true,
      levelType: levelType,
      actions: [
        IconButton(
          icon: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.redLight.withOpacity(0.5),
            ),
            child: Icon(Icons.close, color: AppColors.grey900),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: SizeConfig.scaleHeight(20)),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.grey200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Good luck with your\n",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.grey900,
                          ),
                        ),
                        TextSpan(
                          text: "${levelName.toUpperCase()} Games!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: levelType.color,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(16)),
                  const Text(
                    "Play these fun games — not only will you have a great time, but your golf skills are guaranteed to improve.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: AppColors.grey900),
                  ),
                  SizedBox(height: SizeConfig.scaleHeight(50)),
                  Image.asset(
                    LevelUtils.getBallAssetFromLevelNumber(
                      BallType.skills,
                      levelNumber,
                    ),
                    height: 120,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          gradient: levelType.gradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.sports_golf,
                          size: 60,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            CustomButtonFactory.primary(
              text: "Start Games",
              onPressed: () {
                NavigationService.push(RouteNames.gameStart);
              },
              levelType: levelType,
            ),
            SizedBox(height: SizeConfig.scaleHeight(20)),
          ],
        ),
      ),
    );
  }
}

