import 'package:rdm_weather_app/core/config/weather_api_config.dart';
import 'package:rdm_weather_app/core/utils/date_helper.dart';
import 'package:rdm_weather_app/features/weather/data/datasources/base_remote_data_source.dart';
import 'package:rdm_weather_app/features/weather/data/datasources/forecast_remote_data_source.dart';
import 'package:rdm_weather_app/features/weather/data/models/forecast_model.dart';

class ForecastRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ForecastRemoteDataSource {
  final DateHelper dateHelper;

  ForecastRemoteDataSourceImpl({
    required super.client,
    WeatherApiConfig? config,
    DateHelper? dateHelper,
  })  : dateHelper = dateHelper ?? const DateHelper(),
        super(config: config ?? WeatherApiConfigImpl());

  @override
  Future<List<ForecastModel>> getWeatherForecast(String city) {
    final url = config.getUri('/forecast', city);
    return getJson<List<ForecastModel>>(url, (json) => _parseForecast(json));
  }

  List<ForecastModel> _parseForecast(dynamic data) {
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

      final dayName = dateHelper.getWeekday(entry.key);

      forecasts.add(ForecastModel(
        day: dayName,
        minTemp: minTemp,
        maxTemp: maxTemp,
        description: description,
        icon: icon,
      ));
    }
    return forecasts;
  }
}
