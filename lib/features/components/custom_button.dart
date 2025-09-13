import 'package:bitesize_golf/features/components/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/themes/theme_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final LevelType? levelType;
  final LinearGradient? customGradient;
  final Color? customColor;
  final Color? customTextColor;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final ButtonSize size;
  final ButtonVariant variant;
  final double? width;
  final EdgeInsets? margin;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.levelType,
    this.customGradient,
    this.customColor,
    this.customTextColor,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.size = ButtonSize.medium,
    this.variant = ButtonVariant.filled,
    this.width,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundGradient = _getBackgroundGradient();
    final backgroundColor = _getBackgroundColor();
    final textColor = _getTextColor();

    return Container(
      margin: margin,
      width: width ?? double.infinity,
      height: SizeConfig.scaleHeight(size.height),
      child: ElevatedButton(
        onPressed: (isDisabled || isLoading) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: variant == ButtonVariant.filled ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
            side: variant == ButtonVariant.outlined
                ? BorderSide(color: _getBorderColor(), width: 2)
                : BorderSide.none,
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: variant == ButtonVariant.filled
                ? backgroundGradient
                : null,
            color: variant == ButtonVariant.filled && backgroundGradient == null
                ? (isDisabled
                      ? backgroundColor?.withOpacity(0.5)
                      : backgroundColor)
                : (variant != ButtonVariant.filled
                      ? (variant == ButtonVariant.text
                            ? Colors.transparent
                            : Colors.white)
                      : null),
            borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(8)),
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    height: SizeConfig.scaleWidth(20),
                    width: SizeConfig.scaleWidth(20),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: SizeConfig.scaleWidth(size.iconSize),
                          color: isDisabled
                              ? textColor.withOpacity(0.5)
                              : textColor,
                        ),
                        SizedBox(width: SizeConfig.scaleWidth(8)),
                      ],
                      Text(
                        text,
                        style: GoogleFonts.inter(
                          fontSize: SizeConfig.scaleWidth(size.fontSize),
                          fontWeight: FontWeight.w600,
                          color: isDisabled
                              ? textColor.withOpacity(0.5)
                              : textColor,
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

    if (customGradient != null) return customGradient!;
    if (customColor != null) return null;
    if (levelType != null) return levelType!.gradient;

    return AppColors.blueGradient;
  }

  Color? _getBackgroundColor() {
    if (variant == ButtonVariant.outlined || variant == ButtonVariant.text) {
      return null;
    }

    if (customColor != null) return customColor!;
    if (levelType != null) return levelType!.color;
    return AppColors.blueDark;
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

// Factory extension for common button types
extension CustomButtonFactory on CustomButton {
  static CustomButton primary({
    required String text,
    required VoidCallback? onPressed,
    LevelType? levelType,
    bool isLoading = false,
    ButtonSize size = ButtonSize.large,
    IconData? icon,
    double? width,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      levelType: levelType,
      isLoading: isLoading,
      size: size,
      variant: ButtonVariant.filled,
      icon: icon,
      width: width,
    );
  }

  static CustomButton secondary({
    required String text,
    required VoidCallback? onPressed,
    LevelType? levelType,
    bool isLoading = false,
    ButtonSize size = ButtonSize.large,
    IconData? icon,
    double? width,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      levelType: levelType,
      isLoading: isLoading,
      size: size,
      variant: ButtonVariant.outlined,
      icon: icon,
      width: width,
    );
  }

  static CustomButton text({
    required String text,
    required VoidCallback? onPressed,
    LevelType? levelType,
    ButtonSize size = ButtonSize.medium,
    IconData? icon,
    double? width,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      levelType: levelType,
      size: size,
      variant: ButtonVariant.text,
      icon: icon,
      width: width,
    );
  }

  static CustomButton faded({
    required String text,
    required VoidCallback? onPressed,
    LevelType? levelType,
    bool isLoading = false,
    ButtonSize size = ButtonSize.medium,
    IconData? icon,
    double? width,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      levelType: levelType,
      isLoading: isLoading,
      size: size,
      customTextColor: levelType?.color,
      variant: ButtonVariant.filled, // Use filled variant with light color
      icon: icon,
      width: width,
      customColor:
          levelType?.lightColor ?? AppColors.grey600, // Dynamic faded color
    );
  }

  static CustomButton outline({
    required String text,
    required VoidCallback? onPressed,
    LevelType? levelType,
    ButtonSize size = ButtonSize.medium,
    IconData? icon,
    double? width,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      levelType: levelType,
      size: size,
      variant: ButtonVariant.outlined, // ← OUTLINE, not text
      icon: icon,
      width: width,
    );
  }
}
