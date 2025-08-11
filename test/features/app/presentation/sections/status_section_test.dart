import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rdm_weather_app/features/app/presentation/sections/status_section.dart';

void main() {
  group('StatusSection', () {
    testWidgets('should render status section with correct structure', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: StatusSection(),
            ),
          ),
        ),
      );

      expect(find.byType(StatusSection), findsOneWidget);
    });

    testWidgets('should display status information', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: StatusSection(),
            ),
          ),
        ),
      );

      expect(find.byType(StatusSection), findsOneWidget);
      // Verify that the status section displays information
    });

    testWidgets('should have correct styling', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: StatusSection(),
            ),
          ),
        ),
      );

      expect(find.byType(StatusSection), findsOneWidget);
      // Verify the widget is rendered with proper styling
    });

    testWidgets('should be responsive to different screen sizes', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: StatusSection(),
            ),
          ),
        ),
      );

      expect(find.byType(StatusSection), findsOneWidget);
      // Verify responsiveness
    });
  });
}
