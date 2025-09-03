import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/themes/theme_colors.dart';

class DotProgressIndicator extends StatelessWidget {
  final int totalDots;
  final int completedDots;
  final LevelType levelType;
  final double dotSize;

  const DotProgressIndicator({
    Key? key,
    required this.totalDots,
    required this.completedDots,
    required this.levelType,
    this.dotSize = 12.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDots, (index) {
        bool isCompleted = index < completedDots;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? levelType.color : AppColors.grey300,
          ),
        );
      }),
    );
  }
}
