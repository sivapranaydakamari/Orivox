import 'package:flutter/material.dart';

class AppColors {
  // --- Brand Colors ---
  static const primary = Color(0xFF4F46E5); // Premium Indigo
  static const primaryContainer = Color(0xFFE0E7FF);
  static const onPrimaryContainer = Color(0xFF312E81);

  static const secondary = Color(0xFF10B981); // Emerald
  static const secondaryContainer = Color(0xFFD1FAE5);
  static const onSecondaryContainer = Color(0xFF064E3B);

  static const tertiary = Color(0xFFF43F5E); // Rose
  static const tertiaryContainer = Color(0xFFFFE4E6);
  static const onTertiaryContainer = Color(0xFF881337);
  
  // --- Semantic Colors ---
  static const success = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
  static const errorContainer = Color(0xFFFEE2E2);
  static const onErrorContainer = Color(0xFF991B1B);
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF3B82F6);
  
  // --- Light Theme Neutrals ---
  static const lightBackground = Color(0xFFF9FAFB);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = Color(0xFFF3F4F6);
  static const lightTextPrimary = Color(0xFF111827);
  static const lightTextSecondary = Color(0xFF4B5563);
  static const lightOutline = Color(0xFFD1D5DB);
  static const lightOutlineVariant = Color(0xFFE5E7EB);
  static const lightInverseSurface = Color(0xFF1F2937);
  static const lightInversePrimary = Color(0xFFA5B4FC);

  // --- Dark Theme Neutrals ---
  static const darkBackground = Color(0xFF111827);
  static const darkSurface = Color(0xFF1F2937);
  static const darkSurfaceVariant = Color(0xFF374151);
  static const darkTextPrimary = Color(0xFFF9FAFB);
  static const darkTextSecondary = Color(0xFFD1D5DB);
  static const darkOutline = Color(0xFF4B5563);
  static const darkOutlineVariant = Color(0xFF374151);
  static const darkInverseSurface = Color(0xFFF3F4F6);
  static const darkInversePrimary = Color(0xFF4F46E5);

  // --- Material ColorSchemes ---
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Colors.white,
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    secondary: secondary,
    onSecondary: Colors.white,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,
    tertiary: tertiary,
    onTertiary: Colors.white,
    tertiaryContainer: tertiaryContainer,
    onTertiaryContainer: onTertiaryContainer,
    error: error,
    onError: Colors.white,
    errorContainer: errorContainer,
    onErrorContainer: onErrorContainer,
    surface: lightSurface,
    onSurface: lightTextPrimary,
    surfaceContainerHighest: lightSurfaceVariant,
    onSurfaceVariant: lightTextSecondary,
    outline: lightOutline,
    outlineVariant: lightOutlineVariant,
    inverseSurface: lightInverseSurface,
    onInverseSurface: Colors.white,
    inversePrimary: lightInversePrimary,
    shadow: Colors.black,
    scrim: Colors.black,
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF3730A3),
    onPrimaryContainer: Color(0xFFE0E7FF),
    secondary: secondary,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFF047857),
    onSecondaryContainer: Color(0xFFD1FAE5),
    tertiary: tertiary,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFBE123C),
    onTertiaryContainer: Color(0xFFFFE4E6),
    error: error,
    onError: Colors.white,
    errorContainer: Color(0xFF7F1D1D),
    onErrorContainer: Color(0xFFFEE2E2),
    surface: darkSurface,
    onSurface: darkTextPrimary,
    surfaceContainerHighest: darkSurfaceVariant,
    onSurfaceVariant: darkTextSecondary,
    outline: darkOutline,
    outlineVariant: darkOutlineVariant,
    inverseSurface: darkInverseSurface,
    onInverseSurface: darkBackground,
    inversePrimary: darkInversePrimary,
    shadow: Colors.black,
    scrim: Colors.black,
  );
}
