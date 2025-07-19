import 'package:dartz/dartz.dart';
import 'package:rdm_weather_app/features/weather/domain/entities/forecast.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/weather_repository.dart';

class GetForecast implements UseCase<List<Forecast>, String> {
  final WeatherRepository repository;
  GetForecast(this.repository);

  @override
  Future<Either<Failure, List<Forecast>>> call(String city) async {
    return await repository.getWeatherForecast(city);
  }
}
