import 'package:flutter_test/flutter_test.dart';
import 'package:rdm_weather_app/features/weather/data/providers/weather_repository_provider.dart';

void main() {
  group('WeatherRepositoryProvider', () {
    test('should be defined', () {
      expect(weatherRepositoryProvider, isNotNull);
    });

    test('should have correct type', () {
      expect(weatherRepositoryProvider, isA<Object>());
    });
  });
}
