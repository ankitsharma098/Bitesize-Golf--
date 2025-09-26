import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../Models/book model/book_model.dart';
import '../../../../../core/themes/asset_custom.dart';
import '../../../../../core/themes/theme_colors.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/utils/size_config.dart';

class BookWelcomeWidget extends StatelessWidget {
  final BookModel book;
  final LevelType levelType;
  final VoidCallback onStartReading;

  const BookWelcomeWidget({
    super.key,
    required this.book,
    required this.levelType,
    required this.onStartReading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Welcome Card centered
        Expanded(
          child: Center(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(SizeConfig.scaleWidth(32)),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, // Ensures the card takes only necessary height
                children: [
                  // Title
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome to your\n',
                          style: TextStyle(
                            fontSize: SizeConfig.scaleText(24),
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey900,
                            height: 1.3,
                          ),
                        ),
                        TextSpan(
                          text: '${levelType.name} Book!',
                          style: TextStyle(
                            fontSize: SizeConfig.scaleText(24),
                            fontWeight: FontWeight.w600,
                            color: levelType.color,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: SizeConfig.scaleHeight(24)),

                  // Description
                  Text(
                    book.description,
                    style: TextStyle(
                      fontSize: SizeConfig.scaleText(16),
                      color: AppColors.grey700,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: SizeConfig.scaleHeight(32)),

                  // Character Illustration
                  Image.asset(
                    BallAssetProvider.getKnowBall(levelType),
                    width: SizeConfig.scaleWidth(120),
                    height: SizeConfig.scaleWidth(120),
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.menu_book,
                        size: SizeConfig.scaleWidth(80),
                        color: levelType.color,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),

        // Start Reading Button at the bottom
        CustomButtonFactory.primary(
          levelType: levelType,
          onPressed: onStartReading,
          text: 'Start Reading',
        ),

        SizedBox(height: SizeConfig.scaleHeight(40)),
      ],
    );
  }
}
