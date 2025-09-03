// lib/router/navigation_service.dart
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'app_router.dart';
import 'app_routes.dart';

class NavigationService {
  static GoRouter get _router => AppRouter.router;

  // Basic
  static void go(String path) => _router.go(path);
  static void push(String path) {
    try {
      if (kDebugMode) print('Navigating to: $path');
      _router.push(path);
    } catch (e) {
      if (kDebugMode) print('Navigation error: $e');
    }
  }

  static void pop() {
    if (_router.canPop()) _router.pop();
  }

  static bool canPop() => _router.canPop();

  static void goNamed(
    String name, {
    Map<String, String>? params,
    Object? extra,
  }) => _router.goNamed(name, pathParameters: params ?? {}, extra: extra);

  static void pushNamed(
    String name, {
    Map<String, String>? params,
    Object? extra,
  }) => _router.pushNamed(name, pathParameters: params ?? {}, extra: extra);

  // Shortcuts
  static void goToLogin() => go(RouteNames.login);
  static void goToRegister() => go(RouteNames.register);
  static void goToMain() => go(RouteNames.mainScreen);
  static void goToHome() => go(RouteNames.home);
  static void goToCourses() => go(RouteNames.courses);
  static void goToPlans() => go(RouteNames.plans);
  static void goToPractice() => go(RouteNames.practice);
  static void goToProfile() => go(RouteNames.profile);

  // Details (examples)
  static void goToCourse(String courseId) =>
      pushNamed('courseDetails', params: {'courseId': courseId});

  static void goToLesson(String courseId, String lessonId) => pushNamed(
    'lessonDetails',
    params: {'courseId': courseId, 'lessonId': lessonId},
  );

  static void clearStackAndGoTo(String path) => go(path);
}
