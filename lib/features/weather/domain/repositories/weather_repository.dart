import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/weather.dart';

/// Responsible only for current weather retrieval
abstract class WeatherRepository {
  Future<Either<Failure, Weather>> getCurrentWeather(String city);
}