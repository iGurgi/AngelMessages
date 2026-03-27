import 'package:flutter/material.dart';

class AppTheme {
  static const _primaryColor = Color(0xFF6750A4);
  static const _secondaryColor = Color(0xFF625B71);
  static const _errorColor = Color(0xFFBA1A1A);
  
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.light,
    );
    
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      cardTheme: _buildCardTheme(colorScheme),
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      appBarTheme: _buildAppBarTheme(colorScheme),
      bottomNavigationBarTheme: _buildBottomNavTheme(colorScheme),
      floatingActionButtonTheme: _buildFABTheme(colorScheme),
    );
  }
  
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.dark,
    );
    
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      cardTheme: _buildCardTheme(colorScheme),
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      appBarTheme: _buildAppBarTheme(colorScheme),
      bottomNavigationBarTheme: _buildBottomNavTheme(colorScheme),
      floatingActionButtonTheme: _buildFABTheme(colorScheme),
    );
  }
  
  static CardTheme _buildCardTheme(ColorScheme colorScheme) {
    return CardTheme(
      elevation: 2,
      shadowColor: colorScheme.shadow,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
    );
  }
  
  static ElevatedButtonThemeData _buildElevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        shadowColor: colorScheme.shadow,
      ),
    );
  }
  
  static TextButtonThemeData _buildTextButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
  
  static AppBarTheme _buildAppBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: colorScheme.surfaceTint,
      shadowColor: colorScheme.shadow,
    );
  }
  
  static BottomNavigationBarThemeData _buildBottomNavTheme(ColorScheme colorScheme) {
    return BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurfaceVariant,
      backgroundColor: colorScheme.surface,
    );
  }
  
  static FloatingActionButtonThemeData _buildFABTheme(ColorScheme colorScheme) {
    return FloatingActionButtonThemeData(
      elevation: 6,
      highlightElevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}