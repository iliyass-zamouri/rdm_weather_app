/// Abstracts API configuration and endpoint construction.
abstract class WeatherApiConfig {
  Uri getUri(String endpoint, String city);
}

/// Default implementation for OpenWeatherMap API.
class WeatherApiConfigImpl implements WeatherApiConfig {
  final String baseUrl;
  final String apiKey;

  const WeatherApiConfigImpl({
    this.baseUrl = 'https://api.openweathermap.org/data/2.5',
    this.apiKey = '',
  });

  @override
  Uri getUri(String endpoint, String city) {
    return Uri.parse(
      '$baseUrl$endpoint?q=$city&appid=$apiKey&units=metric',
    );
  }
}
