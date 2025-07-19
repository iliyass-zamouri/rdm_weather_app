class API {
  static const String baseUrl = 'developer.coliaty.com';
  static const String apiVersion = '/api/v1';

  static String fullEndpoint(String endpoint) {
    return '${API.apiVersion}/$endpoint';
  }

  static const String login = 'auth/login';
}
