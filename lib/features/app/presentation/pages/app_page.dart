import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rdm_weather_app/features/app/presentation/sections/search_section.dart';
import 'package:rdm_weather_app/features/app/presentation/sections/status_section.dart';
import 'package:rdm_weather_app/features/forecast/presentation/widgets/forecast_display_section.dart';
import 'package:rdm_weather_app/features/weather/presentation/providers/weather_provider.dart';
import 'package:rdm_weather_app/features/forecast/presentation/providers/forecast_provider.dart';
import 'package:rdm_weather_app/features/weather/presentation/widgets/weather_display_section.dart';

class AppPage extends ConsumerStatefulWidget {
  const AppPage({super.key});

  @override
  ConsumerState<AppPage> createState() => _AppPageState();
}

class _AppPageState extends ConsumerState<AppPage> {
  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherProvider);
    final forecastState = ref.watch(forecastProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.1, 0.3, 0.6, 0.8],
              colors: [
                Color(0xFF08306C),
                Color(0xFF0D47A1),
                Color(0xFF0D47A1),
                Color(0xFF1976D2),
                Color(0xFF64B5F6),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Search Section
                SearchSection(
                  label: "Rechercher une ville",
                  isLoading: weatherState.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  ) ||
                  forecastState.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  ),
                  onSearch: (city) {
                    ref.read(weatherProvider.notifier).fetchWeather(city);
                    ref.read(forecastProvider.notifier).fetchForecast(city);
                  },
                  onClear: () {
                    ref.read(weatherProvider.notifier).reset();
                    ref.read(forecastProvider.notifier).reset();
                  },
                ),
                
                // Status Section
                StatusSection(
                  error: weatherState.maybeWhen(
                    error: (msg) => msg,
                    orElse: () => null,
                  ) ??
                  forecastState.maybeWhen(
                    error: (msg) => msg,
                    orElse: () => null,
                  ),
                  isLoading: weatherState.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  ) ||
                  forecastState.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  ),
                ),
                
                // Weather Display Section
                const WeatherDisplaySection(),
                
                // Forecast Display Section
                const Expanded(
                  child: ForecastDisplaySection(),
                ),
                
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}
