import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:rdm_weather_app/core/error/exceptions.dart';
import 'package:rdm_weather_app/core/error/failures.dart';
import 'package:rdm_weather_app/features/forecast/data/datasources/forecast_remote_data_source.dart';
import 'package:rdm_weather_app/features/forecast/data/models/forecast_model.dart';
import 'package:rdm_weather_app/features/forecast/data/repositories/forecast_repository_impl.dart';

class MockForecastRemoteDataSource implements ForecastRemoteDataSource {
  Future<List<ForecastModel>> Function(String)? _getFunction;

  void setGetFunction(Future<List<ForecastModel>> Function(String) function) {
    _getFunction = function;
  }

  @override
  Future<List<ForecastModel>> get(String city) async {
    if (_getFunction != null) {
      return _getFunction!(city);
    }
    throw UnimplementedError();
  }
}

void main() {
  group('ForecastRepositoryImpl', () {
    late ForecastRepositoryImpl repository;
    late MockForecastRemoteDataSource mockRemoteDataSource;

    setUp(() {
      mockRemoteDataSource = MockForecastRemoteDataSource();
      repository = ForecastRepositoryImpl(mockRemoteDataSource);
    });

    group('get', () {
      const tCity = 'Paris';
      final tForecastModels = [
        ForecastModel(
          day: 'Monday',
          minTemp: 15.0,
          maxTemp: 25.0,
          description: 'Partly cloudy',
          icon: '02d',
        ),
        ForecastModel(
          day: 'Tuesday',
          minTemp: 18.0,
          maxTemp: 28.0,
          description: 'Sunny',
          icon: '01d',
        ),
      ];

      test('should return List<Forecast> when remote data source is successful', () async {
        // Arrange
        mockRemoteDataSource.setGetFunction((_) async => tForecastModels);

        // Act
        final result = await repository.get(tCity);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (forecasts) {
            expect(forecasts.length, 2);
            expect(forecasts[0].day, 'Monday');
            expect(forecasts[0].minTemp, 15.0);
            expect(forecasts[1].day, 'Tuesday');
            expect(forecasts[1].maxTemp, 28.0);
          },
        );
      });

      test('should return ServerFailure when remote data source throws ServerException', () async {
        // Arrange
        mockRemoteDataSource.setGetFunction((_) async => throw ServerException('Server error'));

        // Act
        final result = await repository.get(tCity);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (forecasts) => fail('Expected failure but got success: $forecasts'),
        );
      });

      test('should return NetworkFailure when remote data source throws NetworkException', () async {
        // Arrange
        mockRemoteDataSource.setGetFunction((_) async => throw NetworkException());

        // Act
        final result = await repository.get(tCity);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (forecasts) => fail('Expected failure but got success: $forecasts'),
        );
      });

      test('should return NotFoundFailure when remote data source throws NotFoundException', () async {
        // Arrange
        mockRemoteDataSource.setGetFunction((_) async => throw NotFoundException('City not found'));

        // Act
        final result = await repository.get(tCity);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<NotFoundFailure>()),
          (forecasts) => fail('Expected failure but got success: $forecasts'),
        );
      });

      test('should handle different city names correctly', () async {
        // Arrange
        const cityName = 'London';
        final forecastModels = [
          ForecastModel(
            day: 'Monday',
            minTemp: 10.0,
            maxTemp: 20.0,
            description: 'Cloudy',
            icon: '03d',
          ),
        ];
        mockRemoteDataSource.setGetFunction((_) async => forecastModels);

        // Act
        final result = await repository.get(cityName);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (forecasts) {
            expect(forecasts.length, 1);
            expect(forecasts.first.day, 'Monday');
            expect(forecasts.first.minTemp, 10.0);
            expect(forecasts.first.maxTemp, 20.0);
            expect(forecasts.first.description, 'Cloudy');
            expect(forecasts.first.icon, '03d');
          },
        );
      });

      test('should handle negative temperatures correctly', () async {
        // Arrange
        const cityName = 'Moscow';
        final forecastModels = [
          ForecastModel(
            day: 'Monday',
            minTemp: -10.0,
            maxTemp: -5.0,
            description: 'Snow',
            icon: '13d',
          ),
        ];
        mockRemoteDataSource.setGetFunction((_) async => forecastModels);

        // Act
        final result = await repository.get(cityName);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (forecasts) {
            expect(forecasts.length, 1);
            expect(forecasts.first.day, 'Monday');
            expect(forecasts.first.minTemp, -10.0);
            expect(forecasts.first.maxTemp, -5.0);
            expect(forecasts.first.description, 'Snow');
            expect(forecasts.first.icon, '13d');
          },
        );
      });

      test('should handle high temperatures correctly', () async {
        // Arrange
        const cityName = 'Dubai';
        final forecastModels = [
          ForecastModel(
            day: 'Monday',
            minTemp: 35.0,
            maxTemp: 45.0,
            description: 'Very hot',
            icon: '01d',
          ),
        ];
        mockRemoteDataSource.setGetFunction((_) async => forecastModels);

        // Act
        final result = await repository.get(cityName);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (forecasts) {
            expect(forecasts.length, 1);
            expect(forecasts.first.day, 'Monday');
            expect(forecasts.first.minTemp, 35.0);
            expect(forecasts.first.maxTemp, 45.0);
            expect(forecasts.first.description, 'Very hot');
            expect(forecasts.first.icon, '01d');
          },
        );
      });

      test('should handle decimal temperatures correctly', () async {
        // Arrange
        const cityName = 'Tokyo';
        final forecastModels = [
          ForecastModel(
            day: 'Monday',
            minTemp: 22.7,
            maxTemp: 28.3,
            description: 'Partly cloudy',
            icon: '02d',
          ),
        ];
        mockRemoteDataSource.setGetFunction((_) async => forecastModels);

        // Act
        final result = await repository.get(cityName);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (forecasts) {
            expect(forecasts.length, 1);
            expect(forecasts.first.day, 'Monday');
            expect(forecasts.first.minTemp, 22.7);
            expect(forecasts.first.maxTemp, 28.3);
            expect(forecasts.first.description, 'Partly cloudy');
            expect(forecasts.first.icon, '02d');
          },
        );
      });

      test('should handle different weather descriptions correctly', () async {
        // Arrange
        const cityName = 'Seattle';
        final forecastModels = [
          ForecastModel(
            day: 'Monday',
            minTemp: 20.0,
            maxTemp: 30.0,
            description: 'Heavy rain',
            icon: '09d',
          ),
        ];
        mockRemoteDataSource.setGetFunction((_) async => forecastModels);

        // Act
        final result = await repository.get(cityName);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (forecasts) {
            expect(forecasts.length, 1);
            expect(forecasts.first.day, 'Monday');
            expect(forecasts.first.minTemp, 20.0);
            expect(forecasts.first.maxTemp, 30.0);
            expect(forecasts.first.description, 'Heavy rain');
            expect(forecasts.first.icon, '09d');
          },
        );
      });

      test('should handle multiple forecast days correctly', () async {
        // Arrange
        const cityName = 'New York';
        final forecastModels = [
          ForecastModel(
            day: 'Monday',
            minTemp: 15.0,
            maxTemp: 25.0,
            description: 'Partly cloudy',
            icon: '02d',
          ),
          ForecastModel(
            day: 'Tuesday',
            minTemp: 18.0,
            maxTemp: 28.0,
            description: 'Sunny',
            icon: '01d',
          ),
          ForecastModel(
            day: 'Wednesday',
            minTemp: 12.0,
            maxTemp: 22.0,
            description: 'Rain',
            icon: '09d',
          ),
        ];
        mockRemoteDataSource.setGetFunction((_) async => forecastModels);

        // Act
        final result = await repository.get(cityName);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (forecasts) {
            expect(forecasts.length, 3);
            expect(forecasts[0].day, 'Monday');
            expect(forecasts[0].minTemp, 15.0);
            expect(forecasts[1].day, 'Tuesday');
            expect(forecasts[1].maxTemp, 28.0);
            expect(forecasts[2].day, 'Wednesday');
            expect(forecasts[2].description, 'Rain');
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
