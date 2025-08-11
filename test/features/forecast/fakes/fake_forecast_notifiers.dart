import 'package:dartz/dartz.dart';
import 'package:rdm_weather_app/core/error/failures.dart';
import 'package:rdm_weather_app/features/forecast/domain/entities/forecast.dart';
import 'package:rdm_weather_app/features/forecast/domain/repositories/forecast_repository.dart';
import 'package:rdm_weather_app/features/forecast/domain/usecases/get_forecast.dart';
import 'package:rdm_weather_app/features/forecast/presentation/providers/forecast_provider.dart';
import 'package:rdm_weather_app/features/forecast/presentation/state/forecast_state.dart';

// Fake GetForecast implementation
class FakeGetForecast implements GetForecast {
  @override
  Future<Either<Failure, List<Forecast>>> call(String city) async {
    // Return a successful result with dummy data
    return Right([
      const Forecast(
        day: 'Monday',
        minTemp: 15.0,
        maxTemp: 25.0,
        description: 'Partly cloudy',
        icon: '02d',
      ),
      const Forecast(
        day: 'Tuesday',
        minTemp: 18.0,
        maxTemp: 28.0,
        description: 'Sunny',
        icon: '01d',
      ),
    ]);
  }

  // Implement the missing getter if required by GetForecast
  @override
  ForecastRepository get repository => throw UnimplementedError();
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

class FakeLoadingForecastNotifier extends ForecastNotifier {
  FakeLoadingForecastNotifier() : super(FakeGetForecast()) {
    state = const ForecastState.loading();
  }
}

class FakeLoadedForecastNotifier extends ForecastNotifier {
  FakeLoadedForecastNotifier() : super(FakeGetForecast()) {
    state = ForecastState.loaded([
      const Forecast(
        day: 'Monday',
        minTemp: 15.0,
        maxTemp: 25.0,
        description: 'Partly cloudy',
        icon: '02d',
      ),
      const Forecast(
        day: 'Tuesday',
        minTemp: 18.0,
        maxTemp: 28.0,
        description: 'Sunny',
        icon: '01d',
      ),
    ]);
  }
}
