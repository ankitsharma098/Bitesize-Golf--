import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/themes/theme_colors.dart';

class NotificationBanner extends StatelessWidget {
  final String message;
  final NotificationType type;
  final VoidCallback? onDismiss;
  final Widget? action;

  const NotificationBanner({
    Key? key,
    required this.message,
    required this.type,
    this.onDismiss,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: type.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: type.color, width: 1),
      ),
      child: Row(
        children: [
          Icon(type.icon, color: type.color, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(fontSize: 14, color: type.textColor),
            ),
          ),
          if (action != null) ...[SizedBox(width: 12), action!],
          if (onDismiss != null) ...[
            SizedBox(width: 12),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(Icons.close, color: type.color, size: 18),
            ),
          ],
        ],
      ),
    );
  }
}

enum NotificationType {
  success(
    color: AppColors.success,
    backgroundColor: Color(0xFFEDF7ED),
    textColor: Color(0xFF1B5E20),
    icon: Icons.check_circle,
  ),
  error(
    color: AppColors.error,
    backgroundColor: Color(0xFFFDEDED),
    textColor: Color(0xFFC62828),
    icon: Icons.error,
  ),
  warning(
    color: AppColors.warning,
    backgroundColor: Color(0xFFFFF4E6),
    textColor: Color(0xFFE65100),
    icon: Icons.warning,
  ),
  info(
    color: AppColors.info,
    backgroundColor: Color(0xFFE3F2FD),
    textColor: Color(0xFF1565C0),
    icon: Icons.info,
  );

  const NotificationType({
    required this.color,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
  });

  final Color color;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;
}
