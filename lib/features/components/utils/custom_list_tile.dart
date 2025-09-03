import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/themes/theme_colors.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  final LevelType? levelType;

  const CustomListTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.showDivider = true,
    this.levelType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: ListTile(
            title: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.grey900,
              ),
            ),
            subtitle: subtitle != null
                ? Text(
                    subtitle!,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.grey600,
                    ),
                  )
                : null,
            leading: leading,
            trailing: trailing,
            onTap: onTap,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.grey200,
            indent: leading != null ? 72 : 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
