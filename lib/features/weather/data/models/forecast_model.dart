import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/forecast.dart';

part 'forecast_model.freezed.dart';
part 'forecast_model.g.dart';

@freezed
class ForecastModel with _$ForecastModel {
  const ForecastModel._();

  /// ForecastModel data transfer object (DTO)
  const factory ForecastModel({
    required String day,
    required double minTemp,
    required double maxTemp,
    required String description,
    required String icon,
  }) = _ForecastModel;

  factory ForecastModel.fromJson(Map<String, dynamic> json) =>
      _$ForecastModelFromJson(json);

  /// Convert to domain entity
  Forecast toEntity() => Forecast(
        day: day,
        minTemp: minTemp,
        maxTemp: maxTemp,
        description: description,
        icon: icon,
      );
}
