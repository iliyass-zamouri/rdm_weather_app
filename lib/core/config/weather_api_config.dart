import 'package:rdm_weather_app/core/config/weather_api_config_interface.dart';

class WeatherApiConfigImpl implements WeatherApiConfig {
  final String baseUrl;
  final String apiKey;

  const WeatherApiConfigImpl({
    this.baseUrl = 'https://api.openweathermap.org/data/2.5',
    this.apiKey = '',
  });

  @override
  Uri getUri(String endpoint, String city) {
    return Uri.parse('$baseUrl$endpoint').replace(
      queryParameters: {
        'q': city,
        'appid': apiKey,
        'units': 'metric',
      },
    );
  }
}
