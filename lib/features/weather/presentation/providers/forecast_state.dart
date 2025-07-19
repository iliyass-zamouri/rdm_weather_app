import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/forecast.dart';

part 'forecast_state.freezed.dart';

@freezed
class ForecastState with _$ForecastState {
  const factory ForecastState.initial() = _Initial;
  const factory ForecastState.loading() = _Loading;
  const factory ForecastState.loaded(List<Forecast> forecasts) = _Loaded;
  const factory ForecastState.error(String message) = _Error;
}
