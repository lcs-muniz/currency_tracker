import '../messages/app_messages.dart';

sealed class Failure implements Exception {
  final String msg;
  Failure(this.msg);

  @override
  String toString() => '$runtimeType: $msg!!!';
}

class ServerFailure extends Failure {
  ServerFailure([String? msg]) : super(msg ?? AppMessages.error.serverError);
}

class CacheFailure extends Failure {
  CacheFailure([String? msg]) : super(msg ?? AppMessages.error.cacheError);
}

class DefaultFailure extends Failure {
  DefaultFailure([String? msg]) : super(msg ?? AppMessages.error.defaultError);
}

class APIFailure extends Failure {
  APIFailure([String? msg]) : super(msg ?? AppMessages.error.apiError);
}

class APIFailureOnSave extends Failure {
  APIFailureOnSave([String? msg])
      : super(msg ?? AppMessages.error.apiSaveError);
}

class ApiException extends Failure {
  ApiException([String? msg]) : super(msg ?? AppMessages.error.apiException);
}

class DatabaseFailure extends Failure {
  DatabaseFailure([String? msg])
      : super(msg ?? AppMessages.error.databaseError);
}

class DatabaseInsertFailure extends Failure {
  DatabaseInsertFailure([String? msg])
      : super(msg ?? AppMessages.error.databaseInsertError);
}

class DatabaseQueryFailure extends Failure {
  DatabaseQueryFailure([String? msg])
      : super(msg ?? AppMessages.error.databaseQueryError);
}

class DatabaseUpdateFailure extends Failure {
  DatabaseUpdateFailure([String? msg])
      : super(msg ?? AppMessages.error.databaseUpdateError);
}

class DatabaseDeleteFailure extends Failure {
  DatabaseDeleteFailure([String? msg])
      : super(msg ?? AppMessages.error.databaseDeleteError);
}

class InvalidInputFailure extends Failure {
  InvalidInputFailure([String? msg])
      : super('${AppMessages.error.invalidInput}: ${msg ?? ''}');
}
