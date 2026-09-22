class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException([this.message = 'Server error occurred', this.statusCode]);

  @override
  String toString() => 'ServerException: $message (code: $statusCode)';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException([this.message = 'Network connection failed']);

  @override
  String toString() => 'NetworkException: $message';
}

class StorageException implements Exception {
  final String message;

  const StorageException([this.message = 'Storage error occurred']);

  @override
  String toString() => 'StorageException: $message';
}

class UnsupportedPlatformException implements Exception {
  final String message;

  const UnsupportedPlatformException([this.message = 'Platform is not supported']);

  @override
  String toString() => 'UnsupportedPlatformException: $message';
}

class InvalidUrlException implements Exception {
  final String message;

  const InvalidUrlException([this.message = 'Invalid or malformed URL']);

  @override
  String toString() => 'InvalidUrlException: $message';
}

class PermissionException implements Exception {
  final String message;

  const PermissionException([this.message = 'Required permission was denied']);

  @override
  String toString() => 'PermissionException: $message';
}

