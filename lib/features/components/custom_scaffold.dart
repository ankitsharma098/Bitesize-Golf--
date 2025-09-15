import 'package:flutter/material.dart';
import 'package:bitesize_golf/core/themes/theme_colors.dart';
import 'package:bitesize_golf/features/components/utils/size_config.dart';
import 'package:bitesize_golf/features/components/utils/custom_app_bar.dart';

enum ScreenType {
  form, // For login, register, etc. with form padding
  content, // For home screens, lists, etc.
  splash, // For splash screens with gradient
  fullScreen, // No padding, full control
}

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final bool showBackButton;
  final bool centerTitle;
  final LevelType? levelType;
  final ScreenType screenType;
  final bool safeArea;
  final bool scrollable;
  final EdgeInsetsGeometry? customPadding;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final bool resizeToAvoidBottomInset;

  const CustomScaffold({
    super.key,
    required this.body,
    this.title,
    this.showBackButton = false,
    this.centerTitle = false,
    this.levelType = LevelType.redLevel,
    this.screenType = ScreenType.content,
    this.safeArea = true,
    this.scrollable = false,
    this.customPadding,
    this.backgroundColor,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.actions,
    this.onBackPressed,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize SizeConfig for consistent sizing
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: backgroundColor ?? _getBackgroundColor(),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    if (title == null && !showBackButton && actions == null) {
      return null; // No app bar needed
    }

    return CustomAppBar(
      title: title ?? '',
      showBackButton: showBackButton,
      centerTitle: centerTitle,
      levelType: levelType!,
      actions: actions,
      onBackPressed: onBackPressed,
    );
  }

  Color _getBackgroundColor() {
    switch (screenType) {
      case ScreenType.splash:
        return AppColors.redDark; // Let gradient show through
      case ScreenType.form:
        return AppColors.scaffoldBgColor;
      case ScreenType.content:
        return AppColors.scaffoldBgColor;
      case ScreenType.fullScreen:
        return AppColors.scaffoldBgColor;
      default:
        return AppColors.scaffoldBgColor;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    if (customPadding != null) return customPadding!;

    switch (screenType) {
      case ScreenType.form:
        return EdgeInsets.all(SizeConfig.scaleWidth(12));
      case ScreenType.content:
        return EdgeInsets.symmetric(
          horizontal: SizeConfig.scaleWidth(16),
          vertical: SizeConfig.scaleHeight(8),
        );
      case ScreenType.splash:
      case ScreenType.fullScreen:
        return EdgeInsets.zero;
    }
  }

  Widget _buildBody() {
    Widget bodyWidget = body;

    // FIXED: Handle scrollable FIRST, then add SafeArea and Padding
    if (scrollable) {
      bodyWidget = SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: bodyWidget,
      );
    }

    // Add safe area if requested
    if (safeArea) {
      bodyWidget = SafeArea(child: bodyWidget);
    }

    // Add padding if not fullscreen or splash
    if (screenType != ScreenType.fullScreen &&
        screenType != ScreenType.splash) {
      bodyWidget = Padding(padding: _getPadding(), child: bodyWidget);
    }

    return bodyWidget;
  }
}

// Specialized factory class for common screen types
class AppScaffold {
  static Widget form({
    Key? key,
    required Widget body,
    String? title,
    bool showBackButton = false,
    bool centerTitle = false,
    LevelType levelType = LevelType.redLevel,
    bool scrollable = true,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
  }) {
    return CustomScaffold(
      key: key,
      body: body,
      title: title,
      showBackButton: showBackButton,
      centerTitle: centerTitle,
      levelType: levelType,
      screenType: ScreenType.form,
      scrollable: scrollable,
      actions: actions,
      onBackPressed: onBackPressed,
    );
  }

  static Widget content({
    Key? key,
    required Widget body,
    String? title,
    bool showBackButton = false,
    bool centerTitle = true,
    LevelType levelType = LevelType.redLevel,
    bool scrollable = false,
    Widget? floatingActionButton,
    Widget? bottomNavigationBar,
    List<Widget>? actions,
  }) {
    return CustomScaffold(
      key: key,
      body: body,
      title: title,
      showBackButton: showBackButton,
      centerTitle: centerTitle,
      levelType: levelType,
      screenType: ScreenType.content,
      scrollable: scrollable,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      actions: actions,
    );
  }

  static Widget splash({Key? key, required Widget body}) {
    return CustomScaffold(
      key: key,
      body: body,
      screenType: ScreenType.splash,
      safeArea: false,
    );
  }

  static Widget fullScreen({
    Key? key,
    required Widget body,
    String? title,
    bool showBackButton = false,
    Color? backgroundColor,
    Widget? floatingActionButton,
    Widget? bottomNavigationBar,
  }) {
    return CustomScaffold(
      key: key,
      body: body,
      title: title,
      showBackButton: showBackButton,
      screenType: ScreenType.fullScreen,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
