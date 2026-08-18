import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

import 'package:flutter/foundation.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");

  final bool isDesktopOrWeb = kIsWeb || 
      defaultTargetPlatform == TargetPlatform.windows || 
      defaultTargetPlatform == TargetPlatform.macOS || 
      defaultTargetPlatform == TargetPlatform.linux;

  runApp(
    DevicePreview(
      enabled: !kReleaseMode && isDesktopOrWeb,
      builder: (context) => const ProviderScope(child: OrivoxApp()),
    ),
  );
}

class OrivoxApp extends ConsumerWidget {
  const OrivoxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Orivox Assistant',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
    );
  }
}
