
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rdm_weather_app/core/di/di.dart';
import 'package:rdm_weather_app/features/weather/data/datasources/weather_remote_data_source_impl.dart';

final weatherRemoteDataSourceProvider = Provider<WeatherRemoteDataSourceImpl>((ref) {
  return WeatherRemoteDataSourceImpl(
    client: ref.read(httpClientProvider),
    config: ref.read(apiConfigProvider),
  );
});