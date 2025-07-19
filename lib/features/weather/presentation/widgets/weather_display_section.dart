import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/weather_provider.dart';
import 'weather_widget.dart';

class WeatherDisplaySection extends ConsumerWidget {
  const WeatherDisplaySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    return weatherState.maybeWhen(
      initial: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(
                CupertinoIcons.cloud_sun_rain,
                size: 64,
                color: Colors.white,
              ),
              SizedBox(height: 8),
              Text(
                "Rechercher une ville.",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      loaded: (weather) => WeatherWidget(weather: weather),
      orElse: () => const SizedBox.shrink(),
    );
  }
}
