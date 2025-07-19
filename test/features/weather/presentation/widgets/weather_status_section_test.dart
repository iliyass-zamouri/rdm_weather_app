import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rdm_weather_app/features/weather/presentation/providers/forecast_provider.dart';
import 'package:rdm_weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:rdm_weather_app/features/weather/presentation/widgets/status_bar.dart';
import 'package:rdm_weather_app/features/weather/presentation/widgets/weather_status_section.dart';

import '../../fakes/fake_forecast_notifiers.dart';
import '../../fakes/fake_weather_notifiers.dart';

void main() {
  testWidgets(
      'displays loading state in StatusBar when either provider is loading',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weatherProvider.overrideWith((ref) => FakeLoadingWeatherNotifier()),
          forecastProvider.overrideWith((ref) => FakeInitialForecastNotifier()),
        ],
        child: const MaterialApp(
          home: Scaffold(body: WeatherStatusSection()),
        ),
      ),
    );

    final statusBarFinder = find.byType(StatusBar);
    expect(statusBarFinder, findsOneWidget);

    final statusBarWidget = tester.widget<StatusBar>(statusBarFinder);
    expect(statusBarWidget.isLoading, isTrue);
    expect(statusBarWidget.errorMessage, isNull);
  });

  testWidgets('displays error message in StatusBar from forecastProvider',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weatherProvider.overrideWith((ref) => FakeInitialWeatherNotifier()),
          forecastProvider.overrideWith((ref) => FakeErrorForecastNotifier()),
        ],
        child: const MaterialApp(
          home: Scaffold(body: WeatherStatusSection()),
        ),
      ),
    );

    final statusBarWidget = tester.widget<StatusBar>(find.byType(StatusBar));
    expect(statusBarWidget.isLoading, isFalse);
    expect(statusBarWidget.errorMessage, equals("API down"));
  });

  testWidgets('shows nothing loading and no error when both are initial',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weatherProvider.overrideWith((ref) => FakeInitialWeatherNotifier()),
          forecastProvider.overrideWith((ref) => FakeInitialForecastNotifier()),
        ],
        child: const MaterialApp(
          home: Scaffold(body: WeatherStatusSection()),
        ),
      ),
    );

    final statusBarWidget = tester.widget<StatusBar>(find.byType(StatusBar));
    expect(statusBarWidget.isLoading, isFalse);
    expect(statusBarWidget.errorMessage, isNull);
  });
}
