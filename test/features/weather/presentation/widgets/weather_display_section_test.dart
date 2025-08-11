import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rdm_weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:rdm_weather_app/features/weather/presentation/widgets/weather_display_section.dart';
import 'package:rdm_weather_app/features/weather/presentation/widgets/weather_widget.dart';

import '../../fakes/fake_weather_notifiers.dart';

void main() {
  group('WeatherDisplaySection', () {
    testWidgets('should render initial state with correct message and icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            weatherProvider.overrideWith((ref) => FakeInitialWeatherNotifier()),
          ],
          child: const MaterialApp(
            home: Scaffold(body: WeatherDisplaySection()),
          ),
        ),
      );

      expect(find.byType(WeatherDisplaySection), findsOneWidget);
      expect(find.text('Rechercher une ville.'), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.cloud_sun_rain), findsOneWidget);
    });

    testWidgets('should render nothing for loading state (orElse case)', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            weatherProvider.overrideWith((ref) => FakeLoadingWeatherNotifier()),
          ],
          child: const MaterialApp(
            home: Scaffold(body: WeatherDisplaySection()),
          ),
        ),
      );

      expect(find.byType(WeatherDisplaySection), findsOneWidget);
      // Should show nothing (SizedBox.shrink()) for loading state
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(WeatherWidget), findsNothing);
    });

    testWidgets('should render nothing for error state (orElse case)', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            weatherProvider.overrideWith((ref) => FakeErrorWeatherNotifier()),
          ],
          child: const MaterialApp(
            home: Scaffold(body: WeatherDisplaySection()),
          ),
        ),
      );

      expect(find.byType(WeatherDisplaySection), findsOneWidget);
      // Should show nothing (SizedBox.shrink()) for error state
      expect(find.text('API down'), findsNothing);
      expect(find.byType(WeatherWidget), findsNothing);
    });
  });
}
