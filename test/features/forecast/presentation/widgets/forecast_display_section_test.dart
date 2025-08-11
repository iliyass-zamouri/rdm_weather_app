import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rdm_weather_app/features/forecast/presentation/providers/forecast_provider.dart';
import 'package:rdm_weather_app/features/forecast/presentation/widgets/forecast_display_section.dart';
import 'package:rdm_weather_app/features/weather/presentation/providers/weather_provider.dart';

import '../../fakes/fake_forecast_notifiers.dart';
import '../../../weather/fakes/fake_weather_notifiers.dart';

void main() {
  group('ForecastDisplaySection', () {
    testWidgets('should render initial state', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            weatherProvider.overrideWith((ref) => FakeInitialWeatherNotifier()),
            forecastProvider.overrideWith((ref) => FakeInitialForecastNotifier()),
          ],
          child: const MaterialApp(
            home: Scaffold(body: ForecastDisplaySection()),
          ),
        ),
      );

      expect(find.byType(ForecastDisplaySection), findsOneWidget);
    });

    testWidgets('should render loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            weatherProvider.overrideWith((ref) => FakeInitialWeatherNotifier()),
            forecastProvider.overrideWith((ref) => FakeLoadingForecastNotifier()),
          ],
          child: const MaterialApp(
            home: Scaffold(body: ForecastDisplaySection()),
          ),
        ),
      );

      expect(find.byType(ForecastDisplaySection), findsOneWidget);
    });

    testWidgets('should render error state', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            weatherProvider.overrideWith((ref) => FakeInitialWeatherNotifier()),
            forecastProvider.overrideWith((ref) => FakeErrorForecastNotifier()),
          ],
          child: const MaterialApp(
            home: Scaffold(body: ForecastDisplaySection()),
          ),
        ),
      );

      expect(find.byType(ForecastDisplaySection), findsOneWidget);
    });
  });
}
