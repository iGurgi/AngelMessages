import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand colors
  static const Color deepPurple = Color(0xFF1A0533);
  static const Color softGold = Color(0xFFD4AF37);
  static const Color mutedLavender = Color(0xFFB39DDB);
  static const Color darkBackground = Color(0xFF0D0221);
  static const Color cardBackground = Color(0xFF1F1133);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: mutedLavender,
      primary: deepPurple,
      secondary: softGold,
      tertiary: mutedLavender,
      brightness: Brightness.light,
    );

    return _buildTheme(colorScheme);
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: mutedLavender,
      primary: mutedLavender,
      secondary: softGold,
      tertiary: deepPurple,
      brightness: Brightness.dark,
      surface: cardBackground,
      background: darkBackground,
    );

    return _buildTheme(colorScheme);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    final textTheme = _buildTextTheme(colorScheme);

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
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: softGold,
        foregroundColor: colorScheme.onPrimary,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return softGold;
            }
            return colorScheme.surface;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return deepPurple;
            }
            return colorScheme.onSurface;
          }),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    final baseTextTheme = GoogleFonts.ralewayTextTheme();
    final cinzel = GoogleFonts.cinzel();

    return baseTextTheme.copyWith(
      displayLarge: cinzel.copyWith(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      displayMedium: cinzel.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      displaySmall: cinzel.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      headlineLarge: cinzel.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      headlineMedium: cinzel.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      headlineSmall: cinzel.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      titleLarge: GoogleFonts.raleway(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      titleMedium: GoogleFonts.raleway(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      titleSmall: GoogleFonts.raleway(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      bodyLarge: GoogleFonts.raleway(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.raleway(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.raleway(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: colorScheme.onBackground,
      ),
      labelLarge: GoogleFonts.raleway(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      labelMedium: GoogleFonts.raleway(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      labelSmall: GoogleFonts.raleway(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
    );
  }
}
