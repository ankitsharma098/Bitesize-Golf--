import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/themes/theme_colors.dart';

class RadioTile<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final LevelType? levelType;

  const RadioTile({
    Key? key,
    required this.title,
    this.subtitle,
    required this.value,
    this.groupValue,
    this.onChanged,
    this.levelType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
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
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.grey600),
            )
          : null,
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: levelType?.color ?? AppColors.blueDark,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }
}
