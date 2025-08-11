import 'package:flutter_test/flutter_test.dart';
import 'package:rdm_weather_app/features/weather/domain/entities/weather.dart';

void main() {
  group('Weather Entity', () {
    const testWeather = Weather(
      cityName: 'Paris',
      temperature: 25.0,
      description: 'Clear sky',
      icon: '01d',
    );

    test('should have correct basic properties', () {
      expect(testWeather.cityName, 'Paris');
      expect(testWeather.temperature, 25.0);
      expect(testWeather.description, 'Clear sky');
      expect(testWeather.icon, '01d');
    });

    test('should format temperature correctly', () {
      expect(testWeather.temperatureInCelsius, '25°');
      
      const weatherWithDecimal = Weather(
        cityName: 'London',
        temperature: 18.7,
        description: 'Cloudy',
        icon: '03d',
      );
      expect(weatherWithDecimal.temperatureInCelsius, '19°'); // Should round to nearest integer
    });

    test('should format negative temperature correctly', () {
      const coldWeather = Weather(
        cityName: 'Moscow',
        temperature: -5.0,
        description: 'Snow',
        icon: '13d',
      );
      expect(coldWeather.temperatureInCelsius, '-5°');
    });

    test('should format zero temperature correctly', () {
      const zeroWeather = Weather(
        cityName: 'Test',
        temperature: 0.0,
        description: 'Freezing',
        icon: '13d',
      );
      expect(zeroWeather.temperatureInCelsius, '0°');
    });

    test('should format high temperature correctly', () {
      const hotWeather = Weather(
        cityName: 'Dubai',
        temperature: 45.0,
        description: 'Very hot',
        icon: '01d',
      );
      expect(hotWeather.temperatureInCelsius, '45°');
    });

    test('should generate correct icon URL', () {
      expect(testWeather.iconUrl, 'http://openweathermap.org/img/wn/01d@4x.png');
      
      const differentIcon = Weather(
        cityName: 'Test',
        temperature: 20.0,
        description: 'Test',
        icon: '02n',
      );
      expect(differentIcon.iconUrl, 'http://openweathermap.org/img/wn/02n@4x.png');
    });

    test('should handle different weather descriptions', () {
      const rainyWeather = Weather(
        cityName: 'London',
        temperature: 18.0,
        description: 'Heavy rain',
        icon: '09d',
      );
      expect(rainyWeather.description, 'Heavy rain');
      expect(rainyWeather.icon, '09d');
    });

    test('should maintain data integrity', () {
      const originalWeather = Weather(
        cityName: 'Berlin',
        temperature: -10.0,
        description: 'Snow storm',
        icon: '13d',
      );
      
      expect(originalWeather.cityName, 'Berlin');
      expect(originalWeather.temperature, -10.0);
      expect(originalWeather.description, 'Snow storm');
      expect(originalWeather.icon, '13d');
      expect(originalWeather.temperatureInCelsius, '-10°');
      expect(originalWeather.iconUrl, 'http://openweathermap.org/img/wn/13d@4x.png');
    });
  });
}
