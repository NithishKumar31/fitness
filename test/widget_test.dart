import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/services/storage_service.dart';
import 'package:flutter_application_1/services/ai_service.dart';
import 'package:flutter_application_1/providers/theme_provider.dart';
import 'package:flutter_application_1/providers/language_provider.dart';
import 'package:flutter_application_1/providers/app_state_provider.dart';

void main() {
  testWidgets('Rejuvenate app renders splash screen smoke test', (WidgetTester tester) async {
    final storageService = StorageService();
    final aiService = CompanionAiService();

    await tester.pumpWidget(
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

    // Verify Rejuvenate brand name is rendered
    expect(find.text('Rejuvenate'), findsOneWidget);

    // Allow splash timer to complete and settle
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });
}
