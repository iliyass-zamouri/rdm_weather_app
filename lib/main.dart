import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rdm_weather_app/core/utils/colors.dart';
import 'package:rdm_weather_app/core/utils/constants.dart';
import 'package:rdm_weather_app/features/weather/domain/usecases/get_forecast.dart';
import 'package:rdm_weather_app/features/weather/presentation/providers/forecast_provider.dart';
import 'features/weather/data/datasources/weather_remote_data_source.dart';
import 'features/weather/data/repositories/weather_repository_impl.dart';
import 'features/weather/domain/usecases/get_weather.dart';
import 'features/weather/presentation/pages/weather_page.dart';
import 'features/weather/presentation/providers/weather_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  final client = http.Client();
  final apiKey = dotenv.env[Constants.weatherApiKeyName] ?? '';

  final remoteDataSource = WeatherRemoteDataSourceImpl(
    client: client,
    apiKey: apiKey,
  );
  final repository = WeatherRepositoryImpl(remoteDataSource);

  final getWeather = GetWeather(repository);
  final getForecast = GetForecast(repository);

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
