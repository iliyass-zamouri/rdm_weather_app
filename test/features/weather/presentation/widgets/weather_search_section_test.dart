import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rdm_weather_app/features/weather/presentation/providers/forecast_provider.dart';
import 'package:rdm_weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:rdm_weather_app/features/weather/presentation/widgets/weather_search_section.dart';

import '../../fakes/fake_forecast_notifiers.dart';
import '../../fakes/fake_weather_notifiers.dart';

void main() {
  testWidgets('WeatherSearchSection renders and responds to input',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(overrides: [
        weatherProvider.overrideWith((ref) => FakeInitialWeatherNotifier()),
        forecastProvider.overrideWith((ref) => FakeInitialForecastNotifier()),
      ], child: MaterialApp(home: Scaffold(body: WeatherSearchSection()))),
    );
    expect(find.byType(WeatherSearchSection), findsOneWidget);
    expect(find.text('Rechercher une ville'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Paris');
    expect(find.text('Paris'), findsOneWidget);
  });
}
