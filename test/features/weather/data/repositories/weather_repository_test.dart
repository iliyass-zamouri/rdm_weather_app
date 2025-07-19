import 'package:flutter_test/flutter_test.dart';
import 'package:rdm_weather_app/core/error/exceptions.dart';
import 'package:rdm_weather_app/features/weather/data/models/weather_model.dart';
import 'package:rdm_weather_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:rdm_weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:rdm_weather_app/features/weather/domain/entities/weather.dart';
import 'package:dartz/dartz.dart';
import 'package:rdm_weather_app/core/error/failures.dart';
import 'package:rdm_weather_app/features/weather/data/models/forecast_model.dart';

class FakeWeatherRemoteDataSource implements WeatherRemoteDataSource {
  WeatherModel? weatherModel;
  Exception? exception;

  @override
  Future<WeatherModel> getCurrentWeather(String cityName) async {
    if (exception != null) throw exception!;
    if (weatherModel != null) return weatherModel!;
    throw UnimplementedError();
  }

  @override
  Future<List<ForecastModel>> getWeatherForecast(String cityName) async {
    throw UnimplementedError();
  }
}

void main() {
  late WeatherRepositoryImpl repository;
  late FakeWeatherRemoteDataSource fakeDataSource;

  setUp(() {
    fakeDataSource = FakeWeatherRemoteDataSource();
    repository = WeatherRepositoryImpl(fakeDataSource);
  });

  test('should return Weather when remote call is successful', () async {
    final tWeatherModel = WeatherModel(
      cityName: 'Paris',
      temperature: 20.0,
      description: 'Sunny',
      icon: '01d',
    );
    final tWeather = Weather(
      cityName: 'Paris',
      temperature: 20.0,
      description: 'Sunny',
      icon: '01d',
    );
    fakeDataSource.weatherModel = tWeatherModel;
    final result = await repository.getCurrentWeather('Paris');
    expect(result, Right(tWeather));
  });

  test('should return Failure when remote call throws', () async {
    fakeDataSource.exception = ServerException();
    final result = await repository.getCurrentWeather('Paris');
    expect(result, Left(ServerFailure()));
  });
}
