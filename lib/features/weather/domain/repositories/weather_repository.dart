import 'package:dartz/dartz.dart';
import 'package:rdm_weather_app/features/weather/domain/entities/forecast.dart';
import '../../../../core/error/failures.dart';
import '../entities/weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Weather>> getCurrentWeather(String city);
  Future<Either<Failure, List<Forecast>>> getWeatherForecast(String city);
}
