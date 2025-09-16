import 'package:flutter/material.dart';

import '../../core/themes/asset_custom.dart';
import '../../core/themes/theme_colors.dart';

class BallImage extends StatelessWidget {
  final BallType ballType;
  final LevelType levelType;
  final double? width;
  final double? height;

  const BallImage({
    Key? key,
    required this.ballType,
    required this.levelType,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      BallAssetProvider.getBallAsset(ballType, levelType),
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width ?? 50,
          height: height ?? 50,
          decoration: BoxDecoration(
            color: levelType.lightColor,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.sports_golf, color: levelType.color),
        );
      },
    );
  }
}
