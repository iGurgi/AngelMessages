import 'package:flutter/material.dart';

/// App theming system with Material 3 design and custom color schemes
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Light theme color scheme - inspired by angelic and peaceful colors
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    // Primary colors - soft celestial blue
    primary: Color(0xFF6366F1), // Indigo 500
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE0E7FF), // Indigo 100
    onPrimaryContainer: Color(0xFF1E1B4B), // Indigo 900
    
    // Secondary colors - warm gold accents
    secondary: Color(0xFFF59E0B), // Amber 500
    onSecondary: Color(0xFF000000),
    secondaryContainer: Color(0xFFFEF3C7), // Amber 100
    onSecondaryContainer: Color(0xFF78350F), // Amber 900
    
    // Tertiary colors - soft lavender
    tertiary: Color(0xFF8B5CF6), // Violet 500
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFF3E8FF), // Violet 100
    onTertiaryContainer: Color(0xFF4C1D95), // Violet 900
    
    // Error colors
    error: Color(0xFFDC2626), // Red 600
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFECECA), // Red 100
    onErrorContainer: Color(0xFF7F1D1D), // Red 900
    
    // Surface colors - clean and peaceful
    surface: Color(0xFFFAFAFA), // Gray 50
    onSurface: Color(0xFF111827), // Gray 900
    surfaceContainerHighest: Color(0xFFE5E7EB), // Gray 200
    onSurfaceVariant: Color(0xFF6B7280), // Gray 500
    
    // Background
    background: Color(0xFFFFFFFF),
    onBackground: Color(0xFF111827),
    
    // Outline
    outline: Color(0xFFD1D5DB), // Gray 300
    outlineVariant: Color(0xFFF3F4F6), // Gray 100
    
    // Inverse colors
    inverseSurface: Color(0xFF111827),
    onInverseSurface: Color(0xFFF9FAFB),
    inversePrimary: Color(0xFFA5B4FC), // Indigo 300
    
    // Shadows and overlays
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceTint: Color(0xFF6366F1),
  );

  /// Dark theme color scheme - calming night colors
  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    // Primary colors - softer celestial blue for dark mode
    primary: Color(0xFFA5B4FC), // Indigo 300
    onPrimary: Color(0xFF1E1B4B), // Indigo 900
    primaryContainer: Color(0xFF3730A3), // Indigo 700
    onPrimaryContainer: Color(0xFFE0E7FF), // Indigo 100
    
    // Secondary colors - warm amber
    secondary: Color(0xFFFBBF24), // Amber 400
    onSecondary: Color(0xFF78350F), // Amber 900
    secondaryContainer: Color(0xFF92400E), // Amber 800
    onSecondaryContainer: Color(0xFFFEF3C7), // Amber 100
    
    // Tertiary colors - soft violet
    tertiary: Color(0xFFA78BFA), // Violet 400
    onTertiary: Color(0xFF4C1D95), // Violet 900
    tertiaryContainer: Color(0xFF6D28D9), // Violet 700
    onTertiaryContainer: Color(0xFFF3E8FF), // Violet 100
    
    // Error colors
    error: Color(0xFFF87171), // Red 400
    onError: Color(0xFF7F1D1D), // Red 900
    errorContainer: Color(0xFF991B1B), // Red 800
    onErrorContainer: Color(0xFFFECECA), // Red 100
    
    // Surface colors - deep and serene
    surface: Color(0xFF1F2937), // Gray 800
    onSurface: Color(0xFFF9FAFB), // Gray 50
    surfaceContainerHighest: Color(0xFF374151), // Gray 700
    onSurfaceVariant: Color(0xFF9CA3AF), // Gray 400
    
    // Background
    background: Color(0xFF111827), // Gray 900
    onBackground: Color(0xFFF9FAFB), // Gray 50
    
    // Outline
    outline: Color(0xFF6B7280), // Gray 500
    outlineVariant: Color(0xFF374151), // Gray 700
    
    // Inverse colors
    inverseSurface: Color(0xFFF9FAFB),
    onInverseSurface: Color(0xFF111827),
    inversePrimary: Color(0xFF6366F1),
    
    // Shadows and overlays
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceTint: Color(0xFFA5B4FC),
  );

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      typography: Typography.material2021(),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF111827),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF111827),
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDC2626)),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      
      // List Tile Theme
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        minVerticalPadding: 12,
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE5E7EB),
        thickness: 1,
        space: 1,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedItemColor: Color(0xFF6366F1),
        unselectedItemColor: Color(0xFF6B7280),
        backgroundColor: Color(0xFFFFFFFF),
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        focusElevation: 6,
        hoverElevation: 8,
        highlightElevation: 12,
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      typography: Typography.material2021(),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFFF9FAFB),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF9FAFB),
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0xFF374151),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: const BorderSide(color: Color(0xFF6B7280)),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF374151),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6B7280)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6B7280)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFA5B4FC), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF87171)),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      
      // List Tile Theme
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        minVerticalPadding: 12,
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFF6B7280),
        thickness: 1,
        space: 1,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedItemColor: Color(0xFFA5B4FC),
        unselectedItemColor: Color(0xFF9CA3AF),
        backgroundColor: Color(0xFF1F2937),
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        focusElevation: 6,
        hoverElevation: 8,
        highlightElevation: 12,
      ),
    );
  }
}
