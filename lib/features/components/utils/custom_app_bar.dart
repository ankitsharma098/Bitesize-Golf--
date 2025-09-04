import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/themes/theme_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final LevelType? levelType;
  final VoidCallback? onBackPressed;
  final bool useGradient;
  final bool centerTitle;
  final double? elevation;
  final TextStyle? titleStyle;
  final Color? iconColor;
  final double fontSize;
  final FontWeight fontWeight;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.levelType,
    this.onBackPressed,
    this.useGradient = false,
    this.centerTitle = true,
    this.elevation = 0,
    this.titleStyle,
    this.iconColor,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w600,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get current level colors or default to blue
    final currentLevel = levelType ?? LevelType.redLevel;
    final backgroundColor = currentLevel.color;
    final textColor = iconColor ?? Colors.white;

    // Determine if we should use light or dark status bar icons
    final bool isDarkBackground = _isDarkColor(backgroundColor);

    return Container(
      decoration: useGradient
          ? BoxDecoration(gradient: currentLevel.gradient)
          : null,
      child: AppBar(
        title: Text(
          title,
          style:
              titleStyle ??
              GoogleFonts.inter(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: textColor,
              ),
        ),
        backgroundColor: useGradient ? Colors.transparent : backgroundColor,
        elevation: elevation,
        leading: _buildLeading(context, textColor),
        actions: _buildActions(textColor),
        centerTitle: centerTitle,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDarkBackground
              ? Brightness.light
              : Brightness.dark,
          statusBarBrightness: isDarkBackground
              ? Brightness.dark
              : Brightness.light,
        ),
      ),
    );
  }

  Widget? _buildLeading(BuildContext context, Color textColor) {
    if (leading != null) return leading;

    if (showBackButton && Navigator.of(context).canPop()) {
      return IconButton(
        icon: Icon(Icons.arrow_back, color: textColor, size: 20),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        tooltip: 'Back',
      );
    }

    return null;
  }

  List<Widget>? _buildActions(Color textColor) {
    if (actions == null) return null;

    return actions!.map((action) {
      if (action is IconButton) {
        return IconButton(
          icon: action.icon,
          color: textColor,
          onPressed: action.onPressed,
          tooltip: action.tooltip,
        );
      }
      return action;
    }).toList();
  }

  bool _isDarkColor(Color color) {
    // Calculate luminance to determine if the color is dark
    final luminance = color.computeLuminance();
    return luminance < 0.5;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

// Extension to make it easier to create level-specific app bars
extension CustomAppBarLevel on CustomAppBar {
  static CustomAppBar forLevel({
    required String title,
    required LevelType levelType,
    List<Widget>? actions,
    Widget? leading,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
    bool useGradient = false,
    bool centerTitle = true,
    double? elevation = 0,
    double fontSize = 18,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return CustomAppBar(
      title: title,
      levelType: levelType,
      actions: actions,
      leading: leading,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
      useGradient: useGradient,
      centerTitle: centerTitle,
      elevation: elevation,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }
}

// Helper class for common AppBar configurations
// class AppBarConfig {
//   static CustomAppBar home({
//     required LevelType levelType,
//     List<Widget>? actions,
//   }) {
//     return CustomAppBar.forLevel(
//       title: 'Home',
//       levelType: levelType,
//       showBackButton: false,
//       actions: actions,
//       useGradient: true,
//     );
//   }
//
//   static CustomAppBar profile({
//     required LevelType levelType,
//     VoidCallback? onBackPressed,
//   }) {
//     return CustomAppBar.forLevel(
//       title: 'Profile',
//       levelType: levelType,
//       onBackPressed: onBackPressed,
//     );
//   }
//
//   static CustomAppBar levelScreen({
//     required LevelType levelType,
//     VoidCallback? onBackPressed,
//     List<Widget>? actions,
//   }) {
//     return CustomAppBar.forLevel(
//       title: levelType.name,
//       levelType: levelType,
//       onBackPressed: onBackPressed,
//       actions: actions,
//       useGradient: true,
//     );
//   }
//
//   static CustomAppBar settings({
//     required LevelType levelType,
//     VoidCallback? onBackPressed,
//   }) {
//     return CustomAppBar.forLevel(
//       title: 'Settings',
//       levelType: levelType,
//       onBackPressed: onBackPressed,
//     );
//   }
//
//   static CustomAppBar custom({
//     required String title,
//     required LevelType levelType,
//     List<Widget>? actions,
//     Widget? leading,
//     bool showBackButton = true,
//     VoidCallback? onBackPressed,
//     bool useGradient = false,
//     bool centerTitle = true,
//     double? elevation = 0,
//     double fontSize = 18,
//     FontWeight fontWeight = FontWeight.w600,
//   }) {
//     return CustomAppBar.forLevel(
//       title: title,
//       levelType: levelType,
//       actions: actions,
//       leading: leading,
//       showBackButton: showBackButton,
//       onBackPressed: onBackPressed,
//       useGradient: useGradient,
//       centerTitle: centerTitle,
//       elevation: elevation,
//       fontSize: fontSize,
//       fontWeight: fontWeight,
//     );
//   }
// }

// Usage examples for different screens
/*

// Example 1: Home screen with gradient and no back button
AppBar homeAppBar = AppBarConfig.home(
  levelType: currentUserLevel,
  actions: [
    IconButton(
      icon: Icon(Icons.notifications),
      onPressed: () => Navigator.pushNamed(context, '/notifications'),
    ),
    IconButton(
      icon: Icon(Icons.settings),
      onPressed: () => Navigator.pushNamed(context, '/settings'),
    ),
  ],
);

// Example 2: Profile screen
AppBar profileAppBar = AppBarConfig.profile(
  levelType: currentUserLevel,
  onBackPressed: () {
    // Custom back action
    Navigator.pop(context);
  },
);

// Example 3: Level-specific screen with gradient
AppBar levelAppBar = AppBarConfig.levelScreen(
  levelType: LevelType.goldLevel,
  actions: [
    IconButton(
      icon: Icon(Icons.share),
      onPressed: () => shareLevel(),
    ),
  ],
);

// Example 4: Custom app bar
AppBar customAppBar = AppBarConfig.custom(
  title: 'Custom Screen',
  levelType: LevelType.violetLevel,
  useGradient: true,
  fontSize: 20,
  fontWeight: FontWeight.bold,
  actions: [
    PopupMenuButton<String>(
      onSelected: (value) => handleMenuAction(value),
      itemBuilder: (context) => [
        PopupMenuItem(value: 'share', child: Text('Share')),
        PopupMenuItem(value: 'save', child: Text('Save')),
        PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    ),
  ],
);

// Example 5: Direct usage with specific level
AppBar directAppBar = CustomAppBar(
  title: 'My Screen',
  levelType: LevelType.redLevel,
  useGradient: true,
  actions: [
    IconButton(
      icon: Icon(Icons.favorite),
      onPressed: () => toggleFavorite(),
    ),
  ],
);

*/
