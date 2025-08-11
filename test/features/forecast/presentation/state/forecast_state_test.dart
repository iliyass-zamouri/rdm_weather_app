import 'package:flutter_test/flutter_test.dart';
import 'package:rdm_weather_app/features/forecast/domain/entities/forecast.dart';
import 'package:rdm_weather_app/features/forecast/presentation/state/forecast_state.dart';

void main() {
  group('ForecastState', () {
    final testForecasts = [
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

    group('Initial State', () {
      test('should have correct initial state', () {
        const state = ForecastState.initial();
        
        expect(state, isA<ForecastState>());
        expect(state.when(
          initial: () => true,
          loading: () => false,
          loaded: (forecasts) => false,
          error: (message) => false,
        ), true);
      });
    });

    group('Loading State', () {
      test('should have correct loading state', () {
        const state = ForecastState.loading();
        
        expect(state, isA<ForecastState>());
        expect(state.when(
          initial: () => false,
          loading: () => true,
          loaded: (forecasts) => false,
          error: (message) => false,
        ), true);
      });
    });

    group('Loaded State', () {
      test('should have correct loaded state', () {
        final state = ForecastState.loaded(testForecasts);
        
        expect(state, isA<ForecastState>());
        expect(state.when(
          initial: () => false,
          loading: () => false,
          loaded: (forecasts) => forecasts.length == testForecasts.length,
          error: (message) => false,
        ), true);
      });

      test('should contain correct forecast data', () {
        final state = ForecastState.loaded(testForecasts);
        
        state.when(
          initial: () => fail('Should not be initial state'),
          loading: () => fail('Should not be loading state'),
          loaded: (forecasts) {
            expect(forecasts.length, 2);
            expect(forecasts[0].day, 'Monday');
            expect(forecasts[0].minTemp, 15.0);
            expect(forecasts[1].day, 'Tuesday');
            expect(forecasts[1].maxTemp, 28.0);
          },
          error: (message) => fail('Should not be error state'),
        );
      });
    });

    group('Error State', () {
      test('should have correct error state', () {
        const errorMessage = 'API error occurred';
        final state = ForecastState.error(errorMessage);
        
        expect(state, isA<ForecastState>());
        expect(state.when(
          initial: () => false,
          loading: () => false,
          loaded: (forecasts) => false,
          error: (message) => message == errorMessage,
        ), true);
      });

      test('should contain correct error message', () {
        const errorMessage = 'Network failure';
        final state = ForecastState.error(errorMessage);
        
        state.when(
          initial: () => fail('Should not be initial state'),
          loading: () => fail('Should not be loading state'),
          loaded: (forecasts) => fail('Should not be loaded state'),
          error: (message) => expect(message, errorMessage),
        );
      });
    });

    group('State Equality', () {
      test('should have equal initial states', () {
        const state1 = ForecastState.initial();
        const state2 = ForecastState.initial();
        
        expect(state1, equals(state2));
      });

      test('should have equal loading states', () {
        const state1 = ForecastState.loading();
        const state2 = ForecastState.loading();
        
        expect(state1, equals(state2));
      });

      test('should have equal loaded states with same forecasts', () {
        final state1 = ForecastState.loaded(testForecasts);
        final state2 = ForecastState.loaded(testForecasts);
        
        expect(state1, equals(state2));
      });

      test('should have equal error states with same message', () {
        const errorMessage = 'Error message';
        final state1 = ForecastState.error(errorMessage);
        final state2 = ForecastState.error(errorMessage);
        
        expect(state1, equals(state2));
      });
    });
  });
}
