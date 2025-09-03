import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme Colors
  static const Color _lightPrimary = Color(0xff2E913D);
  static const Color _lightPrimaryContainer = Color(0xff6CB72C);
  static const Color _lightSecondary = Color(0xff46672d);
  static const Color _lightSecondaryContainer = Color(0xffc4eca3);
  static const Color _lightTertiary = Color(0xff006a60);
  static const Color _lightTertiaryContainer = Color(0xff00b7a6);
  static const Color _lightSurface = Color(0xfff7fbeb);
  static const Color _lightSurfaceContainer = Color(0xffebf0e0);
  static const Color _lightSurfaceContainerHigh = Color(0xffe5eada);
  static const Color _lightBackground = Color(0xffffffff);
  static const Color _lightOnPrimary = Color(0xffffffff);
  static const Color _lightOnSecondary = Color(0xffffffff);
  static const Color _lightOnSurface = Color(0xff181d14);
  //static const Color _lightOnBackground = Color(0xff181d14);
  static const Color _lightError = Color(0xffba1a1a);
  static const Color _lightOnError = Color(0xffffffff);
  static const Color _lightOutline = Color(0xff717a67);
  static const Color _lightOutlineVariant = Color(0xffc0cab4);
  static const Color _lightShadow = Color(0xff000000);

  // Dark Theme Colors
  static const Color _darkPrimary = Color(0xff2E913D);
  static const Color _darkPrimaryContainer = Color(0xff6CB72C);
  static const Color _darkSecondary = Color(0xffacd28c);
  static const Color _darkSecondaryContainer = Color(0xff32511a);
  static const Color _darkTertiary = Color(0xff4cdbc9);
  static const Color _darkTertiaryContainer = Color(0xff00b7a6);
  static const Color _darkSurface = Color(0xff10150c);
  static const Color _darkSurfaceContainer = Color(0xff1c2117);
  static const Color _darkSurfaceContainerHigh = Color(0xff272c21);
  static const Color _darkBackground = Color(0xff10150c);
  static const Color _darkOnPrimary = Color(0xff183800);
  static const Color _darkOnSecondary = Color(0xff1a3703);
  static const Color _darkOnSurface = Color(0xffe0e4d5);
  //static const Color _darkOnBackground = Color(0xffe0e4d5);
  static const Color _darkError = Color(0xffffb4ab);
  static const Color _darkOnError = Color(0xff690005);
  static const Color _darkOutline = Color(0xff8b947f);
  static const Color _darkOutlineVariant = Color(0xff414938);
  static const Color _darkShadow = Color(0xff000000);

  static const Color _lightContainerColor = Colors.white; // White
  static const Color _darkContainerColor = Color(0xff1a1a1a);

  static ThemeData lightTheme(BuildContext context) {
    final ColorScheme lightColorScheme = const ColorScheme(
      brightness: Brightness.light,
      primary: _lightPrimary,
      surfaceTint: _lightPrimary,
      onPrimary: _lightOnPrimary,
      primaryContainer: _lightPrimaryContainer,
      onPrimaryContainer: Color(0xff1e4200),
      secondary: _lightSecondary,
      onSecondary: _lightOnSecondary,
      secondaryContainer: _lightSecondaryContainer,
      onSecondaryContainer: Color(0xff4b6c31),
      tertiary: _lightTertiary,
      onTertiary: Color(0xffffffff),
      tertiaryContainer: _lightTertiaryContainer,
      onTertiaryContainer: Color(0xff00413a),
      error: _lightError,
      onError: _lightOnError,
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: _lightSurface,
      onSurface: _lightOnSurface,
      onSurfaceVariant: Color(0xff414938),
      outline: _lightOutline,
      outlineVariant: _lightOutlineVariant,
      shadow: _lightShadow,
      scrim: _lightShadow,
      inverseSurface: Color(0xff2d3228),
      inversePrimary: Color(0xff8cdb4f),
      surfaceContainer: _lightSurfaceContainer,
      surfaceContainerHigh: _lightSurfaceContainerHigh,
      surfaceContainerHighest: Color(0xffe0e4d5),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: _lightBackground,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: _lightPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _lightOnPrimary,
        ),
        iconTheme: const IconThemeData(color: _lightOnPrimary),
        actionsIconTheme: const IconThemeData(color: _lightOnPrimary),
      ),
      canvasColor:
          _lightContainerColor, // This affects some container-like widgets
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _lightBackground,
        selectedItemColor: _lightPrimary,
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
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _lightPrimary,
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
      // inputDecorationTheme: InputDecorationTheme(
      //   filled: true,
      //   //fillColor: _lightSurfaceContainer,
      //   border: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(12),
      //     borderSide: BorderSide.none,
      //   ),
      //   enabledBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(12),
      //     borderSide: BorderSide.none,
      //   ),
      //   focusedBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(12),
      //     borderSide: const BorderSide(color: _lightPrimary, width: 2),
      //   ),
      //   errorBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(12),
      //     borderSide: const BorderSide(color: _lightError, width: 1),
      //   ),
      //   contentPadding: const EdgeInsets.symmetric(
      //     horizontal: 16,
      //     vertical: 16,
      //   ),
      //   hintStyle: GoogleFonts.inter(color: _lightOutline, fontSize: 14),
      //   prefixIconColor: _lightOutline,
      //   suffixIconColor: _lightOutline,
      // ),

      // Card Theme
      // cardTheme: CardTheme(
      //   color: _lightBackground,
      //   elevation: 2,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      //   shadowColor: _lightShadow.withOpacity(0.1),
      // ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimary,
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
          foregroundColor: _lightPrimary,
          side: const BorderSide(color: _lightPrimary),
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
          foregroundColor: _lightPrimary,
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
        selectedColor: _lightPrimary,
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
        iconColor: _lightPrimary,
        textColor: _lightOnSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: _lightOutlineVariant,
        thickness: 1,
        space: 16,
      ),

      // Dialog Theme
      // dialogTheme: DialogTheme(
      //   backgroundColor: _lightBackground,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      //   titleTextStyle: GoogleFonts.inter(
      //     fontSize: 18,
      //     fontWeight: FontWeight.w600,
      //     color: _lightOnSurface,
      //   ),
      //   contentTextStyle: GoogleFonts.inter(
      //     fontSize: 14,
      //     color: _lightOnSurface,
      //   ),
      // ),

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
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _lightPrimary,
        linearTrackColor: _lightOutlineVariant,
        circularTrackColor: _lightOutlineVariant,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _lightPrimary;
          }
          return _lightOutline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _lightPrimary.withOpacity(0.5);
          }
          return _lightOutlineVariant;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _lightPrimary;
          }
          return _lightOutline;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: _lightOnSurface, size: 24),
      primaryIconTheme: const IconThemeData(color: _lightPrimary, size: 24),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    final ColorScheme darkColorScheme = const ColorScheme(
      brightness: Brightness.dark,
      primary: _darkPrimary,
      surfaceTint: _darkPrimary,
      onPrimary: _darkOnPrimary,
      primaryContainer: _darkPrimaryContainer,
      onPrimaryContainer: Color(0xff1e4200),
      secondary: _darkSecondary,
      onSecondary: _darkOnSecondary,
      secondaryContainer: _darkSecondaryContainer,
      onSecondaryContainer: Color(0xff9ec47f),
      tertiary: _darkTertiary,
      onTertiary: Color(0xff003731),
      tertiaryContainer: _darkTertiaryContainer,
      onTertiaryContainer: Color(0xff00413a),
      error: _darkError,
      onError: _darkOnError,
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: _darkSurface,
      onSurface: _darkOnSurface,
      onSurfaceVariant: Color(0xffc0cab4),
      outline: _darkOutline,
      outlineVariant: _darkOutlineVariant,
      shadow: _darkShadow,
      scrim: _darkShadow,
      inverseSurface: Color(0xffe0e4d5),
      inversePrimary: Color(0xff346b00),
      surfaceContainer: _darkSurfaceContainer,
      surfaceContainerHigh: _darkSurfaceContainerHigh,
      surfaceContainerHighest: Color(0xff31362c),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: _darkSurfaceContainerHigh,

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
        iconTheme: const IconThemeData(color: _darkOnSurface),
        actionsIconTheme: const IconThemeData(color: _darkOnSurface),
      ),
      canvasColor:
          _darkContainerColor, // This affects some container-like widgets
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _darkSurface,
        selectedItemColor: _darkPrimary,
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
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _darkPrimary,
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
      // inputDecorationTheme: InputDecorationTheme(
      //   filled: true,
      //   fillColor: _darkSurfaceContainer,
      //   border: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(12),
      //     borderSide: BorderSide.none,
      //   ),
      //   enabledBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(12),
      //     borderSide: BorderSide.none,
      //   ),
      //   focusedBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(12),
      //     borderSide: const BorderSide(color: _darkPrimary, width: 2),
      //   ),
      //   errorBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(12),
      //     borderSide: const BorderSide(color: _darkError, width: 1),
      //   ),
      //   contentPadding: const EdgeInsets.symmetric(
      //     horizontal: 16,
      //     vertical: 16,
      //   ),
      //   hintStyle: GoogleFonts.inter(color: _darkOutline, fontSize: 14),
      //   prefixIconColor: _darkOutline,
      //   suffixIconColor: _darkOutline,
      // ),

      // Card Theme
      // cardTheme: CardTheme(
      //   color: _darkSurfaceContainer,
      //   elevation: 2,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      //   shadowColor: _darkShadow.withOpacity(0.3),
      // ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimary,
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
          foregroundColor: _darkPrimary,
          side: const BorderSide(color: _darkPrimary),
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
          foregroundColor: _darkPrimary,
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
        selectedColor: _darkPrimary,
        disabledColor: _darkOutlineVariant,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // List Tile Theme
      // listTileThemeData: ListTileThemeData(
      //   tileColor: _darkSurfaceContainer,
      //   iconColor: _darkPrimary,
      //   textColor: _darkOnSurface,
      //   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: _darkOutlineVariant,
        thickness: 1,
        space: 16,
      ),

      // // Dialog Theme
      // dialogTheme: DialogTheme(
      //   backgroundColor: _darkSurfaceContainer,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      //   titleTextStyle: GoogleFonts.inter(
      //     fontSize: 18,
      //     fontWeight: FontWeight.w600,
      //     color: _darkOnSurface,
      //   ),
      //   contentTextStyle: GoogleFonts.inter(
      //     fontSize: 14,
      //     color: _darkOnSurface,
      //   ),
      // ),

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
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _darkPrimary,
        linearTrackColor: _darkOutlineVariant,
        circularTrackColor: _darkOutlineVariant,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _darkPrimary;
          }
          return _darkOutline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _darkPrimary.withOpacity(0.5);
          }
          return _darkOutlineVariant;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _darkPrimary;
          }
          return _darkOutline;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: _darkOnSurface, size: 24),
      primaryIconTheme: const IconThemeData(color: _darkPrimary, size: 24),
    );
  }
}
