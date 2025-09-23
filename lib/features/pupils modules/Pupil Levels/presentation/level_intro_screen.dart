import 'package:bitesize_golf/features/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:bitesize_golf/core/themes/theme_colors.dart';
import 'package:bitesize_golf/features/components/utils/size_config.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Models/level model/level_model.dart';
import '../../../../core/themes/asset_custom.dart';
import '../../../components/custom_scaffold.dart';
import '../level overview/presentation/level_overview_screen.dart';

class LevelDetailScreen extends StatelessWidget {
  final LevelModel levelModel;

  const LevelDetailScreen({super.key, required this.levelModel});

  @override
  Widget build(BuildContext context) {
    return AppScaffold.levelScreen(
      title: _getLevelTypeFromModel().name,
      levelType: _getLevelTypeFromModel(),
      showBackButton: true,
      scrollable: true,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        // Main Content Card
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.scaleWidth(0),
            vertical: SizeConfig.scaleWidth(15),
          ),
          padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(20)),
          ),
          child: Column(
            children: [
              // Welcome Header
              _buildWelcomeHeader(),

              SizedBox(height: SizeConfig.scaleHeight(24)),

              // Description Content
              _buildDescriptionContent(),

              SizedBox(height: SizeConfig.scaleHeight(24)),

              // Golf Ball Character (placeholder for now)
              _buildCharacterSection(),
            ],
          ),
        ),

        // Action Buttons
        _buildActionButtons(context),

        SizedBox(height: SizeConfig.scaleHeight(24)),
      ],
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      children: [
        Text(
          'Welcome to',
          style: TextStyle(
            fontSize: SizeConfig.scaleText(24),
            fontWeight: FontWeight.w700,
            color: AppColors.grey900,
          ),
        ),
        SizedBox(height: SizeConfig.scaleHeight(4)),
        Text(
          '${_getLevelTypeFromModel().name} ${levelModel.levelNumber}',
          style: TextStyle(
            fontSize: SizeConfig.scaleText(28),
            fontWeight: FontWeight.bold,
            color: _getLevelTypeFromModel().color,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionContent() {
    return Html(
      data: levelModel.pupilDescription,
      style: {
        "body": Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(SizeConfig.scaleText(16)),
          color: AppColors.grey800,
          fontWeight: FontWeight.w600,
          lineHeight: const LineHeight(1.6),
          textAlign: TextAlign.left,
        ),
        "p": Style(
          margin: Margins.only(bottom: SizeConfig.scaleHeight(16)),
          fontSize: FontSize(SizeConfig.scaleText(16)),
          color: AppColors.grey800,

          lineHeight: const LineHeight(1.6),
          fontWeight: FontWeight.w600,
        ),
        "ul": Style(
          margin: Margins.only(
            left: SizeConfig.scaleWidth(0),
            bottom: SizeConfig.scaleHeight(16),
            top: SizeConfig.scaleHeight(8),
          ),
          fontWeight: FontWeight.w600,

          padding: HtmlPaddings.only(left: SizeConfig.scaleWidth(20)),
        ),
        "li": Style(
          margin: Margins.only(bottom: SizeConfig.scaleHeight(8)),
          fontSize: FontSize(SizeConfig.scaleText(16)),
          color: AppColors.grey800,
          lineHeight: const LineHeight(1.6),
          listStyleType: ListStyleType.disc,
          listStylePosition: ListStylePosition.outside,
          fontWeight: FontWeight.w600,
        ),
        "strong": Style(
          fontWeight: FontWeight.w600,
          color: _getLevelTypeFromModel().color,
        ),
        "em": Style(fontStyle: FontStyle.italic, color: AppColors.grey700),
      },
    );
  }

  Widget _buildCharacterSection() {
    return SizedBox(
      height: SizeConfig.scaleHeight(150),
      child: Center(
        child: SvgPicture.asset(
          BallAssetProvider.getWelcomeBall(_getLevelTypeFromModel()),
          width: SizeConfig.scaleWidth(100),
          height: SizeConfig.scaleWidth(100),
          fit: BoxFit.contain,
          allowDrawingOutsideViewBox: true,
          errorBuilder: (context, error, stackTrace) {
            //print("Error ${error}");
            return Icon(
              Icons.sports_golf,
              size: SizeConfig.scaleWidth(40),
              color: _getLevelTypeFromModel().color,
            );
          },

          placeholderBuilder: (context) {
            // Fallback to a generic icon if asset fails to load
            return Container(
              width: SizeConfig.scaleWidth(80),
              height: SizeConfig.scaleWidth(80),
              decoration: BoxDecoration(
                color: AppColors.grey300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.sports_golf,
                size: SizeConfig.scaleWidth(40),
                color: _getLevelTypeFromModel().color,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Primary Start Button
        CustomButtonFactory.primary(
          levelType: _getLevelTypeFromModel(),
          onPressed: levelModel.isActive && levelModel.isPublished
              ? () => _navigateToLevel(context)
              : null,
          text: 'Start ${_getLevelTypeFromModel().name}',
        ),
        SizedBox(height: SizeConfig.scaleHeight(12)),

        // Secondary Media Button
        CustomButtonFactory.faded(
          levelType: _getLevelTypeFromModel(),
          onPressed: () => _navigateToMedia(context),
          text: 'View Media',
        ),
      ],
    );
  }

  // Helper Methods

  LevelType _getLevelTypeFromModel() {
    // Map level number or access tier to LevelType
    switch (levelModel.levelNumber) {
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
        // Fallback: map by access tier if level number doesn't match
        return _getLevelTypeByAccessTier();
    }
  }

  LevelType _getLevelTypeByAccessTier() {
    switch (levelModel.accessTier.toLowerCase()) {
      case 'red':
        return LevelType.redLevel;
      case 'orange':
        return LevelType.orangeLevel;
      case 'yellow':
        return LevelType.yellowLevel;
      case 'green':
        return LevelType.greenLevel;
      case 'blue':
        return LevelType.blueLevel;
      case 'indigo':
        return LevelType.indigoLevel;
      case 'violet':
        return LevelType.violetLevel;
      case 'coral':
        return LevelType.coralLevel;
      case 'silver':
        return LevelType.silverLevel;
      case 'gold':
        return LevelType.goldLevel;
      default:
        return LevelType.redLevel; // Default fallback
    }
  }

  void _navigateToLevel(BuildContext context) {
    //  print('Navigate to Level');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LevelOverviewScreen(levelModel: levelModel),
      ),
    );
  }

  void _navigateToMedia(BuildContext context) {}
}
