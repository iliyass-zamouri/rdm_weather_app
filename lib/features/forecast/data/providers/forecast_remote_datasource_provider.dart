
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rdm_weather_app/core/di/di.dart';
import 'package:rdm_weather_app/features/forecast/data/datasources/forecast_remote_data_source_impl.dart';

final forecastRemoteDataSourceProvider = Provider<ForecastRemoteDataSourceImpl>((ref) {
  return ForecastRemoteDataSourceImpl(
    client: ref.read(httpClientProvider),
    config: ref.read(apiConfigProvider),
  );
});