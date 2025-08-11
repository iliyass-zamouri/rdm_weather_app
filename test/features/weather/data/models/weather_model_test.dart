import 'package:flutter_test/flutter_test.dart';
import 'package:rdm_weather_app/features/weather/data/models/weather_model.dart';
import 'package:rdm_weather_app/features/weather/domain/entities/weather.dart';

void main() {
  group('WeatherModel', () {
    const tWeatherModel = WeatherModel(
      cityName: 'Paris',
      temperature: 20.0,
      description: 'Sunny',
      icon: '01d',
    );

    group('fromJson', () {
      test('should convert from JSON correctly', () {
        final json = {
          'cityName': 'Paris',
          'temperature': 20.0,
          'description': 'Sunny',
          'icon': '01d',
        };
        final model = WeatherModel.fromJson(json);
        
        expect(model, isA<WeatherModel>());
        expect(model.cityName, 'Paris');
        expect(model.temperature, 20.0);
        expect(model.description, 'Sunny');
        expect(model.icon, '01d');
      });

      test('should handle different data types in JSON', () {
        final json = {
          'cityName': 'London',
          'temperature': 18.5,
          'description': 'Cloudy',
          'icon': '03d',
        };
        final model = WeatherModel.fromJson(json);
        
        expect(model.cityName, 'London');
        expect(model.temperature, 18.5);
        expect(model.description, 'Cloudy');
        expect(model.icon, '03d');
      });
    });

    group('toJson', () {
      test('should convert to JSON correctly', () {
        final json = tWeatherModel.toJson();
        
        expect(json, isA<Map<String, dynamic>>());
        expect(json['cityName'], 'Paris');
        expect(json['temperature'], 20.0);
        expect(json['description'], 'Sunny');
        expect(json['icon'], '01d');
      });

      test('should maintain data integrity through JSON conversion', () {
        final originalModel = WeatherModel(
          cityName: 'Berlin',
          temperature: -5.0,
          description: 'Snow',
          icon: '13d',
        );
        
        final json = originalModel.toJson();
        final convertedModel = WeatherModel.fromJson(json);
        
        expect(convertedModel.cityName, originalModel.cityName);
        expect(convertedModel.temperature, originalModel.temperature);
        expect(convertedModel.description, originalModel.description);
        expect(convertedModel.icon, originalModel.icon);
      });
    });

    group('fromApi', () {
      test('should convert from API response correctly', () {
        final apiResponse = {
          'name': 'Tokyo',
          'main': {'temp': 25.5},
          'weather': [
            {
              'description': 'clear sky',
              'icon': '01d',
            }
          ],
        };
        
        final model = WeatherModel.fromApi(apiResponse);
        
        expect(model.cityName, 'Tokyo');
        expect(model.temperature, 25.5);
        expect(model.description, 'clear sky');
        expect(model.icon, '01d');
      });

      test('should handle API response with different temperature values', () {
        final apiResponse = {
          'name': 'Moscow',
          'main': {'temp': -10.0},
          'weather': [
            {
              'description': 'light snow',
              'icon': '13d',
            }
          ],
        };
        
        final model = WeatherModel.fromApi(apiResponse);
        
        expect(model.cityName, 'Moscow');
        expect(model.temperature, -10.0);
        expect(model.description, 'light snow');
        expect(model.icon, '13d');
      });

      test('should handle API response with complex weather descriptions', () {
        final apiResponse = {
          'name': 'New York',
          'main': {'temp': 30.0},
          'weather': [
            {
              'description': 'scattered clouds',
              'icon': '03d',
            }
          ],
        };
        
        final model = WeatherModel.fromApi(apiResponse);
        
        expect(model.cityName, 'New York');
        expect(model.temperature, 30.0);
        expect(model.description, 'scattered clouds');
        expect(model.icon, '03d');
      });
    });

    group('toEntity', () {
      test('should convert to domain entity correctly', () {
        final entity = tWeatherModel.toEntity();
        
        expect(entity, isA<Weather>());
        expect(entity.cityName, 'Paris');
        expect(entity.temperature, 20.0);
        expect(entity.description, 'Sunny');
        expect(entity.icon, '01d');
      });

      test('should maintain data integrity when converting to entity', () {
        const model = WeatherModel(
          cityName: 'Sydney',
          temperature: 35.0,
          description: 'Hot',
          icon: '01d',
        );
        
        final entity = model.toEntity();
        
        expect(entity.cityName, model.cityName);
        expect(entity.temperature, model.temperature);
        expect(entity.description, model.description);
        expect(entity.icon, model.icon);
      });

      test('should handle negative temperatures in entity conversion', () {
        const model = WeatherModel(
          cityName: 'Oslo',
          temperature: -15.0,
          description: 'Very cold',
          icon: '13d',
        );
        
        final entity = model.toEntity();
        
        expect(entity.temperature, -15.0);
        expect(entity.temperatureInCelsius, '-15°');
      });
    });

    group('computed properties', () {
      test('should have correct temperature formatting', () {
        const model = WeatherModel(
          cityName: 'Test',
          temperature: 22.7,
          description: 'Test',
          icon: '01d',
        );
        
        final entity = model.toEntity();
        expect(entity.temperatureInCelsius, '23°'); // Should round to nearest integer
      });

      test('should have correct icon URL generation', () {
        const model = WeatherModel(
          cityName: 'Test',
          temperature: 20.0,
          description: 'Test',
          icon: '02n',
        );
        
        final entity = model.toEntity();
        expect(entity.iconUrl, 'http://openweathermap.org/img/wn/02n@4x.png');
      });
    });

    group('edge cases', () {
      test('should handle zero temperature', () {
        const model = WeatherModel(
          cityName: 'Test',
          temperature: 0.0,
          description: 'Freezing',
          icon: '13d',
        );
        
        final entity = model.toEntity();
        expect(entity.temperatureInCelsius, '0°');
      });

      test('should handle very high temperatures', () {
        const model = WeatherModel(
          cityName: 'Test',
          temperature: 45.0,
          description: 'Extremely hot',
          icon: '01d',
        );
        
        final entity = model.toEntity();
        expect(entity.temperatureInCelsius, '45°');
      });

      test('should handle very low temperatures', () {
        const model = WeatherModel(
          cityName: 'Test',
          temperature: -40.0,
          description: 'Extremely cold',
          icon: '13d',
        );
        
        final entity = model.toEntity();
        expect(entity.temperatureInCelsius, '-40°');
      });
    });
  });
}
