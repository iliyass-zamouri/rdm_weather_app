import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rdm_weather_app/features/forecast/data/providers/forecast_repository_provider.dart';
import '../../domain/usecases/get_forecast.dart';
import '../state/forecast_state.dart';

final forecastProvider =
    StateNotifierProvider<ForecastNotifier, ForecastState>((ref) {
  final getForecast = ref.watch(getForecastProvider);
  return ForecastNotifier(getForecast);
});

final getForecastProvider = Provider<GetForecast>((ref) {
  return GetForecast(ref.read(forecastRepositoryProvider));
});

class ForecastNotifier extends StateNotifier<ForecastState> {
  final GetForecast getForecast;

  ForecastNotifier(this.getForecast) : super(const ForecastState.initial());

  Future<void> fetchForecast(String city) async {
    state = const ForecastState.loading();
    final result = await getForecast(city);
    result.fold(
      (failure) => state = ForecastState.error(failure.toString()),
      (forecasts) => state = ForecastState.loaded(forecasts),
    );
  }

  reset() {
    state = const ForecastState.initial();
  }
}
