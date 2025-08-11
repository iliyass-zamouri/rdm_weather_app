import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rdm_weather_app/core/utils/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rdm_weather_app/core/config/weather_api_config.dart';
import 'package:http/http.dart' as http;

final httpClientProvider = Provider<http.Client>((ref) => http.Client());

final apiKeyProvider = Provider<String>((ref) => dotenv.env[Constants.weatherApiKeyName] ?? '');
final apiConfigProvider = Provider<WeatherApiConfigImpl>((ref) => WeatherApiConfigImpl(apiKey: ref.read(apiKeyProvider)));

Future<void> configureDependencies() async {
  await dotenv.load(fileName: '.env');
}
