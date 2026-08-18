import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/theme/app_spacing.dart';

class ThemePreferencesScreen extends ConsumerWidget {
  const ThemePreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Preferences'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          RadioListTile<ThemeMode>(
            title: const Text('System Default'),
            subtitle: const Text('Follow system settings'),
            value: ThemeMode.system,
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) ref.read(themeProvider.notifier).setThemeMode(value);
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Light'),
            value: ThemeMode.light,
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) ref.read(themeProvider.notifier).setThemeMode(value);
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark'),
            value: ThemeMode.dark,
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) ref.read(themeProvider.notifier).setThemeMode(value);
            },
          ),
        ],
      ),
    );
  }
}
