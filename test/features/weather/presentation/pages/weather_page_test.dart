import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rdm_weather_app/features/weather/presentation/pages/weather_page.dart';
import 'package:rdm_weather_app/features/weather/presentation/providers/forecast_provider.dart';
import 'package:rdm_weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:rdm_weather_app/features/weather/presentation/widgets/weather_search_section.dart';
import 'package:rdm_weather_app/features/weather/presentation/widgets/weather_status_section.dart';
import 'package:rdm_weather_app/features/weather/presentation/widgets/weather_display_section.dart';
import 'package:rdm_weather_app/features/weather/presentation/widgets/forecast_display_section.dart';
import '../../fakes/fake_forecast_notifiers.dart';
import '../../fakes/fake_weather_notifiers.dart';

void main() {
  testWidgets('WeatherPage renders all main sections',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weatherProvider.overrideWith((ref) => FakeInitialWeatherNotifier()),
          forecastProvider.overrideWith((ref) => FakeForecastNotifier()),
        ],
        child: MaterialApp(home: WeatherPage()),
      ),
    );
    expect(find.byType(WeatherPage), findsOneWidget);

    expect(find.byType(WeatherSearchSection), findsOneWidget);
    expect(find.byType(WeatherStatusSection), findsOneWidget);
    expect(find.byType(WeatherDisplaySection), findsOneWidget);
    expect(find.byType(ForecastDisplaySection), findsOneWidget);
  });
}
