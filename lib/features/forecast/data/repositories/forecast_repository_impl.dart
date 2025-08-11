import 'package:dartz/dartz.dart';
import 'package:rdm_weather_app/features/forecast/data/datasources/forecast_remote_data_source.dart';
import 'package:rdm_weather_app/features/forecast/domain/entities/forecast.dart';
import 'package:rdm_weather_app/features/forecast/domain/repositories/forecast_repository.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';

class ForecastRepositoryImpl implements ForecastRepository {
  final ForecastRemoteDataSource remoteDataSource;

  ForecastRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Forecast>>> get(String city) async {
    try {
      final forecasts = await remoteDataSource.get(city);
      return Right(forecasts.map((f) => f.toEntity()).toList());
    } on AppException catch (e) {
      return Left(e.toFailure());
    }
  }
}