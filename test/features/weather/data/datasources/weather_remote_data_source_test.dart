import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:rdm_weather_app/core/config/weather_api_config.dart';
import 'package:rdm_weather_app/core/error/exceptions.dart';
import 'package:rdm_weather_app/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:rdm_weather_app/features/weather/data/models/weather_model.dart';
import 'package:rdm_weather_app/features/weather/data/models/forecast_model.dart';
import 'package:http/http.dart' as http;

void main() {
  late WeatherApiConfig weatherApiConfig;

  setUp(() {
    weatherApiConfig = WeatherApiConfig();
  });

  group('getCurrentWeather', () {
    const tCityName = 'Paris';
    final tWeatherModel = WeatherModel(
      cityName: tCityName,
      temperature: 26.26,
      description: 'scattered clouds',
      icon: '03d',
    );

    test('should return WeatherModel when the response is 200', () async {
      final url = weatherApiConfig.currentWeatherUri(tCityName, 'fake_api_key');
      final mockHttpClient = MockClient((request) async {
        expect(request.url.toString(), url.toString());
        return http.Response(
          '{"coord":{"lon":2.3488,"lat":48.8534},"weather":[{"id":802,"main":"Clouds","description":"scattered clouds","icon":"03d"}],"base":"stations","main":{"temp":26.26,"feels_like":26.26,"temp_min":24.86,"temp_max":27.43,"pressure":1006,"humidity":54,"sea_level":1006,"grnd_level":996},"visibility":10000,"wind":{"speed":4.63,"deg":210},"clouds":{"all":40},"dt":1752944449,"sys":{"type":2,"id":2012208,"country":"FR","sunrise":1752898051,"sunset":1752954354},"timezone":7200,"id":2988507,"name":"Paris","cod":200}',
          200,
        );
      });
      final dataSource = WeatherRemoteDataSourceImpl(
        client: mockHttpClient,
        apiKey: 'fake_api_key',
      );

      final result = await dataSource.getCurrentWeather(tCityName);
      expect(result, equals(tWeatherModel));
    });

    test('should throw ServerException when the response is not 200', () async {
      final url = weatherApiConfig.currentWeatherUri(tCityName, 'fake_api_key');
      final mockHttpClient = MockClient((request) async {
        expect(request.url.toString(), url.toString());
        return http.Response('Something went wrong', 500);
      });
      final dataSource = WeatherRemoteDataSourceImpl(
        client: mockHttpClient,
        apiKey: 'fake_api_key',
      );

      expect(
        () => dataSource.getCurrentWeather(tCityName),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getWeatherForecast', () {
    const tCityName = 'Paris';
    final tForecastModels = [
      ForecastModel(
        day: 'Samedi',
        minTemp: 24.8,
        maxTemp: 26.26,
        description: 'broken clouds',
        icon: '04n',
      ),
    ];

    test('should return List<ForecastModel> when the response is 200',
        () async {
      final url = weatherApiConfig.forecastUri(tCityName, 'fake_api_key');
      final mockHttpClient = MockClient((request) async {
        expect(request.url.toString(), url.toString());
        return http.Response(
          '{"cod":"200","message":0,"cnt":40,"list":[{"dt":1752948000,"main":{"temp":26.26,"feels_like":26.26,"temp_min":24.23,"temp_max":26.26,"pressure":1006,"sea_level":1006,"grnd_level":996,"humidity":54,"temp_kf":2.03},"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10d"}],"clouds":{"all":40},"wind":{"speed":3.08,"deg":229,"gust":6.43},"visibility":10000,"pop":0.28,"rain":{"3h":0.13},"sys":{"pod":"d"},"dt_txt":"2025-07-19 18:00:00"},{"dt":1752958800,"main":{"temp":24.8,"feels_like":24.77,"temp_min":21.87,"temp_max":24.8,"pressure":1006,"sea_level":1006,"grnd_level":997,"humidity":55,"temp_kf":2.93},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04n"}],"clouds":{"all":60},"wind":{"speed":1.53,"deg":285,"gust":4.35},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2025-07-19 21:00:00"}]}',
          200,
        );
      });
      final dataSource = WeatherRemoteDataSourceImpl(
        client: mockHttpClient,
        apiKey: 'fake_api_key',
      );

      final result = await dataSource.getWeatherForecast(tCityName);
      expect(result.take(2).toList(), equals(tForecastModels));
    });

    test('should throw ServerException when the response is not 200', () async {
      final url = weatherApiConfig.forecastUri(tCityName, 'fake_api_key');
      final mockHttpClient = MockClient((request) async {
        expect(request.url.toString(), url.toString());
        return http.Response('Something went wrong', 500);
      });
      final dataSource = WeatherRemoteDataSourceImpl(
        client: mockHttpClient,
        apiKey: 'fake_api_key',
      );

      expect(
        () => dataSource.getWeatherForecast(tCityName),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
