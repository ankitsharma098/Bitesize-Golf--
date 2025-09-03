import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/themes/theme_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final LevelType? levelType;
  final LinearGradient? customGradient;
  final Color? customColor; // Added back for single color support
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
    this.customGradient,
    this.customColor, // Added back
    this.customTextColor,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.size = ButtonSize.medium,
    this.variant = ButtonVariant.filled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundGradient = _getBackgroundGradient();
    final backgroundColor = _getBackgroundColor();
    final textColor = _getTextColor();

    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isDisabled || isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: variant == ButtonVariant.filled ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: variant == ButtonVariant.outlined
                ? BorderSide(color: _getBorderColor(), width: 2)
                : BorderSide.none,
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            // Use gradient if available, otherwise use solid color
            gradient: variant == ButtonVariant.filled
                ? backgroundGradient
                : null,
            color: variant == ButtonVariant.filled && backgroundGradient == null
                ? backgroundColor
                : (variant != ButtonVariant.filled
                      ? (variant == ButtonVariant.text
                            ? Colors.transparent
                            : Colors.white)
                      : null),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
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
                        Icon(icon, size: size.iconSize, color: textColor),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: GoogleFonts.inter(
                          fontSize: size.fontSize,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  LinearGradient? _getBackgroundGradient() {
    if (variant == ButtonVariant.outlined || variant == ButtonVariant.text) {
      return null;
    }

    // Priority: customGradient > levelType > default gradient (only if no customColor)
    if (customGradient != null) return customGradient!;
    if (customColor != null)
      return null; // Don't use gradient if single color is provided
    if (levelType != null) {
      return LinearGradient(
        colors: [levelType!.color, levelType!.color.withOpacity(0.7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return const LinearGradient(
      colors: [AppColors.blueDark, Color(0xFF1976D2)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  Color? _getBackgroundColor() {
    if (variant == ButtonVariant.outlined || variant == ButtonVariant.text) {
      return null;
    }

    // Priority: customColor > levelType > default color
    if (customColor != null) return customColor!;
    if (levelType != null) return levelType!.color;
    return null; // Will fall back to gradient or default
  }

  Color _getTextColor() {
    if (variant == ButtonVariant.outlined || variant == ButtonVariant.text) {
      if (customGradient != null) return customGradient!.colors.first;
      if (customColor != null) return customColor!;
      if (levelType != null) return levelType!.color;
      return AppColors.blueDark;
    }

    return customTextColor ?? Colors.white;
  }

  Color _getBorderColor() {
    if (customGradient != null) return customGradient!.colors.first;
    if (customColor != null) return customColor!;
    if (levelType != null) return levelType!.color;
    return AppColors.blueDark;
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
