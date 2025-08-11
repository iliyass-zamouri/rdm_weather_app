import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> get(String city);
}
