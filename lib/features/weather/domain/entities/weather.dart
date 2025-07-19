import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather.freezed.dart';

@freezed
class Weather with _$Weather {
  const Weather._();

  const factory Weather({
    required String cityName,
    required double temperature,
    required String description,
    required String icon,
  }) = _Weather;

  String get temperatureInCelsius => '${temperature.toStringAsFixed(0)}°';

  String get iconUrl => 'http://openweathermap.org/img/wn/$icon@4x.png';
}
