import 'package:flutter_test/flutter_test.dart';
import 'package:rdm_weather_app/features/weather/data/models/weather_model.dart';

void main() {
  test('should convert from JSON', () {
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

  test('should convert to JSON', () {
    final model = WeatherModel(
      cityName: 'Paris',
      temperature: 20.0,
      description: 'Sunny',
      icon: '01d',
    );
    final json = model.toJson();
    expect(json, isA<Map<String, dynamic>>());
    expect(json['cityName'], 'Paris');
    expect(json['temperature'], 20.0);
    expect(json['description'], 'Sunny');
    expect(json['icon'], '01d');
  });
}
