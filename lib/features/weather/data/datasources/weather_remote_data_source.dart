import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:rdm_weather_app/core/config/weather_api_config.dart';
import 'package:rdm_weather_app/features/weather/data/models/forecast_model.dart';
import '../../../../core/error/exceptions.dart';
import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather(String city);
  Future<List<ForecastModel>> getWeatherForecast(String city);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;
  final String apiKey;
  final WeatherApiConfig weatherApiConfig = WeatherApiConfig();

  WeatherRemoteDataSourceImpl({required this.client, required this.apiKey});

  @override
  Future<WeatherModel> getCurrentWeather(String city) async {
    final url = weatherApiConfig.currentWeatherUri(city, apiKey);

    try {
      final response = await client.get(url);

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return WeatherModel.fromApi(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw NotFoundException();
      } else {
        throw ServerException();
      }
    } on SocketException {
      throw NetworkException();
    } catch (trace, e) {
      log('Error fetching weather data: $trace, $e');
      rethrow;
    }
  }

  @override
  Future<List<ForecastModel>> getWeatherForecast(String city) async {
    final url = weatherApiConfig.forecastUri(city, apiKey);

    try {
      final response = await client.get(url);

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List list = data['list'];
        final Map<String, List<dynamic>> groupedByDate = {};

        for (var item in list) {
          final date = item['dt_txt'].split(' ')[0];
          groupedByDate.putIfAbsent(date, () => []).add(item);
        }

        final forecasts = <ForecastModel>[];
        for (var entry in groupedByDate.entries) {
          final items = entry.value;
          double minTemp = double.infinity;
          double maxTemp = double.negativeInfinity;
          String description = '';
          String icon = '';

          for (var i in items) {
            final temp = i['main']['temp'].toDouble();
            if (temp < minTemp) minTemp = temp;
            if (temp > maxTemp) maxTemp = temp;
            description = i['weather'][0]['description'];
            icon = i['weather'][0]['icon'];
          }

          final dayName = _getWeekday(entry.key);

          forecasts.add(ForecastModel(
            day: dayName,
            minTemp: minTemp,
            maxTemp: maxTemp,
            description: description,
            icon: icon,
          ));
        }

        return forecasts;
      } else if (response.statusCode == 404) {
        throw NotFoundException();
      } else {
        throw ServerException();
      }
    } on SocketException {
      throw NetworkException();
    } catch (e, stacktrace) {
      log('Error fetching forecast: $e', stackTrace: stacktrace);
      rethrow;
    }
  }

  String _getWeekday(String date) {
    final dt = DateTime.parse(date);
    return [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche'
    ][dt.weekday - 1];
  }
}
