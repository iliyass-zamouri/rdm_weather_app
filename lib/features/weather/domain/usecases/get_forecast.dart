import 'package:dartz/dartz.dart';
import 'package:rdm_weather_app/features/weather/domain/entities/forecast.dart';
import 'package:rdm_weather_app/features/weather/domain/repositories/forecast_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetForecast implements UseCase<List<Forecast>, String> {
  final ForecastRepository repository;
  GetForecast(this.repository);

  @override
  Future<Either<Failure, List<Forecast>>> call(String city) async {
    return await repository.getWeatherForecast(city);
  }
}
