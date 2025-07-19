import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rdm_weather_app/features/weather/presentation/widgets/weather_search_field.dart';
import '../providers/weather_provider.dart';
import '../providers/forecast_provider.dart';

class WeatherSearchSection extends HookConsumerWidget {
  const WeatherSearchSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cityController = useTextEditingController();
    final weatherState = ref.watch(weatherProvider);
    final forecastState = ref.watch(forecastProvider);
    final isLoading = weatherState.maybeWhen(
          loading: () => true,
          orElse: () => false,
        ) ||
        forecastState.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16, bottom: 16),
      child: WeatherSearchField(
        controller: cityController,
        isLoading: isLoading,
        label: "Rechercher une ville",
        suffix: CupertinoIcons.search,
        clear: cityController.text.isNotEmpty ? CupertinoIcons.clear : null,
        onClear: () {
          cityController.clear();
          ref.read(weatherProvider.notifier).reset();
          ref.read(forecastProvider.notifier).reset();
        },
        onSuffix: () {
          final city = cityController.text.trim();
          if (city.isNotEmpty) {
            ref.read(weatherProvider.notifier).fetchWeather(city);
            ref.read(forecastProvider.notifier).fetchForecast(city);
          }
        },
      ),
    );
  }
}
