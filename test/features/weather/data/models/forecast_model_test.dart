import 'package:flutter_test/flutter_test.dart';
import 'package:rdm_weather_app/features/weather/data/models/forecast_model.dart';

void main() {
  test('should convert from JSON', () {
    final json = {
      'day': 'Monday',
      'maxTemp': 25.0,
      'minTemp': 15.0,
      'description': 'Sunny',
      'icon': '01d',
    };
    final model = ForecastModel.fromJson(json);
    expect(model, isA<ForecastModel>());
    expect(model.day, 'Monday');
    expect(model.maxTemp, 25.0);
    expect(model.minTemp, 15.0);
    expect(model.description, 'Sunny');
    expect(model.icon, '01d');
  });

  test('should convert to JSON', () {
    final model = ForecastModel(
        day: 'Monday',
        description: 'Sunny',
        icon: '01d',
        maxTemp: 25.0,
        minTemp: 15.0);
    final json = model.toJson();
    expect(json, isA<Map<String, dynamic>>());
    expect(json['day'], 'Monday');
    expect(json['maxTemp'], 25.0);
    expect(json['minTemp'], 15.0);
    expect(json['description'], 'Sunny');
    expect(json['icon'], '01d');
  });
}
