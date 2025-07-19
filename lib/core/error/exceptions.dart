abstract class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException([super.message = 'Pas de connexion Internet.']);
}

class NotFoundException extends AppException {
  NotFoundException([super.message = 'Ville non trouvée.']);
}

class UnexpectedException extends AppException {
  UnexpectedException([super.message = 'Une erreur inattendue est survenue.']);
}

class ServerException extends AppException {
  ServerException(
      [super.message = 'Erreur du serveur. Veuillez réessayer plus tard.']);
}
