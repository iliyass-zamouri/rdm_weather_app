import 'package:dartz/dartz.dart';
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
      final weather = await remoteDataSource.getWeather(city);
      return Right(weather.toEntity());
    } on AppException catch (e) {
      return Left(e.toFailure());
    }
  }
}