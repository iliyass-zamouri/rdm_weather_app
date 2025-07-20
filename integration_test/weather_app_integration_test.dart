import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rdm_weather_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Weather App Integration Tests', () {
    testWidgets('Search for a valid city, display weather and forecast & clear',
        (tester) async {
      app.main();

      await tester.pumpAndSettle();

      expect(find.text('Rechercher une ville.'), findsOneWidget);

      final searchField = find.byType(TextFormField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'Paris');

      final searchIcon = find.byIcon(CupertinoIcons.search);
      await tester.tap(searchIcon);

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Paris'), findsWidgets);
      expect(find.textContaining('°'), findsWidgets);

      final clearIcon = find.byIcon(CupertinoIcons.clear);
      await tester.tap(clearIcon);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Rechercher une ville.'), findsOneWidget);
    });

    testWidgets('Search for an invalid city, display error message',
        (tester) async {
      app.main();

      await tester.pumpAndSettle();

      expect(find.text('Rechercher une ville.'), findsOneWidget);

      final searchField = find.byType(TextFormField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'SomeInvalidCity');

      final searchIcon = find.byIcon(CupertinoIcons.search);
      await tester.tap(searchIcon);

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.textContaining('Ville non trouvée.'), findsOneWidget);

      final clearIcon = find.byIcon(CupertinoIcons.clear);
      await tester.tap(clearIcon);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Rechercher une ville.'), findsOneWidget);
    });
  });
}
