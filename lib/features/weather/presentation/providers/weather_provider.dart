import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/usecases/get_weather.dart';
import 'weather_state.dart';

final weatherProvider =
    StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  final getWeather = ref.watch(getWeatherProvider);
  return WeatherNotifier(getWeather);
});

final getWeatherProvider = Provider<GetWeather>((ref) {
  throw UnimplementedError();
});

class WeatherNotifier extends StateNotifier<WeatherState> {
  final GetWeather getWeather;

  WeatherNotifier(this.getWeather) : super(const WeatherState.initial());

  Future<void> fetchWeather(String city) async {
    state = const WeatherState.loading();
    final result = await getWeather(city);
    result.fold(
      (failure) => state = WeatherState.error(failure.toString()),
      (weather) => state = WeatherState.loaded(weather),
    );
  }

  reset() {
    state = const WeatherState.initial();
  }
}
