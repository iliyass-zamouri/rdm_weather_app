import 'package:flutter_test/flutter_test.dart';
import 'package:rdm_weather_app/features/forecast/domain/entities/forecast.dart';

void main() {
  group('Forecast Entity', () {
    const testForecast = Forecast(
      day: 'Monday',
      minTemp: 15.0,
      maxTemp: 25.0,
      description: 'Partly cloudy',
      icon: '02d',
    );

    test('should have correct basic properties', () {
      expect(testForecast.day, 'Monday');
      expect(testForecast.minTemp, 15.0);
      expect(testForecast.maxTemp, 25.0);
      expect(testForecast.description, 'Partly cloudy');
      expect(testForecast.icon, '02d');
    });

    test('should format minimum temperature correctly', () {
      expect(testForecast.minTempInCelsius, '15°');
      
      const forecastWithDecimal = Forecast(
        day: 'Tuesday',
        minTemp: 18.7,
        maxTemp: 28.0,
        description: 'Sunny',
        icon: '01d',
      );
      expect(forecastWithDecimal.minTempInCelsius, '19°'); // Should round to nearest integer
    });

    test('should format maximum temperature correctly', () {
      expect(testForecast.maxTempInCelsius, '25°');
      
      const forecastWithDecimal = Forecast(
        day: 'Wednesday',
        minTemp: 20.0,
        maxTemp: 30.3,
        description: 'Clear',
        icon: '01d',
      );
      expect(forecastWithDecimal.maxTempInCelsius, '30°'); // Should round to nearest integer
    });

    test('should handle negative temperatures correctly', () {
      const coldForecast = Forecast(
        day: 'Thursday',
        minTemp: -10.0,
        maxTemp: -5.0,
        description: 'Snow',
        icon: '13d',
      );
      expect(coldForecast.minTempInCelsius, '-10°');
      expect(coldForecast.maxTempInCelsius, '-5°');
    });

    test('should handle zero temperature correctly', () {
      const zeroForecast = Forecast(
        day: 'Friday',
        minTemp: 0.0,
        maxTemp: 5.0,
        description: 'Freezing',
        icon: '13d',
      );
      expect(zeroForecast.minTempInCelsius, '0°');
      expect(zeroForecast.maxTempInCelsius, '5°');
    });

    test('should handle high temperatures correctly', () {
      const hotForecast = Forecast(
        day: 'Saturday',
        minTemp: 35.0,
        maxTemp: 45.0,
        description: 'Very hot',
        icon: '01d',
      );
      expect(hotForecast.minTempInCelsius, '35°');
      expect(hotForecast.maxTempInCelsius, '45°');
    });

    test('should generate correct icon URL', () {
      expect(testForecast.iconUrl, 'http://openweathermap.org/img/wn/02d@2x.png');
      
      const differentIcon = Forecast(
        day: 'Sunday',
        minTemp: 20.0,
        maxTemp: 30.0,
        description: 'Rain',
        icon: '09d',
      );
      expect(differentIcon.iconUrl, 'http://openweathermap.org/img/wn/09d@2x.png');
    });

    test('should handle different weather descriptions', () {
      const rainyForecast = Forecast(
        day: 'Monday',
        minTemp: 10.0,
        maxTemp: 20.0,
        description: 'Heavy rain',
        icon: '09d',
      );
      expect(rainyForecast.description, 'Heavy rain');
      expect(rainyForecast.icon, '09d');
    });

    test('should maintain data integrity', () {
      const originalForecast = Forecast(
        day: 'Tuesday',
        minTemp: -5.0,
        maxTemp: 10.0,
        description: 'Snow storm',
        icon: '13d',
      );
      
      expect(originalForecast.day, 'Tuesday');
      expect(originalForecast.minTemp, -5.0);
      expect(originalForecast.maxTemp, 10.0);
      expect(originalForecast.description, 'Snow storm');
      expect(originalForecast.icon, '13d');
      expect(originalForecast.minTempInCelsius, '-5°');
      expect(originalForecast.maxTempInCelsius, '10°');
      expect(originalForecast.iconUrl, 'http://openweathermap.org/img/wn/13d@2x.png');
    });

    test('should handle temperature ranges correctly', () {
      const wideRangeForecast = Forecast(
        day: 'Wednesday',
        minTemp: -20.0,
        maxTemp: 40.0,
        description: 'Variable',
        icon: '02d',
      );
      
      expect(wideRangeForecast.minTempInCelsius, '-20°');
      expect(wideRangeForecast.maxTempInCelsius, '40°');
      expect(wideRangeForecast.maxTemp - wideRangeForecast.minTemp, 60.0);
    });
  });
}
