import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/themes/theme_colors.dart';

class LevelBadge extends StatelessWidget {
  final LevelType levelType;
  final String? customText;
  final bool isSmall;

  const LevelBadge({
    Key? key,
    required this.levelType,
    this.customText,
    this.isSmall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 12,
        vertical: isSmall ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: levelType.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        customText ?? levelType.name,
        style: GoogleFonts.inter(
          fontSize: isSmall ? 12 : 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
