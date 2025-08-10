import 'package:rdm_weather_app/core/error/failures.dart';

/// Base class for app exceptions
abstract class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;

  Failure toFailure();
}

class NetworkException extends AppException {
  NetworkException([super.message = 'Pas de connexion Internet.']);

  @override
  Failure toFailure() => NetworkFailure();
}

class NotFoundException extends AppException {
  NotFoundException([super.message = 'Ville non trouvée.']);

  @override
  Failure toFailure() => NotFoundFailure();
}

class UnexpectedException extends AppException {
  UnexpectedException([super.message = 'Une erreur inattendue est survenue.']);

  @override
  Failure toFailure() => UnexpectedFailure();
}

class ServerException extends AppException {
  ServerException(
      [super.message = 'Erreur du serveur. Veuillez réessayer plus tard.']);

  @override
  Failure toFailure() => ServerFailure();
}
