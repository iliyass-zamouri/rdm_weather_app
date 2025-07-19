import 'package:freezed_annotation/freezed_annotation.dart';

part 'forecast.freezed.dart';

@freezed
class Forecast with _$Forecast {
  const Forecast._();
  const factory Forecast({
    required String day,
    required double minTemp,
    required double maxTemp,
    required String description,
    required String icon,
  }) = _Forecast;

  String get minTempInCelsius => '${minTemp.toStringAsFixed(0)}°';
  String get maxTempInCelsius => '${maxTemp.toStringAsFixed(0)}°';

  String get iconUrl => 'http://openweathermap.org/img/wn/$icon@2x.png';
}
