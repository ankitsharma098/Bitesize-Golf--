// Enhanced NavigationService with better debugging
import 'package:bitesize_golf/route/routes_names.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';

class NavigationService {
  static GoRouter get _router => AppRouter.router;

  // Basic
  static void go(String path) {
    try {
      if (kDebugMode) print('NavigationService.go: Navigating to: $path');
      if (kDebugMode) {
        print(
          'Current location: ${_router.routerDelegate.currentConfiguration.uri.path}',
        );
      }
      _router.go(path);
      if (kDebugMode) print('Navigation successful');
    } catch (e) {
      if (kDebugMode) print('NavigationService.go error: $e');
    }
  }

  static void push(String path) {
    try {
      if (kDebugMode) print('NavigationService.push: Navigating to: $path');
      if (kDebugMode) {
        print(
          'Current location: ${_router.routerDelegate.currentConfiguration.uri.path}',
        );
      }
      if (kDebugMode) {
        print(
          'Can push: ${_router.canPop()}',
        ); // This will be true if there are routes to pop
      }
      _router.push(path);
      if (kDebugMode) print('Push successful');
    } catch (e) {
      if (kDebugMode) print('NavigationService.push error: $e');
      // Fallback to go() if push fails
      if (kDebugMode) print('Trying fallback with go()');
      go(path);
    }
  }

  static void pop() {
    if (_router.canPop()) {
      if (kDebugMode) print('NavigationService.pop: Popping route');
      _router.pop();
    } else {
      if (kDebugMode)
        print('NavigationService.pop: Cannot pop, no routes in stack');
    }
  }

  static bool canPop() => _router.canPop();

  static void goNamed(
    String name, {
    Map<String, String>? params,
    Object? extra,
  }) {
    try {
      if (kDebugMode)
        print('NavigationService.goNamed: $name with params: $params');
      _router.goNamed(name, pathParameters: params ?? {}, extra: extra);
    } catch (e) {
      if (kDebugMode) print('NavigationService.goNamed error: $e');
    }
  }

  static void pushNamed(
    String name, {
    Map<String, String>? params,
    Object? extra,
  }) {
    try {
      if (kDebugMode)
        print('NavigationService.pushNamed: $name with params: $params');
      _router.pushNamed(name, pathParameters: params ?? {}, extra: extra);
    } catch (e) {
      if (kDebugMode) print('NavigationService.pushNamed error: $e');
    }
  }

  // Shortcuts with debugging
  static void goToLogin() {
    if (kDebugMode)
      print('NavigationService.goToLogin: Going to ${RouteNames.login}');
    go(RouteNames.login);
  }

  static void goToRegister() {
    if (kDebugMode)
      print('NavigationService.goToRegister: Going to ${RouteNames.register}');
    go(RouteNames.register);
  }

  static void goToProfile() {
    if (kDebugMode)
      print('NavigationService.goToProfile: Going to ${RouteNames.profile}');
    go(RouteNames.profile);
  }

  // Details (examples)
  static void goToCourse(String courseId) =>
      pushNamed('courseDetails', params: {'courseId': courseId});

  static void goToLesson(String courseId, String lessonId) => pushNamed(
    'lessonDetails',
    params: {'courseId': courseId, 'lessonId': lessonId},
  );

  static void clearStackAndGoTo(String path) {
    if (kDebugMode)
      print(
        'NavigationService.clearStackAndGoTo: Clearing stack and going to $path',
      );
    go(path);
  }
}
