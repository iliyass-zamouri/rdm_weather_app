import 'package:dartz/dartz.dart';
import 'package:rdm_weather_app/core/error/failures.dart';
import 'package:rdm_weather_app/features/weather/domain/entities/forecast.dart';
import 'package:rdm_weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:rdm_weather_app/features/weather/domain/usecases/get_forecast.dart';
import 'package:rdm_weather_app/features/weather/presentation/providers/forecast_provider.dart';
import 'package:rdm_weather_app/features/weather/presentation/providers/forecast_state.dart';

// Fake GetForecast implementation
class FakeGetForecast implements GetForecast {
  @override
  Future<Either<Failure, List<Forecast>>> call(String city) async {
    // Return a successful result with dummy data
    return Future.value(Right(<Forecast>[]));
  }

  // Implement the missing getter if required by GetForecast
  @override
  WeatherRepository get repository => throw UnimplementedError();
}

// Fake ForecastNotifier for tests
class FakeForecastNotifier extends ForecastNotifier {
  FakeForecastNotifier() : super(FakeGetForecast());
}

class FakeErrorForecastNotifier extends ForecastNotifier {
  FakeErrorForecastNotifier() : super(FakeGetForecast()) {
    state = const ForecastState.error("API down");
  }
}

class FakeInitialForecastNotifier extends ForecastNotifier {
  FakeInitialForecastNotifier() : super(FakeGetForecast()) {
    state = const ForecastState.initial();
  }
}
