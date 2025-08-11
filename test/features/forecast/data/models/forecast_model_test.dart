import 'package:flutter_test/flutter_test.dart';
import 'package:rdm_weather_app/features/forecast/data/models/forecast_model.dart';
import 'package:rdm_weather_app/features/forecast/domain/entities/forecast.dart';

void main() {
  group('ForecastModel', () {
    const tForecastModel = ForecastModel(
      day: 'Monday',
      minTemp: 15.0,
      maxTemp: 25.0,
      description: 'Partly cloudy',
      icon: '02d',
    );

    group('fromJson', () {
      test('should convert from JSON correctly', () {
        final json = {
          'day': 'Monday',
          'minTemp': 15.0,
          'maxTemp': 25.0,
          'description': 'Partly cloudy',
          'icon': '02d',
        };
        final model = ForecastModel.fromJson(json);
        
        expect(model, isA<ForecastModel>());
        expect(model.day, 'Monday');
        expect(model.minTemp, 15.0);
        expect(model.maxTemp, 25.0);
        expect(model.description, 'Partly cloudy');
        expect(model.icon, '02d');
      });

      test('should handle different data types in JSON', () {
        final json = {
          'day': 'Tuesday',
          'minTemp': 18.5,
          'maxTemp': 28.0,
          'description': 'Cloudy',
          'icon': '03d',
        };
        final model = ForecastModel.fromJson(json);
        
        expect(model.day, 'Tuesday');
        expect(model.minTemp, 18.5);
        expect(model.maxTemp, 28.0);
        expect(model.description, 'Cloudy');
        expect(model.icon, '03d');
      });
    });

    group('toJson', () {
      test('should convert to JSON correctly', () {
        final json = tForecastModel.toJson();
        
        expect(json, isA<Map<String, dynamic>>());
        expect(json['day'], 'Monday');
        expect(json['minTemp'], 15.0);
        expect(json['maxTemp'], 25.0);
        expect(json['description'], 'Partly cloudy');
        expect(json['icon'], '02d');
      });

      test('should maintain data integrity through JSON conversion', () {
        final originalModel = ForecastModel(
          day: 'Wednesday',
          minTemp: -5.0,
          maxTemp: 10.0,
          description: 'Snow',
          icon: '13d',
        );
        
        final json = originalModel.toJson();
        final convertedModel = ForecastModel.fromJson(json);
        
        expect(convertedModel.day, originalModel.day);
        expect(convertedModel.minTemp, originalModel.minTemp);
        expect(convertedModel.maxTemp, originalModel.maxTemp);
        expect(convertedModel.description, originalModel.description);
        expect(convertedModel.icon, originalModel.icon);
      });
    });

    group('toEntity', () {
      test('should convert to domain entity correctly', () {
        final entity = tForecastModel.toEntity();
        
        expect(entity, isA<Forecast>());
        expect(entity.day, 'Monday');
        expect(entity.minTemp, 15.0);
        expect(entity.maxTemp, 25.0);
        expect(entity.description, 'Partly cloudy');
        expect(entity.icon, '02d');
      });

      test('should maintain data integrity when converting to entity', () {
        const model = ForecastModel(
          day: 'Thursday',
          minTemp: 20.0,
          maxTemp: 35.0,
          description: 'Hot',
          icon: '01d',
        );
        
        final entity = model.toEntity();
        
        expect(entity.day, model.day);
        expect(entity.minTemp, model.minTemp);
        expect(entity.maxTemp, model.maxTemp);
        expect(entity.description, model.description);
        expect(entity.icon, model.icon);
      });

      test('should handle negative temperatures in entity conversion', () {
        const model = ForecastModel(
          day: 'Friday',
          minTemp: -15.0,
          maxTemp: -5.0,
          description: 'Very cold',
          icon: '13d',
        );
        
        final entity = model.toEntity();
        
        expect(entity.minTemp, -15.0);
        expect(entity.maxTemp, -5.0);
        expect(entity.minTempInCelsius, '-15°');
        expect(entity.maxTempInCelsius, '-5°');
      });
    });

    group('computed properties', () {
      test('should have correct temperature formatting', () {
        const model = ForecastModel(
          day: 'Saturday',
          minTemp: 22.7,
          maxTemp: 28.3,
          description: 'Test',
          icon: '01d',
        );
        
        final entity = model.toEntity();
        expect(entity.minTempInCelsius, '23°'); // Should round to nearest integer
        expect(entity.maxTempInCelsius, '28°'); // Should round to nearest integer
      });

      test('should have correct icon URL generation', () {
        const model = ForecastModel(
          day: 'Sunday',
          minTemp: 20.0,
          maxTemp: 30.0,
          description: 'Test',
          icon: '02n',
        );
        
        final entity = model.toEntity();
        expect(entity.iconUrl, 'http://openweathermap.org/img/wn/02n@2x.png');
      });
    });

    group('edge cases', () {
      test('should handle zero temperatures', () {
        const model = ForecastModel(
          day: 'Test',
          minTemp: 0.0,
          maxTemp: 0.0,
          description: 'Freezing',
          icon: '13d',
        );
        
        final entity = model.toEntity();
        expect(entity.minTempInCelsius, '0°');
        expect(entity.maxTempInCelsius, '0°');
      });

      test('should handle very high temperatures', () {
        const model = ForecastModel(
          day: 'Test',
          minTemp: 45.0,
          maxTemp: 50.0,
          description: 'Extremely hot',
          icon: '01d',
        );
        
        final entity = model.toEntity();
        expect(entity.minTempInCelsius, '45°');
        expect(entity.maxTempInCelsius, '50°');
      });

      test('should handle very low temperatures', () {
        const model = ForecastModel(
          day: 'Test',
          minTemp: -40.0,
          maxTemp: -30.0,
          description: 'Extremely cold',
          icon: '13d',
        );
        
        final entity = model.toEntity();
        expect(entity.minTempInCelsius, '-40°');
        expect(entity.maxTempInCelsius, '-30°');
      });
    });
  });
}
