import 'package:bitesize_golf/core/themes/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme Colors using your AppColors
  static const Color _lightPrimary = AppColors.redDark; // Main red theme
  static const Color _lightPrimaryContainer = AppColors.redLight;
  static const Color _lightSecondary = AppColors.grey700;
  static const Color _lightSecondaryContainer = AppColors.grey200;
  static const Color _lightTertiary = AppColors.blueDark;
  static const Color _lightTertiaryContainer = AppColors.blueLight;
  static const Color _lightSurface = AppColors.white;
  static const Color _lightSurfaceContainer = AppColors.grey100;
  static const Color _lightSurfaceContainerHigh = AppColors.grey200;
  static const Color _lightBackground = AppColors.white;
  static const Color _lightOnPrimary = AppColors.white;
  static const Color _lightOnSecondary = AppColors.white;
  static const Color _lightOnSurface = AppColors.grey900;
  static const Color _lightError = AppColors.error;
  static const Color _lightOnError = AppColors.white;
  static const Color _lightOutline = AppColors.grey600;
  static const Color _lightOutlineVariant = AppColors.grey400;
  static const Color _lightShadow = AppColors.grey900;

  // Dark Theme Colors using your AppColors
  static const Color _darkPrimary = AppColors.redDark;
  static const Color _darkPrimaryContainer = AppColors.redLight;
  static const Color _darkSecondary = AppColors.grey500;
  static const Color _darkSecondaryContainer = AppColors.grey800;
  static const Color _darkTertiary = AppColors.blueDark;
  static const Color _darkTertiaryContainer = AppColors.blueLight;
  static const Color _darkSurface = AppColors.grey900;
  static const Color _darkSurfaceContainer = AppColors.grey800;
  static const Color _darkSurfaceContainerHigh = AppColors.grey700;
  static const Color _darkBackground = AppColors.grey900;
  static const Color _darkOnPrimary = AppColors.white;
  static const Color _darkOnSecondary = AppColors.white;
  static const Color _darkOnSurface = AppColors.grey100;
  static const Color _darkError = AppColors.error;
  static const Color _darkOnError = AppColors.white;
  static const Color _darkOutline = AppColors.grey600;
  static const Color _darkOutlineVariant = AppColors.grey700;
  static const Color _darkShadow = AppColors.grey900;

  // Container colors
  static const Color _lightContainerColor = AppColors.white;
  static const Color _darkContainerColor = AppColors.grey800;

  static ThemeData lightTheme(BuildContext context, {LevelType? levelType}) {
    // Use level-specific colors if provided, otherwise default to red
    final Color primaryColor = levelType?.color ?? AppColors.redDark;
    final Color primaryContainer = levelType?.lightColor ?? AppColors.redLight;

    final ColorScheme lightColorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      surfaceTint: primaryColor,
      onPrimary: _lightOnPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: AppColors.grey900,
      secondary: _lightSecondary,
      onSecondary: _lightOnSecondary,
      secondaryContainer: _lightSecondaryContainer,
      onSecondaryContainer: AppColors.grey900,
      tertiary: _lightTertiary,
      onTertiary: AppColors.white,
      tertiaryContainer: _lightTertiaryContainer,
      onTertiaryContainer: AppColors.grey900,
      error: _lightError,
      onError: _lightOnError,
      errorContainer: AppColors.redLight,
      onErrorContainer: AppColors.grey900,
      surface: _lightSurface,
      onSurface: _lightOnSurface,
      onSurfaceVariant: AppColors.grey700,
      outline: _lightOutline,
      outlineVariant: _lightOutlineVariant,
      shadow: _lightShadow,
      scrim: _lightShadow,
      inverseSurface: AppColors.grey900,
      inversePrimary: primaryContainer,
      surfaceContainer: _lightSurfaceContainer,
      surfaceContainerHigh: _lightSurfaceContainerHigh,
      surfaceContainerHighest: AppColors.grey300,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: AppColors.scaffoldBgColor,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _lightOnPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        actionsIconTheme: const IconThemeData(color: AppColors.white),
      ),

      canvasColor: _lightContainerColor,

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _lightBackground,
        selectedItemColor: primaryColor,
        unselectedItemColor: _lightOutline,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: _lightOnPrimary,
        elevation: 4,
      ),

      // Text Theme
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: _lightOnSurface,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: _lightOnSurface,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _lightOnSurface,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _lightOnSurface,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _lightOnSurface,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _lightOnSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _lightOnSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _lightOnSurface,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _lightOutline,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _lightOnSurface,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _lightOutline,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: _lightOutline,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightSurfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _lightOutlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _lightOutlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: GoogleFonts.inter(color: _lightOutline, fontSize: 14),
        prefixIconColor: _lightOutline,
        suffixIconColor: _lightOutline,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: _lightBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: _lightShadow.withOpacity(0.1),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: _lightOnPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: _lightSurfaceContainer,
        selectedColor: primaryColor,
        disabledColor: _lightOutlineVariant,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        tileColor: _lightBackground,
        iconColor: primaryColor,
        textColor: _lightOnSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.grey300,
        thickness: 1,
        space: 16,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: _lightBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _lightOnSurface,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: _lightOnSurface,
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _lightOnSurface,
        contentTextStyle: GoogleFonts.inter(
          color: _lightBackground,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: _lightOutlineVariant,
        circularTrackColor: _lightOutlineVariant,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return _lightOutline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withOpacity(0.5);
          }
          return _lightOutlineVariant;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return _lightOutline;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: AppColors.grey900, size: 24),
      primaryIconTheme: IconThemeData(color: primaryColor, size: 24),
    );
  }

  static ThemeData darkTheme(BuildContext context, {LevelType? levelType}) {
    // Use level-specific colors if provided, otherwise default to red
    final Color primaryColor = levelType?.color ?? AppColors.redDark;
    final Color primaryContainer = levelType?.lightColor ?? AppColors.redLight;

    final ColorScheme darkColorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor,
      surfaceTint: primaryColor,
      onPrimary: _darkOnPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: AppColors.grey900,
      secondary: _darkSecondary,
      onSecondary: _darkOnSecondary,
      secondaryContainer: _darkSecondaryContainer,
      onSecondaryContainer: AppColors.grey100,
      tertiary: _darkTertiary,
      onTertiary: AppColors.white,
      tertiaryContainer: _darkTertiaryContainer,
      onTertiaryContainer: AppColors.grey100,
      error: _darkError,
      onError: _darkOnError,
      errorContainer: AppColors.redDark,
      onErrorContainer: AppColors.redLight,
      surface: _darkSurface,
      onSurface: _darkOnSurface,
      onSurfaceVariant: AppColors.grey400,
      outline: _darkOutline,
      outlineVariant: _darkOutlineVariant,
      shadow: _darkShadow,
      scrim: _darkShadow,
      inverseSurface: AppColors.grey100,
      inversePrimary: primaryColor,
      surfaceContainer: _darkSurfaceContainer,
      surfaceContainerHigh: _darkSurfaceContainerHigh,
      surfaceContainerHighest: AppColors.grey600,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: AppColors.grey900,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: _darkSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _darkOnSurface,
        ),
        iconTheme: const IconThemeData(color: AppColors.grey100),
        actionsIconTheme: const IconThemeData(color: AppColors.grey100),
      ),

      canvasColor: _darkContainerColor,

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _darkSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: _darkOutline,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: _darkOnPrimary,
        elevation: 4,
      ),

      // Text Theme
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: _darkOnSurface,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: _darkOnSurface,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _darkOnSurface,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _darkOnSurface,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _darkOnSurface,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _darkOnSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _darkOnSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _darkOnSurface,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _darkOutline,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _darkOnSurface,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _darkOutline,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: _darkOutline,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _darkOutlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _darkOutlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: GoogleFonts.inter(color: _darkOutline, fontSize: 14),
        prefixIconColor: _darkOutline,
        suffixIconColor: _darkOutline,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: _darkSurfaceContainer,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: _darkShadow.withOpacity(0.3),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: _darkOnPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: _darkSurfaceContainer,
        selectedColor: primaryColor,
        disabledColor: _darkOutlineVariant,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        tileColor: _darkSurfaceContainer,
        iconColor: primaryColor,
        textColor: _darkOnSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.grey700,
        thickness: 1,
        space: 16,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: _darkSurfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _darkOnSurface,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: _darkOnSurface,
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _darkSurfaceContainerHigh,
        contentTextStyle: GoogleFonts.inter(
          color: _darkOnSurface,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: _darkOutlineVariant,
        circularTrackColor: _darkOutlineVariant,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return _darkOutline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withOpacity(0.5);
          }
          return _darkOutlineVariant;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return _darkOutline;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: AppColors.grey100, size: 24),
      primaryIconTheme: IconThemeData(color: primaryColor, size: 24),
    );
  }

  // Helper method to create theme with specific level
  static ThemeData getThemeForLevel(
    BuildContext context,
    LevelType levelType, {
    bool isDark = false,
  }) {
    return isDark
        ? darkTheme(context, levelType: levelType)
        : lightTheme(context, levelType: levelType);
  }
}
