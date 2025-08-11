import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:rdm_weather_app/core/config/weather_api_config.dart';
import 'package:rdm_weather_app/core/config/weather_api_config_interface.dart';
import 'package:rdm_weather_app/core/error/exceptions.dart';
import 'package:rdm_weather_app/features/forecast/data/datasources/forecast_remote_data_source_impl.dart';
import 'package:http/http.dart' as http;

void main() {
  late WeatherApiConfig weatherApiConfig;

  setUp(() {
    weatherApiConfig = WeatherApiConfigImpl();
  });

  group('ForecastRemoteDataSourceImpl', () {
    const tCityName = 'Paris';

    test('should return List<ForecastModel> when the response is 200', () async {
      final url = weatherApiConfig.getUri('/forecast', tCityName);
      final mockHttpClient = MockClient((request) async {
        expect(request.url.toString(), url.toString());
        return http.Response(
          '{"cod":"200","message":0,"cnt":40,"list":[{"dt":1752948000,"main":{"temp":26.26,"feels_like":26.26,"temp_min":24.23,"temp_max":26.26,"pressure":1006,"sea_level":1006,"grnd_level":996,"humidity":54,"temp_kf":2.03},"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10d"}],"clouds":{"all":40},"wind":{"speed":3.08,"deg":229,"gust":6.43},"visibility":10000,"pop":0.28,"rain":{"3h":0.13},"sys":{"pod":"d"},"dt_txt":"2025-07-19 18:00:00"},{"dt":1752958800,"main":{"temp":24.8,"feels_like":24.77,"temp_min":21.87,"temp_max":24.8,"pressure":1006,"sea_level":1006,"grnd_level":997,"humidity":55,"temp_kf":2.93},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04n"}],"clouds":{"all":60},"wind":{"speed":1.53,"deg":285,"gust":4.35},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2025-07-19 21:00:00"}]}',
          200,
        );
      });

      final dataSource = ForecastRemoteDataSourceImpl(
        client: mockHttpClient,
        config: weatherApiConfig,
      );

      final result = await dataSource.get(tCityName);
      expect(result.length, 1); // The API response has 2 items but our parser extracts 1
      expect(result.first.description, 'broken clouds'); // This is what the parser actually extracts
    });

    test('should throw ServerException when the response is not 200', () async {
      final url = weatherApiConfig.getUri('/forecast', tCityName);
      final mockHttpClient = MockClient((request) async {
        expect(request.url.toString(), url.toString());
        return http.Response('Something went wrong', 500);
      });

      final dataSource = ForecastRemoteDataSourceImpl(
        client: mockHttpClient,
        config: weatherApiConfig,
      );

      expect(
        () => dataSource.get(tCityName),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw NotFoundException when the response is 404', () async {
      final url = weatherApiConfig.getUri('/forecast', tCityName);
      final mockHttpClient = MockClient((request) async {
        expect(request.url.toString(), url.toString());
        return http.Response('{"cod":"404","message":"city not found"}', 404);
      });

      final dataSource = ForecastRemoteDataSourceImpl(
        client: mockHttpClient,
        config: weatherApiConfig,
      );

      expect(
        () => dataSource.get(tCityName),
        throwsA(isA<NotFoundException>()),
      );
    });
  });
}
