import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rdm_weather_app/core/utils/colors.dart';
import 'package:rdm_weather_app/core/utils/constants.dart';
import 'package:rdm_weather_app/features/weather/data/datasources/impl/current_weather_remote_data_source_impl.dart';
import 'package:rdm_weather_app/features/weather/data/datasources/impl/forecast_remote_data_source_impl.dart';
import 'package:rdm_weather_app/features/weather/data/repositories/forecast_repository_impl.dart';
import 'package:rdm_weather_app/features/weather/presentation/pages/weather_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/di/di.dart';
import 'features/weather/data/repositories/weather_repository_impl.dart';
import 'features/weather/domain/usecases/get_weather.dart';
import 'features/weather/domain/usecases/get_forecast.dart';
import 'package:http/http.dart' as http;
import 'package:rdm_weather_app/core/config/weather_api_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  final client = http.Client();
  final apiKey = dotenv.env[Constants.weatherApiKeyName] ?? '';
  final apiConfig = WeatherApiConfigImpl(apiKey: apiKey);

  final weatherRemoteDataSource = WeatherRemoteDataSourceImpl(
    client: client,
    config: apiConfig,
  );
  final forecastRemoteDataSource = ForecastRemoteDataSourceImpl(
    client: client,
    config: apiConfig,
  );

  final weatherRepository =
      WeatherRepositoryImpl(weatherRemoteDataSource);
  final forecastRepository = ForecastRepositoryImpl(forecastRemoteDataSource);

  final getWeather = GetWeather(weatherRepository);
  final getForecast = GetForecast(forecastRepository);

  runApp(ProviderScope(
    overrides: [
      getWeatherProvider.overrideWithValue(getWeather),
      getForecastProvider.overrideWithValue(getForecast),
    ],
    child: const WeatherApp(),
  ));
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RDM Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: AppColors.primarySwatch),
      home: const WeatherPage(),
    );
  }
}
