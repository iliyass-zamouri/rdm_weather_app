import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/forecast.dart';

/// Responsible only for weather forecast retrieval
abstract class ForecastRepository {
  Future<Either<Failure, List<Forecast>>> getWeatherForecast(String city);
}
