import 'package:flutter_test/flutter_test.dart';
import 'package:rdm_weather_app/features/weather/domain/entities/weather.dart';
import 'package:rdm_weather_app/features/weather/presentation/state/weather_state.dart';
import '../../fakes/fake_weather_notifiers.dart';

void main() {
  group('WeatherNotifier', () {
    test('should have initial state', () {
      final notifier = FakeInitialWeatherNotifier();
      expect(notifier.state, const WeatherState.initial());
    });

    test('should have loading state', () {
      final notifier = FakeLoadingWeatherNotifier();
      expect(notifier.state, const WeatherState.loading());
    });

    test('should have loaded state with weather data', () {
      final notifier = FakeLoadedWeatherNotifier();
      expect(notifier.state, isA<WeatherState>());
      
      final state = notifier.state;
      expect(state.maybeWhen(
        loaded: (weather) => weather.cityName == 'Test City',
        orElse: () => false,
      ), isTrue);
    });

    test('should have error state with message', () {
      final notifier = FakeErrorWeatherNotifier();
      expect(notifier.state, isA<WeatherState>());
      
      final state = notifier.state;
      expect(state.maybeWhen(
        error: (message) => message == 'API down',
        orElse: () => false,
      ), isTrue);
    });

    group('state transitions', () {
      test('should transition from initial to loading to loaded', () async {
        final notifier = FakeInitialWeatherNotifier();
        
        // Initial state
        expect(notifier.state, const WeatherState.initial());
        
        // Simulate fetching weather
        await notifier.fetchWeather('Paris');
        
        // Should end up in loaded state
        final state = notifier.state;
        expect(state.maybeWhen(
          loaded: (weather) => weather.cityName == 'Paris',
          orElse: () => false,
        ), isTrue);
      });

      test('should reset to initial state', () {
        final notifier = FakeLoadedWeatherNotifier();
        
        // Should start in loaded state
        expect(notifier.state, isA<WeatherState>());
        
        // Reset
        notifier.reset();
        
        // Should be back to initial state
        expect(notifier.state, const WeatherState.initial());
      });
    });

    group('weather data validation', () {
      test('should have valid weather data in loaded state', () {
        final notifier = FakeLoadedWeatherNotifier();
        final state = notifier.state;
        
        state.maybeWhen(
          loaded: (weather) {
            expect(weather.cityName, 'Test City');
            expect(weather.temperature, 25.0);
            expect(weather.description, 'Clear sky');
            expect(weather.icon, '01d');
            expect(weather.temperatureInCelsius, '25°');
            expect(weather.iconUrl, 'http://openweathermap.org/img/wn/01d@4x.png');
          },
          orElse: () => fail('Expected loaded state'),
        );
      });

      test('should format temperature correctly', () {
        const weather = Weather(
          cityName: 'Test',
          temperature: 18.7,
          description: 'Test',
          icon: '01d',
        );
        
        expect(weather.temperatureInCelsius, '19°');
      });

      test('should format negative temperature correctly', () {
        const weather = Weather(
          cityName: 'Test',
          temperature: -5.0,
          description: 'Test',
          icon: '01d',
        );
        
        expect(weather.temperatureInCelsius, '-5°');
      });

      test('should generate correct icon URL', () {
        const weather = Weather(
          cityName: 'Test',
          temperature: 20.0,
          description: 'Test',
          icon: '02d',
        );
        
        expect(weather.iconUrl, 'http://openweathermap.org/img/wn/02d@4x.png');
      });
    });
  });
}
