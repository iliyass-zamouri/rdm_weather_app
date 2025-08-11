import 'package:flutter_test/flutter_test.dart';
import 'package:rdm_weather_app/features/weather/domain/entities/weather.dart';
import 'package:rdm_weather_app/features/weather/presentation/state/weather_state.dart';

void main() {
  group('WeatherState', () {
    const testWeather = Weather(
      cityName: 'Paris',
      temperature: 25.0,
      description: 'Sunny',
      icon: '01d',
    );

    group('Initial State', () {
      test('should have correct initial state', () {
        const state = WeatherState.initial();
        
        expect(state, isA<WeatherState>());
        expect(state.when(
          initial: () => true,
          loading: () => false,
          loaded: (weather) => false,
          error: (message) => false,
        ), true);
      });

      test('should have correct initial state properties', () {
        const state = WeatherState.initial();
        
        expect(state, isA<WeatherState>());
      });
    });

    group('Loading State', () {
      test('should have correct loading state', () {
        const state = WeatherState.loading();
        
        expect(state, isA<WeatherState>());
        expect(state.when(
          initial: () => false,
          loading: () => true,
          loaded: (weather) => false,
          error: (message) => false,
        ), true);
      });
    });

    group('Loaded State', () {
      test('should have correct loaded state', () {
        final state = WeatherState.loaded(testWeather);
        
        expect(state, isA<WeatherState>());
        expect(state.when(
          initial: () => false,
          loading: () => false,
          loaded: (weather) => weather == testWeather,
          error: (message) => false,
        ), true);
      });

      test('should contain correct weather data', () {
        final state = WeatherState.loaded(testWeather);
        
        state.when(
          initial: () => fail('Should not be initial state'),
          loading: () => fail('Should not be loading state'),
          loaded: (weather) {
            expect(weather.cityName, 'Paris');
            expect(weather.temperature, 25.0);
            expect(weather.description, 'Sunny');
            expect(weather.icon, '01d');
          },
          error: (message) => fail('Should not be error state'),
        );
      });
    });

    group('Error State', () {
      test('should have correct error state', () {
        const errorMessage = 'API error occurred';
        final state = WeatherState.error(errorMessage);
        
        expect(state, isA<WeatherState>());
        expect(state.when(
          initial: () => false,
          loading: () => false,
          loaded: (weather) => false,
          error: (message) => message == errorMessage,
        ), true);
      });

      test('should contain correct error message', () {
        const errorMessage = 'Network failure';
        final state = WeatherState.error(errorMessage);
        
        state.when(
          initial: () => fail('Should not be initial state'),
          loading: () => fail('Should not be loading state'),
          loaded: (weather) => fail('Should not be loaded state'),
          error: (message) => expect(message, errorMessage),
        );
      });
    });

    group('State Equality', () {
      test('should have equal initial states', () {
        const state1 = WeatherState.initial();
        const state2 = WeatherState.initial();
        
        expect(state1, equals(state2));
      });

      test('should have equal loading states', () {
        const state1 = WeatherState.loading();
        const state2 = WeatherState.loading();
        
        expect(state1, equals(state2));
      });

      test('should have equal loaded states with same weather', () {
        final state1 = WeatherState.loaded(testWeather);
        final state2 = WeatherState.loaded(testWeather);
        
        expect(state1, equals(state2));
      });

      test('should have equal error states with same message', () {
        const errorMessage = 'Error message';
        final state1 = WeatherState.error(errorMessage);
        final state2 = WeatherState.error(errorMessage);
        
        expect(state1, equals(state2));
      });
    });
  });
}
