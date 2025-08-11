import 'package:dartz/dartz.dart';
import 'package:rdm_weather_app/features/weather/domain/entities/weather.dart';
import 'package:rdm_weather_app/features/weather/domain/repositories/weather_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetWeather implements UseCase<Weather, String> {
  final WeatherRepository repository;
  GetWeather(this.repository);

  @override
  Future<Either<Failure, Weather>> call(String city) async {
    return await repository.get(city);
  }
}
