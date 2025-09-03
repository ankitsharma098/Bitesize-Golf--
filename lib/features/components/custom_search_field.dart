import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/themes/theme_colors.dart';

class CustomSearchField extends StatelessWidget {
  final String placeholder;
  final String? value;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const CustomSearchField({
    Key? key,
    this.placeholder = 'Search...',
    this.value,
    this.onChanged,
    this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: value != null ? TextEditingController(text: value) : null,
      onChanged: onChanged,
      style: GoogleFonts.inter(fontSize: 16),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: GoogleFonts.inter(color: AppColors.grey500),
        prefixIcon: Icon(Icons.search, color: AppColors.grey500),
        suffixIcon: value != null && value!.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: AppColors.grey500),
                onPressed: onClear,
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.grey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.blueDark, width: 2),
        ),
      ),
    );
  }
}
