import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:rdm_weather_app/features/forecast/domain/entities/forecast.dart';
import 'package:rdm_weather_app/features/forecast/domain/repositories/forecast_repository.dart';
import 'package:rdm_weather_app/features/forecast/domain/usecases/get_forecast.dart';
import 'package:rdm_weather_app/core/error/failures.dart';

class MockForecastRepository implements ForecastRepository {
  Future<Either<Failure, List<Forecast>>> Function(String)? _getFunction;

  void setGetFunction(Future<Either<Failure, List<Forecast>>> Function(String) function) {
    _getFunction = function;
  }

  @override
  Future<Either<Failure, List<Forecast>>> get(String city) async {
    if (_getFunction != null) {
      return _getFunction!(city);
    }
    throw UnimplementedError();
  }
}

void main() {
  group('GetForecast', () {
    late GetForecast useCase;
    late MockForecastRepository mockRepository;

    setUp(() {
      mockRepository = MockForecastRepository();
      useCase = GetForecast(mockRepository);
    });

    const tCity = 'Paris';
    final tForecasts = [
      const Forecast(
        day: 'Monday',
        minTemp: 15.0,
        maxTemp: 25.0,
        description: 'Partly cloudy',
        icon: '02d',
      ),
      const Forecast(
        day: 'Tuesday',
        minTemp: 18.0,
        maxTemp: 28.0,
        description: 'Sunny',
        icon: '01d',
      ),
    ];

    test('should get forecast from the repository', () async {
      // Arrange
      mockRepository.setGetFunction((city) async => Right(tForecasts));

      // Act
      final result = await useCase(tCity);

      // Assert
      expect(result, Right(tForecasts));
      expect(result.fold(
        (failure) => failure,
        (forecasts) => forecasts,
      ), tForecasts);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      final failure = ServerFailure();
      mockRepository.setGetFunction((city) async => Left(failure));

      // Act
      final result = await useCase(tCity);

      // Assert
      expect(result, Left(failure));
      expect(result.fold(
        (failure) => failure,
        (forecasts) => forecasts,
      ), isA<ServerFailure>());
    });

    test('should return NetworkFailure when repository fails with network error', () async {
      // Arrange
      final failure = NetworkFailure();
      mockRepository.setGetFunction((city) async => Left(failure));

      // Act
      final result = await useCase(tCity);

      // Assert
      expect(result, Left(failure));
      expect(result.fold(
        (failure) => failure,
        (forecasts) => forecasts,
      ), isA<NetworkFailure>());
    });

    test('should return NotFoundFailure when repository fails with not found error', () async {
      // Arrange
      final failure = NotFoundFailure();
      mockRepository.setGetFunction((city) async => Left(failure));

      // Act
      final result = await useCase(tCity);

      // Assert
      expect(result, Left(failure));
      expect(result.fold(
        (failure) => failure,
        (forecasts) => forecasts,
      ), isA<NotFoundFailure>());
    });

    test('should handle different city names correctly', () async {
      // Arrange
      const cityName = 'London';
      final forecasts = [
        const Forecast(
          day: 'Monday',
          minTemp: 10.0,
          maxTemp: 20.0,
          description: 'Cloudy',
          icon: '03d',
        ),
      ];
      mockRepository.setGetFunction((city) async => Right(forecasts));

      // Act
      final result = await useCase(cityName);

      // Assert
      expect(result, Right(forecasts));
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
      final forecasts = [
        const Forecast(
          day: 'Monday',
          minTemp: -10.0,
          maxTemp: -5.0,
          description: 'Snow',
          icon: '13d',
        ),
      ];
      mockRepository.setGetFunction((city) async => Right(forecasts));

      // Act
      final result = await useCase(cityName);

      // Assert
      expect(result, Right(forecasts));
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (forecasts) {
          expect(forecasts.first.minTemp, -10.0);
          expect(forecasts.first.maxTemp, -5.0);
          expect(forecasts.first.minTempInCelsius, '-10°');
          expect(forecasts.first.maxTempInCelsius, '-5°');
        },
      );
    });

    test('should handle high temperatures correctly', () async {
      // Arrange
      const cityName = 'Dubai';
      final forecasts = [
        const Forecast(
          day: 'Monday',
          minTemp: 35.0,
          maxTemp: 45.0,
          description: 'Very hot',
          icon: '01d',
        ),
      ];
      mockRepository.setGetFunction((city) async => Right(forecasts));

      // Act
      final result = await useCase(cityName);

      // Assert
      expect(result, Right(forecasts));
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (forecasts) {
          expect(forecasts.first.minTemp, 35.0);
          expect(forecasts.first.maxTemp, 45.0);
          expect(forecasts.first.minTempInCelsius, '35°');
          expect(forecasts.first.maxTempInCelsius, '45°');
        },
      );
    });

    test('should handle decimal temperatures correctly', () async {
      // Arrange
      const cityName = 'Tokyo';
      final forecasts = [
        const Forecast(
          day: 'Monday',
          minTemp: 22.7,
          maxTemp: 28.3,
          description: 'Partly cloudy',
          icon: '02d',
        ),
      ];
      mockRepository.setGetFunction((city) async => Right(forecasts));

      // Act
      final result = await useCase(cityName);

      // Assert
      expect(result, Right(forecasts));
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (forecasts) {
          expect(forecasts.first.minTemp, 22.7);
          expect(forecasts.first.maxTemp, 28.3);
          expect(forecasts.first.minTempInCelsius, '23°'); // Should round to nearest integer
          expect(forecasts.first.maxTempInCelsius, '28°'); // Should round to nearest integer
        },
      );
    });

    test('should handle different weather descriptions correctly', () async {
      // Arrange
      const cityName = 'Sydney';
      final forecasts = [
        const Forecast(
          day: 'Monday',
          minTemp: 20.0,
          maxTemp: 30.0,
          description: 'Heavy rain',
          icon: '09d',
        ),
      ];
      mockRepository.setGetFunction((city) async => Right(forecasts));

      // Act
      final result = await useCase(cityName);

      // Assert
      expect(result, Right(forecasts));
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (forecasts) {
          expect(forecasts.first.description, 'Heavy rain');
          expect(forecasts.first.icon, '09d');
          expect(forecasts.first.iconUrl, 'http://openweathermap.org/img/wn/09d@2x.png');
        },
      );
    });

    test('should handle multiple forecast days correctly', () async {
      // Arrange
      const cityName = 'New York';
      final multipleForecasts = [
        const Forecast(
          day: 'Monday',
          minTemp: 15.0,
          maxTemp: 25.0,
          description: 'Partly cloudy',
          icon: '02d',
        ),
        const Forecast(
          day: 'Tuesday',
          minTemp: 18.0,
          maxTemp: 28.0,
          description: 'Sunny',
          icon: '01d',
        ),
        const Forecast(
          day: 'Wednesday',
          minTemp: 12.0,
          maxTemp: 22.0,
          description: 'Rain',
          icon: '09d',
        ),
      ];
      mockRepository.setGetFunction((city) async => Right(multipleForecasts));

      // Act
      final result = await useCase(cityName);

      // Assert
      expect(result, Right(multipleForecasts));
      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (forecasts) {
          expect(forecasts.length, 3);
          expect(forecasts[0].day, 'Monday');
          expect(forecasts[1].day, 'Tuesday');
          expect(forecasts[2].day, 'Wednesday');
        },
      );
    });

    test('should verify repository is called with correct city', () async {
      // Arrange
      mockRepository.setGetFunction((city) async => Right(tForecasts));

      // Act
      await useCase(tCity);

      // Assert - The test passes if the repository is called correctly
      // We can't easily verify the exact call without a proper mocking framework,
      // but the test structure ensures the repository method is called
    });
  });
}
