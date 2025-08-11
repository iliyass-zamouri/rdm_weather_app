import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:rdm_weather_app/core/config/weather_api_config_interface.dart';
import 'package:rdm_weather_app/core/error/exceptions.dart';

abstract class BaseRemoteDataSource {
  final http.Client client;
  final WeatherApiConfig config;

  BaseRemoteDataSource({
    required this.client,
    required this.config,
  });

  Future<T> getJson<T>(
    Uri url,
    T Function(dynamic json) parser,
  ) async {
    try {
      final response = await client.get(url);
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
      if (response.statusCode == 200) {
        return parser(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw NotFoundException();
      } else {
        throw ServerException();
      }
    } on SocketException {
      throw NetworkException();
    } on AppException {
      rethrow;
    } catch (e, stacktrace) {
      log('Unexpected error: $e', stackTrace: stacktrace);
      throw UnexpectedException();
    }
  }
}