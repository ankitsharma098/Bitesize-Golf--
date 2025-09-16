import 'package:bitesize_golf/features/components/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../../core/themes/theme_colors.dart';

class AvatarWidget extends StatelessWidget {
  final String? avatarUrl;

  const AvatarWidget({super.key, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.scaleWidth(
        120,
      ), // Slightly larger to accommodate border and padding
      height: SizeConfig.scaleWidth(120),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 6), // White border
      ),
      child: Container(
        width: SizeConfig.scaleWidth(108), // Adjusted for padding
        height: SizeConfig.scaleWidth(108),
        padding: const EdgeInsets.all(
          6,
        ), // Padding between border and inner content
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.grey300, // Grey background
        ),
        child: ClipOval(
          child: Image(
            image: NetworkImage(
              avatarUrl ??
                  'https://static.vecteezy.com/system/resources/thumbnails/020/911/730/small/profile-icon-avatar-icon-user-icon-person-icon-free-png.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
