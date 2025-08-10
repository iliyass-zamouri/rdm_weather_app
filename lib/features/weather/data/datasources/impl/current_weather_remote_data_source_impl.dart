import 'package:rdm_weather_app/core/config/weather_api_config.dart';
import 'package:rdm_weather_app/features/weather/data/datasources/base_remote_data_source.dart';
import 'package:rdm_weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:rdm_weather_app/features/weather/data/models/weather_model.dart';

class WeatherRemoteDataSourceImpl extends BaseRemoteDataSource
    implements WeatherRemoteDataSource {
  WeatherRemoteDataSourceImpl({
    required super.client,
    WeatherApiConfig? config,
  }) : super(config: config ?? WeatherApiConfigImpl());

  @override
  Future<WeatherModel> getWeather(String city) {
    final url = config.getUri('/weather', city);
    return getJson<WeatherModel>(url, (json) => WeatherModel.fromApi(json));
  }
}
