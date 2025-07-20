import 'package:flutter/cupertino.dart';
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
  group('WeatherStatusSection', () {
    testWidgets('shows loading indicator when any provider is loading',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            weatherProvider.overrideWith((ref) => FakeLoadingWeatherNotifier()),
            forecastProvider
                .overrideWith((ref) => FakeInitialForecastNotifier()),
          ],
          child: const MaterialApp(
            home: Scaffold(body: WeatherStatusSection()),
          ),
        ),
      );
      // StatusBar.loading() returns a CircularProgressIndicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(StatusBar),
          findsNothing); // StatusBar is not a widget class
      expect(find.byType(SizedBox), findsNothing);
      expect(find.textContaining('error'), findsNothing);
    });

    testWidgets('shows error message from forecastProvider', (tester) async {
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
      // StatusBar.error() returns an Icon and a Text
      expect(
          find.byIcon(CupertinoIcons.exclamationmark_triangle), findsOneWidget);
      expect(find.text('API down'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows nothing when both providers are initial',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            weatherProvider.overrideWith((ref) => FakeInitialWeatherNotifier()),
            forecastProvider
                .overrideWith((ref) => FakeInitialForecastNotifier()),
          ],
          child: const MaterialApp(
            home: Scaffold(body: WeatherStatusSection()),
          ),
        ),
      );
      // Should only show SizedBox.shrink()
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(
          find.byIcon(CupertinoIcons.exclamationmark_triangle), findsNothing);
      expect(find.textContaining('error'), findsNothing);
    });
  });
}
