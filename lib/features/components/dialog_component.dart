import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/themes/theme_colors.dart';

class CustomModal extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final bool canDismiss;
  final LevelType? levelType;

  const CustomModal({
    Key? key,
    required this.title,
    required this.content,
    this.actions,
    this.canDismiss = true,
    this.levelType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: levelType?.color ?? AppColors.grey900,
                    ),
                  ),
                ),
                if (canDismiss)
                  IconButton(
                    icon: Icon(Icons.close, color: AppColors.grey600),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
              ],
            ),
            SizedBox(height: 16),
            content,
            if (actions != null) ...[
              SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: actions!),
            ],
          ],
        ),
      ),
    );
  }
}
