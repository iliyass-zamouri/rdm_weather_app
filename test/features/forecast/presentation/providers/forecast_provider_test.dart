import 'package:flutter_test/flutter_test.dart';
import 'package:rdm_weather_app/features/forecast/domain/entities/forecast.dart';
import 'package:rdm_weather_app/features/forecast/presentation/state/forecast_state.dart';
import '../../fakes/fake_forecast_notifiers.dart';

void main() {
  group('ForecastNotifier', () {
    test('should have initial state', () {
      final notifier = FakeInitialForecastNotifier();
      expect(notifier.state, const ForecastState.initial());
    });

    test('should have loading state', () {
      final notifier = FakeLoadingForecastNotifier();
      expect(notifier.state, const ForecastState.loading());
    });

    test('should have loaded state with forecast data', () {
      final notifier = FakeLoadedForecastNotifier();
      expect(notifier.state, isA<ForecastState>());
      
      final state = notifier.state;
      expect(state.maybeWhen(
        loaded: (forecasts) => forecasts.isNotEmpty,
        orElse: () => false,
      ), isTrue);
    });

    test('should have error state with message', () {
      final notifier = FakeErrorForecastNotifier();
      expect(notifier.state, isA<ForecastState>());
      
      final state = notifier.state;
      expect(state.maybeWhen(
        error: (message) => message == 'API down',
        orElse: () => false,
      ), isTrue);
    });

    group('state transitions', () {
      test('should transition from initial to loading to loaded', () async {
        final notifier = FakeInitialForecastNotifier();
        
        // Initial state
        expect(notifier.state, const ForecastState.initial());
        
        // Simulate fetching forecast
        await notifier.fetchForecast('Paris');
        
        // Should end up in loaded state
        final state = notifier.state;
        expect(state.maybeWhen(
          loaded: (forecasts) => forecasts.isNotEmpty,
          orElse: () => false,
        ), isTrue);
      });

      test('should reset to initial state', () {
        final notifier = FakeLoadedForecastNotifier();
        
        // Should start in loaded state
        expect(notifier.state, isA<ForecastState>());
        
        // Reset
        notifier.reset();
        
        // Should be back to initial state
        expect(notifier.state, const ForecastState.initial());
      });
    });

    group('forecast data validation', () {
      test('should have valid forecast data in loaded state', () {
        final notifier = FakeLoadedForecastNotifier();
        final state = notifier.state;
        
        state.maybeWhen(
          loaded: (forecasts) {
            expect(forecasts.isNotEmpty, true);
            final forecast = forecasts.first;
            expect(forecast.day, isA<String>());
            expect(forecast.minTemp, isA<double>());
            expect(forecast.maxTemp, isA<double>());
            expect(forecast.description, isA<String>());
            expect(forecast.icon, isA<String>());
          },
          orElse: () => fail('Expected loaded state'),
        );
      });

      test('should format temperature correctly', () {
        const forecast = Forecast(
          day: 'Test',
          minTemp: 18.7,
          maxTemp: 25.3,
          description: 'Test',
          icon: '01d',
        );
        
        expect(forecast.minTempInCelsius, '19°');
        expect(forecast.maxTempInCelsius, '25°');
      });

      test('should format negative temperature correctly', () {
        const forecast = Forecast(
          day: 'Test',
          minTemp: -5.0,
          maxTemp: 2.0,
          description: 'Test',
          icon: '01d',
        );
        
        expect(forecast.minTempInCelsius, '-5°');
        expect(forecast.maxTempInCelsius, '2°');
      });

      test('should generate correct icon URL', () {
        const forecast = Forecast(
          day: 'Test',
          minTemp: 20.0,
          maxTemp: 30.0,
          description: 'Test',
          icon: '02n',
        );
        
        expect(forecast.iconUrl, 'http://openweathermap.org/img/wn/02n@2x.png');
      });
    });
  });
}
