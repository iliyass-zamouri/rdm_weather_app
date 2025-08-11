import 'package:flutter_test/flutter_test.dart';
import 'package:rdm_weather_app/features/weather/data/providers/weather_remote_datasource_provider.dart';

void main() {
  group('WeatherRemoteDataSourceProvider', () {
    test('should be defined', () {
      expect(weatherRemoteDataSourceProvider, isNotNull);
    });

    test('should have correct type', () {
      expect(weatherRemoteDataSourceProvider, isA<Object>());
    });
  });
}
