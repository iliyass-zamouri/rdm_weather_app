import 'package:flutter/material.dart';
import 'package:rdm_weather_app/features/forecast/domain/entities/forecast.dart';
import 'package:rdm_weather_app/features/forecast/presentation/widgets/forecast_widget.dart';

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
          final isEven = index % 2 == 0;
          final beginOffset = isEven ? const Offset(-1, 0) : const Offset(1, 0);

          return TweenAnimationBuilder<Offset>(
            tween: Tween<Offset>(begin: beginOffset, end: Offset.zero),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutBack,
            builder: (context, offset, child) {
              return Transform.translate(
                offset: Offset(offset.dx * 100, 0),
                child: child,
              );
            },
            child: ForecastWidget(forecast: forecasts[index]),
          );
        },
      ),
    );
  }
}
