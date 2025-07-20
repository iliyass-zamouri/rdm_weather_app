import 'package:flutter/material.dart';
import 'package:rdm_weather_app/features/weather/presentation/widgets/weather_search_section.dart';
import 'package:rdm_weather_app/features/weather/presentation/widgets/weather_status_section.dart';
import 'package:rdm_weather_app/features/weather/presentation/widgets/weather_display_section.dart';
import 'package:rdm_weather_app/features/weather/presentation/widgets/forecast_display_section.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              const WeatherSearchSection(),
              const WeatherStatusSection(),
              const WeatherDisplaySection(),
              Expanded(child: const ForecastDisplaySection()),
            ],
          ),
        ),
      ),
    );
  }
}
