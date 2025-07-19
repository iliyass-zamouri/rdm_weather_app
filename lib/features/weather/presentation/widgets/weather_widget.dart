import 'package:flutter/material.dart';
import 'package:rdm_weather_app/features/weather/domain/entities/weather.dart';

class WeatherWidget extends StatelessWidget {
  final Weather weather;
  const WeatherWidget({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            weather.cityName,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
          ),
          Text(
            weather.description,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.white54),
          ),
          Image.network(
            weather.iconUrl,
            fit: BoxFit.cover,
            width: 50,
            height: 50,
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Text(
              weather.temperatureInCelsius,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 78,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
