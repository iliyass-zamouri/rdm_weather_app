import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/weather_provider.dart';
import '../providers/forecast_provider.dart';
import 'status_bar.dart';

class WeatherStatusSection extends ConsumerWidget {
  const WeatherStatusSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    final errorMessage = weatherState.maybeWhen(
          error: (msg) => msg,
          orElse: () => null,
        ) ??
        forecastState.maybeWhen(
          error: (msg) => msg,
          orElse: () => null,
        );

    if (isLoading) {
      return StatusBar.loading();
    }

    if (errorMessage != null) {
      return StatusBar.error(
        icon: CupertinoIcons.exclamationmark_triangle,
        message: errorMessage,
      );
    }

    return const SizedBox.shrink();
  }
}
