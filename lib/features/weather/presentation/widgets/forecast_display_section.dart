import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/forecast_provider.dart';
import 'forecast_listing_widget.dart';

class ForecastDisplaySection extends ConsumerWidget {
  const ForecastDisplaySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastState = ref.watch(forecastProvider);
    return forecastState.maybeWhen(
      loaded: (forecasts) => ForecastListingWidget(forecasts: forecasts),
      orElse: () => const SizedBox.shrink(),
    );
  }
}
