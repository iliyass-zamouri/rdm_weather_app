import '../models/forecast_model.dart';

abstract class ForecastRemoteDataSource {
  Future<List<ForecastModel>> getWeatherForecast(String city);
}
