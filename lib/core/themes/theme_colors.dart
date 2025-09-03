import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  // Grey Scale
  static const Color grey900 = Color(0xFF1F1F1F);
  static const Color grey800 = Color(0xFF404141);
  static const Color grey700 = Color(0xFF626262);
  static const Color grey600 = Color(0xFF8E8E8E);
  static const Color grey500 = Color(0xFFADADAD);
  static const Color grey400 = Color(0xFFDCDCDC);
  static const Color grey300 = Color(0xFFEDEDED);
  static const Color grey200 = Color(0xFFE5E5E5);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color white = Color(0xFFFFFFFF);

  // Level Colors - Dark
  static const Color redDark = Color(0xFFFF1F27);
  static const Color orangeDark = Color(0xFFFF7600);
  static const Color yellowDark = Color(0xFFEEE200);
  static const Color greenDark = Color(0xFF00AB3F);
  static const Color blueDark = Color(0xFF315FE2);
  static const Color indigoDark = Color(0xFF7A0FC6);
  static const Color violetDark = Color(0xFFA900FF);
  static const Color coralDark = Color(0xFFFF7F50);
  static const Color silverDark = Color(0xFF8E8E8E);
  static const Color goldDark = Color(0xFFBF9742);

  // Level Colors - Light
  static const Color redLight = Color(0xFFF9DEDF);
  static const Color orangeLight = Color(0xFFFFDFC5);
  static const Color yellowLight = Color(0xFFFFF9CC);
  static const Color greenLight = Color(0xFFC6EED5);
  static const Color blueLight = Color(0xFFC9D7FF);
  static const Color indigoLight = Color(0xFFF0DDFF);
  static const Color violetLight = Color(0xFFF0DDFF);
  static const Color coralLight = Color(0xFFFFE5DC);
  static const Color silverLight = Color(0xFFDCDCDC);
  static const Color goldLight = Color(0xFFFFF7E4);

  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  //gradient Colors

  static const LinearGradient redGradient = LinearGradient(
    colors: [Color(0xFFFF1F27), Color(0xFFE1020A)], // Two colors
    // begin: Alignment.topLeft,
    // end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFF8F2E), Color(0xFFFF7600)], // Two colors
    // begin: Alignment.topLeft,
    // end: Alignment.bottomRight,
  );

  static const LinearGradient yellowGradient = LinearGradient(
    colors: [Color(0xFFFFF200), Color(0xFFEEE200)], // Two colors
    // begin: Alignment.topLeft,
    // end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF00C649), Color(0xFF00AB3F)], // Two colors
    // begin: Alignment.topLeft,
    // end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF3366F8), Color(0xFF305DDD)], // Two colors
    // begin: Alignment.topLeft,
    // end: Alignment.bottomRight,
  );

  static const LinearGradient indigoGradient = LinearGradient(
    colors: [Color(0xFF7A0FC6), Color(0xFF6609A9)], // Two colors
    // begin: Alignment.topLeft,
    // end: Alignment.bottomRight,
  );

  static const LinearGradient violetGradient = LinearGradient(
    colors: [Color(0xFFB523FF), Color(0xFFA900FF)], // Two colors
    // begin: Alignment.topLeft,
    // end: Alignment.bottomRight,
  );

  static const LinearGradient carolGradient = LinearGradient(
    colors: [Color(0xFFFF8C61), Color(0xFFFF7F50)], // Two colors
    // begin: Alignment.topLeft,
    // end: Alignment.bottomRight,
  );

  static const LinearGradient silverGradient = LinearGradient(
    colors: [Color(0xFFBDBABA), Color(0xFF999898)], // Two colors
    //egin: Alignment.topLeft,
    // end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFEABE3C), Color(0xFFCEA247)], // Two colors
    // begin: Alignment.topLeft,
    // end: Alignment.bottomRight,
  );
}

enum LevelType {
  beginner(
    color: AppColors.redDark,
    lightColor: AppColors.redLight,
    name: 'Beginner',
  ),
  intermediate(
    color: AppColors.orangeDark,
    lightColor: AppColors.orangeLight,
    name: 'Intermediate',
  ),
  advanced(
    color: AppColors.yellowDark,
    lightColor: AppColors.yellowLight,
    name: 'Advanced',
  ),
  expert(
    color: AppColors.greenDark,
    lightColor: AppColors.greenLight,
    name: 'Expert',
  ),
  master(
    color: AppColors.blueDark,
    lightColor: AppColors.blueLight,
    name: 'Master',
  ),
  grandMaster(
    color: AppColors.indigoDark,
    lightColor: AppColors.indigoLight,
    name: 'Grand Master',
  );

  const LevelType({
    required this.color,
    required this.lightColor,
    required this.name,
  });

  final Color color;
  final Color lightColor;
  final String name;
}
