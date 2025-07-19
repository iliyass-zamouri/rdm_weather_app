import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:rdm_weather_app/features/weather/domain/entities/forecast.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Weather>> getCurrentWeather(String city) async {
    try {
      final weather = await remoteDataSource.getCurrentWeather(city);
      return Right(weather.toEntity());
    } on NotFoundException {
      log('City not found: $city');
      return Left(NotFoundFailure());
    } on NetworkException {
      log('Network error occurred while fetching weather data.');
      return Left(NetworkFailure());
    } on ServerException {
      log('Server error occurred while fetching weather data.');
      return Left(ServerFailure());
    } catch (_) {
      log('Unexpected error occurred while fetching weather data.');
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<Forecast>>> getWeatherForecast(
      String city) async {
    try {
      final forecasts = await remoteDataSource.getWeatherForecast(city);
      return Right(forecasts.map((f) => f.toEntity()).toList());
    } on NotFoundException {
      return Left(NotFoundFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on ServerException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(UnexpectedFailure());
    }
  }
}
