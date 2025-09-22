import 'package:bitesize_golf/features/components/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/themes/theme_colors.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final String? value;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap; // <-- NEW
  final bool readOnly;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final TextInputType keyboardType;
  final bool isEnabled;
  final String? errorText;
  final int maxLines;
  final LevelType? levelType;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final Color? customBorderColor;
  final Color? customFocusColor;

  const CustomTextField({
    Key? key,
    this.label,
    this.placeholder,
    this.value,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.onTap, // <-- NEW
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.keyboardType = TextInputType.text,
    this.isEnabled = true,
    this.errorText,
    this.maxLines = 1,
    this.levelType,
    this.validator,
    this.focusNode,
    this.textInputAction,
    this.autofocus = false,
    this.customBorderColor,
    this.customFocusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final focusColor = _getFocusColor();
    final borderColor = _getBorderColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: GoogleFonts.inter(
              fontSize: SizeConfig.scaleWidth(14),
              fontWeight: FontWeight.w500,
              color: AppColors.grey700,
            ),
          ),
          SizedBox(height: SizeConfig.scaleHeight(8)),
        ],
        TextFormField(
          controller: controller,
          initialValue: controller == null ? value : null,
          onChanged: onChanged,
          obscureText: obscureText,
          onTap: onTap, // <-- NEW
          readOnly: readOnly,
          keyboardType: keyboardType,
          enabled: isEnabled,
          maxLines: maxLines,
          validator: validator,
          focusNode: focusNode,
          textInputAction: textInputAction,
          autofocus: autofocus,
          style: GoogleFonts.inter(
            fontSize: SizeConfig.scaleWidth(16),
            color: AppColors.grey900,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: GoogleFonts.inter(
              fontSize: SizeConfig.scaleWidth(16),
              color: AppColors.grey500,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: AppColors.grey500,
                    size: SizeConfig.scaleWidth(20),
                  )
                : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(
                      suffixIcon,
                      color: AppColors.grey500,
                      size: SizeConfig.scaleWidth(20),
                    ),
                    onPressed: onSuffixIconTap,
                  )
                : null,
            filled: true,
            fillColor: isEnabled ? Colors.white : AppColors.grey100,
            contentPadding: EdgeInsets.symmetric(
              horizontal: SizeConfig.scaleWidth(16),
              vertical: SizeConfig.scaleHeight(16),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
              borderSide: BorderSide(color: focusColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            errorText: errorText,
            errorStyle: GoogleFonts.inter(
              fontSize: SizeConfig.scaleWidth(12),
              color: AppColors.error,
            ),
          ),
        ),
      ],
    );
  }

  Color _getFocusColor() {
    if (customFocusColor != null) return customFocusColor!;
    if (levelType != null) return levelType!.color;
    return AppColors.blueDark;
  }

  Color _getBorderColor() {
    if (customBorderColor != null) return customBorderColor!;
    return AppColors.grey300;
  }
}

// Extension for easier usage with different field types
extension CustomTextFieldFactory on CustomTextField {
  static CustomTextField email({
    String? label = 'Email*',
    String? placeholder = 'Enter your email',
    TextEditingController? controller,
    LevelType? levelType,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) {
    return CustomTextField(
      label: label,
      placeholder: placeholder,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icons.email_outlined,
      levelType: levelType,
      validator: validator ?? _defaultEmailValidator,
      onChanged: onChanged,
      textInputAction: TextInputAction.next,
    );
  }

  static CustomTextField name({
    String? label = 'Name*',
    String? placeholder = 'Enter your Name',
    TextEditingController? controller,
    LevelType? levelType,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) {
    return CustomTextField(
      label: label,
      placeholder: placeholder,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      levelType: levelType,
      validator: validator ?? _defaultEmailValidator,
      onChanged: onChanged,
      textInputAction: TextInputAction.next,
    );
  }

  static CustomTextField password({
    String? label = 'Password*',
    String? placeholder = 'Enter your password',
    TextEditingController? controller,
    LevelType? levelType,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
    required bool obscureText,
    required VoidCallback onToggleObscurity,
  }) {
    return CustomTextField(
      label: label,
      placeholder: placeholder,
      controller: controller,
      obscureText: obscureText,
      prefixIcon: Icons.lock_outline,
      suffixIcon: obscureText
          ? Icons.visibility_outlined
          : Icons.visibility_off_outlined,
      onSuffixIconTap: onToggleObscurity,
      levelType: levelType,
      validator: validator ?? _defaultPasswordValidator,
      onChanged: onChanged,
      textInputAction: TextInputAction.done,
    );
  }
  // Add this to your existing CustomTextFieldFactory extension

  static CustomTextField search({
    String? placeholder = 'Search by Name...',
    String? label,
    TextEditingController? controller,
    LevelType? levelType,
    ValueChanged<String>? onChanged,
    VoidCallback? onClear,
    bool showClearButton = true,
  }) {
    return CustomTextField(
      label: label,
      placeholder: placeholder,
      controller: controller,
      prefixIcon: Icons.search,
      suffixIcon:
          showClearButton && controller != null && controller.text.isNotEmpty
          ? Icons.clear
          : null,
      onSuffixIconTap:
          onClear ??
          () {
            controller?.clear();
            onChanged?.call('');
          },
      levelType: levelType,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
    );
  }

  // Alternative search with more customization options
  static CustomTextField searchAdvanced({
    String? placeholder = 'Search...',
    String? label,
    TextEditingController? controller,
    LevelType? levelType,
    ValueChanged<String>? onChanged,
    VoidCallback? onClear,
    VoidCallback? onSubmitted,
    IconData? searchIcon = Icons.search,
    IconData? clearIcon = Icons.clear,
    bool autofocus = false,
    bool showClearButton = true,
  }) {
    return CustomTextField(
      label: label,
      placeholder: placeholder,
      controller: controller,
      prefixIcon: searchIcon,
      suffixIcon:
          showClearButton && controller != null && controller.text.isNotEmpty
          ? clearIcon
          : null,
      onSuffixIconTap:
          onClear ??
          () {
            controller?.clear();
            onChanged?.call('');
          },
      levelType: levelType,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      autofocus: autofocus,
    );
  }

  static CustomTextField phone({
    String? label = 'Phone Number*',
    String? placeholder = 'Enter your phone number',
    TextEditingController? controller,
    LevelType? levelType,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) {
    return CustomTextField(
      label: label,
      placeholder: placeholder,
      controller: controller,
      keyboardType: TextInputType.phone,
      prefixIcon: Icons.phone_outlined,
      levelType: levelType,
      validator: validator ?? _defaultPhoneValidator,
      onChanged: onChanged,
      textInputAction: TextInputAction.next,
    );
  }

  static CustomTextField multiline({
    String? label,
    String? placeholder,
    TextEditingController? controller,
    LevelType? levelType,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
    int maxLines = 4,
  }) {
    return CustomTextField(
      label: label,
      placeholder: placeholder,
      controller: controller,
      maxLines: maxLines,
      levelType: levelType,
      validator: validator,
      onChanged: onChanged,
      textInputAction: TextInputAction.newline,
    );
  }

  // inside custom_text_field.dart  extension CustomTextFieldFactory
  static CustomTextField date({
    required TextEditingController controller,
    String? label,
    String? placeholder,
    LevelType? levelType,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) => CustomTextField(
    controller: controller,
    label: label,
    placeholder: placeholder,
    levelType: levelType,
    validator: validator,
    onTap: onTap,
    readOnly: true,
    prefixIcon: Icons.calendar_today,
    textInputAction: TextInputAction.next,
  );

  static CustomTextField dropdown({
    required TextEditingController controller,
    String? label,
    String? placeholder,
    LevelType? levelType,
    VoidCallback? onTap,
    String? Function(String?)? validator,
    bool locked = false, // 🔒 new param
  }) => CustomTextField(
    controller: controller,
    label: label,
    placeholder: placeholder,
    levelType: levelType,
    validator: locked ? null : validator, // no validation if locked
    onTap: locked ? null : onTap, // disable tap
    readOnly: true,
    isEnabled: !locked, // grey background
    suffixIcon: Icons.arrow_drop_down,
    textInputAction: TextInputAction.next,
  );

  static CustomTextField number({
    required TextEditingController controller,
    String? label,
    String? placeholder,
    LevelType? levelType,
    String? Function(String?)? validator,
  }) => CustomTextField(
    controller: controller,
    label: label,
    placeholder: placeholder,
    levelType: levelType,
    validator: validator,
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
  );

  // Default validators
  static String? _defaultEmailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? _defaultPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? _defaultPhoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length < 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}
