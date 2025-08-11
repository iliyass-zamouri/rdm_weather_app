
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rdm_weather_app/features/forecast/data/repositories/forecast_repository_impl.dart';
import 'package:rdm_weather_app/features/forecast/domain/repositories/forecast_repository.dart';
import 'package:rdm_weather_app/features/forecast/data/providers/forecast_remote_datasource_provider.dart';

final forecastRepositoryProvider = Provider<ForecastRepository>((ref) {
  return ForecastRepositoryImpl(ref.read(forecastRemoteDataSourceProvider));
});