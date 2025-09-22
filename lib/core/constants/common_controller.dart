import 'package:bitesize_golf/route/navigator_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../route/routes_names.dart';

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
