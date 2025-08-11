import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:rdm_weather_app/core/error/exceptions.dart';
import 'package:rdm_weather_app/core/error/failures.dart';
import 'package:rdm_weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:rdm_weather_app/features/weather/data/models/weather_model.dart';
import 'package:rdm_weather_app/features/weather/data/repositories/weather_repository_impl.dart';

class MockWeatherRemoteDataSource implements WeatherRemoteDataSource {
  Future<WeatherModel> Function(String)? _getFunction;

  void setGetFunction(Future<WeatherModel> Function(String) function) {
    _getFunction = function;
  }

  @override
  Future<WeatherModel> get(String city) async {
    if (_getFunction != null) {
      return _getFunction!(city);
    }
    throw UnimplementedError();
  }
}

void main() {
  group('WeatherRepositoryImpl', () {
    late WeatherRepositoryImpl repository;
    late MockWeatherRemoteDataSource mockRemoteDataSource;

    setUp(() {
      mockRemoteDataSource = MockWeatherRemoteDataSource();
      repository = WeatherRepositoryImpl(mockRemoteDataSource);
    });

    group('get', () {
      const tCity = 'Paris';
      final tWeatherModel = WeatherModel(
        cityName: 'Paris',
        temperature: 25.0,
        description: 'Clear sky',
        icon: '01d',
      );
      final tWeather = tWeatherModel.toEntity();

      test('should return Weather when remote data source is successful', () async {
        // Arrange
        mockRemoteDataSource.setGetFunction((_) async => tWeatherModel);

        // Act
        final result = await repository.get(tCity);

        // Assert
        expect(result, Right(tWeather));
        expect(result.fold(
          (failure) => failure,
          (weather) => weather,
        ), tWeather);
      });

      test('should return ServerFailure when remote data source throws ServerException', () async {
        // Arrange
        mockRemoteDataSource.setGetFunction((_) async => throw ServerException('Server error'));

        // Act
        final result = await repository.get(tCity);

        // Assert
        expect(result, Left(ServerFailure()));
        expect(result.fold(
          (failure) => failure,
          (weather) => weather,
        ), isA<ServerFailure>());
      });

      test('should return NetworkFailure when remote data source throws NetworkException', () async {
        // Arrange
        mockRemoteDataSource.setGetFunction((_) async => throw NetworkException());

        // Act
        final result = await repository.get(tCity);

        // Assert
        expect(result, Left(NetworkFailure()));
        expect(result.fold(
          (failure) => failure,
          (weather) => weather,
        ), isA<NetworkFailure>());
      });

      test('should return NotFoundFailure when remote data source throws NotFoundException', () async {
        // Arrange
        mockRemoteDataSource.setGetFunction((_) async => throw NotFoundException('City not found'));

        // Act
        final result = await repository.get(tCity);

        // Assert
        expect(result, Left(NotFoundFailure()));
        expect(result.fold(
          (failure) => failure,
          (weather) => weather,
        ), isA<NotFoundFailure>());
      });

      test('should handle different city names correctly', () async {
        // Arrange
        const cityName = 'London';
        final weatherModel = WeatherModel(
          cityName: cityName,
          temperature: 18.0,
          description: 'Cloudy',
          icon: '03d',
        );
        mockRemoteDataSource.setGetFunction((_) async => weatherModel);

        // Act
        final result = await repository.get(cityName);

        // Assert
        expect(result, Right(weatherModel.toEntity()));
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (weather) {
            expect(weather.cityName, cityName);
            expect(weather.temperature, 18.0);
            expect(weather.description, 'Cloudy');
            expect(weather.icon, '03d');
          },
        );
      });

      test('should handle negative temperatures correctly', () async {
        // Arrange
        const cityName = 'Moscow';
        final weatherModel = WeatherModel(
          cityName: cityName,
          temperature: -10.0,
          description: 'Snow',
          icon: '13d',
        );
        mockRemoteDataSource.setGetFunction((_) async => weatherModel);

        // Act
        final result = await repository.get(cityName);

        // Assert
        expect(result, Right(weatherModel.toEntity()));
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (weather) {
            expect(weather.temperature, -10.0);
            expect(weather.temperatureInCelsius, '-10°');
          },
        );
      });

      test('should handle high temperatures correctly', () async {
        // Arrange
        const cityName = 'Dubai';
        final weatherModel = WeatherModel(
          cityName: cityName,
          temperature: 45.0,
          description: 'Very hot',
          icon: '01d',
        );
        mockRemoteDataSource.setGetFunction((_) async => weatherModel);

        // Act
        final result = await repository.get(cityName);

        // Assert
        expect(result, Right(weatherModel.toEntity()));
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (weather) {
            expect(weather.temperature, 45.0);
            expect(weather.temperatureInCelsius, '45°');
          },
        );
      });

      test('should handle decimal temperatures correctly', () async {
        // Arrange
        const cityName = 'Tokyo';
        final weatherModel = WeatherModel(
          cityName: cityName,
          temperature: 22.7,
          description: 'Partly cloudy',
          icon: '02d',
        );
        mockRemoteDataSource.setGetFunction((_) async => weatherModel);

        // Act
        final result = await repository.get(cityName);

        // Assert
        expect(result, Right(weatherModel.toEntity()));
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (weather) {
            expect(weather.temperature, 22.7);
            expect(weather.temperatureInCelsius, '23°'); // Should round to nearest integer
          },
        );
      });

      test('should handle different weather descriptions correctly', () async {
        // Arrange
        const cityName = 'Sydney';
        final weatherModel = WeatherModel(
          cityName: cityName,
          temperature: 30.0,
          description: 'Heavy rain',
          icon: '09d',
        );
        mockRemoteDataSource.setGetFunction((_) async => weatherModel);

        // Act
        final result = await repository.get(cityName);

        // Assert
        expect(result, Right(weatherModel.toEntity()));
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (weather) {
            expect(weather.description, 'Heavy rain');
            expect(weather.icon, '09d');
            expect(weather.iconUrl, 'http://openweathermap.org/img/wn/09d@4x.png');
          },
        );
      });

      test('should throw exception when remote data source throws unexpected exception', () async {
        // Arrange
        mockRemoteDataSource.setGetFunction((_) async => throw Exception('Unexpected error'));

        // Act & Assert
        expect(
          () => repository.get(tCity),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
