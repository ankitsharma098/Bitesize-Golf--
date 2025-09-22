import 'package:flutter/material.dart';
import 'package:bitesize_golf/core/themes/theme_colors.dart';
import 'package:bitesize_golf/features/components/utils/size_config.dart';
import 'package:bitesize_golf/features/components/utils/custom_app_bar.dart';

enum ScreenType { form, content, splash, fullScreen, tabScreen }

enum AppBarType { none, transparent, colored, gradient, custom }

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final bool showBackButton;
  final bool centerTitle;
  final LevelType? levelType;
  final ScreenType screenType;
  final AppBarType appBarType;
  final bool safeArea;
  final bool scrollable;
  final EdgeInsetsGeometry? customPadding;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final bool resizeToAvoidBottomInset;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? customAppBar;

  const CustomScaffold({
    super.key,
    required this.body,
    this.title,
    this.showBackButton = false,
    this.centerTitle = false,
    this.levelType = LevelType.redLevel,
    this.screenType = ScreenType.content,
    this.appBarType = AppBarType.colored,
    this.safeArea = true,
    this.scrollable = false,
    this.customPadding,
    this.backgroundColor,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.actions,
    this.onBackPressed,
    this.resizeToAvoidBottomInset = true,
    this.automaticallyImplyLeading = true,
  }) : customAppBar = null;

  const CustomScaffold.withCustomAppBar({
    super.key,
    required this.body,
    required this.customAppBar,
    this.screenType = ScreenType.content,
    this.safeArea = true,
    this.scrollable = false,
    this.customPadding,
    this.backgroundColor,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
  }) : title = null,
       showBackButton = false,
       centerTitle = false,
       levelType = null,
       appBarType = AppBarType.custom,
       actions = null,
       onBackPressed = null,
       automaticallyImplyLeading = true;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: backgroundColor ?? _getBackgroundColor(),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: _buildAppBar(context),
      body: _buildBody(),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      extendBodyBehindAppBar: appBarType == AppBarType.transparent,
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    if (customAppBar != null) return customAppBar;

    if (appBarType == AppBarType.none) return null;

    if (title == null &&
        !showBackButton &&
        (actions == null || actions!.isEmpty)) {
      return null;
    }

    switch (appBarType) {
      case AppBarType.transparent:
        return _buildTransparentAppBar(context);
      case AppBarType.colored:
        return _buildColoredAppBar(context);
      case AppBarType.gradient:
        return _buildGradientAppBar(context);
      case AppBarType.none:
      case AppBarType.custom:
      default:
        return null;
    }
  }

  PreferredSizeWidget _buildTransparentAppBar(BuildContext context) {
    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.scaleText(18),
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading && showBackButton,
      leading: _buildLeading(context),
      actions: _buildActions(),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  PreferredSizeWidget _buildColoredAppBar(BuildContext context) {
    final currentLevel = levelType ?? LevelType.redLevel;

    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.scaleText(18),
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      backgroundColor: currentLevel.color,
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading && showBackButton,
      leading: _buildLeading(context),
      actions: _buildActions(),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  PreferredSizeWidget _buildGradientAppBar(BuildContext context) {
    final currentLevel = levelType ?? LevelType.redLevel;

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(gradient: currentLevel.gradient),
        child: AppBar(
          title: title != null
              ? Text(
                  title!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.scaleText(18),
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: centerTitle,
          automaticallyImplyLeading:
              automaticallyImplyLeading && showBackButton,
          leading: _buildLeading(context),
          actions: _buildActions(),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (!showBackButton) return null;

    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
    );
  }

  List<Widget>? _buildActions() {
    return actions?.map((action) {
      if (action is IconButton) {
        return IconButton(
          icon: action.icon,
          onPressed: action.onPressed,
          color: Colors.white,
        );
      }
      return action;
    }).toList();
  }

  Color _getBackgroundColor() {
    switch (screenType) {
      case ScreenType.splash:
        return AppColors.redDark;
      case ScreenType.form:
        return AppColors.scaffoldBgColor;
      case ScreenType.content:
      case ScreenType.tabScreen:
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
        return EdgeInsets.all(SizeConfig.scaleWidth(16));
      case ScreenType.content:
        return EdgeInsets.symmetric(
          horizontal: SizeConfig.scaleWidth(16),
          vertical: SizeConfig.scaleHeight(8),
        );
      case ScreenType.tabScreen:
        return EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(16));
      case ScreenType.splash:
      case ScreenType.fullScreen:
        return EdgeInsets.zero;
    }
  }

  Widget _buildBody() {
    Widget bodyWidget = body;

    if (scrollable) {
      bodyWidget = SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: bodyWidget,
      );
    }

    if (safeArea) {
      bodyWidget = SafeArea(child: bodyWidget);
    }

    if (screenType != ScreenType.fullScreen &&
        screenType != ScreenType.splash) {
      bodyWidget = Padding(padding: _getPadding(), child: bodyWidget);
    }

    return bodyWidget;
  }
}

class AppScaffold {


  static Widget withCustomAppBar({
    Key? key,
    required Widget body,
    required PreferredSizeWidget appBar,
    ScreenType screenType = ScreenType.content,
    bool scrollable = false,
    bool safeArea = true,
    EdgeInsetsGeometry? customPadding,
    Color? backgroundColor,
    Widget? floatingActionButton,
    Widget? bottomNavigationBar,
    bool resizeToAvoidBottomInset = true,
  }) {
    return CustomScaffold.withCustomAppBar(
      key: key,
      body: body,
      customAppBar: appBar,
      screenType: screenType,
      scrollable: scrollable,
      safeArea: safeArea,
      customPadding: customPadding,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }


  static Widget tabScreen({
    Key? key,
    required Widget body,
    String? title,
    LevelType levelType = LevelType.redLevel,
    bool scrollable = false,
    List<Widget>? actions,
    AppBarType appBarType = AppBarType.colored,
  }) {
    return CustomScaffold(
      key: key,
      body: body,
      title: title,
      levelType: levelType,
      screenType: ScreenType.tabScreen,
      appBarType: appBarType,
      scrollable: scrollable,
      actions: actions,
      showBackButton: false,
      centerTitle: true,
    );
  }

  static Widget form({
    Key? key,
    required Widget body,
    String? title,
    bool showBackButton = true,
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
      levelType: levelType,
      screenType: ScreenType.form,
      appBarType: AppBarType.colored,
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
    LevelType levelType = LevelType.redLevel,
    bool scrollable = false,
    AppBarType appBarType = AppBarType.colored,
    Widget? floatingActionButton,
    Widget? bottomNavigationBar,
    List<Widget>? actions,
  }) {
    return CustomScaffold(
      key: key,
      body: body,
      title: title,
      showBackButton: showBackButton,
      levelType: levelType,
      screenType: ScreenType.content,
      appBarType: appBarType,
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
      appBarType: AppBarType.none,
      safeArea: false,
    );
  }

  static Widget fullScreen({
    Key? key,
    required Widget body,
    String? title,
    bool showBackButton = false,
    AppBarType appBarType = AppBarType.none,
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
      appBarType: appBarType,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  static Widget levelScreen({
    Key? key,
    required Widget body,
    String? title,
    required LevelType levelType,
    bool showBackButton = true,
    bool scrollable = false,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
  }) {
    return CustomScaffold(
      key: key,
      body: body,
      title: title,
      showBackButton: showBackButton,
      levelType: levelType,
      screenType: ScreenType.content,
      appBarType: AppBarType.gradient,
      scrollable: scrollable,
      actions: actions,
      onBackPressed: onBackPressed,
    );
  }
}
