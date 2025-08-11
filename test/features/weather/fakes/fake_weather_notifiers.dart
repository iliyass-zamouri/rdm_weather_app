import 'package:rdm_weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:rdm_weather_app/features/weather/presentation/state/weather_state.dart';
import 'package:rdm_weather_app/features/weather/domain/usecases/get_weather.dart';
import 'package:rdm_weather_app/features/weather/domain/entities/weather.dart';
import 'package:dartz/dartz.dart';
import 'package:rdm_weather_app/core/error/failures.dart';

// Fake GetWeather implementation
class FakeGetWeather implements GetWeather {
  @override
  Future<Either<Failure, Weather>> call(String city) async {
    return Right(Weather(
      // Fill with dummy data if needed
      cityName: city,
      temperature: 20.0,
      description: 'Sunny',
      icon: '01d',
    ));
  }

  @override
  get repository => throw UnimplementedError();
}

// Weather Notifiers for tests
class FakeLoadingWeatherNotifier extends WeatherNotifier {
  FakeLoadingWeatherNotifier() : super(FakeGetWeather()) {
    state = const WeatherState.loading();
  }
}

class FakeInitialWeatherNotifier extends WeatherNotifier {
  FakeInitialWeatherNotifier() : super(FakeGetWeather()) {
    state = const WeatherState.initial();
  }
}

class FakeErrorWeatherNotifier extends WeatherNotifier {
  FakeErrorWeatherNotifier() : super(FakeGetWeather()) {
    state = const WeatherState.error("API down");
  }
}

class FakeLoadedWeatherNotifier extends WeatherNotifier {
  FakeLoadedWeatherNotifier() : super(FakeGetWeather()) {
    state = WeatherState.loaded(Weather(
      cityName: 'Test City',
      temperature: 25.0,
      description: 'Clear sky',
      icon: '01d',
    ));
  }
}
