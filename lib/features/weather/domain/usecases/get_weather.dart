import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class GetWeather implements UseCase<Weather, String> {
  final WeatherRepository repository;
  GetWeather(this.repository);

  @override
  Future<Either<Failure, Weather>> call(String city) async {
    return await repository.getCurrentWeather(city);
  }
}
