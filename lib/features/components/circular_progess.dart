import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/themes/theme_colors.dart';

class CircularProgressWithIcon extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final IconData icon;
  final LevelType levelType;
  final double size;

  const CircularProgressWithIcon({
    Key? key,
    required this.progress,
    required this.icon,
    required this.levelType,
    this.size = 60.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 4,
            backgroundColor: AppColors.grey300,
            valueColor: AlwaysStoppedAnimation<Color>(levelType.color),
          ),
        ),
        Icon(icon, color: levelType.color, size: size * 0.4),
      ],
    );
  }
}
