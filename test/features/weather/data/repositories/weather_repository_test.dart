import 'package:flutter_test/flutter_test.dart';
import 'package:rdm_weather_app/core/error/exceptions.dart';
import 'package:rdm_weather_app/features/weather/data/datasources/forecast_remote_data_source.dart';
import 'package:rdm_weather_app/features/weather/data/models/weather_model.dart';
import 'package:rdm_weather_app/features/weather/data/repositories/forecast_repository_impl.dart';
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
  Future<WeatherModel> getWeather(String cityName) async {
    if (exception != null) throw exception!;
    if (weatherModel != null) return weatherModel!;
    throw UnimplementedError();
  }
}

class FakeForecastRemoteDataSource implements ForecastRemoteDataSource {
  List<ForecastModel>? forecastModels;
  Exception? exception;

  @override
  Future<List<ForecastModel>> getWeatherForecast(String cityName) async {
    if (exception != null) throw exception!;
    if (forecastModels != null) return forecastModels!;
    throw UnimplementedError();
  }
}

void main() {
  late WeatherRepositoryImpl weatherRepository;
  late ForecastRepositoryImpl forecastRepository;
  late FakeWeatherRemoteDataSource fakeWeatherDataSource;
  late FakeForecastRemoteDataSource fakeForecastDataSource;

  setUp(() {
    fakeWeatherDataSource = FakeWeatherRemoteDataSource();
    fakeForecastDataSource = FakeForecastRemoteDataSource();
    weatherRepository = WeatherRepositoryImpl(fakeWeatherDataSource);
    forecastRepository = ForecastRepositoryImpl(fakeForecastDataSource);
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
      fakeWeatherDataSource.weatherModel = tWeatherModel;
      final result = await weatherRepository.getCurrentWeather('Paris');
      expect(result, Right(tWeather));
    });

    test('returns NotFoundFailure on NotFoundException', () async {
      fakeWeatherDataSource.exception = NotFoundException();
      final result = await weatherRepository.getCurrentWeather('Paris');
      expect(result, Left(NotFoundFailure()));
    });

    test('returns NetworkFailure on NetworkException', () async {
      fakeWeatherDataSource.exception = NetworkException();
      final result = await weatherRepository.getCurrentWeather('Paris');
      expect(result, Left(NetworkFailure()));
    });

    test('returns ServerFailure on ServerException', () async {
      fakeWeatherDataSource.exception = ServerException();
      final result = await weatherRepository.getCurrentWeather('Paris');
      expect(result, Left(ServerFailure()));
    });

    test('returns UnexpectedFailure on unknown error', () async {
      fakeWeatherDataSource.exception = Exception('Unknown');
      final result = await weatherRepository.getCurrentWeather('Paris');
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
      fakeForecastDataSource.forecastModels = tForecastModels;
      final result = await forecastRepository.getWeatherForecast('Paris');
      expect(result.getOrElse(() => []), tForecasts);
    });

    test('returns NotFoundFailure on NotFoundException', () async {
      fakeForecastDataSource.exception = NotFoundException();
      final result = await forecastRepository.getWeatherForecast('Paris');
      expect(result, Left(NotFoundFailure()));
    });

    test('returns NetworkFailure on NetworkException', () async {
      fakeForecastDataSource.exception = NetworkException();
      final result = await forecastRepository.getWeatherForecast('Paris');
      expect(result, Left(NetworkFailure()));
    });

    test('returns ServerFailure on ServerException', () async {
      fakeForecastDataSource.exception = ServerException();
      final result = await forecastRepository.getWeatherForecast('Paris');
      expect(result, Left(ServerFailure()));
    });

    test('returns UnexpectedFailure on unknown error', () async {
      fakeForecastDataSource.exception = Exception('Unknown');
      final result = await forecastRepository.getWeatherForecast('Paris');
      expect(result, Left(UnexpectedFailure()));
    });
  });
}
