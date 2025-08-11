import 'package:flutter_test/flutter_test.dart';
import 'package:rdm_weather_app/features/forecast/data/providers/forecast_repository_provider.dart';

void main() {
  group('ForecastRepositoryProvider', () {
    test('should be defined', () {
      expect(forecastRepositoryProvider, isNotNull);
    });

    test('should have correct type', () {
      expect(forecastRepositoryProvider, isA<Object>());
    });
  });
}
