import 'package:flutter/material.dart';

/// App color schemes and constants for the Angel Messages app.
/// Uses Material 3 design with ColorScheme.fromSeed for consistent theming.
class AppColors {
  AppColors._();

  /// Primary brand color - a spiritual purple shade
  static const Color primary = Color(0xFF6B46C1);

  /// Light theme color scheme generated from primary color
  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.light,
  );

  /// Dark theme color scheme generated from primary color
  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.dark,
  );

  /// Additional semantic colors for specific use cases
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  /// Surface tints for elevated surfaces in light theme
  static final Color lightSurfaceTint = lightColorScheme.primary;

  /// Surface tints for elevated surfaces in dark theme
  static final Color darkSurfaceTint = darkColorScheme.primary;

  /// Custom container colors for message cards
  static final Color lightMessageContainer = lightColorScheme.primaryContainer;
  static final Color darkMessageContainer = darkColorScheme.primaryContainer;

  /// Custom container colors for notification badges
  static final Color lightNotificationContainer = lightColorScheme.secondaryContainer;
  static final Color darkNotificationContainer = darkColorScheme.secondaryContainer;

  /// Text colors on primary background
  static final Color lightOnPrimary = lightColorScheme.onPrimary;
  static final Color darkOnPrimary = darkColorScheme.onPrimary;

  /// Text colors on surface backgrounds
  static final Color lightOnSurface = lightColorScheme.onSurface;
  static final Color darkOnSurface = darkColorScheme.onSurface;

  /// Text colors on container backgrounds
  static final Color lightOnPrimaryContainer = lightColorScheme.onPrimaryContainer;
  static final Color darkOnPrimaryContainer = darkColorScheme.onPrimaryContainer;

  /// Helper method to get the appropriate color scheme based on brightness
  static ColorScheme getColorScheme(Brightness brightness) {
    return brightness == Brightness.light ? lightColorScheme : darkColorScheme;
  }

  /// Helper method to get surface tint color based on brightness
  static Color getSurfaceTint(Brightness brightness) {
    return brightness == Brightness.light ? lightSurfaceTint : darkSurfaceTint;
  }

  /// Helper method to get message container color based on brightness
  static Color getMessageContainer(Brightness brightness) {
    return brightness == Brightness.light ? lightMessageContainer : darkMessageContainer;
  }

  /// Helper method to get notification container color based on brightness
  static Color getNotificationContainer(Brightness brightness) {
    return brightness == Brightness.light ? lightNotificationContainer : darkNotificationContainer;
  }
}