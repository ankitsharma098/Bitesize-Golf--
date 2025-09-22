import 'package:bitesize_golf/features/components/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/themes/theme_colors.dart';

/// Single reusable radio tile
class CustomRadioTile<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final String label;
  final Widget? icon;
  final LevelType? levelType;

  const CustomRadioTile({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
    this.icon,
    this.levelType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activeColor = levelType?.color ?? AppColors.redDark;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(12)),
      child: Container(
        padding: EdgeInsets.all(SizeConfig.scaleWidth(16)),
        decoration: BoxDecoration(
          color: Colors.white,
          // color: groupValue == value
          //     ? activeColor.withOpacity(.10)
          //     : Colors.grey[100],
          borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(12)),
          // border: Border.all(
          //   color: groupValue == value ? activeColor : Colors.grey[300]!,
          //   width: 2,
          // ),
        ),
        child: Row(
          children: [
            Icon(
              groupValue == value
                  ? Icons.radio_button_on
                  : Icons.radio_button_off,
              color: groupValue == value ? activeColor : Colors.grey[500],
              size: SizeConfig.scaleWidth(24),
            ),
            SizedBox(width: SizeConfig.scaleWidth(12)),
            if (icon != null) ...[
              icon!,
              SizedBox(width: SizeConfig.scaleWidth(8)),
            ],
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: SizeConfig.scaleWidth(16),
                  fontWeight: FontWeight.w600,
                  color: groupValue == value ? activeColor : Colors.grey[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Convenience wrapper for a **horizontal** group (2 items max fits nicely)
class CustomRadioGroup<T> extends StatelessWidget {
  final List<RadioOption<T>> options;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final LevelType? levelType;

  const CustomRadioGroup({
    Key? key,
    required this.options,
    required this.groupValue,
    required this.onChanged,
    this.levelType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options
          .map(
            (opt) => Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.scaleWidth(6),
                ),
                child: CustomRadioTile<T>(
                  value: opt.value,
                  groupValue: groupValue,
                  onChanged: onChanged,
                  label: opt.label,
                  icon: opt.icon,
                  levelType: levelType,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

/* ---------- bloc class ---------- */
class RadioOption<T> {
  final T value;
  final String label;
  final Widget? icon;

  const RadioOption({required this.value, required this.label, this.icon});
}
