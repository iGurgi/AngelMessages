import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color deepPurple = Color(0xFF1A0533);
  static const Color softGold = Color(0xFFD4AF37);
  static const Color mutedLavender = Color(0xFFB39DDB);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: mutedLavender,
      brightness: Brightness.light,
      primary: mutedLavender,
      secondary: softGold,
      surface: Colors.white,
      background: const Color(0xFFF5F5F5),
    );

    return _buildTheme(colorScheme);
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: mutedLavender,
      brightness: Brightness.dark,
      primary: mutedLavender,
      secondary: softGold,
      surface: const Color(0xFF1E1E1E),
      background: deepPurple,
    );

    return _buildTheme(colorScheme);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    final textTheme = TextTheme(
      displayLarge: GoogleFonts.cinzel(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: colorScheme.onSurface,
      ),
      displayMedium: GoogleFonts.cinzel(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      displaySmall: GoogleFonts.cinzel(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      headlineLarge: GoogleFonts.cinzel(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      headlineMedium: GoogleFonts.cinzel(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      headlineSmall: GoogleFonts.cinzel(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      titleLarge: GoogleFonts.raleway(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      titleMedium: GoogleFonts.raleway(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: colorScheme.onSurface,
      ),
      titleSmall: GoogleFonts.raleway(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: colorScheme.onSurface,
      ),
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

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.headlineSmall,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: colorScheme.surface,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: softGold,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return mutedLavender;
            }
            return colorScheme.surface;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.white;
            }
            return colorScheme.onSurface;
          }),
        ),
      ),
    );
  }
}
