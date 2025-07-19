import 'package:flutter/material.dart';
import 'package:rdm_weather_app/features/weather/domain/entities/forecast.dart';
import 'package:rdm_weather_app/features/weather/presentation/widgets/forecast_widget.dart';

class ForecastListingWidget extends StatelessWidget {
  final List<Forecast> forecasts;

  const ForecastListingWidget({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white38,
            Colors.white10,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: forecasts.length,
        itemBuilder: (context, index) {
          return ForecastWidget(forecast: forecasts[index]);
        },
      ),
    );
  }
}
