import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/themes/theme_colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String? label;
  final T? value;
  final List<DropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? placeholder;
  final bool isEnabled;

  const CustomDropdown({
    Key? key,
    this.label,
    this.value,
    required this.items,
    this.onChanged,
    this.placeholder,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.grey700,
            ),
          ),
          SizedBox(height: 8),
        ],
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isEnabled ? Colors.white : AppColors.grey100,
            border: Border.all(color: AppColors.grey300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<T>(
            value: value,
            onChanged: isEnabled ? onChanged : null,
            isExpanded: true,
            underline: SizedBox(),
            hint: placeholder != null
                ? Text(
                    placeholder!,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.grey500,
                    ),
                  )
                : null,
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item.value,
                child: Row(
                  children: [
                    if (item.icon != null) ...[
                      Icon(item.icon, size: 20, color: AppColors.grey600),
                      SizedBox(width: 8),
                    ],
                    Text(
                      item.label,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.grey900,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class DropdownItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  const DropdownItem({required this.value, required this.label, this.icon});
}
