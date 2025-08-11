import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:rdm_weather_app/core/config/weather_api_config.dart';
import 'package:rdm_weather_app/core/config/weather_api_config_interface.dart';
import 'package:rdm_weather_app/core/error/exceptions.dart';
import 'package:rdm_weather_app/features/weather/data/datasources/weather_remote_data_source_impl.dart';
import 'package:rdm_weather_app/features/weather/data/models/weather_model.dart';
import 'package:http/http.dart' as http;

void main() {
  late WeatherApiConfig weatherApiConfig;

  setUp(() {
    weatherApiConfig = WeatherApiConfigImpl();
  });

  group('WeatherRemoteDataSourceImpl', () {
    const tCityName = 'Paris';
    final tWeatherModel = WeatherModel(
      cityName: tCityName,
      temperature: 26.26,
      description: 'scattered clouds',
      icon: '03d',
    );

    test('should return WeatherModel when the response is 200', () async {
      final url = weatherApiConfig.getUri('/weather', tCityName);
      final mockHttpClient = MockClient((request) async {
        expect(request.url.toString(), url.toString());
        return http.Response(
          '{"coord":{"lon":2.3488,"lat":48.8534},"weather":[{"id":802,"main":"Clouds","description":"scattered clouds","icon":"03d"}],"base":"stations","main":{"temp":26.26,"feels_like":26.26,"temp_min":24.86,"temp_max":27.43,"pressure":1006,"humidity":54,"sea_level":1006,"grnd_level":996},"visibility":10000,"wind":{"speed":4.63,"deg":210},"clouds":{"all":40},"dt":1752944449,"sys":{"type":2,"id":2012208,"country":"FR","sunrise":1752898051,"sunset":1752954354},"timezone":7200,"id":2988507,"name":"Paris","cod":200}',
          200,
        );
      });
      
      final dataSource = WeatherRemoteDataSourceImpl(
        client: mockHttpClient,
        config: weatherApiConfig,
      );

      final result = await dataSource.get(tCityName);
      expect(result, equals(tWeatherModel));
    });

    test('should throw ServerException when the response is not 200', () async {
      final url = weatherApiConfig.getUri('/weather', tCityName);
      final mockHttpClient = MockClient((request) async {
        expect(request.url.toString(), url.toString());
        return http.Response('Something went wrong', 500);
      });
      
      final dataSource = WeatherRemoteDataSourceImpl(
        client: mockHttpClient,
        config: weatherApiConfig,
      );

      expect(
        () => dataSource.get(tCityName),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw NotFoundException when the response is 404', () async {
      final url = weatherApiConfig.getUri('/weather', tCityName);
      final mockHttpClient = MockClient((request) async {
        expect(request.url.toString(), url.toString());
        return http.Response('{"cod":"404","message":"city not found"}', 404);
      });
      
      final dataSource = WeatherRemoteDataSourceImpl(
        client: mockHttpClient,
        config: weatherApiConfig,
      );

      expect(
        () => dataSource.get(tCityName),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('should handle different city names correctly', () async {
      const cityName = 'London';
      final weatherModel = WeatherModel(
        cityName: cityName,
        temperature: 18.0,
        description: 'light rain',
        icon: '10d',
      );

      final url = weatherApiConfig.getUri('/weather', cityName);
      final mockHttpClient = MockClient((request) async {
        expect(request.url.toString(), url.toString());
        return http.Response(
          '{"coord":{"lon":-0.1276,"lat":51.5074},"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10d"}],"base":"stations","main":{"temp":18.0,"feels_like":17.5,"temp_min":16.0,"temp_max":20.0,"pressure":1012,"humidity":75},"visibility":10000,"wind":{"speed":3.5,"deg":180},"clouds":{"all":90},"dt":1752944449,"sys":{"type":2,"id":2075535,"country":"GB","sunrise":1752898000,"sunset":1752954400},"timezone":0,"id":2643743,"name":"London","cod":200}',
          200,
        );
      });
      
      final dataSource = WeatherRemoteDataSourceImpl(
        client: mockHttpClient,
        config: weatherApiConfig,
      );

      final result = await dataSource.get(cityName);
      expect(result.cityName, equals(weatherModel.cityName));
      expect(result.temperature, equals(weatherModel.temperature));
      expect(result.description, equals(weatherModel.description));
      expect(result.icon, equals(weatherModel.icon));
    });

    test('should handle negative temperatures correctly', () async {
      const cityName = 'Moscow';
      final weatherModel = WeatherModel(
        cityName: cityName,
        temperature: -10.0,
        description: 'light snow',
        icon: '13d',
      );

      final url = weatherApiConfig.getUri('/weather', cityName);
      final mockHttpClient = MockClient((request) async {
        expect(request.url.toString(), url.toString());
        return http.Response(
          '{"coord":{"lon":37.6173,"lat":55.7558},"weather":[{"id":600,"main":"Snow","description":"light snow","icon":"13d"}],"base":"stations","main":{"temp":-10.0,"feels_like":-15.0,"temp_min":-12.0,"temp_max":-8.0,"pressure":1020,"humidity":80},"visibility":8000,"wind":{"speed":2.0,"deg":45},"clouds":{"all":70},"dt":1752944449,"sys":{"type":2,"id":2000314,"country":"RU","sunrise":1752897000,"sunset":1752955000},"timezone":10800,"id":524901,"name":"Moscow","cod":200}',
          200,
        );
      });
      
      final dataSource = WeatherRemoteDataSourceImpl(
        client: mockHttpClient,
        config: weatherApiConfig,
      );

      final result = await dataSource.get(cityName);
      expect(result.temperature, equals(-10.0));
      expect(result.description, equals('light snow'));
    });

    test('should handle malformed JSON response', () async {
      final url = weatherApiConfig.getUri('/weather', tCityName);
      final mockHttpClient = MockClient((request) async {
        expect(request.url.toString(), url.toString());
        return http.Response('{"invalid": "json"', 200); // Malformed JSON
      });
      
      final dataSource = WeatherRemoteDataSourceImpl(
        client: mockHttpClient,
        config: weatherApiConfig,
      );

      expect(
        () => dataSource.get(tCityName),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle empty response body', () async {
      final url = weatherApiConfig.getUri('/weather', tCityName);
      final mockHttpClient = MockClient((request) async {
        expect(request.url.toString(), url.toString());
        return http.Response('', 200);
      });
      
      final dataSource = WeatherRemoteDataSourceImpl(
        client: mockHttpClient,
        config: weatherApiConfig,
      );

      expect(
        () => dataSource.get(tCityName),
        throwsA(isA<Exception>()),
      );
    });

    test('should use correct HTTP method', () async {
      final url = weatherApiConfig.getUri('/weather', tCityName);
      final mockHttpClient = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.toString(), url.toString());
        return http.Response(
          '{"coord":{"lon":2.3488,"lat":48.8534},"weather":[{"id":802,"main":"Clouds","description":"scattered clouds","icon":"03d"}],"base":"stations","main":{"temp":26.26,"feels_like":26.26,"temp_min":24.86,"temp_max":27.43,"pressure":1006,"humidity":54,"sea_level":1006,"grnd_level":996},"visibility":10000,"wind":{"speed":4.63,"deg":210},"clouds":{"all":40},"dt":1752944449,"sys":{"type":2,"id":2012208,"country":"FR","sunrise":1752898051,"sunset":1752954354},"timezone":7200,"id":2988507,"name":"Paris","cod":200}',
          200,
        );
      });
      
      final dataSource = WeatherRemoteDataSourceImpl(
        client: mockHttpClient,
        config: weatherApiConfig,
      );

      await dataSource.get(tCityName);
      // The test passes if the request method is GET
    });
  });
}
