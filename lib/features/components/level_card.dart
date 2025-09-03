import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/themes/theme_colors.dart';

class LevelCard extends StatelessWidget {
  final LevelType levelType;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isCompleted;
  final IconData? leadingIcon;

  const LevelCard({
    Key? key,
    required this.levelType,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.isCompleted = false,
    this.leadingIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted ? levelType.color : AppColors.grey300,
          width: isCompleted ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                if (leadingIcon != null)
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: levelType.lightColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(leadingIcon, color: levelType.color, size: 24),
                  ),
                if (leadingIcon != null) SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey900,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
                if (isCompleted)
                  Icon(Icons.check_circle, color: levelType.color, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final StatusType statusType;
  final IconData? icon;
  final VoidCallback? onTap;
  final Widget? trailing;

  const StatusCard({
    Key? key,
    required this.title,
    this.subtitle,
    required this.statusType,
    this.icon,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusType.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusType.color, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: statusType.color, size: 20),
              SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: statusType.textColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: statusType.textColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

enum StatusType {
  done(
    color: AppColors.success,
    backgroundColor: Color(0xFFEDF7ED),
    textColor: Color(0xFF1B5E20),
  ),
  notPassed(
    color: AppColors.error,
    backgroundColor: Color(0xFFFDEDED),
    textColor: Color(0xFFC62828),
  ),
  inProgress(
    color: AppColors.warning,
    backgroundColor: Color(0xFFFFF4E6),
    textColor: Color(0xFFE65100),
  ),
  resetSelections(
    color: AppColors.error,
    backgroundColor: Color(0xFFFDEDED),
    textColor: Color(0xFFC62828),
  );

  const StatusType({
    required this.color,
    required this.backgroundColor,
    required this.textColor,
  });

  final Color color;
  final Color backgroundColor;
  final Color textColor;
}
