import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/themes/theme_colors.dart';

class LoadingSpinner extends StatelessWidget {
  final LevelType? levelType;
  final double size;
  final String? message;

  const LoadingSpinner({
    Key? key,
    this.levelType,
    this.size = 40.0,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                levelType?.color ?? AppColors.blueDark,
              ),
            ),
          ),
          if (message != null) ...[
            SizedBox(height: 16),
            Text(
              message!,
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.grey600),
            ),
          ],
        ],
      ),
    );
  }
}
