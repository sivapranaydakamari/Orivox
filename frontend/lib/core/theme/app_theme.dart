import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';
import 'app_radius.dart';
import 'app_shadows.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return _buildTheme(AppColors.lightColorScheme, false);
  }

  static ThemeData get darkTheme {
    return _buildTheme(AppColors.darkColorScheme, true);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme, bool isDark) {
    final textTheme = AppTypography.getTextTheme(isDark: isDark);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: AppShadows.elevation0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: AppShadows.elevation1,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
          textStyle: textTheme.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.outline, width: 1.0),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: colorScheme.outline, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: colorScheme.error, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: colorScheme.error, width: 2.0),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant.withAlpha(178)),
        errorStyle: textTheme.labelSmall?.copyWith(color: colorScheme.error),
      ),

      // Cards & Surfaces
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: AppShadows.elevation1,
        shadowColor: colorScheme.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgRadius,
          side: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
        margin: const EdgeInsets.all(AppSpacing.sm),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        elevation: AppShadows.elevation3,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xlRadius),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium,
      ),

      // Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        elevation: AppShadows.elevation3,
        type: BottomNavigationBarType.fixed,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        selectedIconTheme: IconThemeData(color: colorScheme.primary),
        unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
        selectedLabelTextStyle: textTheme.labelSmall?.copyWith(color: colorScheme.primary),
        unselectedLabelTextStyle: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
      ),

      // Feedback & Selection
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.lightSurface : AppColors.darkSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
        behavior: SnackBarBehavior.floating,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        labelStyle: textTheme.labelMedium?.copyWith(color: colorScheme.onSurface),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.pillRadius),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) return null;
          if (states.contains(WidgetState.selected)) return colorScheme.primary;
          return null;
        }),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xsRadius),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) return null;
          if (states.contains(WidgetState.selected)) return colorScheme.primary;
          return null;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) return colorScheme.onPrimary;
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) return colorScheme.primary;
          return null;
        }),
      ),
    );
  }
}
