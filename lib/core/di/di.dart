import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rdm_weather_app/features/forecast/data/datasources/forecast_remote_data_source_impl.dart';
import 'package:rdm_weather_app/features/forecast/data/repositories/forecast_repository_impl.dart';
import 'package:rdm_weather_app/features/forecast/domain/repositories/forecast_repository.dart';
import 'package:rdm_weather_app/features/weather/data/datasources/weather_remote_data_source_impl.dart';
import 'package:rdm_weather_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:rdm_weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:rdm_weather_app/core/utils/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rdm_weather_app/core/config/weather_api_config.dart';

final httpClientProvider = Provider<http.Client>((ref) => http.Client());

final apiKeyProvider = Provider<String>((ref) => dotenv.env[Constants.weatherApiKeyName] ?? '');
final apiConfigProvider = Provider<WeatherApiConfigImpl>((ref) => WeatherApiConfigImpl(apiKey: ref.read(apiKeyProvider)));

final weatherRemoteDataSourceProvider = Provider<WeatherRemoteDataSourceImpl>((ref) {
  return WeatherRemoteDataSourceImpl(
    client: ref.read(httpClientProvider),
    config: ref.read(apiConfigProvider),
  );
});

final forecastRemoteDataSourceProvider = Provider<ForecastRemoteDataSourceImpl>((ref) {
  return ForecastRemoteDataSourceImpl(
    client: ref.read(httpClientProvider),
    config: ref.read(apiConfigProvider),
  );
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepositoryImpl(ref.read(weatherRemoteDataSourceProvider));
});

final forecastRepositoryProvider = Provider<ForecastRepository>((ref) {
  return ForecastRepositoryImpl(ref.read(forecastRemoteDataSourceProvider));
});


Future<void> configureDependencies() async {
  await dotenv.load(fileName: '.env');
}
