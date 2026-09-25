/// Base class for all domain-level exceptions.
///
/// Never expose platform/framework errors to the domain layer —
/// wrap them in these typed exceptions instead.
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Task was not found in the data source.
final class TaskNotFoundException extends AppException {
  const TaskNotFoundException(String id)
      : super('Task with id "$id" was not found.');
}

/// Generic data persistence failure.
final class StorageException extends AppException {
  const StorageException(String details) : super('Storage error: $details');
}

/// Network or remote data source failure.
final class NetworkException extends AppException {
  const NetworkException(String details) : super('Network error: $details');
}
