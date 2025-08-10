import 'package:dartz/dartz.dart';
import 'package:rdm_weather_app/features/weather/data/datasources/forecast_remote_data_source.dart';
import 'package:rdm_weather_app/features/weather/domain/entities/forecast.dart';
import 'package:rdm_weather_app/features/weather/domain/repositories/forecast_repository.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';

class ForecastRepositoryImpl implements ForecastRepository {
  final ForecastRemoteDataSource remoteDataSource;

  ForecastRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Forecast>>> getWeatherForecast(String city) async {
    try {
      final forecasts = await remoteDataSource.getWeatherForecast(city);
      return Right(forecasts.map((f) => f.toEntity()).toList());
    } on AppException catch (e) {
      return Left(e.toFailure());
    }
  }
}