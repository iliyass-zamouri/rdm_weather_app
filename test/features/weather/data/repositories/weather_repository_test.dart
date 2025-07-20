import 'package:flutter_test/flutter_test.dart';
import 'package:rdm_weather_app/core/error/exceptions.dart';
import 'package:rdm_weather_app/features/weather/data/models/weather_model.dart';
import 'package:rdm_weather_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:rdm_weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:rdm_weather_app/features/weather/domain/entities/forecast.dart';
import 'package:rdm_weather_app/features/weather/domain/entities/weather.dart';
import 'package:dartz/dartz.dart';
import 'package:rdm_weather_app/core/error/failures.dart';
import 'package:rdm_weather_app/features/weather/data/models/forecast_model.dart';

class FakeWeatherRemoteDataSource implements WeatherRemoteDataSource {
  WeatherModel? weatherModel;
  Exception? exception;
  List<ForecastModel>? forecastModels;

  @override
  Future<WeatherModel> getCurrentWeather(String cityName) async {
    if (exception != null) throw exception!;
    if (weatherModel != null) return weatherModel!;
    throw UnimplementedError();
  }

  @override
  Future<List<ForecastModel>> getWeatherForecast(String cityName) async {
    if (exception != null) throw exception!;
    if (forecastModels != null) return forecastModels!;
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

  group('getCurrentWeather', () {
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

    test('returns Weather on success', () async {
      fakeDataSource.weatherModel = tWeatherModel;
      final result = await repository.getCurrentWeather('Paris');
      expect(result, Right(tWeather));
    });

    test('returns NotFoundFailure on NotFoundException', () async {
      fakeDataSource.exception = NotFoundException();
      final result = await repository.getCurrentWeather('Paris');
      expect(result, Left(NotFoundFailure()));
    });

    test('returns NetworkFailure on NetworkException', () async {
      fakeDataSource.exception = NetworkException();
      final result = await repository.getCurrentWeather('Paris');
      expect(result, Left(NetworkFailure()));
    });

    test('returns ServerFailure on ServerException', () async {
      fakeDataSource.exception = ServerException();
      final result = await repository.getCurrentWeather('Paris');
      expect(result, Left(ServerFailure()));
    });

    test('returns UnexpectedFailure on unknown error', () async {
      fakeDataSource.exception = Exception('Unknown');
      final result = await repository.getCurrentWeather('Paris');
      expect(result, Left(UnexpectedFailure()));
    });
  });

  group('getWeatherForecast', () {
    final tForecastModels = [
      ForecastModel(
        day: '2025-07-19',
        minTemp: 15.0,
        maxTemp: 25.0,
        description: 'Sunny',
        icon: '01d',
      ),
      ForecastModel(
        day: '2025-07-20',
        minTemp: 16.0,
        maxTemp: 22.0,
        description: 'Cloudy',
        icon: '02d',
      ),
    ];
    final tForecasts = tForecastModels.map((f) => f.toEntity()).toList();

    test('returns Forecast list on success', () async {
      fakeDataSource.forecastModels = tForecastModels;
      final result = await repository.getWeatherForecast('Paris');
      expect(result.getOrElse(() => []), tForecasts);
    });

    test('returns NotFoundFailure on NotFoundException', () async {
      fakeDataSource.exception = NotFoundException();
      final result = await repository.getWeatherForecast('Paris');
      expect(result, Left(NotFoundFailure()));
    });

    test('returns NetworkFailure on NetworkException', () async {
      fakeDataSource.exception = NetworkException();
      final result = await repository.getWeatherForecast('Paris');
      expect(result, Left(NetworkFailure()));
    });

    test('returns ServerFailure on ServerException', () async {
      fakeDataSource.exception = ServerException();
      final result = await repository.getWeatherForecast('Paris');
      expect(result, Left(ServerFailure()));
    });

    test('returns UnexpectedFailure on unknown error', () async {
      fakeDataSource.exception = Exception('Unknown');
      final result = await repository.getWeatherForecast('Paris');
      expect(result, Left(UnexpectedFailure()));
    });
  });
}
