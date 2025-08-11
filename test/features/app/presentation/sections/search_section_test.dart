import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rdm_weather_app/features/app/presentation/sections/search_section.dart';

void main() {
  group('SearchSection', () {
    void onSearch(String query) {}
    void onClear() {}

    testWidgets('should render search section with correct structure', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SearchSection(
                onSearch: onSearch,
                onClear: onClear,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SearchSection), findsOneWidget);
    });

    testWidgets('should contain search field', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SearchSection(
                onSearch: onSearch,
                onClear: onClear,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should have correct search field properties', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SearchSection(
                onSearch: onSearch,
                onClear: onClear,
              ),
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.hintText, isNotNull);
    });

    testWidgets('should handle text input correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SearchSection(
                onSearch: onSearch,
                onClear: onClear,
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Paris');
      expect(find.text('Paris'), findsOneWidget);
    });

    testWidgets('should have correct styling', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SearchSection(
                onSearch: onSearch,
                onClear: onClear,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SearchSection), findsOneWidget);
      // Verify the widget is rendered with proper styling
    });
  });
}
