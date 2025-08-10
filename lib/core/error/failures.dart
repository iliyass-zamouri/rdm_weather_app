import 'package:equatable/equatable.dart';

/// Base class for failures
abstract class Failure with EquatableMixin {
  @override
  List<Object?> get props => [];

  String get message => toString();

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  @override
  String toString() => 'Erreur du serveur. Veuillez réessayer plus tard.';
}

class NetworkFailure extends Failure {
  @override
  String toString() => 'Vérifier votre connexion internet';
}

class NotFoundFailure extends Failure {
  @override
  String toString() => 'Ville non trouvée.';
}

class UnexpectedFailure extends Failure {
  @override
  String toString() => 'Une erreur inattendue est survenue.';
}
