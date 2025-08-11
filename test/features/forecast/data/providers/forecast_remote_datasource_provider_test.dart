import 'package:flutter_test/flutter_test.dart';
import 'package:rdm_weather_app/features/forecast/data/providers/forecast_remote_datasource_provider.dart';

void main() {
  group('ForecastRemoteDataSourceProvider', () {
    test('should be defined', () {
      expect(forecastRemoteDataSourceProvider, isNotNull);
    });

    test('should have correct type', () {
      expect(forecastRemoteDataSourceProvider, isA<Object>());
    });
  });
}
