import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/themes/theme_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final LevelType? levelType;
  final Color? customColor;
  final Color? customTextColor;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final ButtonSize size;
  final ButtonVariant variant;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.levelType,
    this.customColor,
    this.customTextColor,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.size = ButtonSize.medium,
    this.variant = ButtonVariant.filled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = _getBackgroundColor();
    Color textColor = _getTextColor();

    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isDisabled || isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: variant == ButtonVariant.filled ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: variant == ButtonVariant.outlined
                ? BorderSide(color: backgroundColor, width: 2)
                : BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: size.iconSize),
                    SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: GoogleFonts.inter(
                      fontSize: size.fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (variant == ButtonVariant.outlined || variant == ButtonVariant.text) {
      return variant == ButtonVariant.text ? Colors.transparent : Colors.white;
    }

    if (customColor != null) return customColor!;
    if (levelType != null) return levelType!.color;
    return AppColors.blueDark;
  }

  Color _getTextColor() {
    if (variant == ButtonVariant.outlined || variant == ButtonVariant.text) {
      if (customColor != null) return customColor!;
      if (levelType != null) return levelType!.color;
      return AppColors.blueDark;
    }

    return customTextColor ?? Colors.white;
  }
}

enum ButtonSize {
  small(height: 36.0, fontSize: 14.0, iconSize: 16.0),
  medium(height: 48.0, fontSize: 16.0, iconSize: 20.0),
  large(height: 56.0, fontSize: 18.0, iconSize: 24.0);

  const ButtonSize({
    required this.height,
    required this.fontSize,
    required this.iconSize,
  });

  final double height;
  final double fontSize;
  final double iconSize;
}

enum ButtonVariant { filled, outlined, text }
