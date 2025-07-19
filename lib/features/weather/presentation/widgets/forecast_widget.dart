import 'package:flutter/material.dart';
import 'package:rdm_weather_app/features/weather/domain/entities/forecast.dart';

class ForecastWidget extends StatelessWidget {
  final Forecast forecast;
  const ForecastWidget({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(forecast.day,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(
                    forecast.description,
                    style: const TextStyle(color: Colors.white60),
                  ),
                ],
              ),
              Spacer(),
              Text(
                "${forecast.minTempInCelsius} / ${forecast.maxTempInCelsius}",
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Image.network(
                  forecast.iconUrl,
                  width: 50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
