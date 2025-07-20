import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rdm_weather_app/features/weather/presentation/widgets/status_bar.dart';
import '../providers/weather_provider.dart';
import 'weather_widget.dart';

class WeatherDisplaySection extends ConsumerWidget {
  const WeatherDisplaySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    return weatherState.maybeWhen(
      initial: () => StatusBar.initial(
        icon: CupertinoIcons.cloud_sun_rain,
        message: "Rechercher une ville.",
      ),
      loaded: (weather) => WeatherWidget(weather: weather),
      orElse: () => const SizedBox.shrink(),
    );
  }
}
