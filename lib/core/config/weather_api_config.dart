class WeatherApiConfig {
  final String baseUrl;
  final String currentWeatherEndpoint;
  final String forecastEndpoint;

  const WeatherApiConfig({
    this.baseUrl = 'https://api.openweathermap.org/data/2.5',
    this.currentWeatherEndpoint = '/weather',
    this.forecastEndpoint = '/forecast',
  });

  Uri currentWeatherUri(String city, String apiKey) {
    return Uri.parse(
        '$baseUrl$currentWeatherEndpoint?q=$city&appid=$apiKey&units=metric');
  }

  Uri forecastUri(String city, String apiKey) {
    return Uri.parse(
        '$baseUrl$forecastEndpoint?q=$city&appid=$apiKey&units=metric');
  }
}
