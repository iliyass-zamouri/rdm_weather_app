import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/weather.dart';

part 'weather_model.freezed.dart';
part 'weather_model.g.dart';

@freezed
class WeatherModel with _$WeatherModel {
  const WeatherModel._();

  /// WeatherModel data transfer object (DTO)
  const factory WeatherModel({
    required String cityName,
    required double temperature,
    required String description,
    required String icon,
  }) = _WeatherModel;

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);

  /// Factory for creating WeatherModel from API response
  factory WeatherModel.fromApi(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temperature: (json['main']['temp']).toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }

  /// Convert to domain entity
  Weather toEntity() => Weather(
        cityName: cityName,
        temperature: temperature,
        description: description,
        icon: icon,
      );
}
