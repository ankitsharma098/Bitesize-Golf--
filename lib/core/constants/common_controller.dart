import 'package:bitesize_golf/route/navigator_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../route/routes_names.dart';
import '../themes/theme_colors.dart';

Future<void> logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    NavigationService.go(RouteNames.welcome);
    // GoRouter.of(context).go(RouteNames.welcome);
  } catch (e) {
    print('Error during logout: $e');
    throw Exception('Failed to log out: $e');
  }
}

LevelType getLevelTypeFromModel(int levelNumber) {
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
      return LevelType.redLevel;
  }
}
