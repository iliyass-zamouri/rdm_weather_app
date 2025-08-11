import 'package:flutter_test/flutter_test.dart';
import 'package:rdm_weather_app/features/weather/domain/entities/weather.dart';

void main() {
  group('Weather Entity', () {
    const testWeather = Weather(
      cityName: 'Paris',
      temperature: 25.0,
      description: 'Sunny',
      icon: '01d',
    );

    test('should have correct basic properties', () {
      expect(testWeather.cityName, 'Paris');
      expect(testWeather.temperature, 25.0);
      expect(testWeather.description, 'Sunny');
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

    test('should handle negative temperatures correctly', () {
      const coldWeather = Weather(
        cityName: 'Moscow',
        temperature: -10.0,
        description: 'Snow',
        icon: '13d',
      );
      expect(coldWeather.temperatureInCelsius, '-10°');
    });

    test('should handle zero temperature correctly', () {
      const zeroWeather = Weather(
        cityName: 'Toronto',
        temperature: 0.0,
        description: 'Freezing',
        icon: '13d',
      );
      expect(zeroWeather.temperatureInCelsius, '0°');
    });

    test('should handle high temperatures correctly', () {
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
        cityName: 'Tokyo',
        temperature: 20.0,
        description: 'Rain',
        icon: '09d',
      );
      expect(differentIcon.iconUrl, 'http://openweathermap.org/img/wn/09d@4x.png');
    });

    test('should handle different weather descriptions', () {
      const rainyWeather = Weather(
        cityName: 'Seattle',
        temperature: 15.0,
        description: 'Heavy rain',
        icon: '09d',
      );
      expect(rainyWeather.description, 'Heavy rain');
      expect(rainyWeather.icon, '09d');
    });

    test('should maintain data integrity', () {
      const originalWeather = Weather(
        cityName: 'Berlin',
        temperature: -5.0,
        description: 'Snow storm',
        icon: '13d',
      );
      
      expect(originalWeather.cityName, 'Berlin');
      expect(originalWeather.temperature, -5.0);
      expect(originalWeather.description, 'Snow storm');
      expect(originalWeather.icon, '13d');
      expect(originalWeather.temperatureInCelsius, '-5°');
      expect(originalWeather.iconUrl, 'http://openweathermap.org/img/wn/13d@4x.png');
    });

    test('should handle temperature ranges correctly', () {
      const wideRangeWeather = Weather(
        cityName: 'Anchorage',
        temperature: -30.0,
        description: 'Extreme cold',
        icon: '13d',
      );
      
      expect(wideRangeWeather.temperatureInCelsius, '-30°');
      expect(wideRangeWeather.temperature, -30.0);
    });
  });
}
