import 'package:flutter/material.dart';
import 'package:bitesize_golf/core/themes/theme_colors.dart';

class SnackBarUtils {
  /// Shows a snackbar with level-based colors
  static void showLevelSnackBar(
    BuildContext context, {
    required String message,
    required int levelNumber,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    bool useGradient = false,
    IconData? icon,
  }) {
    final levelType = _getLevelTypeFromNumber(levelNumber);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // content: Row(
        //   children: [
        //     if (icon != null) ...[
        //       Icon(
        //         icon,
        //         color: Colors.white,
        //         size: 20,
        //       ),
        //       const SizedBox(width: 8),
        //     ],
        //     Expanded(
        //       child: Text(
        //         message,
        //         style: const TextStyle(
        //           color: Colors.white,
        //           fontSize: 14,
        //           fontWeight: FontWeight.w500,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        backgroundColor: useGradient ? null : levelType.color,
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        // If using gradient, wrap content in a Container with gradient
        content: useGradient
            ? Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: levelType.gradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  /// Shows a success snackbar with level colors
  static void showSuccessSnackBar(
    BuildContext context, {
    required String message,
    required int levelNumber,
    Duration duration = const Duration(seconds: 3),
    bool useGradient = false,
  }) {
    showLevelSnackBar(
      context,
      message: message,
      levelNumber: levelNumber,
      duration: duration,
      useGradient: useGradient,
      icon: Icons.check_circle_outline,
    );
  }

  /// Shows an error snackbar with level colors
  static void showErrorSnackBar(
    BuildContext context, {
    required String message,
    required int levelNumber,
    Duration duration = const Duration(seconds: 4),
    bool useGradient = false,
  }) {
    showLevelSnackBar(
      context,
      message: message,
      levelNumber: levelNumber,
      duration: duration,
      useGradient: useGradient,
      icon: Icons.error_outline,
    );
  }

  /// Shows a warning snackbar with level colors
  static void showWarningSnackBar(
    BuildContext context, {
    required String message,
    required int levelNumber,
    Duration duration = const Duration(seconds: 3),
    bool useGradient = false,
  }) {
    showLevelSnackBar(
      context,
      message: message,
      levelNumber: levelNumber,
      duration: duration,
      useGradient: useGradient,
      icon: Icons.warning_outlined,
    );
  }

  /// Shows an info snackbar with level colors
  static void showInfoSnackBar(
    BuildContext context, {
    required String message,
    required int levelNumber,
    Duration duration = const Duration(seconds: 3),
    bool useGradient = false,
  }) {
    showLevelSnackBar(
      context,
      message: message,
      levelNumber: levelNumber,
      duration: duration,
      useGradient: useGradient,
      icon: Icons.info_outline,
    );
  }

  /// Gets the level gradient based on level number
  static LinearGradient getLevelGradient(int levelNumber) {
    return _getLevelTypeFromNumber(levelNumber).gradient;
  }

  /// Gets the level color based on level number
  static Color getLevelColor(int levelNumber) {
    return _getLevelTypeFromNumber(levelNumber).color;
  }

  /// Gets the level light color based on level number
  static Color getLevelLightColor(int levelNumber) {
    return _getLevelTypeFromNumber(levelNumber).lightColor;
  }

  /// Internal method to get LevelType from number
  static LevelType _getLevelTypeFromNumber(int levelNumber) {
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
        return LevelType.redLevel; // Default fallback
    }
  }

  /// Custom snackbar with full control over styling
  static void showCustomLevelSnackBar(
    BuildContext context, {
    required Widget content,
    required int levelNumber,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    bool useGradient = false,
    double? elevation,
    EdgeInsets? margin,
    EdgeInsets? padding,
  }) {
    final levelType = _getLevelTypeFromNumber(levelNumber);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: useGradient
            ? Container(
                padding: padding ?? const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: levelType.gradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: content,
              )
            : content,
        backgroundColor: useGradient ? Colors.transparent : levelType.color,
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: margin ?? const EdgeInsets.all(16),
        elevation: elevation,
      ),
    );
  }
}
