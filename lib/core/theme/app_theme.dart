import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application theme configuration with Material 3
class AppTheme {
  AppTheme._();

  // Brand colors
  static const Color deepPurple = Color(0xFF1A0533);
  static const Color softGold = Color(0xFFD4AF37);
  static const Color mutedLavender = Color(0xFFB39DDB);

  /// Dark theme (primary theme)
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: mutedLavender,
      brightness: Brightness.dark,
      primary: mutedLavender,
      secondary: softGold,
      background: deepPurple,
      surface: const Color(0xFF2A1541),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: deepPurple,
      textTheme: _textTheme(colorScheme),
      appBarTheme: _appBarTheme(colorScheme),
      cardTheme: _cardTheme(colorScheme),
      floatingActionButtonTheme: _fabTheme(colorScheme),
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme),
      segmentedButtonTheme: _segmentedButtonTheme(colorScheme),
    );
  }

  /// Light theme (alternative)
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: mutedLavender,
      brightness: Brightness.light,
      primary: deepPurple,
      secondary: softGold,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _textTheme(colorScheme),
      appBarTheme: _appBarTheme(colorScheme),
      cardTheme: _cardTheme(colorScheme),
      floatingActionButtonTheme: _fabTheme(colorScheme),
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme),
      segmentedButtonTheme: _segmentedButtonTheme(colorScheme),
    );
  }

  /// Text theme using Cinzel for headings and Raleway for body
  static TextTheme _textTheme(ColorScheme colorScheme) {
    return TextTheme(
      // Display styles (Cinzel)
      displayLarge: GoogleFonts.cinzel(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: colorScheme.onBackground,
      ),
      displayMedium: GoogleFonts.cinzel(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      displaySmall: GoogleFonts.cinzel(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      // Headline styles (Cinzel)
      headlineLarge: GoogleFonts.cinzel(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: colorScheme.onBackground,
      ),
      headlineMedium: GoogleFonts.cinzel(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: colorScheme.onBackground,
      ),
      headlineSmall: GoogleFonts.cinzel(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: colorScheme.onBackground,
      ),
      // Title styles (Cinzel)
      titleLarge: GoogleFonts.cinzel(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      titleMedium: GoogleFonts.cinzel(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: colorScheme.onSurface,
      ),
      titleSmall: GoogleFonts.cinzel(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: colorScheme.onSurface,
      ),
      // Body styles (Raleway)
      bodyLarge: GoogleFonts.raleway(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: colorScheme.onSurface,
      ),
      bodyMedium: GoogleFonts.raleway(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: colorScheme.onSurface,
      ),
      bodySmall: GoogleFonts.raleway(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: colorScheme.onSurface,
      ),
      // Label styles (Raleway)
      labelLarge: GoogleFonts.raleway(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: colorScheme.onSurface,
      ),
      labelMedium: GoogleFonts.raleway(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: colorScheme.onSurface,
      ),
      labelSmall: GoogleFonts.raleway(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: colorScheme.onSurface,
      ),
    );
  }

  /// AppBar theme
  static AppBarTheme _appBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: colorScheme.secondary),
      titleTextStyle: GoogleFonts.cinzel(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colorScheme.onBackground,
      ),
    );
  }

  /// Card theme
  static CardTheme _cardTheme(ColorScheme colorScheme) {
    return CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: colorScheme.surface,
    );
  }

  /// Floating Action Button theme
  static FloatingActionButtonThemeData _fabTheme(ColorScheme colorScheme) {
    return FloatingActionButtonThemeData(
      backgroundColor: softGold,
      foregroundColor: deepPurple,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  /// Elevated Button theme
  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: softGold,
        foregroundColor: deepPurple,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Segmented Button theme
  static SegmentedButtonThemeData _segmentedButtonTheme(
    ColorScheme colorScheme,
  ) {
    return SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return softGold.withOpacity(0.3);
          }
          return Colors.transparent;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return softGold;
          }
          return colorScheme.onSurface;
        }),
      ),
    );
  }
}
