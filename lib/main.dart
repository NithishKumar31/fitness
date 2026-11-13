import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'services/storage_service.dart';
import 'services/ai_service.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'providers/app_state_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  await storageService.init();

  final aiService = CompanionAiService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(storageService)),
        ChangeNotifierProvider(create: (_) => LanguageProvider(storageService)),
        ChangeNotifierProvider(
          create: (_) => AppStateProvider(
            storage: storageService,
            aiService: aiService,
          ),
        ),
      ],
      child: const RejuvenateApp(),
    ),
  );
}

class RejuvenateApp extends StatelessWidget {
  const RejuvenateApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Rejuvenate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}
