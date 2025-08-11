
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rdm_weather_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:rdm_weather_app/features/weather/domain/repositories/weather_repository.dart';
import 'package:rdm_weather_app/features/weather/data/providers/weather_remote_datasource_provider.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepositoryImpl(ref.read(weatherRemoteDataSourceProvider));
});